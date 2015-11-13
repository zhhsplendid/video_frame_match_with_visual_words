function [ matches, matchDis] = rawDescriptorMatches(image1, image2, imSIFT1, imSIFT2, matchThres)
% Allow a user to select a region of interest (see provided selectRegion) 
% in one frame, and then match descriptors in that region to descriptors 
% in the second image based on Euclidean distance in SIFT space. Display the
% selected region of interest in the first image (a polygon)

% the matching process is: A descriptor D1 is matched to a descriptor D2 
% only if the Euclidean distance d(D1,D2) multiplied by matchThres is not greater 
% than the second minimum distance of D1 to all other descriptors. 

% Default value of matchThres = 1.5. Setting
% large matchThres causes the matching uniquely.

    if nargin < 5
        matchThres = 1.5;
    end
    
    selectedIndeces = selectRegion(image1, imSIFT1.positions);
    selectedDescriptors = imSIFT1.descriptors(selectedIndeces, :);
    
    distances = dist2(imSIFT2.descriptors, selectedDescriptors);
    
    [minDis, minIndex] = min(distances);
    % Here can be optimized to find second larger element in each column
    % But I'm just lazy so I used function :P
    sortedDis = sort(distances); 
    secondMinDis = sortedDis(2, :);
    
    properIndex = minDis * matchThres < secondMinDis;
    properDescris = find(properIndex);
    corresDescris = minIndex(properIndex);
    matches = [properDescris; corresDescris];
    matchDis = minDis(properIndex);
    
    figure;
    imshow(image2);
    title('raw descriptor matching');
    displaySIFTPatches(imSIFT2.positions(corresDescris,:), ...        
        imSIFT2.scales(corresDescris,:), imSIFT2.orientations(corresDescris,:), image2);
end

