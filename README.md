# data-exploration-covid19
Description:   Exploration of the first 2 years of global covid data with various queries

Motivation:    Curiosity to analyze distribution of infections, deaths, vaccinations, and other metrics
               on a per country basis as well as a continental basis
             
Functionality: The program contains queries indicating various metrics and performs 
               operations to further manipulate data into digestible formats. It highlights
               casting data types to ints for use in aggregate functions as well as utilizing
               both CTEs and Temp tables to perform ops on novel columns created from the datasets.
               It also creates a view later used to visualize a world map in Tableau.
                
Tech Used:     Microsoft SQL Management Server Studio 2022 (local instance connection)

How-To:        1. Establish local server connection in SSMS and create a new database
               2. Download the associated .xlsx datasets ('CovidDeaths', 'CovidVaccinations')
               3. Import datasets into database in SSMS (If error is encountered, launch Import Wizard from
                  SSMS folder in Start Menu; issue pertains to 32-bit vs 64-bit)
               4. Check Top 1000 rows to ensure datasets loaded in properly
               5. Download the .sql file 'Covid_Data_Exploration_Queries'
               6. Run queries one at a time.
               7. Branch off to do your own exploring with the data
