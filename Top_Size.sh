#!/bin/bash



N=-1

minsize=0

short_size=false

dir="." # по умолчанию ищем в текущем каталоге



while (( "$#" )) # $# возвращает кол-во текущих параметров

# (()) сравнивает с 0

do

    case "$1" in

        --help)

            # Вывод справки о формате и выход

            echo "Usage: Top_Size.sh [--help] [-h] [-N] [-s minsize] [--] [dir...] где

 --help - вывод справки о формате и выход

 -N - количество файлов, если не задано - все файлы

(N - число, например -10)

 minsize - минимальный размер, если не задан - 1 байт

 -h - вывод размера в человекочитаемом формате

(оптимальный выбор единиц измерения размера - байты, килобайты,

мегабайты и т.д.)

 dir... - каталог(и) поиска, если не заданы - текущий каталог (.)

 -- - разделение опций и каталога

(поддержка каталогов, начинающихся с минуса)"

            exit 0;;

        -s)

            shift

            minsize=$1

            shift;;

        -h)

            short_size=true

            shift;;

        --)

            shift

            # каталог для поиска

            dir="$1"

            break;;

  -[0-9]*) # любое количество символов цифр от 0 до 9

            # Извлекаем количество наибольших файлов

            # то есть обрезаем все до первого минуса в первом аргументе

            N="${1#-}"

            shift;;

        *)

            # каталог для поиска

            dir="$1"

            shift;;

    esac

done



# Находим файлы и фильтруем их по минимальному размеру

find "$dir" -type f -size +"$minsize"c -printf "%s\t%p\n" |

    # Сортировка по размеру в обратном порядке

    sort -nr |

    # Ограничение вывода первыми N файлами, если N указан

    if [ "$N" > 0 ];

    then

        head -n "$N"

    else

        cat

    fi |

    while IFS=$'\t' read -r filesize filepath;

    do

        if [ "$short_size" = true ];

        then

            # Вывод размера в "человекочитаемом формате"

            du -h "$filepath"

        else

            echo "$filesize $filepath"

        fi

    done

exit 0