#!/bin/bash
# compare.sh

# $1是要查找的字段，$2是进行查找的字符串
comparestr() {
	res=1
	./grepi -q -p $1 $2
	if [ $? -eq 0 ]
	then
		res=0
	fi
	return $res
}

# 必选参数：两个文件路径
# 默认找相同处，-v找不同处
common=y
while getopts v OPTION
do
	case $OPTION in
	v)common=n;;
	esac
done
shift $((OPTIND-1))
if [ -z $1 ] || [ -z $2 ]
then
	echo "Need more params"
	exit 1
fi
cat $1 | grep -v ^# | while read line
do
	comparestr $line $2
	res=$?
	if [ $res -eq 0 ] && [ $common = "y" ]
	then
		echo $line is in common
	fi
	if [ $res -eq 1 ] && [ $common = "n" ]
	then
		echo $line is not in common
	fi
done
