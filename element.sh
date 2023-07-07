#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
#check if given an argument
if [[ -z $1 ]]
then
  #if not argument passed then exit script
  echo "Please provide an element as an argument." 
  exit
else
  #check if argument is a number and thus the atomic number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$1
  else
    #if given symbol or name get the atomic number
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1' OR name='$1'")
  fi
  #pull all information from tables for the element
  INFORMATION=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER")
  #check if any information is found
  if [[ -z $INFORMATION ]]
  then
    #If not information found
    echo "I could not find that element in the database."
  else
  #If information found print the required sentence
    echo $INFORMATION | (IFS="|" read -r ID NUMBER SYMBOL NAME  MASS MELTING BOILING TYPE;
    echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  )
  fi






fi
