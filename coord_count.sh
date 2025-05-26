#!/bin/bash

# Проверка, передан ли файл в качестве аргумента
if [ $# -eq 0 ]; then
  echo "Ошибка: Не указан файл для обработки."
  echo "Использование: $0 <имя_файла>"
  exit 1
fi

# Имя файла из аргумента
input_file=$1

# Проверка, существует ли файл
if [ ! -f "$input_file" ]; then
  echo "Ошибка: Файл '$input_file' не найден."
  exit 1
fi

# Инициализация переменных для суммирования
sum_x=0
sum_y=0
sum_z=0
count=0

# Чтение файла построчно
while IFS= read -r line; do
  # Проверяем, что строка начинается с HETATM
  if [[ $line == HETATM* ]]; then
    # Разделяем строку на столбцы
    columns=($line)
    
    # Извлекаем координаты (6-й, 7-й и 8-й столбцы)
    x=${columns[6]}
    y=${columns[7]}
    z=${columns[8]}
    
    # Суммируем значения
    sum_x=$(echo "$sum_x + $x" | bc)
    sum_y=$(echo "$sum_y + $y" | bc)
    sum_z=$(echo "$sum_z + $z" | bc)
    
    # Увеличиваем счетчик строк
    count=$((count + 1))
  fi
done < "$input_file"

# Вычисляем средние значения
avg_x=$(echo "scale=3; $sum_x / $count" | bc)
avg_y=$(echo "scale=3; $sum_y / $count" | bc)
avg_z=$(echo "scale=3; $sum_z / $count" | bc)

# Выводим результат
echo "Среднее значение X: $avg_x"
echo "Среднее значение Y: $avg_y"
echo "Среднее значение Z: $avg_z"
