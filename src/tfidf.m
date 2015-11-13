function [ weightedHist ] = tfidf( frameHist, dataDir )

    load([dataDir 'idf.mat'], 'idf');
    [row, k] = size(frameHist);
    weightedHist = zeros(row, k);
    for i = 1:row
        hist = frameHist(i,:);
        checkZero = sum(hist);
        if checkZero ~= 0
            weightedHist(i,:) = (hist / checkZero) .* idf;
        end
    end
end

