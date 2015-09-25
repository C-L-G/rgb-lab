clear all
close all
a = dlmread('in_out.txt');
a = [a(1:256,1),a(5:260,2)];
plot(a(:,1),a(:,2),'LineWidth',2)
axis equal
grid on 

hold on
b = dlmread('param.txt');
plot(b(:,1),b(:,2),'r+','LineWidth',2)
title('16点线性拟合单调函数，verilog输出数据对比图')
