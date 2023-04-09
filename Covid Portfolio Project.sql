--Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

Select *
From PortfolioProject. .CovidDeaths
Where continent is not null
order by 3,4


--Select *
--From PortfolioProject. .CovidVaccinations$
--order by 3,4

--Select Data that are Using

Select Location, date, total_cases, total_deaths, population
From PortfolioProject. .CovidDeaths
order by 1,2


--Total cases vs Total deaths
--W/ Likelihood of dying when contracted in country

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject. .CovidDeaths
Where location like 'Philippines'
order by 1,2

--Total cases vs Population
--Percentage of population got covid

Select Location, date, Population, total_cases,(total_cases/population)*100 as PercentPopulationInfected 
From PortfolioProject. .CovidDeaths
--Where location like 'Philippines'
order by 1,2

--Countries w/ highest infection rate compared to population

Select Location, Population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject. .CovidDeaths
--Where location like 'Philippines'
Group by Location, Population
order by PercentPopulationInfected desc



-- Showing Countries w/ Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject. .CovidDeaths
--Where location like 'Philippines'
Where continent is not null
Group by Location
order by TotalDeathCount desc



--BY Continent Breakdown

--Continents w/ Highest death count per population


Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject. .CovidDeaths
--Where location like 'Philippines'
Where continent is not null
Group by continent
order by TotalDeathCount desc


-- Global numbers

Select  Sum(new_cases)as total_cases, Sum(cast(new_deaths as int)) as total_deaths, Sum(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject. .CovidDeaths
--Where location like 'Philippines'
where continent is not null
--Group BY date
order by 1,2


--Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum (Convert(int,vac.new_vaccinations)) Over (Partition by dea.Location Order by dea.location,dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location =vac.location
	and dea.date = vac.date
Where dea.continent is not null
order by 2,3


--Use CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum (Convert(int,vac.new_vaccinations)) Over (Partition by dea.Location Order by dea.location,dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location =vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
)
Select *,(RollingPeopleVaccinated/Population)*100
From PopvsVac



--Temp table

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum (Convert(int,vac.new_vaccinations)) Over (Partition by dea.Location Order by dea.location,dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location =vac.location
	and dea.date = vac.date
--Where dea.continent is not null
--order by 2,3


Select *,(RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum (Convert(int,vac.new_vaccinations)) Over (Partition by dea.Location Order by dea.location,dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location =vac.location
	and dea.date = vac.date
--Where dea.continent is not null
--order by 2,3


--Create view for visualization of stored data

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum (Convert(int,vac.new_vaccinations)) Over (Partition by dea.Location Order by dea.location,dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location =vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3


Select *
From PercentPopulationVaccinated