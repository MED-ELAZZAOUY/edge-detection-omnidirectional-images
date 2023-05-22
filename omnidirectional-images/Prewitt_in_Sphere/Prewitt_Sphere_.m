clear;
close all
warning off;

% read in the image
I1 = double(rgb2gray(imread('images/Cata0048.jpg')));
y0 = size(I1,2)/2;
I = I1(1:size(I1,1),floor(y0-size(I1,1)/2):floor(y0+size(I1,1)/2-1));

% display the original image
figure;imshow(uint8(I));

% set the omnidirectional to perspective projection parameters
alphau = 487.6209324/2;
alphav = 472.6740525/2;
h = 0.8685267683;
u0 = 249;
v0 = 250;
sx = 480;
sy = 480;
phi1 = 0:2*pi/479:2*pi;
theta1 = pi/2:pi/958:pi;

% compute the spherical coordinates phi and theta using meshgrid
[phi,theta] = meshgrid(linspace(0, 2*pi, 480), linspace(pi/2, pi, 480));

% convert spherical coordinates to Cartesian coordinates X, Y, and Z
Z = cos(theta);
X = h*cot(theta/2).*cos(phi);
Y = h*cot(theta/2).*sin(phi);

% compute the projected image coordinates u and v using the perspective projection model
u = alphau*Y + v0;
v = alphav*X + u0;

% interpolate the image onto the new coordinates using cubic interpolation
[X1, Y1] = meshgrid(1:size(I,2),1:size(I,1));
Is = interp2(X1, Y1, I, u, v, 'cubic');


%------------------Prewritt Filter in 2D---------------------------------------------------
x = imread('prewritt_normal.png');
figure;imshow(x);
title('Prewitt Filter in 2D');
figure,colormap(gray),axis off,surf(X,Y,Z,'facecolor','texturemap','cdata',x,'edgecolor','none');
title('Prewitt Filter in 2D');

%--------------------Prewritt Filter in sphere-------------------------------------------------

% compute the matrices of Prewitt for I_theta and 1/sin(theta)
P_theta = [-1 -1 -1; 0 0 0; 1 1 1]/6;
P_phi = [-1 0 1; -1 0 1; -1 0 1]/6;

% compute the partial derivatives of the interpolated image Is with respect to theta and phi using the Prewitt filters
I_theta = conv2(Is, P_theta, 'same');
I_phi = conv2(Is, P_phi, 'same');

% compute the value of 1/sin(theta) at each point
sin_theta = sin(theta);
sin_theta(sin_theta == 0) = eps; % avoid division by zero
one_over_sin_theta = 1./sin_theta;

% compute the partial derivative of the interpolated image Is with respect to phi using the Prewitt filter and the value of 1/sin(theta)
I_phi_over_sin_theta = conv2(one_over_sin_theta.*Is, P_phi, 'same');

% Compute the gradient magnitude and direction
mag = sqrt(I_phi_over_sin_theta.^2 + I_phi.^2);


% display the results
figure;imshow(I_theta, []);
title('Partial derivative with respect to theta');

figure;imshow(I_phi, []);
title('Partial derivative with respect to phi');

figure;imshow(mag, []);
title('prewitt Filter in Sphere');
figure,colormap(gray),axis off,surf(X,Y,Z,'facecolor','texturemap','cdata',mag,'edgecolor','none');
title('Prewitt Filter in sphere');

