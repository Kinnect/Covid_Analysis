#Select Data

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM covid_project.covid_deaths
ORDER BY 1,2

#Case Fatality Ratio: The proportion of persons with a particular condition (cases) who die from that condition

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM covid_project.covid_deaths
WHERE (continent != '')
AND Location like '%state%'
ORDER BY 1,2

#Infection rate

SELECT Location, date, population, total_cases, total_deaths, (total_cases/population)*100 as InfectionRate
FROM covid_project.covid_deaths
WHERE (continent != '')
AND Location like '%state%'
ORDER BY 1,2

#Highest infection rate by Location

SELECT Location, population, MAX(total_cases) as MaxInfectionCount, MAX((total_cases/population))*100 as MaxInfectionPercentage
FROM covid_project.covid_deaths
WHERE (continent != '')
GROUP BY Location, population
ORDER BY MaxInfectionPercentage DESC

#Highest death rate by Location

SELECT Location, population, MAX(total_deaths) as MaxDeathCount, MAX((total_deaths/population))*100 as MaxDeathPercentage
FROM covid_project.covid_deaths
WHERE (continent != '')
GROUP BY Location, population
ORDER BY MaxDeathPercentage DESC

# Total death count by location

SELECT Location, MAX(cast(Total_deaths AS UNSIGNED)) as TotalDeathCount
FROM covid_project.covid_deaths
WHERE (continent != '')
GROUP BY Location
ORDER BY TotalDeathCount DESC

# Total death count by continent

SELECT Location, MAX(cast(Total_deaths AS UNSIGNED)) as TotalDeathCount
FROM covid_project.covid_deaths
WHERE (continent = '')
GROUP BY Location
ORDER BY TotalDeathCount DESC

#Global COVID Numbers

SELECT date, SUM(new_cases) as TotalCases, SUM(new_deaths) as TotalDeatths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
FROM covid_project.covid_deaths
WHERE (continent != '')
GROUP BY date
ORDER BY 1,2

#Total Population vs Vaccinations (CTE)

WITH PopvsVac (continent, location, date, population, new_vaccination, VaccinationsOverTime)
AS
(
SELECT dt.continent, dt.location, dt.date, dt.population, va.new_vaccinations,
SUM(va.new_vaccinations) OVER (PARTITION BY dt.location ORDER BY dt.location, dt.date) 
as PopvsVac
FROM covid_project.covid_deaths dt
JOIN covid_project.covid_vaccinations va
ON dt.location = va.location
AND dt.date = va.date
WHERE (dt.continent != '')
)
SELECT *, (VaccinationsOverTime/population)*100 as VaccinationPercentOverTime
FROM PopvsVac
WHERE continent like '%north%'

#PercentPopulationVaccinated (View)

CREATE VIEW PercentPopulationVaccinated as
SELECT dt.continent, dt.location, dt.date, dt.population, va.new_vaccinations,
SUM(va.new_vaccinations) OVER (PARTITION BY dt.location ORDER BY dt.location, dt.date) 
as PopvsVac
FROM covid_project.covid_deaths dt
JOIN covid_project.covid_vaccinations va
ON dt.location = va.locationpercentpopulationvaccinated
AND dt.date = va.date
WHERE (dt.continent != '')


