function [ similarFrames ] = fullFrameQueries(siftDir, framesDir, ...
    vocabularyCenters, queryFrame, outputNumber, toShow, saveToFile, loadFromFile, ...
    ,useTfidf, ignoreCommon)
% do bag-of-words matching, using a linear scan through all the “database” frames
% input:
%   siftDir: string of name of the folder storing SIFT
%   frameDir: string of name of the folder storing frames
%   vocabularyCenters: 128 * n centers from question 2
%   queryFrame: integer to indicate the frame to query
%   outputNumber: integer indicates how many frames output
%   toShow: boolean indicates whether show similar images 
%   saveToFile, loadToFile: boolean, whether save/load the histogram to files

% output:
%   indeces of similar frames.
    FULL_FRAME_QUERY = true;
    ONLY_COMPARE_NONZERO_WORDS = false;
    
    similarFrames = regionQueries(siftDir, framesDir, ...
        vocabularyCenters, queryFrame, outputNumber, toShow, saveToFile, loadFromFile, ...
        FULL_FRAME_QUERY, ONLY_COMPARE_NONZERO_WORDS, useTfidf, ignoreCommon);
    %{
    SAVE_DIR = 'precompute_data/';

    siftFiles = dir([siftDir '/*.jpeg.mat']);
    fname = [siftDir '/' siftFiles(queryFrame).name];
    
    load(fname, 'imname', 'descriptors');
    queryHist = wordsHist(descriptors, vocabularyCenters);
    if norm(queryHist) == 0
        'bad query, try another'
        return;
    end
    totalFiles = length(siftFiles);
    similarScores = zeros(1, totalFiles);
    k = size(vocabularyCenters, 1);
    
    bagOfWordHist = zeros(totalFiles, k);
    if loadFromFile
        load([SAVE_DIR 'allHist.mat'], 'bagOfWordHist');
    end
    
    for i = 1: totalFiles
        ['computing ' , int2str(i) , ' frame of total ' int2str(totalFiles), ' frames']
        if loadFromFile
            %load([SAVE_DIR 'frame', int2str(i) , '.mat'], 'testHist');
            testHist = bagOfWordHist(i, :);
        else
            fname = [siftDir '/' siftFiles(i).name];
            load(fname, 'descriptors');
            testHist = wordsHist(descriptors, vocabularyCenters);
            bagOfWordHist(i, :) = testHist;
        end
        
        %if saveToFile
            %save([SAVE_DIR 'frame' int2str(i) '.mat'], 'testHist');
        %end
        
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
%}
end

