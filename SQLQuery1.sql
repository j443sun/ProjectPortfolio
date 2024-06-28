
Select*
From ProjectPortfolio..CovidDeaths
where continent is not null
order by 3,4
--Select*
--From ProjectPortfolio..CovidVaccinations
--order by 3,4

--Select Data we will be using
 
 Select Location, date, total_cases, new_cases, total_deaths, population
 from ProjectPortfolio..CovidDeaths
 where continent is not null
 order by 1,2

 --Total Cases vs Deaths



Select location, date, total_cases, total_deaths, (convert(decimal(18,2), total_deaths)/(convert(decimal(18,2), total_cases))*100) AS DeathPercentage
 from ProjectPortfolio..CovidDeaths
 where location like  '%Canada%'
and ( continent is not null)
 order by 1,2 

 --Total Cases vs Population
 Select location, date,  Population, total_cases, (convert(decimal(18,2), total_cases)/(convert(decimal(18,2), population))*100) AS PercentInfected
 from ProjectPortfolio..CovidDeaths
 where continent is not null
 and ( location like  '%Canada%' or location like '%States%')
 
 order by 1,2 


 --Highest INfection Rates
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, 
       (CONVERT(decimal(18,2), MAX(total_cases)) / CONVERT(decimal(18,2), population) * 100) AS PercentInfected
FROM ProjectPortfolio..CovidDeaths
where continent is not null
GROUP BY location, population
ORDER BY PercentInfected DESC

--HighestDeathRates
SELECT location, Max(cast(total_deaths as int)) as TotalDeathCount
from ProjectPortfolio..CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc

--By continent

--continents with most death count
SELECT continent, Max(cast(total_deaths as int)) as TotalDeathCount
from ProjectPortfolio..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc

Select date, sum(new_Cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, 
sum(cast(new_deaths as int)) /sum(new_cases) * 100 as Death_Percentage
from ProjectPortfolio..CovidDeaths
where continent is not null and new_cases != 0
group by date
order by 1,2 

Select cast(total_deaths as float) as total_deaths, cast(total_cases as float) as total_cases, 
cast(total_deaths as float)/cast(total_cases as float)  * 100 as death_percentage
from ProjectPortfolio..CovidDeaths
where total_deaths is not null and new_cases != 0
--takes into toal deaths of each country

select sum(new_Cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, 
sum(cast(new_deaths as int)) /sum(new_cases) * 100 as Death_Percentage
from ProjectPortfolio..CovidDeaths
where continent is not null and new_cases != 0
order by 1,2 
--takes into account sum of all new cases for more accurate total around the world, sum of total will overcount total amount of cases and deaths


select *
from ProjectPortfolio..CovidDeaths dea
join  ProjectPortfolio..CovidVaccinations vac
	on dea.location = vac.location and dea.date = vac.date

--Population vs vaccination
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(float, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) /2 
as rolling_people_vaccinated 
--create cte or temp table
from ProjectPortfolio..CovidDeaths dea
join  ProjectPortfolio..CovidVaccinations vac
	on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null and vac.new_vaccinations is not null
order by 2,3


--use cte
with PopVsVac (Continent, Location, Date, Population, new_vaccinations, rolling_people_vaccinated) 
as 
(select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(float, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) 
as rolling_people_vaccinated
--create cte or temp table

from ProjectPortfolio..CovidDeaths dea
join  ProjectPortfolio..CovidVaccinations vac
	on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null and vac.new_vaccinations is not null)
select *, (rolling_people_vaccinated/population) * 100
from PopVsVac
order by 2,3


Drop table if exists #PercentPopulationVaccinated -- always add incase you want to make changes
create table #PercentPopulationVaccinated
(
continent nvarchar(511),
location nvarchar(511),
date datetime, 
population numeric,
new_vaccinations numeric,
rolling_people_vaccinated numeric)

insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(float, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) /2 
as rolling_people_vaccinated 
--create cte or temp table
from ProjectPortfolio..CovidDeaths dea
join  ProjectPortfolio..CovidVaccinations vac
	on dea.location = vac.location and dea.date = vac.date
select *, (rolling_people_vaccinated/population) * 100
from #PercentPopulationVaccinated

create view PercentPopulationVaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(float, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) /2 
as rolling_people_vaccinated 
--create cte or temp table
from ProjectPortfolio..CovidDeaths dea
join  ProjectPortfolio..CovidVaccinations vac
	on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null

select* 
from PercentPopulationVaccinated