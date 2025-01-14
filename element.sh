#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

MAIN_PROGRAM() {
  if [[ -z $1 ]]
  then
    echo "Please provide an element as an argument."
  else
    PRINT_ELEMENT $1
  fi
}

PRINT_ELEMENT() {
  INPUT=$1
  if [[ ! $INPUT =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$(echo $($PSQL "SELECT atomic_number FROM elements WHERE symbol='$INPUT' OR name='$INPUT';") | sed 's/ //g')
  else
    ATOMIC_NUMBER=$(echo $($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$INPUT;") | sed 's/ //g')
  fi
  
  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo "I could not find that element in the database."
  else
    ELEMENT_INFO=$($PSQL "SELECT elements.atomic_number, elements.name, elements.symbol, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius FROM elements JOIN properties ON elements.atomic_number=properties.atomic_number JOIN types ON properties.type_id=types.type_id WHERE elements.atomic_number=$ATOMIC_NUMBER;")
    
    echo "$ELEMENT_INFO" | while IFS=" | " read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
    done
  fi
}

START_PROGRAM() {
  MAIN_PROGRAM $1
}

START_PROGRAM $1
