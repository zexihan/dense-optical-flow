% Project 3 Dense Optical Flow
% Quanwei Hao, Zexi Han

% import images
% 1 toys1.gif toys2.gif
% 2 toys21.gif toys22.gif
% 3 LKTestpgm/LKTest1im1.pgm LKTestpgm/LKTest1im2.pgm
% 4 LKTestpgm/LKTest2im1.pgm LKTestpgm/LKTest2im2.pgm
% 5 LKTestpgm/LKTest3im1.pgm LKTestpgm/LKTest3im2.pgm
im_1 = imread('toys21.gif');
im_2 = imread('toys22.gif');

% parameters
level = 2;
window_width = 9;

% estimate optical flow
[im2_level, optical_flow_u, optical_flow_v] = estimateOpticalFlowLK(im_1, im_2, window_width, level);

% display optical flow
step = 5;
imshow(im_2);
[w,h] = size(optical_flow_u);
u_down = optical_flow_u(1:step:end, 1:step:end);
v_down = optical_flow_v(1:step:end, 1:step:end);

[m,n] = size(im2_level);
[X,Y] = meshgrid(1:n, 1:m);
X_down = X(1:step:end, 1:step:end);
Y_down = Y(1:step:end, 1:step:end);
hold on;
quiver(X_down, Y_down, u_down, v_down, 5);