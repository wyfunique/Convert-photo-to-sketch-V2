m = imread('road_sign.png');
figure(1); imshow(m);
m = rgb2gray(m);
[nr, nc, c] = size(m);

% firstly, use sobel operator to find edges 
sobel = [0,0,0; 1,1,1; 0,0,0];
e = edge(m);
% Enhance the edges by highlighting the edge pixels using white (value 255)
% This makes a significant improvement on the final result quality.
m = uint8(e) * 255 + m;
figure(2); imshow(m);

% Compute gradients
g = gradient(m);
% ginv and einv are only for displaying g and e in inverted colors
ginv = uint8(ones(nr, nc) * 255) - g .* 2;
einv = uint8(ones(nr, nc) * 255) - uint8(e) * 255;
figure(3); imshow(ginv); figure(4); imshow(uint8(einv));

% Compute the final line-drawing image
S = drawLines(g);
figure(5); imshow(S);