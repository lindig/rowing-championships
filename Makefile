#
#
#

.PHONY: all clean

all: world-cup.db

world-cup.db: world-cup.sql race.csv crew.csv
	sqlite3 $@ < $< || rm -f world-cup.db

clean:
	rm -f world-cup.db
