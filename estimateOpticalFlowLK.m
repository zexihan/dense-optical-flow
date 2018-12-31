function [im2_level, optical_flow_u, optical_flow_v] = estimateOpticalFlowLK(im_1, im_2, window_width, level)

im1 = double(im_1);
im2 = double(im_2);
im1 = (im1 - mean(im1)) / std2(im1);
im2 = (im2 - mean(im2)) / std2(im2);
im1_pyramid = cell(1,level+1);
im2_pyramid = cell(1,level+1);
im1_pyramid{1} = im1;
im2_pyramid{1} = im2;

% pyramids
for i = 2:level+1
    im1_pyramid{i} = impyramid(im1_pyramid{i-1},'reduce');
    im2_pyramid{i} = impyramid(im2_pyramid{i-1},'reduce');
end

prev_optical_flow_u = zeros;
prev_optical_flow_v = zeros;

% estimate optical flow
for L = level+1:-1:1
    im2_level = im2_pyramid{L};
    im1_level = im1_pyramid{L};
    [h,w] = size(im2_level);
    k = [-1 8 0 -8 1]/12;
    ix = conv2(im2_level, k, 'same');
    iy = conv2(im2_level, k', 'same');
    it = im2_level - im1_level;

    Ix2 = conv2(ix.^2, ones(window_width), 'same');
    Iy2 = conv2(iy.^2, ones(window_width), 'same');
    Ixy = conv2(ix.*iy, ones(window_width), 'same');
    Ixt = conv2(ix.*it, ones(window_width), 'same');
    Iyt = conv2(iy.*it, ones(window_width), 'same');

    optical_flow_u = zeros(h,w);
    optical_flow_v = zeros(h,w);
    thre = 0.3;
    for i = 1:h
        for j = 1:w
            A = [Ix2(i,j) Ixy(i,j); Ixy(i,j) Iy2(i,j)];
            b = -[Ixt(i,j); Iyt(i,j)];
            e = eig(A);
            if min(e) > thre
                V = A\b;
                optical_flow_v(i,j) = V(2);
                optical_flow_u(i,j) = V(1);
            end
        end
    end
    optical_flow_u = optical_flow_u + prev_optical_flow_u;
    optical_flow_v = optical_flow_v + prev_optical_flow_v;

    % interpolation
    if L > 1
        [y,x] = size(im2_pyramid{L-1});
        [X,Y] = meshgrid(1:x, 1:y);
        prev_optical_flow_u = 2 * interp2(optical_flow_u, X/2, Y/2);
        prev_optical_flow_v = 2 * interp2(optical_flow_v, X/2, Y/2);
    end

end

end