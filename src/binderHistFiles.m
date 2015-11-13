function binderHistFiles(SAVE_DIR, SIFT_DIR)
    if nargin < 2
        SAVE_DIR = 'precompute_data/bag_of_words_histogram/';
        SIFT_DIR = './v/filer4b/v44q010/a4data/sift/';
    end
    
    siftFiles = dir([SIFT_DIR '/*.jpeg.mat']);
    load('precompute_data/vocabulary_centers.mat', 'vocabularyCenters');
    
    totalFiles = length(siftFiles);
    k = size(vocabularyCenters, 1);
    
    bagOfWordHist = zeros(totalFiles, k);
    
    for i = 1:totalFiles
        load([SAVE_DIR 'frame', int2str(i) , '.mat'], 'testHist');
        bagOfWordHist(i,:) = testHist;
    end
    save('precompute_data/allHist.mat', 'bagOfWordHist');
end

