clc;
clear;

originalImage = imread('saturn2.gif');
filteredImage = applyRectangleMedianFilter(originalImage, 3, 3);

imshowpair(originalImage, filteredImage, 'montage');

%{
    The window of this 2D median filter is a rectangle (a matrix which has 'numOfRows' rows and 'numOfColumns' columns).
    This function supposes 'numOfRows' and 'numOfColumns' to be odd positive integers (not necessarily the same).
%}
function filteredImage = applyRectangleMedianFilter(originalImage, numOfRows, numOfColumns)
    offsetX = numOfColumns - ceil(numOfColumns / 2);
    offsetY = numOfRows - ceil(numOfRows / 2);
    
    filteredImage = zeros(size(originalImage, 1) + 2 * offsetY, size(originalImage, 2) + 2 * offsetX);
    filteredImage(ceil(numOfRows / 2):(end - offsetY), ceil(numOfColumns / 2):(end - offsetX)) = originalImage;
    
    for i = ceil(numOfRows / 2):(size(filteredImage, 1) - offsetY)
        for j = ceil(numOfColumns / 2):(size(filteredImage, 2) - offsetX)
            window = filteredImage((i - offsetY):(i + offsetY), (j - offsetX):(j + offsetX));
            
            v = reshape(window, 1, []);
            v = sort(v);
            
            middleIndex = ceil(size(v, 2) / 2);
            filteredImage(i, j) = v(middleIndex);
        end
    end
end