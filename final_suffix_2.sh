#!/bin/bash

dry_run=false
printnames=false
was_rename=false
is_suffix=false
separator=false

# Функция для отображения справки
function show_help {
    echo "Формат вызова: ./final_suffix.sh суффикс [-h] [-d] [-v] -- названия файлов"
    echo "  суффикс - суффикс, который следует добавить перед расширением"
    echo "  -h - вывод справки о формате команды"
    echo "  -d - 'сухой' запуск - отображает предполагаемые изменения без переименования"
    echo "  -v - выводит имена переименовываемых файлов"
    echo "  -- - разделитель опций и имен файлов"
    echo "  названия файлов - список переименовываемых файлов"
}

# Переименование файлов
function my_rename {
    file=$1
    if [ -e "$file" ]
    then
    	if [[ !($file =~ *[/]*) ]]
  	then
      		file="./${file}"
  	fi
  	
    path=${file%/*}
    file=${file##*/}
    ext=${file##*.}
    
    if [ "$ext" = "$file" ]
    then
    	ext=""
    else
    	ext=.$ext
    fi
    
    file_no_ext=${file%.*}
    new_filename=$path/$file_no_ext$suffix$ext

    if $printnames
    then
    	echo $file
    fi
        
    if $dry_run
    then
    	echo "Renaming '$file' to '$new_filename'"
    else
    	mv -i "$file" "$new_filename"
    fi
        
    else
        >&2 echo "Ошибка: Файл не найден: $file"
    fi
}

# Проверка наличия аргументов
if [ "$#" == 0 ]; then
    >&2 echo "Ошибка: не хватает аргументов."
    exit 1
fi

while (( "$#" )) 
do
    if [[ $separator = true ]] #-- meeted after that suffix or file names
    then
    	if [[ $is_suffix == false ]]
  	then
    		suffix="$1"
    		is_suffix=true
  	else
    		my_rename "$1"
    		was_rename=true
    	fi
    	shift
    else

	    case $1 in
		-h)
		    show_help
		    exit 0
		    ;;
		-d)
		    dry_run=true
		    shift
		    ;;
		-v)
		    printnames=true
		    shift
		    ;;
		--)
		    separator=true
		    shift
		    ;;
		-*)
		    if [[ $is_suffix == false ]]
		    then
  			suffix="$1"
  			is_suffix=true
  		    else
  		    	>&2 echo "Ошибка: Неверная опция: $1"
		    	show_help
		    	exit 1
		    fi
		    shift
		    ;;
		*)
		    if [[ $is_suffix == false ]]
		    then
  			suffix="$1"
  			is_suffix=true
  		    else
  		        my_rename "$1"
			was_rename=true
		    fi
		    shift
		    ;;

	    esac
    fi
done

# Проверяем наличие файлов
if [ "$was_rename" == false ]; then
    >&2 echo "Ошибка: Не указаны файлы для переименования."
    exit 2
fi

