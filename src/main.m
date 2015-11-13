function main(  )

    % You may need to change dir here
    FRAMES_DIR = './v/filer4b/v44q010/a4data/frames/';
    SIFT_DIR = './v/filer4b/v44q010/a4data/sift/';
    DATA_DIR = './precompute_data/';
    
    RUN_QUESTIONS = [1, 3, 4];
    RUN_EXTRA = [1, 3];
    
    %Question 1, raw descriptor matching
    if find(RUN_QUESTIONS == 1)
        load([SIFT_DIR, '/twoFrameData.mat']); 
        %In twoFrameData.mat, we have im1/2, descriptors1/2, orients1/2,
        %positions1/2, scales1/2
        imSIFT1 = ImageSIFT(descriptors1, orients1, positions1, scales1);
        imSIFT2 = ImageSIFT(descriptors2, orients2, positions2, scales2);
        rawDescriptorMatches(im1, im2, imSIFT1, imSIFT2, 1);
    end
    
    %Question 2
    if find(RUN_QUESTIONS == 2)
        vocabularyCenters = visualizeVocabulary(SIFT_DIR, FRAMES_DIR);
        save([DATA_DIR 'vocabulary_centers.mat'], 'vocabularyCenters');
        bagOfWordHist = computeBOWHist(SIFT_DIR, vocabularyCenters);
        save([DATA_DIR 'allHist.mat'], 'bagOfWordHist');
        precomputeIdf(DATA_DIR);
        weightedHist = tfidf(bagOfWordHist, DATA_DIR);
        save([DATA_DIR 'tfidf.mat'], 'weightedHist');
    end
    
    %Question 3
    if find(RUN_QUESTIONS == 3)
        SHOW_RESULT_IMAGES = true;
        NUMBER_OF_SIMILAR_FRAMES = 5;
        QUERY_FRAME = [1];
        SAVE_TO_FILE = false;
        LOAD_FROM_FILE = true;
        USE_TFIDF = false;
        IGNORE_COMMON = false;
        
        load([DATA_DIR 'vocabulary_centers.mat'], 'vocabularyCenters');
        for i = 1:length(QUERY_FRAME)
            fullFrameQueries(SIFT_DIR, FRAMES_DIR, vocabularyCenters, QUERY_FRAME(i),...
                NUMBER_OF_SIMILAR_FRAMES, SHOW_RESULT_IMAGES, SAVE_TO_FILE, LOAD_FROM_FILE,...
                USE_TFIDF, IGNORE_COMMON);
        end
    end
    
    %Question 4
    if find(RUN_QUESTIONS == 4)
        SHOW_RESULT_IMAGES = true;
        NUMBER_OF_SIMILAR_FRAMES = 5;
        QUERY_FRAME = 1;
        SAVE_TO_FILE = false;
        LOAD_FROM_FILE = true;
        FULL_FRAME_QUERY = false;
        ONLY_COMPARE_NON_ZERO_WORDS = false;
        USE_TFIDF = true;
        IGNORE_COMMON = true;
        
        load([DATA_DIR 'vocabulary_centers.mat'], 'vocabularyCenters');
        regionQueries(SIFT_DIR, FRAMES_DIR, vocabularyCenters, QUERY_FRAME,...
            NUMBER_OF_SIMILAR_FRAMES, SHOW_RESULT_IMAGES, SAVE_TO_FILE, LOAD_FROM_FILE,...
            FULL_FRAME_QUERY, ONLY_COMPARE_NON_ZERO_WORDS, USE_TFIDF, IGNORE_COMMON);
    end
    
    % Extra credit 1
    if find(RUN_EXTRA == 1)
        PRE_COMPUTE = true;
        IGNORE_THRES = 8000;
        % pre compute the tfidf value. If has already run question 2
        % don need to run again here.
        if PRE_COMPUTE 
            load([DATA_DIR 'allHist.mat'], 'bagOfWordHist');
            precomputeIdf(DATA_DIR);
            weightedHist = tfidf(bagOfWordHist, DATA_DIR);
            save([DATA_DIR 'tfidf.mat'], 'weightedHist');
        end
        notIgnore = find(sum(bagOfWordHist) > 8000);
        
    end
    
    % Extra credit 3
    if find(RUN_EXTRA == 3)
        NUMBER_TO_SHOW = 5;
        SAVE_TO_FILE = 0;
        LOAD_FROM_FILE = 1;
        shotBreakDetection(SIFT_DIR, FRAMES_DIR, DATA_DIR, NUMBER_TO_SHOW, ...
            SAVE_TO_FILE, LOAD_FROM_FILE);
    end
    
end

