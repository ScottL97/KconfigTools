#!/bin/bash

# 必选参数：两个文件路径
# 默认找相同，-v找不同
common=y
while getopts v OPTION
do
	case $OPTION in
	v)common=n;;
	esac
done
shift $((OPTIND-1))
cat $1 | grep -v ^# | while read line
do
	key=$(echo $line | awk -F = '{print $1}')
	value1=$(echo $line | awk -F = '{print $2}')
	# 查找$2中对应行
	./grepi -q -p ^$key= $2
	if [ $? -eq 0 ]
	then
		value2=$(grep ^$key= $2 | awk -F = '{print $2}')
		if [ $common = y ]
		then
			if [ "$value1" = "$value2" ]
			then
				echo $key IN COMMON
			fi
		else
			if [ "$value1" != "$value2" ]
			then
				((sum++))
				echo "[$key]  $value1 $value2 $sum"
			fi
		fi
	fi
done
echo "******************************************"
#if [ $common = y  ]
#then
#	echo "In common: $sum"
#else
#	echo "Not in common: $sum"
#fi
