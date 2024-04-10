use [Portfolio project]

--Covid Table 1
--Global numbers

SELECT sum(new_cases) as TotalNewCases,sum(cast(new_deaths as int)) as TotalNewDeaths,sum(cast(new_deaths as int))/sum((new_cases))*100 as DeathPercentage
from CovidDeaths
where continent is not null

--Covid Table 2
--Showing the continent with highest death count

SELECT continent,max(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc

--Covid Table 3
--Countries with Highest Infection rate comapred to Population

SELECT location,population,max(total_cases)as HighestInfectionCount,max(total_cases/population)*100 as PercentPopulationInfected
from CovidDeaths
where continent is not null
group by location,population
order by PercentPopulationInfected desc

--Covid Table 4
--Countries with Highest Infection rate comapred to Population with Date

SELECT location,population,date,max(total_cases)as HighestInfectionCount,max(total_cases/population)*100 as PercentPopulationInfected
from CovidDeaths
where continent is not null
group by location,population,date
order by PercentPopulationInfected desc