# rgb-lab
rgb和lab互转

lab色彩空间说明可参考wiki：https://en.wikipedia.org/wiki/Lab_color_space

RGB 转 LAB 色彩空间

在rgb-to-lab 文件夹下

已经仿真OK

文件说明：

rgb_to_lab_verb.v ---> top rtl 这个是B版本

rgb_to_lab_tb.sv ----> top sim 

root1D3.v  ----------> x^（1/3) 线性拟合函数

root1D3_tb.sv -------> 拟合函数仿真top

read_test_data.m ----> 读取仿真输出文件的matlab script

ft.m  ---------------> lab转换的matlab函数

文件夹data_stream_to_file :流输出模块，和github上的工程一样，https://github.com/C-L-G/stream-to-file-package

文件夹linear_transfomation： 线性拟合模块，和github上的工程一样，https://github.com/C-L-G/linear-transfomation

文件夹matrix_multiper：矩阵乘模块，和github上的工程一样，https://github.com/C-L-G/matrix-multiper

文件夹public：公用库，存放常用模块

Have fun

--@--Young--@--






