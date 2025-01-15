#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"

# Check if an argument is provided
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit 0
fi

# Use the first argument as the input
INPUT=$1

# Query the database
if [[ $INPUT =~ ^[0-9]+$ ]]; then
  DATA=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $INPUT")
else
  DATA=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol = '$INPUT' OR name = '$INPUT'")
fi

# Check if data exists
if [[ -z $DATA ]]; then
  echo "I could not find that element in the database."
else
  # Trim whitespace and clean up the data
  DATA=$(echo "$DATA" | sed 's/^[ \t]*//;s/[ \t]*$//;s/|/ /g')

  # Parse the data into variables
  read -r NUMBER SYMBOL NAME TYPE MASS MELTING BOILING <<< "$DATA"
  
  # Format the output correctly
  echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
fi
