Select *
From Project..[Covid-deaths]
Where continent is not null
Order by 3,4


Select *
From Project..[Covid-vaccinations]
Order by 3,4


Select Location, date, total_cases, new_cases, total_deaths, population
From Project..[Covid-deaths]
order by 1,2


Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From Project..[Covid-deaths]
Where Location like '%Canada%'
order by 1,2


Select Location, date, total_cases, Population, (total_cases/Population)*100 as InfectionRate
From Project..[Covid-deaths]
Where Location like '%Canada%'
order by 1,2


Select Location, Population, Max(total_cases) as HighestInfectionCount, Max((total_cases/Population))*100 as PercentPopulationInfected
From Project..[Covid-deaths]
Group by Location, Population
order by PercentPopulationInfected desc


Select Location, Max(cast(total_deaths as int)) as TotalDeathCount
From Project..[Covid-deaths]
Where continent is not null
Group by Location
order by TotalDeathCount desc


Select continent, Max(cast(total_deaths as int)) as TotalDeathCount
From Project..[Covid-deaths]
Where continent is not null
Group by continent
order by TotalDeathCount desc


Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From Project..[Covid-deaths]
where continent is not null
Group By date
order by 1,2


Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From Project..[Covid-deaths]
where continent is not null
order by 1,2


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From Project..[Covid-deaths] dea
Join Project..[Covid-vaccinations] vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3



With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (Partition by dea.Location Order by dea.location,
dea.Date) as RollingPeopleVaccinated
From Project..[Covid-deaths] dea
Join Project..[Covid-vaccinations] vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac 



DROP Table if exists #PrecentPopulationVaccinated
Create Table #PrecentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)


Insert into #PrecentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (Partition by dea.Location Order by dea.location,
dea.Date) as RollingPeopleVaccinated
From Project..[Covid-deaths] dea
Join Project..[Covid-vaccinations] vac
on dea.location = vac.location
and dea.date = vac.date



Select *, (RollingPeopleVaccinated/Population)*100
From #PrecentPopulationVaccinated 



Create View PrecentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (Partition by dea.Location Order by dea.location,
dea.Date) as RollingPeopleVaccinated
From Project..[Covid-deaths] dea
Join Project..[Covid-vaccinations] vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null


Select *
From PrecentPopulationVaccinated