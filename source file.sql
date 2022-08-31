/*
* File: pxp131_Assignment2.sql
* 
* 1) Rename this file according to the instructions in the assignment statement.
* 2) Use this file to insert your solution.
*
*
* Author: SINGH, PRABAL
* Student ID Number: 2327029
* Institutional mail prefix: PXP131
*/


/*
*  Assume a user account 'fsad' with password 'fsad2022' with permission
* to create  databases already exists. You do NO need to include the commands
* to create the user nor to give it permission in you solution.
* For your testing, the following command may be used:
*
* CREATE USER fsad PASSWORD 'fsad2022' CREATEDB;
* GRANT pg_read_server_files TO fsad;
*/


/* *********************************************************
* Exercise 1. Create the Smoked Trout database
* 
************************************************************ */

-- The first time you login to execute this file with \i it may
-- be convenient to change the working directory.
\cd 'C:/Users/PRABAL YADAV/Desktop/assignment 2 fsad'
  -- In PostgreSQL, folders are identified with '/'


-- 1) Create a database called SmokedTrout.

CREATE DATABASE SmokedTrout WITH OWNER = fsad ENCODING = 'UTF8' CONNECTION LIMIT = -1;
-- 2) Connect to the database
\c smokedtrout fsad





/* *********************************************************
* Exercise 2. Implement the given design in the Smoked Trout database
* 
************************************************************ */

-- 1) Create a new ENUM type called materialState for storing the raw material state
CREATE TYPE materialstate AS ENUM (
    'Solid',
    'Liquid',
    'Gas',
    'Plasma'
);

-- 2) Create a new ENUM type called materialComposition for storing whether
-- a material is Fundamental or Composite.
CREATE TYPE public.materialcomposition AS ENUM (
    'Fundamental',
    'Composite'
);


-- 3) Create the table TradingRoute with the corresponding attributes.
CREATE TABLE public.tradingroute (
    monitoringkey integer NOT NULL,
    fleetsize smallint,
    lastyearrevenue decimal,
    operatingcompany character varying(50)
);
ALTER TABLE ONLY public.tradingroute
    ADD CONSTRAINT tradingroute_pkey PRIMARY KEY (monitoringkey);
-- 4) Create the table Planet with the corresponding attributes.
CREATE TABLE public.planet (
    planetid integer NOT NULL,
    population smallint,
    starsystem character varying(50),
    name character varying(50)
);
ALTER TABLE ONLY public.planet
    ADD CONSTRAINT planet_pkey PRIMARY KEY (planetid);
-- 5) Create the table SpaceStation with the corresponding attributes.
CREATE TABLE public.spacestation (
    stationid integer NOT NULL,
    planetid integer NOT NULL,
    name character varying(50),
    longitude character varying(50),
    latitude character varying(50)
);
ALTER TABLE ONLY public.spacestation
    ADD CONSTRAINT spacestation_pkey PRIMARY KEY (stationid);

ALTER TABLE ONLY public.spacestation
    ADD CONSTRAINT spacestation_planetid_fkey FOREIGN KEY (planetid) REFERENCES public.planet(planetid) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;

-- 6) Create the parent table Product with the corresponding attributes.
CREATE TABLE public.product (
    productid integer NOT NULL,
    volumeperton numeric,
    valueperton numeric,
    name character varying(50)
);
ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (productid);
-- 7) Create the child table RawMaterial with the corresponding attributes.
CREATE TABLE public.rawmaterial (
    fundamentalorcomposite public.materialcomposition,
    state public.materialstate
)
INHERITS (public.product);

-- 8) Create the child table ManufacturedGood. 
CREATE TABLE public.manufacturedgood (
)
INHERITS (public.product);

-- 9) Create the table MadeOf with the corresponding attributes.
CREATE TABLE public.madeof (
    manufacturedgoodid integer,
    productid integer
);

-- 10) Create the table Batch with the corresponding attributes.
CREATE TABLE public.batch (
    batchid integer NOT NULL,
    productid integer NOT NULL,
    extractionormanufacturingdate date,
    originalfrom smallint
);
ALTER TABLE ONLY public.batch
    ADD CONSTRAINT batch_pkey PRIMARY KEY (batchid);
