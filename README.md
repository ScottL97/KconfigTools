# mylinuxtools
自编的一些Linux实用小工具

# grepdir
Usage：
```
$ ls
testdir/ grepdir
$ ls testdir/
testfile1 testfile2 testfile3
$ cat testdir/testfile1
test
$ ./grepdir -p test testdir/
test
In file: testdir/testfile
-----------------
test2
In file: testdir/testfile2
-----------------
```
