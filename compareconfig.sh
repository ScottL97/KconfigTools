#!/bin/bash
# compareconfig.sh

# 必选参数：两个内核配置文件
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
		# 获取$2中对应行的值
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
