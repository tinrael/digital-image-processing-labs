clc;
clear;

originalImage = imread('saturn2.gif');
figure;
imshow(originalImage);

% filteredImage = applyRectangleMedianFilter(originalImage, 3, 3); % worse, because more blurred
filteredImage = applyCrossMedianFilter(originalImage, 3, 4); % better, because less blurred
figure;
imshow(filteredImage);
figure;
imshowpair(originalImage, filteredImage, 'montage');

originalImage = imread('saturn3.gif');
figure;
imshow(originalImage);

% filteredImage = applyRectangleMedianFilter(originalImage, 4, 5); % worse, because more blurred
filteredImage = applyCrossMedianFilter(originalImage, 5, 6); % better, because less blurred
figure;
imshow(filteredImage);
figure;
imshowpair(originalImage, filteredImage, 'montage');

%{
    The window of this 2D median filter is a rectangle (a matrix which has 'numOfRows' rows and 'numOfColumns' columns).
    This function supposes 'numOfRows' and 'numOfColumns' to be positive integers (not necessarily the same).
%}
function filteredImage = applyRectangleMedianFilter(originalImage, numOfRows, numOfColumns)
    offsetX = numOfColumns - ceil(numOfColumns / 2);
    offsetY = numOfRows - ceil(numOfRows / 2);
    
    differenceOffsetX = 0;
    differenceOffsetY = 0;
    
    if rem(numOfColumns, 2) == 0
        differenceOffsetX = 1;
    end
    
    if rem(numOfRows, 2) == 0
        differenceOffsetY = 1;
    end
    
    filteredImage = zeros(size(originalImage, 1) + 2 * offsetY - differenceOffsetY, size(originalImage, 2) + 2 * offsetX - differenceOffsetX, class(originalImage));
    filteredImage(ceil(numOfRows / 2):(end - offsetY), ceil(numOfColumns / 2):(end - offsetX)) = originalImage;
    
    for i = ceil(numOfRows / 2):(size(filteredImage, 1) - offsetY)
        for j = ceil(numOfColumns / 2):(size(filteredImage, 2) - offsetX)
            % the window
            rectangle = filteredImage((i - (offsetY - differenceOffsetY)):(i + offsetY), (j - (offsetX - differenceOffsetX)):(j + offsetX));
            
            v = reshape(rectangle, 1, []);
            v = sort(v);
            
            middleIndex = ceil(size(v, 2) / 2);
            filteredImage(i, j) = v(middleIndex);
        end
    end
    
    filteredImage = filteredImage(ceil(numOfRows / 2):(size(filteredImage, 1) - offsetY), ceil(numOfColumns / 2):(size(filteredImage, 2) - offsetX));
end

%{
    The window of this 2D median filter is a cross.
    The cross has the 'crossHeight' height and the 'crossWidth' width.
    This function supposes 'crossHeight' and 'crossWidth' to be positive integers (not necessarily the same).
%}
function filteredImage = applyCrossMedianFilter(originalImage, crossHeight, crossWidth)
    offsetX = crossWidth - ceil(crossWidth / 2);
    offsetY = crossHeight - ceil(crossHeight / 2);
    
    differenceOffsetX = 0;
    differenceOffsetY = 0;
    
    if rem(crossWidth, 2) == 0
        differenceOffsetX = 1;
    end
    
    if rem(crossHeight, 2) == 0
        differenceOffsetY = 1;
    end
    
    filteredImage = zeros(size(originalImage, 1) + 2 * offsetY - differenceOffsetY, size(originalImage, 2) + 2 * offsetX - differenceOffsetX, class(originalImage));
    filteredImage(ceil(crossHeight / 2):(end - offsetY), ceil(crossWidth / 2):(end - offsetX)) = originalImage;
    
    for i = ceil(crossHeight / 2):(size(filteredImage, 1) - offsetY)
        for j = ceil(crossWidth / 2):(size(filteredImage, 2) - offsetX)
            % the elements on the cross's horizontal line including the (i, j)
            horizontal = filteredImage(i, (j - (offsetX - differenceOffsetX)):(j + offsetX));
            
            % the elements on the cross's vertical line above the (i, j) (not including (i, j))
            above = transpose(filteredImage((i - (offsetY - differenceOffsetY)):(i - 1), j));
            
            % the elements on the cross's vertical line below the (i, j) (not including (i, j))
            below = transpose(filteredImage((i + 1):(i + offsetY), j));
            
            cross = [horizontal above below]; % the window
            cross = sort(cross);
            
            middleIndex = ceil(size(cross, 2) / 2);
            filteredImage(i, j) = cross(middleIndex);
        end
    end
    
    filteredImage = filteredImage(ceil(crossHeight / 2):(size(filteredImage, 1) - offsetY), ceil(crossWidth / 2):(size(filteredImage, 2) - offsetX));
end