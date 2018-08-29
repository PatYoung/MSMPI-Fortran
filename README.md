# MSMPI-Fortran
## 其中*hello.f90*为测试运行程序
## *data.f90*为产生需要被*test.f90*读取数据的程序，为随机产生的
## *test.f90*即为利用并行读取矩阵数据的程序，由主进程分发到分进程，且按列分发
## 注意程序在目录下没有*MPI*所需文件，是不能编译的，编译详见[这里](https://blog.csdn.net/xenonhu/article/details/78196443)
