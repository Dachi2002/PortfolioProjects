
Select location, date, total_Cases, new_cases, total_Deaths, population 
From Project..CovidDeaths$
order by 1,2 

-- Looking at Total Cases vs Total Deaths 

Select location, date, total_Cases,  total_Deaths, (Total_deaths/Total_Cases)*100 As DeathPercentage
From Project..CovidDeaths$
Where location like '&Georgia&'
order by 1,2  

-- Looking at Total Cases Vs Population 

Select location, date,population,total_Cases,  (total_Cases/population)*100 As PerctentPopulationInfected 
From Project..CovidDeaths$
Where location like '%Georgia%'
Order By 1,2

-- Looking at Countries with highest Infaction Rate comparet to Population 

Select location,population, Max(total_Cases) As HighestInfectionCount,  Max((total_Cases/population))*100 As PerctentPopulationInfected 
From Project..CovidDeaths$
--Where location like '%Georgia%'
Group By location,population
Order By PerctentPopulationInfected  desc


-- Shwoing Countries with Highest Death Count per Population 

Select location,  MAX(cast(total_Deaths as int)) as TotalDeathCount 
From Project..CovidDeaths$
Where continent is not null 
--Where location like '&Georgia&'
Group By Location  
Order By TotalDeathCount DESC


-- Showing Cointinent With Highest Death Conunt Per Population 


Select location,  MAX(cast(total_Deaths as int)) as TotalDeathCount 
From Project..CovidDeaths$
Where continent is  null 
--Where location like '&Georgia&'
Group By location
Order By TotalDeathCount DESC

-- Global Numbers 

Select  SUM(New_Cases) as total_cases, SUM(Cast(new_deaths As int )) as total_deaths , 
SUM(Cast(new_deaths As int ))/Sum(New_Cases)*100 As DeathPercentage 
From Project..CovidDeaths$
Where continent is not null 
 
Order by 1,2 

-- Looking at Total Vaccinations VS Total Population

With PopVsVac (Continent, location, date, population, new_vaccinaionts,RolingPeopleVaccinated)
as 
(
Select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location,dea.date) as RolingPeopleVaccinated
From Project..CovidDeaths$ dea
Join Project..CovidVaccinations$ vac
    ON dea.location = vac.location
	AND dea.date = vac.date 
Where dea.continent is not null 
)
Select * , (RolingPeopleVaccinated/Population)*100 
From PopVsVac



-- TempTable

Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)
 Insert into #PercentPopulationVaccinated
 Select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location,dea.date) as RolingPeopleVaccinated
From Project..CovidDeaths$ dea
Join Project..CovidVaccinations$ vac
    ON dea.location = vac.location
	AND dea.date = vac.date 


Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


-- Create View

Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location,dea.date) as RolingPeopleVaccinated
From Project..CovidDeaths$ dea
Join Project..CovidVaccinations$ vac
    ON dea.location = vac.location
	AND dea.date = vac.date 
Where dea.continent is not null 









