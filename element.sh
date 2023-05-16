#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --tuples-only -c"

if [[ -z $1 ]]
then
  echo -e "\nPlease provide an element as an argument."
  exit
fi

#Input for the element
#first if checks if input is number
if [[ $1 =~ ^[1-9]+$ ]]
then
  NUMBER=$($PSQL "select atomic_number from elements where atomic_number = '$1'")
else
#if argument is string
  NUMBER=$($PSQL "select atomic_number from elements join properties using(atomic_number) join types using(type_id) where name = '$1' or symbol = '$1'")
fi

if [[ -z $NUMBER ]]
then
  echo -e "\nI could not find that element in the database."
  exit
fi

NAME=$($PSQL "select name from elements where atomic_number = '$NUMBER'")
SYMBOL=$($PSQL "select symbol from elements where atomic_number = '$NUMBER'")
TYPE=$($PSQL "select type from elements join properties using(atomic_number) join types using(type_id) where atomic_number = '$NUMBER'")
MASS=$($PSQL "select atomic_mass from elements join properties using(atomic_number) join types using(type_id) where atomic_number = '$NUMBER'")
M_POINT=$($PSQL "select melting_point_celsius from elements join properties using(atomic_number) join types using(type_id) where atomic_number = '$NUMBER'")
B_POINT=$($PSQL "select boiling_point_celsius from elements join properties using(atomic_number) join types using(type_id) where atomic_number = '$NUMBER'")

NUMBER=$(echo $NUMBER | sed 's/ //g')
SYMBOL=$(echo $SYMBOL | sed 's/ //g')
TYPE=$(echo $TYPE | sed 's/ //g')
MASS=$(echo $MASS | sed 's/ //g')
M_POINT=$(echo $M_POINT | sed 's/ //g')
B_POINT=$(echo $B_POINT | sed 's/ //g')
NAME=$(echo $NAME | sed 's/ //g')

echo -e "\nThe element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $M_POINT celsius and a boiling point of $B_POINT celsius."
