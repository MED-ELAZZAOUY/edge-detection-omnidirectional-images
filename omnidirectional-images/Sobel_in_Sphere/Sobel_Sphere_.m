clear;
close all
warning off;
% séquence
I1=double(rgb2gray(imread('images/Cata0047.jpg')));               
 figure;imshow(uint8(I1));
            
y0=size(I1,2)/2;
I=I1(1:size(I1,1),floor(y0-size(I1,1)/2):floor(y0+size(I1,1)/2-1));
%figure;imshow(uint8(I));

% paramètres omni <--> perspective
alphau=487.6209324/2;
alphav=472.6740525/2;
h =0.8685267683;
u0=249;
v0=250;
sx=480;
sy=480;
phi1= 0:2*pi/479:2*pi;
theta1= pi/2:pi/958:pi;
[X1,Y1]=meshgrid(1:sy,1:sx);

%defined and the spherical coordinates phi and theta are calculated using meshgrid
[phi,theta] = meshgrid( linspace(0, 2*pi, 480), ...
    linspace(pi/2, pi ,480));

%%C = A.*B
%The spherical coordinates are then converted to Cartesian coordinates X, Y, and Z
Z=cos(theta);
X=h*cot(theta/2).*cos(phi);
Y=h*cot(theta/2).*sin(phi);

%Finally, the original image is interpolated onto the new coordinates using interp2 
u=alphau*Y+v0;
v=alphav*X+u0;
[X1,Y1]=meshgrid(1:size(I,2),1:size(I,1));
Is = interp2(X1,Y1,I,u,v,'cubic') ;

%function with the 'cubic' method and is displayed as an omnidirectional projection using the surf function.
%The result is a 3D plot of the image on a sphere where the image color is mapped onto the surface.
%figure;imshow(uint8(Is));

figure;imshow(uint8(Is));
%Is = imcrop(Is,[10 9 480 480]);
Is_am = imcrop(Is,[10 9 480 370]);
%figure;imshow(uint8(Is_am));
%figure,colormap(gray),axis off,surf(X,Y,Z,'facecolor','texturemap','cdata',Is,'edgecolor','none');


%------------------Sobel Filter in 2D---------------------------------------------------

% Create Sobel kernels
kernel_x = [-1 0 1; -2 0 2; -1 0 1];
kernel_y = [-1 -2 -1; 0 0 0; 1 2 1];

% Convolve image with kernels
gradient_x = conv2(double(Is), kernel_x, 'same');
gradient_y = conv2(double(Is), kernel_y, 'same');

% Compute magnitude of gradient
magnitude = sqrt(gradient_x.^2 + gradient_y.^2);

% Normalize magnitude values
magnitude = (magnitude / max(magnitude(:))) * 255;

% Apply threshold to create binary edge map
threshold = 50;
edges = zeros(size(magnitude));
edges(magnitude > threshold) = 255;

% Display the resulting edge-detected image
figure;imshow(edges);title('Sobel Filter in 2D');

figure,colormap(gray),axis off,surf(X,Y,Z,'facecolor','texturemap','cdata',edges,'edgecolor','none');
title('Sobel Filter in 2D');

%--------------------Sobel Filter in sphere-------------------------------------------------

% compute the matrices of Sobel for I_theta and 1/sin(theta)
P_theta = [-1 -2 -1; 0 0 0; 1 2 1]/8;
P_phi = [-1 0 1; -2 0 2; -1 0 1]/8;

% compute the partial derivatives of the interpolated image Is with respect to theta and phi using the Sobel filters
I_theta = conv2(Is, P_theta, 'same');
I_phi = conv2(Is, P_phi, 'same');

% compute the value of 1/sin(theta) at each point
sin_theta = sin(theta);
sin_theta(sin_theta == 0) = eps; % avoid division by zero
one_over_sin_theta = 1./sin_theta;

% compute the partial derivative of the interpolated image Is with respect to phi using the Sobel filter and the value of 1/sin(theta)
I_phi_over_sin_theta = conv2(one_over_sin_theta.*Is, P_phi, 'same');

% display the results
%figure;imshow(uint8(Is));
%title('Interpolated Image');

figure;imshow(I_theta, []);
title('Partial derivative with respect to theta');

figure;imshow(I_phi, []);
title('Partial derivative with respect to phi');

% Compute the gradient magnitude and direction
mag = sqrt(I_theta.^2 + I_phi_over_sin_theta.^2);

%figure;imshow(I_phi_over_sin_theta, []);
%title('Partial derivative with respect to phi, divided by sin(theta)');

figure;imshow(mag, []);title('Sobel Filter in Sphere');
figure,colormap(gray),axis off,surf(X,Y,Z,'facecolor','texturemap','cdata',mag,'edgecolor','none');
title('Sobel Filter in sphere');


