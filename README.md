# World Rowing Championships

This repository builds an Sqlite3 database with results from World
Rowing Championships. 

|Year|Event                       |
|----|----------------------------|
|2010|WCH Karapiro, New Zealand   |
|2011|WCH Bled, Slovenia          |
|2012|2012 WSJCH Plovdiv, Bulgaria|
|2013|WCH Chungju, Korea          |
|2014|WCH Amsterdam, NED          |
|2015|WCH Aiguebelette, France    |
|2016|WCHIE Rotterdam, Netherlands|
|2016|WCH Rotterdam, Netherlands  |
|2017|WCH Sarasota-Bradenton, USA |

## Building

```sh
$ make
```

If you don't have Make available, you can also load `world-cup.sql` into
an Sqlite3 datbase to create the database from the CSV files in this
repository.

## Examples

### Fastest Races in a Year

Find the fastest races in selected boat classes for every year:

```sql
SELECT year, 
       class, 
       min(time_2000m) AS time, 
       team, 
       descr 
FROM   race, 
       crew 
WHERE  class IN ( "M8+", "W8+", "M4x", "W4x" ) 
       AND crew.race = race.id 
GROUP  BY class, 
          year 
ORDER  BY class, 
          time, 
          year; 
```

Result times are in seconds.

```
year  class  time    team  descr                      
----  -----  ------  ----  ---------------------------
2014  M4x    332.26  UKR   WCH Amsterdam, NED         
2011  M4x    339.31  AUS   WCH Bled, Slovenia         
2013  M4x    341.13  GER   WCH Chungju, Korea         
2010  M4x    341.44  CRO   WCH Karapiro, New Zealand  
2017  M4x    343.1   LTU   WCH Sarasota-Bradenton, USA
2015  M4x    343.32  GER   WCH Aiguebelette, France   

2014  M8+    324.11  GBR   WCH Amsterdam, NED         
2010  M8+    324.62  GER   WCH Karapiro, New Zealand  
2015  M8+    325.28  NED   WCH Aiguebelette, France   
2017  M8+    326.85  GER   WCH Sarasota-Bradenton, USA
2011  M8+    328.81  GER   WCH Bled, Slovenia         
2013  M8+    330.35  GBR   WCH Chungju, Korea         

2014  W4x    366.84  GER   WCH Amsterdam, NED         
2015  W4x    375.24  GER   WCH Aiguebelette, France   
2010  W4x    375.62  GBR   WCH Karapiro, New Zealand  
2017  W4x    376.71  NED   WCH Sarasota-Bradenton, USA
2011  W4x    378.37  GER   WCH Bled, Slovenia         
2013  W4x    383.27  POL   WCH Chungju, Korea         

2014  W8+    356.83  USA   WCH Amsterdam, NED         
2015  W8+    359.58  USA   WCH Aiguebelette, France   
2010  W8+    360.52  USA   WCH Karapiro, New Zealand  
2013  W8+    362.14  USA   WCH Chungju, Korea         
2011  W8+    363.65  USA   WCH Bled, Slovenia         
2017  W8+    366.4   ROU   WCH Sarasota-Bradenton, USA
```

### Speed Difference between Light and Open Weight

Compare the fastest race for a boat class in a year between light-weight
and open-weight crews.

```sql
select
  A.year,
  A.class,
  B.class,
  printf( "%5.2f", (B.time / A.time - 1.0) * 100) as percent
from
  (
    select
      year,
      class,
      min(time_2000m) as time
    from
      race
    where
      class in ("M4x", "W4x", "M1x", "W1x")
    group by
      year,
      class
  ) as A
  join (
    select
      year,
      class,
      min(time_2000m) as time
    from
      race
    where
      class in ("LM4x", "LW4x", "LM1x", "LW1x")
    group by
      year,
      class
  ) as B
where
  A.year = B.year
  and "L" || A.class = B.class
order by
  A.class,
  percent
```

```
year  class  class  percent
----  -----  -----  -------
2014  M1x    LM1x    1.57
2017  M1x    LM1x    2.05
2015  M1x    LM1x    2.15
2013  M1x    LM1x    2.81
2011  M1x    LM1x    3.79
2010  M1x    LM1x    4.46

2015  M4x    LM4x    1.51
2017  M4x    LM4x    2.55
2014  M4x    LM4x    3.16
2013  M4x    LM4x    4.22
2010  M4x    LM4x    4.58
2011  M4x    LM4x    5.50

2013  W1x    LW1x    1.20
2015  W1x    LW1x    2.06
2017  W1x    LW1x    3.66
2014  W1x    LW1x    3.76
2010  W1x    LW1x    3.85
2011  W1x    LW1x    4.27

2014  W4x    LW4x    2.48
2013  W4x    LW4x    2.56
2011  W4x    LW4x    2.58
2015  W4x    LW4x    2.63
2017  W4x    LW4x    4.58
2010  W4x    LW4x    5.23
```

## Structure

```sql
CREATE TABLE crew(
  race INTEGER,
  team TEXT,
  athlete TEXT,
  birthday DATE
);
CREATE TABLE race(
  id INTEGER,
  year INTEGER,
  date DATE,
  descr TEXT,
  class TEXT,
  number TEXT,
  round TEXT,
  gender TEXT,
  weight TEXT,
  junior TEXT,
  adaptive TEXT,
  coxed TEXT,
  final TEXT,
  time_500m REAL,
  time_1000m REAL,
  time_1500m REAL,
  time_2000m REAL
);
```

## Data Sources

The data in this directory was derived from 
[World Rowing Championship Pacing Profile Project](https://github.com/danichusfu/rowing_pacing_profiles), which in
turn derived it from published race results. Compared with the original
data, the data here is slighly simplified.


