select *
from CovidDeaths
where continent is not null
ORDER BY 1,2

SELECT *
FROM CovidVaccinations
where continent is not null
ORDER BY 1,2

SELECT location,population,date,total_deaths,new_cases,total_cases
from CovidDeaths
where continent is not null

--Total cases vs total deaths

SELECT location,population,date,total_deaths,total_cases,(total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths
where location like '%India%'
and continent is not null

--Total cases vs POPULATION

SELECT location,population,date,total_cases,(total_cases/population)*100 as CasePercantage
from CovidDeaths
where continent is not null
--where location like '%India%'
order by CasePercantage desc

--Countries with Highest Infection rate comapred to Population

SELECT location,population,date,max(total_cases)as HighestInfectionCount,max(total_cases/population)*100 as PercentPopulationInfected
from CovidDeaths
where continent is not null
group by location,population,date
order by PercentPopulationInfected desc

--Showing Countries with the highest Death Count per Population

SELECT location,max(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc

--LET'S BREAK THINGS DOWN BY CONTINENT

--Showing the continent with highest death count

SELECT continent,max(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc


--Global numbers

SELECT sum(new_cases) as TotalNewCases,sum(cast(new_deaths as int)) as TotalNewDeaths,sum(cast(new_deaths as int))/sum((new_cases))*100 as DeathPercentage
from CovidDeaths
--where location like '%India%'
where continent is not null

--Joining coviddeaths and covidvaccines table

SELECT *
from CovidDeaths dea
join CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date

--Looking at Total Population vs Vaccinations

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

--CTE

with popVSloc (continent,Location,Date,Population,new_vaccinations,RollingPeopleVaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
)
select *, (RollingPeopleVaccinated/Population)* 100
from popVSloc

--temp table
drop table if exists PercentPopulationInfected
Create table PercentPopulationInfected
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into PercentPopulationInfected
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null

select *,(RollingPeopleVaccinated/Population)* 100
from PercentPopulationInfected














