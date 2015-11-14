function [ shotBreakFrames ] = shotBreakDetection(siftDir, framesDir, dataDir, numberToShow, saveToFile, loadFromFile)
% input:
%   numberToShow: integer, how many pictures you want to see my result

% output:
%   shotBreakFrams: n * 2 integers, in every raw, 2 integers indicates the
%     two neighbor frames are scene change

    SAVE_DIR = dataDir;
    THRESHOLD = 0.2;
    IGNORE_BLACK = false; 
    % We may not see a frame whose next or previou frames is black screen 
    % is an interesting shot break.
    % (although it strongly indicates the scene changes but it's too naive)
    % setting IGNORE_BLACK to true will ignore black screen shot break 
    
    if loadFromFile
        load([SAVE_DIR 'allHist.mat'], 'bagOfWordHist');
    else
        load([dataDir 'vocabulary_centers.mat'], 'vocabularyCenters');
        bagOfWordHist = computeBOWHist(siftDir, vocabularyCenters);
    end
    
    if saveToFile
        save([SAVE_DIR 'allHist.mat'], 'bagOfWordHist');
    end
    
    totalFiles = size(bagOfWordHist, 1);
    breakScore = zeros(1, totalFiles - 1);
    shotBreakFrames = [];
    
    for i = 1: (totalFiles - 1)
        hist1 = bagOfWordHist(i, :);
        hist2 = bagOfWordHist(i + 1, :);
        div = (norm(hist1) * norm(hist2));
        if div == 0
            if norm(hist1) + norm(hist2) ~= 0
                breakScore(i) = 0;
            else
                breakScore(i) = 1;
            end
        else
            breakScore(i) = sum(hist1 .* hist2) / div;
        end
        
        if breakScore(i) < THRESHOLD
            if IGNORE_BLACK
                if breakScore(i) ~= 0
                    shotBreakFrames = [shotBreakFrames; i, i+1];
                end
            else        
                shotBreakFrames = [shotBreakFrames; i, i+1];
            end
        end
    end
    
    
    if numberToShow > 0
        %figure;
        %plot(breakScore);
        %breakScore(1:25)
        %size(shotBreakFrames)
        
        %randomly choose frames to show
        showIndex = randperm(size(shotBreakFrames, 1));
        showIndex = showIndex(1: numberToShow);
        
        siftFiles = dir([siftDir '/*.jpeg.mat']);
        figure;
        hold on;
        for i = 1:numberToShow
            for j = 1:2
                % showFrame = shotBreakFrames(i, j);
                showFrame = shotBreakFrames(showIndex(i), j);
                fname = [siftDir '/' siftFiles(showFrame).name];
                load(fname, 'imname');
                imname = [framesDir '/' imname];
                showImage = imread(imname);
                
                subplot(numberToShow, 2, (i - 1) * 2 + j);
                imshow(showImage);
            end
        end
        hold off;
    end
end