-- 11) Create the table Sells with the corresponding attributes.
CREATE TABLE public.sells (
    batchid integer NOT NULL,
    stationid integer NOT NULL
);
ALTER TABLE ONLY public.sells
    ADD CONSTRAINT sells_pkey PRIMARY KEY (batchid);
ALTER TABLE ONLY public.sells
    ADD CONSTRAINT sells_stationid_fkey FOREIGN KEY (stationid) REFERENCES public.spacestation(stationid) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;

-- 12)  Create the table Buys with the corresponding attributes.
CREATE TABLE public.buys (
    batchid integer NOT NULL,
    stationid integer NOT NULL
);
ALTER TABLE ONLY public.buys
    ADD CONSTRAINT buys_pkey PRIMARY KEY (batchid);

ALTER TABLE ONLY public.buys
    ADD CONSTRAINT buys_stationid_fkey FOREIGN KEY (stationid) REFERENCES public.spacestation(stationid) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;

-- 13)  Create the table CallsAt with the corresponding attributes.
CREATE TABLE public.callsat (
    monitoringkey integer NOT NULL,
    stationid integer NOT NULL,
    visitorder smallint
);
ALTER TABLE ONLY public.callsat
    ADD CONSTRAINT callsat_stationid_fkey FOREIGN KEY (stationid) REFERENCES public.spacestation(stationid) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;

-- 14)  Create the table Distance with the corresponding attributes.
CREATE TABLE public.distance (
    planetorigin integer NOT NULL,
    planetdestination integer NOT NULL,
    avgdistance numeric NOT NULL
);
ALTER TABLE ONLY public.distance
    ADD CONSTRAINT distance_planetdestination_fkey FOREIGN KEY (planetdestination) REFERENCES public.planet(planetid) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


/* *********************************************************
* Exercise 3. Populate the Smoked Trout database
* 
************************************************************ */
/* *********************************************************
* NOTE: The copy statement is NOT standard SQL.
* The copy statement does NOT permit on-the-fly renaming columns,
* hence, whenever necessary, we:
* 1) Create a dummy table with the column name as in the file
* 2) Copy from the file to the dummy table
* 3) Copy from the dummy table to the real table
* 4) Drop the dummy table (This is done further below, as I keep
*    the dummy table also to imporrt the other columns)
************************************************************ */



-- 1) Unzip all the data files in a subfolder called data from where you have your code file 
-- NO CODE GOES HERE. THIS STEP IS JUST LEFT HERE TO KEEP CONSISTENCY WITH THE ASSIGNMENT STATEMENT

-- 2) Populate the table TradingRoute with the data in the file TradeRoutes.csv.
 CREATE TABLE Dummy (
monitoringkey integer NOT NULL ,
fleetsize smallint ,
operatingcompany character varying(50),
lastyearrevenue decimal);

\copy Dummy FROM './data/TradeRoutes.csv' WITH (FORMAT CSV , HEADER );

INSERT INTO TradingRoute (monitoringkey ,operatingcompany ,
fleetSize ,lastyearrevenue)
SELECT monitoringKey ,operatingcompany ,
fleetsize ,lastyearrevenue FROM Dummy;

DROP TABLE Dummy;

-- 3) Populate the table Planet with the data in the file Planets.csv.

CREATE TABLE Dummy (
planetid integer NOT NULL,
    starsystem character varying(50),
    planet character varying(50),
    population_in_millions_ smallint);

\copy Dummy FROM './data/Planets.csv' WITH (FORMAT CSV , HEADER );

INSERT INTO planet (planetid ,population ,
starsystem ,name)
SELECT planetid ,population_in_millions_ ,
starsystem ,planet FROM Dummy;

DROP TABLE Dummy;    

-- 4) Populate the table SpaceStation with the data in the file SpaceStations.csv.

CREATE TABLE Dummy (
stationid integer NOT NULL,
    planetid integer NOT NULL,
    spacestations character varying(50),
    longitude character varying(50),
    latitude character varying(50));

\copy Dummy FROM './data/SpaceStations.csv' WITH (FORMAT CSV , HEADER );

INSERT INTO spacestation (stationid,
    planetid, 
    name, 
    longitude, 
    latitude)
