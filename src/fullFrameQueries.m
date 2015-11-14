function [ similarFrames ] = fullFrameQueries(siftDir, framesDir, ...
    vocabularyCenters, queryFrame, outputNumber, toShow, saveToFile, loadFromFile, ...
    useTfidf, ignoreCommon)
% do bag-of-words matching, using a linear scan through all the “database” frames
% input:
%   siftDir: string of name of the folder storing SIFT
%   frameDir: string of name of the folder storing frames
%   vocabularyCenters: 128 * n centers from question 2
%   queryFrame: integer to indicate the frame to query
%   outputNumber: integer indicates how many frames output
%   toShow: boolean indicates whether show similar images 
%   saveToFile, loadToFile: boolean, whether save/load the histogram to files
%   useTfidf, ignoreCommon: if true we will use tfidf, ignore common features

% output:
%   indeces of similar frames.

    FULL_FRAME_QUERY = true;
    ONLY_COMPARE_NONZERO_WORDS = false;
    % Just use region query and select full frame as region. Specify that
    % we won't ignore feature words which doesn't occur in query frame 
    similarFrames = regionQueries(siftDir, framesDir, ...
        vocabularyCenters, queryFrame, outputNumber, toShow, saveToFile, loadFromFile, ...
        FULL_FRAME_QUERY, ONLY_COMPARE_NONZERO_WORDS, useTfidf, ignoreCommon);
    
end

