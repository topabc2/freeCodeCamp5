#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=postgres -t --tuples-only -c"
# *********************************************

RANDOM_NUMBER=$(( $RANDOM % 1000 + 1 ))
echo $RANDOM_NUMBER
echo "Enter your username:"
read USERNAME

USERNAME_CHECK=$($PSQL "SELECT * FROM users WHERE username = '$USERNAME'")

if [[ -z $USERNAME_CHECK ]]
then
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  USER_INSERT=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
  INSERT_GAMES_PLAYED=$($PSQL "UPDATE users SET games_played = $(( $GAMES_PLAYED + 1 )) WHERE username='$USERNAME'")
else
  echo "$USERNAME_CHECK" | while read USERNAME BAR USER_ID BAR GAMES_PLAYED BAR BEST_GAME
  do
    INSERT_GAMES_PLAYED=$($PSQL "UPDATE users SET games_played = $(( $GAMES_PLAYED + 1 )) WHERE username='$USERNAME'")
    echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  done
fi

echo "Guess the secret number between 1 and 1000:"
read GUESS

GUESS_NUMBER=0
while [[ $GUESS != $RANDOM_NUMBER ]]
do
  if [[ $GUESS =~ ^[0-9]+$ ]]
  then
    GUESS_NUMBER=$(( $GUESS_NUMBER + 1 ))
    if [[ $GUESS < $RANDOM_NUMBER ]]
    then
      echo "It's higher than that, guess again:"
      read GUESS
    elif [[ $GUESS > $RANDOM_NUMBER ]]
    then
      echo "It's lower than that, guess again:"
      read GUESS
    fi
  else
    echo "That is not an integer, guess again:"
    read GUESS
  fi
done

GUESS_NUMBER=$(( $GUESS_NUMBER + 1 ))
echo "You guessed it in $GUESS_NUMBER tries. The secret number was $RANDOM_NUMBER. Nice job!"

USERNAME_CHECK_2=$($PSQL "SELECT * FROM users WHERE username = '$USERNAME'")
echo "$USERNAME_CHECK_2" | while read USERNAME BAR USER_ID BAR GAMES_PLAYED BAR BEST_GAME
do
  if [[ "$BEST_GAME" = "0" ]]
  then
    INSERT_BEST_GAME=$($PSQL "UPDATE users SET best_game = $GUESS_NUMBER WHERE username='$USERNAME'")
  fi

  if [[ $GUESS_NUMBER -lt $BEST_GAME ]]
  then
    INSERT_BEST_GAME=$($PSQL "UPDATE users SET best_game = $GUESS_NUMBER WHERE username='$USERNAME'")
  fi
done