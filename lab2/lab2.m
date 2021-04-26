clc;
clear;

% f(x, y) is an approximating surface of the second order
syms f(x, y) a b c alpha beta gamma
f(x, y) = a*x^2 + b*y^2 + c*x*y + alpha*x + beta*y + gamma;

% g(x, y) is a window
syms g(x, y)
epsilon = (f(x-1, y-1) - g(x-1, y-1))^2 + (f(x-1, y) - g(x-1, y))^2 + (f(x-1, y+1) - g(x-1, y+1))^2 ... 
    + (f(x, y-1) - g(x, y-1))^2 + (f(x, y) - g(x, y))^2 + (f(x, y+1) - g(x, y+1))^2 ... 
    + (f(x+1, y-1) - g(x+1, y-1))^2 + (f(x+1, y) - g(x+1, y))^2 + (f(x+1, y+1) - g(x+1, y+1))^2;

eqn1 = diff(epsilon, a) == 0;
eqn2 = diff(epsilon, b) == 0;
eqn3 = diff(epsilon, c) == 0;
eqn4 = diff(epsilon, alpha) == 0;
eqn5 = diff(epsilon, beta) == 0;
eqn6 = diff(epsilon, gamma) == 0;

[A, B] = equationsToMatrix([eqn1, eqn2, eqn3, eqn4, eqn5, eqn6], [a, b, c, alpha, beta, gamma]);

coefficients = solve([eqn1, eqn2, eqn3, eqn4, eqn5, eqn6], [a, b, c, alpha, beta, gamma]);

% grad(x, y) is |grad(x, y)|
syms grad(x, y)
grad(x, y) = sqrt((2*(coefficients.a)*x + (coefficients.c)*y + coefficients.alpha)^2 + (2*(coefficients.b)*y + (coefficients.c)*x + coefficients.beta)^2);

originalImage = double(imread('cameraman.tif'));
resultImage = applyEdgeDetectionAlgorithm(originalImage);

figure;
imshow(uint8(resultImage));

figure;
imshow(255 - uint8(resultImage)); % negative resultImage

edgeDetectionAlgorithm = @() applyEdgeDetectionAlgorithm(originalImage);
time = timeit(edgeDetectionAlgorithm)

function resultImage = applyEdgeDetectionAlgorithm(originalImage)
    resultImage = zeros(size(originalImage), class(originalImage));
    % x is a row, y is a column
    for x = 2:(size(originalImage, 1) - 1)
        for y = 2:(size(originalImage, 2) - 1)
            % the statement below is equivalent to: resultImage(x, y) = grad(x, y);
            resultImage(x, y) = sqrt((originalImage(x - 1, y - 1)/6 - y*(originalImage(x - 1, y - 1)/4 - originalImage(x - 1, y + 1)/4 - originalImage(x + 1, y - 1)/4 + originalImage(x + 1, y + 1)/4) + originalImage(x - 1, y + 1)/6 - originalImage(x + 1, y - 1)/6 - originalImage(x + 1, y + 1)/6 - x*(originalImage(x - 1, y - 1)/3 + originalImage(x - 1, y + 1)/3 + originalImage(x + 1, y - 1)/3 + originalImage(x + 1, y + 1)/3 - (2*originalImage(x, y))/3 - (2*originalImage(x, y - 1))/3 - (2*originalImage(x, y + 1))/3 + originalImage(x - 1, y)/3 + originalImage(x + 1, y)/3) - (2*x*originalImage(x, y))/3 - (2*x*originalImage(x, y - 1))/3 - (2*x*originalImage(x, y + 1))/3 + (x*originalImage(x - 1, y))/3 + (x*originalImage(x + 1, y))/3 + originalImage(x - 1, y)/6 - originalImage(x + 1, y)/6 + (x*originalImage(x - 1, y - 1))/3 + (x*originalImage(x - 1, y + 1))/3 + (x*originalImage(x + 1, y - 1))/3 + (x*originalImage(x + 1, y + 1))/3 + (y*originalImage(x - 1, y - 1))/4 - (y*originalImage(x - 1, y + 1))/4 - (y*originalImage(x + 1, y - 1))/4 + (y*originalImage(x + 1, y + 1))/4)^2 + (originalImage(x - 1, y - 1)/6 - x*(originalImage(x - 1, y - 1)/4 - originalImage(x - 1, y + 1)/4 - originalImage(x + 1, y - 1)/4 + originalImage(x + 1, y + 1)/4) - originalImage(x - 1, y + 1)/6 + originalImage(x + 1, y - 1)/6 - originalImage(x + 1, y + 1)/6 - y*(originalImage(x - 1, y - 1)/3 + originalImage(x - 1, y + 1)/3 + originalImage(x + 1, y - 1)/3 + originalImage(x + 1, y + 1)/3 - (2*originalImage(x, y))/3 + originalImage(x, y - 1)/3 + originalImage(x, y + 1)/3 - (2*originalImage(x - 1, y))/3 - (2*originalImage(x + 1, y))/3) - (2*y*originalImage(x, y))/3 + (y*originalImage(x, y - 1))/3 + (y*originalImage(x, y + 1))/3 - (2*y*originalImage(x - 1, y))/3 - (2*y*originalImage(x + 1, y))/3 + originalImage(x, y - 1)/6 - originalImage(x, y + 1)/6 + (x*originalImage(x - 1, y - 1))/4 - (x*originalImage(x - 1, y + 1))/4 - (x*originalImage(x + 1, y - 1))/4 + (x*originalImage(x + 1, y + 1))/4 + (y*originalImage(x - 1, y - 1))/3 + (y*originalImage(x - 1, y + 1))/3 + (y*originalImage(x + 1, y - 1))/3 + (y*originalImage(x + 1, y + 1))/3)^2);
        end
    end
end