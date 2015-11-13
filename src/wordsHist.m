function [ histo ] = wordsHist( descriptors, vocabularyCenters )
% input
%   descriptors: n * 128 SIFT descriptors
%   vocabularyCenters: k * 128 visual word centers
% output:
%   histogram 1 * k: counts how many descriptors in each word

    distances = dist2(vocabularyCenters, descriptors);
    % size(distances) = k * n
    [minDis, minIndex] = min(distances);
    
    k = size(vocabularyCenters, 1);
    histo = histc(minIndex, 1:k);
    
end

