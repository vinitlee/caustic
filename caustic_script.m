orig_img = imread('fourier.jpg');
img_line = orig_img(300,500:600)';


img = zeros(1,300);
img(150) = 1000;

depth2 = SingleDimensionCaustic(img);