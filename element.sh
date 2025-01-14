#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"

#  check if an argument is provided
if [[ -z $1 ]]
then
    echo "Please provide an element as an argument."
    exit 0
fi

# use the first argument as the SYMBOL
SYMBOL=$1

 
# if input is not a number
if [[ ! $SYMBOL =~ ^[0-9]+$ ]]
then
    # if input is greater than two letters
    LENGTH=$(echo -n "$SYMBOL" | wc -m)
    if [[ $LENGTH -gt 2 ]]
    then
        # get data by full name
        DATA=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name = '$SYMBOL'")
    else
        # get data by atomic symbol
        DATA=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol = '$SYMBOL'")
    fi
else
    # get data by atomic number
    DATA=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $SYMBOL")
fi

# Check if data is empty

if [[ -z $DATA ]]
then
    echo "I could not find that element in the database."
else
    # Parse and display the data
    echo $DATA | while read TYPEID BAR NUMBER BAR SYMBOL BAR NAME BAR WEIGHT BAR MELTING BAR BOILING BAR TYPE
    do
        echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $WEIGHT amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
fi







