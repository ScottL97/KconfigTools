# KconfigTools
Kconfig配置对比、批量修改等相关的Linux工具。

# 测试用例
```
root@scott-virtual-machine:~/mylinuxtools# cat f1
# config_c=n
config_php=y
config_python=n
config_perl=y
root@scott-virtual-machine:~/mylinuxtools# cat f2
config_c=y
# config_python=n
config_php=y
config_perl=n
```
# grepi
## Advantages
1. 可以使用-q选项不输出任何信息，以供其他进程调用而不产生冗余信息。
2. 可以使用正则表达式检索一个目录中的所有文件的内容。
## Usage
```
root@scott-virtual-machine:~/mylinuxtools# grepi -p python f1
[Target file]: f1
[Word]: python
config_python=n
-----------------
root@scott-virtual-machine:~/mylinuxtools# grepi -p python .
[Target dir]: .
[Word]: python
# config_python=n
In file: ./f2
-----------------
config_python=n
In file: ./f1
-----------------
```
# compare
## Advantages
1. 和diff等逐行比较的工具不同，该工具用于查找两个文本文件中相同的行，适合没有顺序要求的配置文件比对。
2. 可以查找相同行和不同行。
3. 忽略注释（#开头的行）
## Usage
```
root@scott-virtual-machine:~/mylinuxtools# ./compare.sh f1 f2
config_php=y is in common
config_python=n is in common
root@scott-virtual-machine:~/mylinuxtools# ./compare.sh -v f1 f2
config_perl=y is not in common
```

# compareconfig
## Advantage
用于Linux内核配置文件比对的专用工具。
## Usage
```
root@scott-virtual-machine:~/mylinuxtools# ./compareconfig.sh -v ../configs/config-3.10.0-957.27.2.el7.x86_64 ../configs/kernel-aarch64.config 
[CONFIG_NR_CPUS]  5120 4096 1
[CONFIG_NODES_SHIFT]  10 3 2
[CONFIG_CPU_FREQ_STAT]  m y 3
...
root@scott-virtual-machine:~/mylinuxtools# ./compareconfig.sh ../configs/config-3.10.0-957.27.2.el7.x86_64 ../configs/kernel-aarch64.config 
CONFIG_64BIT IN COMMON
CONFIG_MMU IN COMMON
CONFIG_GENERIC_HWEIGHT IN COMMON
...
```

# modifyconfig
## Advantage
用于Linux内核配置文件批量比对，并以第二个参数指定的内核配置文件为标准，修改一定数量的配置项（可使用取半法），生成不同版本的配置文件，以排查导致内核启动失败的内核配置项。
## Usage
```
$ ./modifyconfig config_failed config_success 58 1 参照config_success修改58项内核配置项，生成config_failed.1
$ ./modifyconfig config_failed.1 config_success 29 1 参照config_success修改58项内核配置项，生成config_failed.2
...
```



