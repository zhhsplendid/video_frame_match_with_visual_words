function [ idf ] = precomputeIdf( dataDir )
    
    load([dataDir 'allHist.mat'], 'bagOfWordHist');
    
    [totalFile, k] = size(bagOfWordHist);
    idf = log(totalFile ./ sum(bagOfWordHist > 0));
    
    save([dataDir 'idf.mat'], 'idf');
end

