#!/bin/bash

clear

# Устанавливаем размер экрана
rows=$(tput lines)
cols=$(tput cols)

# Устанавливаем начальное положение ракеток
paddle1_y=$(( $rows / 2 - 2 ))
paddle2_y=$(( $rows / 2 - 2 ))

# Устанавливаем начальное положение шарика
ball_x=$(( $cols / 2 ))
ball_y=$(( $rows / 2 ))

# Устанавливаем начальную скорость шарика
ball_vx=1
ball_vy=-1

# Отрисовка игрового поля
function draw_screen {
  tput clear

  # Отрисовка ракеток
  for (( i=0; i<5; i++ )); do
    tput cup $(( $paddle1_y + $i )) 2
    echo "|"
    tput cup $(( $paddle2_y + $i )) $(( $cols - 3 ))
    echo "|"
  done
}

# Обработка событий
function handle_input {
  read -s -n 1 -t 0.05 key
  case $key in
    w)
      # Движение первой ракетки вверх
      if (( $paddle1_y > 1 )); then
        paddle1_y=$(( $paddle1_y - 2 ))
      fi
      ;;
    s)
      # Движение первой ракетки вниз
      if (( $paddle1_y < $rows - 6 )); then
        paddle1_y=$(( $paddle1_y + 2 ))
      fi
      ;;
    i)
      # Движение второй ракетки вверх
      if (( $paddle2_y > 1 )); then
        paddle2_y=$(( $paddle2_y - 2 ))
      fi
      ;;
    k)
      # Движение второй ракетки вниз
      if (( $paddle2_y < $rows - 6 )); then
        paddle2_y=$(( $paddle2_y + 2 ))
      fi
      ;;
    q)
      # Выход из игры
      exit 0
      ;;
  esac
}

# Основной цикл игры
while true; do

  # Обработка ввода пользователя
  handle_input

  # Обновление положения шарика
  ball_x=$(( $ball_x + $ball_vx ))
  ball_y=$(( $ball_y + $ball_vy ))

  # Отражение шарика от границ поля
  if (( $ball_x < 2 || $ball_x > $cols - 3 )); then
    ball_vx=$(( $ball_vx * -1 ))
  fi

  if (( $ball_y < 1 || $ball_y > $rows - 2 )); then
    ball_vy=$(( $ball_vy * -1 ))
  fi

  # Отражение шарика от ракеток
  if (( $ball_x == 3 && $ball_y >= $paddle1_y && $ball_y <= $paddle1_y + 4 )); then
    ball_vx=$(( $ball_vx * -1 ))
  fi

  if (( $ball_x == $cols - 4 && $ball_y >= $paddle2_y && $ball_y <= $paddle2_y + 4 )); then
    ball_vx=$(( $ball_vx * -1 ))
  fi

  # Проверка на проигрыш
  if (( $ball_x == 1 )); then
    echo "Player 2 wins!"
    exit 0
  fi

  if (( $ball_x == $cols - 2 )); then
    echo "Player 1 wins!"
    exit 0
  fi

  # Отрисовка экрана
  draw_screen

  # Отрисовка шарика
  tput cup $ball_y $ball_x
  echo "O"

  # Задержка
  sleep 0.05
done