SELECT stationid,
    planetid, 
    spacestations, 
    longitude, 
    latitude FROM Dummy;

DROP TABLE Dummy;
-- 5) Populate the tables RawMaterial and Product with the data in the file Products_Raw.csv.  
CREATE TABLE Dummy (
productid integer NOT NULL,
name character varying(50),
stt character varying(50),
    volumeperton numeric,
    valueperton numeric,
    state materialstate);

\copy Dummy FROM './data/Products_Raw.csv' WITH (FORMAT CSV , HEADER );

update  Dummy set stt ='Fundamental' where stt='No';
update  Dummy set stt='Composite' where stt='Yes';
ALTER TABLE Dummy ADD fc materialcomposition; 
UPDATE Dummy set fc ='Fundamental' where stt='Fundamental';
UPDATE Dummy set fc ='Composite' where stt='Composite';
INSERT INTO rawmaterial (productid ,
    volumeperton ,
    valueperton ,
    name ,
    fundamentalorcomposite,
    state )
SELECT productid ,
    volumeperton ,
    valueperton ,
    name ,
    fc,
    state 
    FROM Dummy;

DROP TABLE Dummy;
-- 6) Populate the tables ManufacturedGood and Product with the data in the file  Products_Manufactured.csv.
 \copy public.manufacturedgood (productid,name, volumeperton, valueperton) from './data/Products_Manufactured.csv' WITH (FORMAT CSV , HEADER )
-- 7) Populate the table MadeOf with the data in the file MadeOf.csv.

CREATE TABLE Dummy (
manufacturedgoodid integer,
    productid integer);

\copy Dummy FROM './data/MadeOf.csv' WITH (FORMAT CSV , HEADER );

INSERT INTO madeof (manufacturedgoodid ,
    productid )
SELECT manufacturedgoodid ,
    productid  
    FROM Dummy;

DROP TABLE Dummy;
-- 8) Populate the table Batch with the data in the file Batches.csv.
  
CREATE TABLE Dummy (
    batchid integer NOT NULL,
    productid integer NOT NULL,
    extractionormanufacturingdate date,
    originalfrom smallint);

\copy Dummy FROM './data/Batches.csv' WITH (FORMAT CSV , HEADER );

INSERT INTO batch (batchid ,
    productid ,
    extractionormanufacturingdate ,
    originalfrom )
SELECT batchid ,
    productid ,
    extractionormanufacturingdate ,
    originalfrom  
    FROM Dummy;

DROP TABLE Dummy;
-- 9) Populate the table Sells with the data in the file Sells.csv.

CREATE TABLE Dummy (
    batchid integer NOT NULL,
    stationid integer NOT NULL);

\copy Dummy FROM './data/Sells.csv' WITH (FORMAT CSV , HEADER );

INSERT INTO sells (batchid ,
    stationid )
SELECT batchid ,
    stationid   
    FROM Dummy;

DROP TABLE Dummy;
-- 10) Populate the table Buys with the data in the file Buys.csv.
CREATE TABLE Dummy (
    batchid integer NOT NULL,
    stationid integer NOT NULL);

\copy Dummy FROM './data/Buys.csv' WITH (FORMAT CSV , HEADER );

INSERT INTO buys (batchid ,
    stationid )
SELECT batchid ,
    stationid   
    FROM Dummy;

DROP TABLE Dummy;
-- 11) Populate the table CallsAt with the data in the file CallsAt.csv. 
CREATE TABLE Dummy (
    monitoringkey integer NOT NULL,
    stationid integer NOT NULL,
    visitorder smallint);

\copy Dummy FROM './data/CallsAt.csv' WITH (FORMAT CSV , HEADER );

INSERT INTO callsat (monitoringkey,
    stationid ,
    visitorder)
SELECT monitoringkey,
    stationid ,
    visitorder 
    FROM Dummy;

DROP TABLE Dummy;
-- 12) Populate the table Distance with the data in the file PlanetDistances.csv.
 
CREATE TABLE Dummy (
  planetorigin integer NOT NULL,
    planetdestination integer NOT NULL,
    distance numeric NOT NULL);

\copy Dummy FROM './data/PlanetDistances.csv' WITH (FORMAT CSV , HEADER );

