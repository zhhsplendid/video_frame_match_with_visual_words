function [kmeansCenters] = visualizeVocabulary(siftDir, framesDir)
% Build a visual vocabulary. Display example image
% patches associated with two of the visual words. 
% Choose two words that are distinct to
% illustrate what the different words are capturing
    
    K = 1500;
    PORTION = 0.1;
    % fraction of choose frames to contruct vocabulary
    % If portion equals 1, we use all frames. 0 < PORTION <= 1
    
    PATCHES_TO_SHOW = 10;
    
    
    siftFiles = dir([siftDir '/*.jpeg.mat']);
    
    %random choose
    %vocabularyFrameCount = int32(length(siftFiles) * PORTION);
    %shuffleFrames = randperm(length(siftFiles));
    %vocabularyFrameIndex = shuffleFrames(1:vocabularyFrameCount);
    
    %step choose
    step = round(1 / PORTION);
    vocabularyFrameIndex = 1:step:length(siftFiles);
    
    features = zeros(128, 0);
    frameFeatureCount = 1;
    totalCount = 0;
    for i = vocabularyFrameIndex
        fname = [siftDir '/' siftFiles(i).name];
        load(fname, 'imname', 'descriptors');
        
        %TODO maybe add descriptor filters 
        features = [features, descriptors'];
        totalCount = totalCount + size(descriptors, 1);
        frameFeatureCount = [frameFeatureCount, totalCount + 1];
    end
    %size(features)
    [membership, kmeansCenters, rms] = kmeansML(K, features);
    kmeansCenters = kmeansCenters'; % now size is K * 128;
    
    %'kmeans over'
    % show pathes, just choose firt two words.
    WORD = [1, 2];
    indexMember = {find(membership == WORD(1)), find(membership == WORD(2))};
    
    figure;
    hold on;
    for i = 1:2
        %here we choose top PATCHES_TO_SHOW nearest patches
        distancesInWord = dist2(features(:, indexMember{i}(1:PATCHES_TO_SHOW))', kmeansCenters(WORD(i), :));
        %distancesInWord's size is n * 1 
        [sortedDis, sortedIndex] = sort(distancesInWord);
        indexToShow = indexMember{i}(sortedIndex(1: PATCHES_TO_SHOW));
        for j = 1: PATCHES_TO_SHOW
            index = indexToShow(j);
            findIndex = find(frameFeatureCount > index, 1) - 1;
            fIndex = vocabularyFrameIndex(findIndex);
            inFrameIndex = index - frameFeatureCount(findIndex) + 1;
            
            fname = [siftDir '/' siftFiles(fIndex).name];
            load(fname, 'imname', 'positions', 'scales', 'orients');
            imname = [framesDir '/' imname]; 
            im = imread(imname);
            grayImage = rgb2gray(im);
            
            patch = getPatchFromSIFTParameters(positions(inFrameIndex,:), ...
                scales(inFrameIndex), orients(inFrameIndex), grayImage);
            
            subplot(2, PATCHES_TO_SHOW, (i - 1) * PATCHES_TO_SHOW + j);
            
            imshow(patch);
            title('visual words');
            %size(patch)
        end
    end
    hold off;
end

