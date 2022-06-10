
-- likelihood of dieing from covid
SELECT location, date, total_cases, new_cases,total_deaths,(total_deaths/total_cases)*100 as deathwatch
FROM CovidDeaths
WHERE location = 'Nigeria' AND continent IS not NUll
ORDER BY 1,2;

-- looking at total cases vs population
SELECT location, date, population,total_cases,(total_cases/population)*100 as infected_population
FROM CovidDeaths
WHERE location = 'Nigeria' AND continent IS not NUll
ORDER BY 1,2;

-- checking for errors in the population
SELECT DISTINCT LOCATION
FROM coviddeaths
order by 1

-- Check the amount of infections per country
SELECT location,population,MAX(total_cases) AS HIghest,MAX((total_cases/population))*100 as infected_population
FROM CovidDeaths
WHERE location NOT IN ('WORLD''high income','low income','international','lower middle income','upper middle income') AND continent IS not NUll
GROUP BY [location],population
ORDER BY infected_population DESC

-- The death toll
SELECT continent,MAX(CAST(total_deaths AS int)) AS HIghest
FROM CovidDeaths
WHERE continent IS not NULL AND location NOT IN ('EURopean union','high income','low income','international','lower middle income','upper middle income')
GROUP BY continent
ORDER BY HIghest DESC;

--Global numbers
SELECT date, SUM(new_cases) daily_new,SUM(CAST(new_deaths AS int)) hades,SUM(CAST(new_deaths AS int))/SUM(new_cases) as deathwatch
FROM CovidDeaths
WHERE continent IS not NUll
GROUP BY date
ORDER BY 1;

-- looking at total population vs vaccination
WITH cuse 
AS (SELECT d.continent,d.location,d.date,population,v.new_vaccinations,
		SUM(CONVERT(bigint,v.new_vaccinations)) OVER (PARTITION BY d.location 
													ORDER BY d.date 
													 ) running_tot                           
FROM CovidDeaths d
JOIN CovidVaccinations v
	ON d.location = v.location 
AND d.date = v.date
WHERE d.continent IS not NUll 
--ORDER BY 2,3
)
SELECT *,(running_tot/population)*100 popVSvac
FROM cuse