clear all
close all
format long
MXYZ = [0.412453 0.357580 0.180423;
        0.212671 0.715160 0.072169;
        0.019334 0.119193 0.950227];


a = dlmread('rgb_lab.txt');

rgb = flipud(rot90(a(:,1:3)));
rgb = rgb(:,2:end);
lab = flipud(rot90(a(:,4:6)));
lab = lab(:,13:end);
xyz_mentor = flipud(rot90(a(:,7:9)));
xyz_mentor = xyz_mentor(:,6:end);
xyz_matlab = MXYZ*rgb;
xyz_matlab = [xyz_matlab(1,:)/0.9515;xyz_matlab(2,:);xyz_matlab(3,:)/1.0886];
rgb = rgb/(max(rgb(1,:)));
xyz = MXYZ*rgb;
%%--CIE LAB 
yn = xyz(2,:);
xn = xyz(1,:)/0.9515;
zn = xyz(3,:)/1.0886;

fx = ft(xn);
fy = ft(yn);
fz = ft(zn);

L = 116*fy-16;
A = 500*(fx-fy);
B = 200*(fy-fz);
lab_matlab = [L;A;B];

lab(:,1:10)
vpa(lab_matlab(:,1:10),3)
xyz_mentor(:,1:10)
vpa(xyz_matlab(:,1:10),4)

