SELECT *
FROM Portfolio_Project_Covid..CovidDeaths
WHERE continent is NOT NULL
ORDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths	, population
FROM Portfolio_Project_Covid..CovidDeaths
ORDER BY 1,2


-- Query 1: Looking at Total Cases vs Total Deaths
SELECT location, date, total_cases, total_deaths, ((total_deaths/total_cases)*100) AS DeathPerc
FROM Portfolio_Project_Covid..CovidDeaths
WHERE location LIKE '%states%' AND continent is NOT NULL
ORDER BY 1,2


-- Query 2: Total Cases vs Population
SELECT location, date, population, total_cases, (total_cases/population)*100 AS InfectedPerc
FROM Portfolio_Project_Covid..CovidDeaths
WHERE location LIKE '%states' AND continent is NOT NULL
ORDER BY 1,2


-- Query 3: Highest infection rates per country (calculated against population)
SELECT location, population, MAX(total_cases) AS PeakInfectionCount, MAX((total_cases/population))*100 AS MaxInfectedPopPerc
FROM Portfolio_Project_Covid..CovidDeaths
WHERE continent is NOT NULL
GROUP BY location, population
ORDER BY MaxInfectedPopPerc desc


-- Query 4: Percentage dead per population for each country
SELECT location, MAX(CAST(total_deaths as int)) AS TotalDeathCount
FROM Portfolio_Project_Covid..CovidDeaths
WHERE continent is NOT NULL
GROUP BY location
ORDER BY TotalDeathCount desc

--Query 5: Checking Death Count by Continent (1st is technically correct)
--(2nd is what was used during visualization in tableau)
--SELECT location, MAX(CAST(total_deaths as int)) AS TotalDeathCount
--FROM Portfolio_Project_Covid..CovidDeaths
--WHERE continent is NULL
--GROUP BY location
--ORDER BY TotalDeathCount desc

SELECT location, MAX(CAST(total_deaths as int)) AS TotalDeathCount
FROM Portfolio_Project_Covid..CovidDeaths
WHERE continent is NULL
GROUP BY location
ORDER BY TotalDeathCount desc

-- Query 6:
SELECT continent, MAX(CAST(total_deaths as int)) AS TotalDeathCount
FROM Portfolio_Project_Covid..CovidDeaths
WHERE continent is NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount desc

-- Query 7: GLOBAL NUMBERS
SELECT SUM(new_cases) AS Total_Cases, SUM(CAST(new_deaths as int)) AS Total_Deaths, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 AS
DeathPercentage
FROM Portfolio_Project_Covid..CovidDeaths
WHERE continent is NOT NULL
--GROUP BY date
ORDER BY 1,2




-- First Table Join (Looking at Total Pop vs Vaccinations)
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,
dea.date) AS RollingVaccinationCount
-- RollingVaccinationCount/population * 100
FROM Portfolio_Project_Covid..CovidDeaths dea
JOIN Portfolio_Project_Covid..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3

-- Using a CTE to perform ops on RollingVacCount
WITH PopvsVac (continent, location, date, population, new_vaccinations, RollingVaccinationCount)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,
dea.date) AS RollingVaccinationCount
-- RollingVaccinationCount/population * 100
FROM Portfolio_Project_Covid..CovidDeaths dea
JOIN Portfolio_Project_Covid..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)
SELECT *, (RollingVaccinationCount/population)*100
FROM PopvsVac


--Temp Table Variant

DROP TABLE IF exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingVaccinationCount numeric)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,
dea.date) AS RollingVaccinationCount
-- RollingVaccinationCount/population * 100
FROM Portfolio_Project_Covid..CovidDeaths dea
JOIN Portfolio_Project_Covid..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL

SELECT *, (RollingVaccinationCount/population)*100
FROM #PercentPopulationVaccinated



-- Creating a View for later visualization

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,
dea.date) AS RollingVaccinationCount
-- RollingVaccinationCount/population * 100
FROM Portfolio_Project_Covid..CovidDeaths dea
JOIN Portfolio_Project_Covid..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL