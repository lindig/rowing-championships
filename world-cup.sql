
DROP TABLE IF EXISTS crew;
CREATE TABLE crew(
  race INTEGER,
  team TEXT,
  athlete TEXT,
  birthday DATE
);

DROP TABLE IF EXISTS race;
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

.mode csv
.header on
.import crew.csv crew
.import race.csv race

CREATE UNIQUE INDEX race_idx on race(id);



