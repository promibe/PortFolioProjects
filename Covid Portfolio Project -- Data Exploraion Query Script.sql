-- SQlPortfolioProject database
-- imported two tables CovidDeaths and CovidVaccination to the above database

Drop table [SQLPortfolioProject]..CovidDeaths
Drop table [SQLPortfolioProject]..CovidVaccination$

select * 
from SQLPortfolioProject.dbo.CovidDeaths$
order by 3,4

select *
from SQLPortfolioProject..CovidVaccination$

-- Select Data that we are going to be using

select location, total_deaths --date, total_cases, new_cases, total_deaths, population
from SQLPortfolioProject.dbo.CovidDeaths
--where location like %A%
where total_deaths is not null
order by 1 Asc, 2 desc


-- 1-- Looking at Total Cases vs Total Deaths
-- show the likelihood of dying if you contract covid in your country
select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from SQLPortfolioProject..CovidDeaths
where location like '%States%'
order by 1,2


-- 2-- Looking at Total Cases vs Population
-- shows what percentage of population got covid
select Location, date, total_cases, population, (cast(total_cases as int)/population)*100 as PercentofPopulationInfected
from SQLPortfolioProject..CovidDeaths
--where location like '%states%
order by 1,2


-- 3-- Looking at Countries with hightest infection rate compared to populaion
select Location, population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population)*100) as PercentageofPopulationInfected
from SQLPortfolioProject..CovidDeaths
--where location like '%states%
group by Location, population
order by PercentageofPopulationInfected asc

-- 4-- Showing the countries with the highest death count per population
select location, Max(cast(Total_deaths as int)) as TotalDeathCount 
from SQLPortfolioProject..CovidDeaths
--where location like '%states%
where continent is not null
group by location
order by TotalDeathCount desc


-- 5 -- LETS BREAK THINGS DOWN BY CONTINENT

select continent Max(cast(Total_deaths as int)) as TotalDeathCount 
from SQLPortfolioProject..CovidDeaths
--where location like '%states%
where continent is not null
group by continent
order by TotalDeathCount desc


-- 6 -- Showing continents with the highest death count 
select continent, Max(cast(Total_deaths as int) as TotalDeathCount
from SQLPortfolioProject..CovidDeaths
group by continent
order by TotalDeathCount desc 



-- 7-- GLOBAL NUMBERS
-- showing the global death and cases in their corresponding dates

select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int) as total_deaths, SUM(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from SQLPortfolioProject..CovidDeaths
where continent is not null
group by date
order by 1,2 

-- shows the overall new cases and new_deaths
select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int) as total_deaths, SUM(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from SQLPortfolioProject..CovidDeaths
where continent is not null
--group by date
order by 1,2 


-- EXPLORING THE VACCINATION TABLE

Select * 
from SQLPortfolioProject..CovidVaccination

-- Joining the coviddeaths and Covidvaccination table
select *
from SQLPortfolioProject..CovidDeaths dea
join SQLPortfolioProject..CovidVaccination vac
	on dea.location = vac.location
	and dea.date = vac.date

-- Looking at Total Population vs Vaccinations
-- a) selecting my columns
select dea.continent, dea.location, dea.date, dea.population, vac.vaccinatons
from SQLPortfolioProject..Coviddeath dea
join SQLPortfolioProject..CovidVaccination vac
	on dea.location = vac.location
	and dea.date = vac.death
where continent is not null
order by 1,2,3

-- Rowing count of newly vaccinated people daily using partition

select dea.continent, dea.location dea.date, dea.population, vac.new_vaccinations, 
sum(convert(int, vac.new_vaccination)) over (partition by dea.location order by dea.location, dea.date) as 
RollingPeopleVaccinated
from SQLPortfolioproject..CovidDeaths dea
join SQLPortFolioProject..CovidVaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3



-- Looking at Total Population vs Vaccinations
-- USE CTE

with PopvsVac (Continent, Location, Date, Population, New_vaccination, RollingPeopleVaccinated)
as
(select dea.continent, dea.location dea.date, dea.population, vac.new_vaccinations, 
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as 
RollingPeopleVaccinated
from SQLPortfolioproject..CovidDeaths dea
join SQLPortFolioProject..CovidVaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

)
select * from 
PopvsVac

select *, (RollingPeopleVaccinated/Population)*100
from PopvsVac



-- USE TEMP TABLE
drop table if exis #parcentpopulationVaccinated
create table #parcentpopulationVaccinated
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccination numeric,
RollingPeopleVaccinated numeric)

insert into #parcentpopulationVaccinated
select dea.continent, dea.location dea.date, dea.population, vac.new_vaccinations, 
sum(convert(int, vac.new_vaccination)) over (partition by dea.location order by dea.location, dea.date) as 
RollingPeopleVaccinated
from SQLPortfolioproject..CovidDeaths dea
join SQLPortFolioProject..CovidVaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select *, (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated



-- CREATING VIEW TO STORE DATE FOR LATER VISUALISATONS

create view PercentPopulationVaccinated as 
select dea.continent, dea.location dea.date, dea.population, vac.new_vaccinations, 
sum(convert(int, vac.new_vaccination)) over (partition by dea.location order by dea.location, dea.date) as 
RollingPeopleVaccinated
from SQLPortfolioproject..CovidDeaths dea
join SQLPortFolioProject..CovidVaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3


select * 
from PercentPopulationVaccinated


