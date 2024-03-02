#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS;
do
  # Insert winner team
  if [[ $WINNER != 'winner' ]]
  then
    WINNER_RESULT=$($PSQL "select name from teams where name='$WINNER'")
    if [[ -z $WINNER_RESULT ]]
    then
      INSERT_WINNER_RESULT=$($PSQL "insert into teams(name) values('$WINNER')")
      if [[ $INSERT_WINNER_RESULT == 'INSERT 0 1' ]]
        then
        echo Inserted winner team: $WINNER
      fi
    fi
  fi

  # Insert opponent team
  if [[ $OPPONENT != 'opponent' ]]
  then
    OPPONENT_RESULT=$($PSQL "select name from teams where name='$OPPONENT'")
    if [[ -z $OPPONENT_RESULT ]]
      then
      INSERT_OPPONENT_RESULT=$($PSQL "insert into teams(name) values('$OPPONENT')")
      if [[ $INSERT_OPPONENT_RESULT == 'INSERT 0 1' ]]
        then
        echo Inserted opponent team: $OPPONENT
      fi
    fi
  fi


   # Inser the game info
  WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
  OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")

  echo $WINNER_ID, $OPPONENT_ID
  INSERT_GAME_INFO_RESULT=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values('$YEAR', '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')")
  if [[ $INSERT_GAME_INFO_RESULT == 'INSERT 0 1' ]]
  then
    echo Inserted game: $YEAR, $ROUND, $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS
  fi
done