INSERT INTO distance (planetorigin ,
    planetdestination  ,
    avgdistance)
SELECT planetorigin ,
    planetdestination  ,
    distance 
    FROM Dummy;


/* *********************************************************
* Exercise 4. Query the database
* 
************************************************************ */

-- 4.1 Report last year taxes per company

-- 1) Add an attribute Taxes to table TradingRoute
ALTER TABLE tradingroute ADD column taxes decimal;
-- 2) Set the derived attribute taxes as 12% of LastYearRevenue
UPDATE tradingroute SET taxes= lastyearrevenue*0.12;
-- 3) Report the operating company and the sum of its taxes group by company.
SELECT operatingcompany, SUM(taxes) AS "SUM OF TAXES" FROM tradingroute GROUP BY operatingcompany;



-- 4.2 What's the longest trading route in parsecs?

-- 1) Create a dummy table RouteLength to store the trading route and their lengths.
CREATE TABLE public.routelength (
    monitoringkey integer,
    length numeric
);
-- 2) Create a view EnrichedCallsAt that brings together trading route, space stations and planets.
CREATE VIEW public.enrichedcallsat AS
 SELECT callsat.monitoringkey,
    callsat.stationid,
    spacestation.planetid,
    callsat.visitorder
   FROM (public.spacestation
     JOIN public.callsat ON ((callsat.stationid = spacestation.stationid)));
-- 3) Add the support to execute an anonymous code block as follows;
do
$$
declare
-- 4) Within the declare section, declare a variable of type real to store a route total distance.
routetotaldistance decimal := 0.0;
-- 5) Within the declare section, declare a variable of type real to store a hop partial distance.
hoppartialdistance decimal :=0.0;
-- 6) Within the declare section, declare a variable of type record to iterate over routes.
routerec record;
-- 7) Within the declare section, declare a variable of type record to iterate over hops.
hoprec record;
-- 8) Within the declare section, declare a variable of type text to transiently build dynamic queries.
dynquery text;
-- 9) Within the main body section, loop over routes in TradingRoutes
begin
-- 10) Within the loop over routes, get all visited planets (in order) by this trading route.
for routerec in select monitoringkey  from tradingroute
loop
dynquery:= 'create view  portsofcall as '
||'select  planetid , visitorder '
||'from enrichedcallsat '
||'where monitoringkey = '||routerec.monitoringkey
||' order by visitorder';
-- 11) Within the loop over routes, execute the dynamic view
execute dynquery;
-- 12) Within the loop over routes, create a view Hops for storing the hops of that route. 
create view hops as select a.planetid as planetorigin ,  b.planetid as planetdestination from portsofcall a,portsofcall b where b.visitorder = a.visitorder+1 order by a.visitorder;
-- 13) Within the loop over routes, initialize the route total distance to 0.0.
routetotaldistance :=0.0;
-- 14) Within the loop over routes, create an inner loop over the hops
for hoprec in select planetorigin,planetdestination from hops
loop
-- 15) Within the loop over hops, get the partial distances of the hop. 
dynquery:='select avgdistance from distance where planetorigin = '
||hoprec.planetorigin
||' and planetdestination = '
|| hoprec.planetdestination;
-- 16)  Within the loop over hops, execute the dynamic view and store the outcome INTO the hop partial distance.
execute dynquery into hoppartialdistance;
-- 17)  Within the loop over hops, accumulate the hop partial distance to the route total distance.
routetotaldistance := routetotaldistance + hoppartialdistance;
-- 18)  Go back to the routes loop and insert into the dummy table RouteLength the pair (RouteMonitoringKey,RouteTotalDistance).
end loop;
-- 19)  Within the loop over routes, drop the view for Hops (and cascade to delete dependent objects).
insert into routelength(monitoringkey, length) values(routerec.monitoringkey,routetotaldistance);
drop view hops cascade;
-- 20)  Within the loop over routes, drop the view for PortsOfCall (and cascade to delete dependent objects).
drop view portsofcall cascade;
end loop;
end;
$$;
-- 21)  Finally, just report the longest route in the dummy table RouteLength.
select monitoringkey from routelength where length=(select max(length) from routelength);
