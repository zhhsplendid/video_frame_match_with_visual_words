classdef ImageSIFT
    % This class store the SIFT features of one image.
    
    properties
        imname; % string // name of the image file that goes with this data
        numfeats; % 1 * 1 double // number of detected features ( = n)
        
        descriptors; % n * 128 double // the SIFT vectors
        orientations; % n * 1 double // the orientations of the patches
        positions; % n * 2 double // the positions of the patch centers
        scales; % n * 1 double // the scales of the patches
    end
    
    methods 
        % This constructor saves the basic properties of SIFT.
        % Because we may use this class for images not load from file, 
        % The image name isn't a essential property to be set here.
        function obj = ImageSIFT(descris, orients, pos, sc)
            obj.numfeats = size(descris, 1);
            obj.descriptors = descris;
            obj.orientations = orients;
            obj.positions = pos;
            obj.scales = sc;
        end
        
        % Set image name
        function obj = setImageName(name)
            obj.imname = name;
        end
        
        % We can load SIFT directly from file
        function obj = loadFromFile(fileName)
            load(fileName, 'imname', 'numfeats', 'descriptors', 'orientations', 'positions', 'scales');
            obj.imname = imname;
            obj.numfeats = numfeats;
            obj.descriptors = descriptors;
            obj.orientations = orientations;
            obj.positions = positions;
            obj.scales = scales;
        end
    end
    
   
    
end

