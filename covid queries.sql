--Analyzing Covid Data

--Daily increases in relation to population
SELECT location, date, population, total_cases, (total_cases/population)*100 as PopvsCase
FROM portfoliocovid.dbo.Deaths
Where location like '%states'
Order by 1,2;

--Daily Death rate percentage
SELECT location, date, total_cases, total_deaths,(total_cases/total_deaths)*100 as DeathPercentage
FROM portfoliocovid.dbo.Deaths
Where location = 'United States';

--What country has the highest infection rate compared to their population

SELECT location,population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentagePopulationInfected
FROM portfoliocovid.dbo.Deaths
Group by location, population
Order by PercentagePopulationInfected desc;

--What country has the highest death count
SELECT location, MAX(total_deaths) as TotalDeathCount
FROM portfoliocovid.dbo.Deaths
Where continent is not null
Group by location
Order by TotalDeathCount desc;

--Breaking things down by continents

--Highest death count by continent
SELECT location, MAX(total_deaths) as TotalDeathCount
FROM portfoliocovid.dbo.Deaths
Where continent is null
Group by location
Order by TotalDeathCount desc;

--Global Data per day

SELECT  date, SUM(new_cases) as TotalCases, SUM(New_deaths) as TotalDeaths, SUM(new_deaths)/SUM(new_cases)*100 as TotalPercentage
FROM portfoliocovid.dbo.Deaths
WHERE continent is not null
Group by date
Order by 1,2;


--Global Data 

SELECT SUM(new_cases) as TotalCases, SUM(New_deaths) as TotalDeaths, SUM(new_deaths)/SUM(new_cases)*100 as TotalPercentage
FROM portfoliocovid.dbo.Deaths
WHERE continent is not null
Order by 1,2;

--Covid Vaccine Data

Select * 
FROM portfoliocovid.dbo.deaths d
JOIN portfoliocovid.dbo.Vaccine v
ON
d.location = v.location 
and
d.date = v.date;


--Total population vs vaccination
SELECT  d.continent, d.location, d.date, d.population, v.new_vaccinations
from portfoliocovid.dbo.deaths d
JOIN portfoliocovid.dbo.Vaccine v
ON d.location = v.location and d.date = v.date
Where d.continent is not null;


SELECT  d.continent, d.location, d.date, d.population, v.new_vaccinations, SUM(cast(v.new_vaccinations as INT)) OVER (Partition by d.location order by d.location, d.date) as VaccinatedbyDay
from portfoliocovid.dbo.deaths d
JOIN portfoliocovid.dbo.Vaccine v
ON d.location = v.location and d.date = v.date
Where d.continent is not null;












