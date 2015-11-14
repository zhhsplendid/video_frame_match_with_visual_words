function [ similarFrames ] = regionQueries(siftDir, framesDir, ...
    vocabularyCenters, queryFrame, outputNumber, toShow, saveToFile, loadFromFile, ...
    fullFrameQuery, onlyCompareNonZeroWords, useTfidf, ignoreCommon)
% Select your favorite query regions. 
% do bag-of-words matching, using a linear scan through all the “database” frames
% Compare two bag-of-words histograms using the normalized scalar product

% input:
%   siftDir: string of name of the folder storing SIFT
%   frameDir: string of name of the folder storing frames
%   vocabularyCenters: 128 * n centers from question 2
%   queryFrame: integer to indicate the frame to query
%   outputNumber: integer indicates how many frames output
%   toShow: boolean indicates whether show similar images 
%   saveToFile, loadFromFile: boolean, whether save/load the histogram to files
%   fullFrameQuery: boolean, if true we don't choose region but query full frame
%   onlyCompareNonZeroWords: boolean, if true, we just count histogram of
%       features in the query region.
%   useTfidf, ignoreCommon: if true we will use tfidf, ignore common features

% output:
%   indeces of similar frames.

    SAVE_DIR = 'precompute_data/';
    COMMON_FEATURE_THRES = 4000;
    
    siftFiles = dir([siftDir '/*.jpeg.mat']);
    fname = [siftDir '/' siftFiles(queryFrame).name];
    
    load(fname, 'imname', 'descriptors', 'positions');
    queryimname = [framesDir '/' imname];
    
    if ~fullFrameQuery
        queryImage = imread(queryimname);
        figure;
        selectedIndeces = selectRegion(queryImage, positions);
        selectedDescriptors = descriptors(selectedIndeces, :);
        queryHist = wordsHist(selectedDescriptors, vocabularyCenters);
    else 
        queryHist = wordsHist(descriptors, vocabularyCenters);
    end
    
    if norm(queryHist) == 0
        'bad query without any feature, try another'
        return;
    end
    
    totalFiles = length(siftFiles);
    similarScores = zeros(1, totalFiles);
    k = size(vocabularyCenters, 1);
    
    bagOfWordHist = zeros(totalFiles, k);
    if loadFromFile
        load([SAVE_DIR 'allHist.mat'], 'bagOfWordHist');
    else
        bagOfWordHist = computeBOWHist(siftDir, vocabularyCenters);
    end
    
    
    
    if useTfidf
        queryHist = tfidf(queryHist, SAVE_DIR);
    end
    
    
    if ignoreCommon
        % notIgnoreList = find(sum(bagOfWordHist) < COMMON_FEATURE_THRES);
        notIgnoreList = find(sum(bagOfWordHist > 0) < COMMON_FEATURE_THRES);
        queryHist = queryHist(notIgnoreList);
    end
    
    if onlyCompareNonZeroWords
        nonZeroIndex = find(queryHist > 0);
        queryHist = queryHist(nonZeroIndex);
    end
    
    for i = 1: totalFiles
        testHist = bagOfWordHist(i, :);
        
        %if saveToFile
            %save([SAVE_DIR 'frame' int2str(i) '.mat'], 'testHist');
        %end
        if useTfidf
            testHist = tfidf(testHist, SAVE_DIR);
        end
        
        if ignoreCommon
            %notIgnoreList = find(sum(bagOfWordHist > 0) < COMMON_FEATURE_THRES);
            testHist = testHist(notIgnoreList);
        end
        
        if onlyCompareNonZeroWords
            testHist = testHist(nonZeroIndex);
        end
        
        if norm(testHist) == 0
            similarScores(i) = 0;
        else
            similarScores(i) = sum(testHist .* queryHist) / (norm(testHist) * norm(queryHist));
        end
    end
    
    if saveToFile
        save([SAVE_DIR 'allHist.mat'], 'bagOfWordHist');
    end
    
    [sortedScores, sortedIndex] = sort(similarScores, 'descend');
 
    if find(queryFrame == sortedIndex(1:outputNumber))
        similarFrames = sortedIndex(1: outputNumber + 1);
        similarFrames = similarFrames(similarFrames ~= queryFrame);
    else
        similarFrames = sortedIndex(1:outputNumber);
    end
    
    if toShow
        figure;
        hold on;
        % show query image
        imname = [framesDir '/' imname];
        subplot(2, outputNumber, round(outputNumber / 2));
        
        imshow(imread(imname));
        title('query image');
        % show similar images
        
        for i = 1: outputNumber
            f = similarFrames(i);
            fname = [siftDir '/' siftFiles(f).name];
            load(fname, 'imname');
            imname = [framesDir '/' imname];
            subplot(2, outputNumber, outputNumber + i);
            
            imshow(imread(imname));
            title('results');
        end
        hold off;
    end
    
end

