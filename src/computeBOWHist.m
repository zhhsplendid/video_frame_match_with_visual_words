function [ bagOfWordHist ] = computeBOWHist(siftDir, vocabularyCenters)
    
    siftFiles = dir([siftDir '/*.jpeg.mat']);
    totalFiles = length(siftFiles);
    bagOfWordHist = zeros(totalFiles, size(vocabularyCenters, 1));
    
    for i = 1: totalFiles
        ['computing ' , int2str(i) , ' frame of total ' int2str(totalFiles), ' frames']
        
        fname = [siftDir '/' siftFiles(i).name];
        load(fname, 'descriptors');
        testHist = wordsHist(descriptors, vocabularyCenters);

        bagOfWordHist(i, :) = testHist;
    end

end

