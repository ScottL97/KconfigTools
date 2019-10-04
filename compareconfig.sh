#!/bin/bash
# compareconfig.sh

find_include_null() {
cat $1 | grep -v ^# | while read line
do
	key=$(echo $line | awk -F = '{print $1}')
	if [ -n "$key" ]
	then
		value1=$(echo $line | awk -F = '{print $2}')
		# 查找$2中对应行
		./grepi -q -p "^$key=" $2
		if [ $? -eq 0 ]
		then
			# 获取$2中对应行的值
			value2=$(grep "^$key=" $2 | awk -F = '{print $2}')
			if [ $common = y ]
			then
				if [ "$value1" = "$value2" ]
				then
					((sum++))
					echo "[$key IN COMMON]  $value1 $sum"
				fi
			else
				if [ "$value1" != "$value2" ]
				then
					((sum++))
					echo "[$key]  $value1 $value2 $sum"
				fi
			fi
		else # 查找$1中存在、$2中不存在的配置项
			if [ $common = n ]
			then
				((sum++))
				echo "[$key]  $value1 <NULL> $sum"
			fi
		fi
		echo $sum > tmp
	fi
done
if [ $common = n ]
then
	# 查找$2中存在、$1中不存在的配置项
	find_null $2 $1
fi
}

find_null() {
read sum < tmp
cat $1 | grep -v ^# | while read line
do
	key=$(echo $line | awk -F = '{print $1}')
	if [ -n "$key" ]
	then
		value1=$(echo $line | awk -F = '{print $2}')
		# 查找$2中对应行
		./grepi -q -p "^$key=" $2
		if [ $? -ne 0 ]
		then # 在$1中存在，在$2中不存在的配置项
			((sum++))
			echo "[$key]  <NULL> $value1 $sum"
		fi
	fi	
done
}

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
file1="$1"
file2="$2"
if [ -z "$1" ] || [ -z "$2" ]
then
	echo "Wrong params"
	exit 1
fi
sum=0
echo "config | $file1 | $file2 | sum"
find_include_null $file1 $file2 # 找到$file1中有、$file2中没有的配置项以及$file1和$file2都有、但是值不同的配置项
rm -rf tmp
