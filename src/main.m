function main(  )

    % You may need to change dir here
    FRAMES_DIR = './v/filer4b/v44q010/a4data/frames/';
    SIFT_DIR = './v/filer4b/v44q010/a4data/sift/';
    
    %Question 1, raw descriptor matching
    load([SIFT_DIR, '/twoFrameData.mat']); 
    %In twoFrameData.mat, we have im1/2, descriptors1/2, orients1/2,
    %positions1/2, scales1/2
    imSIFT1 = ImageSIFT(descriptors1, orients1, positions1, scales1);
    imSIFT2 = ImageSIFT(descriptors2, orients2, positions2, scales2);
    rawDescriptorMatches(im1, im2, imSIFT1, imSIFT2);
    
    %Question 2
    
    
end

