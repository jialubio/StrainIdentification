%cd('/Users/AngelaLu/Documents/You_lab/Strain Identification/Image Segmenter');
cd('/Volumes/Jia/You lab/Microscopy/Keyence/Morphology/20190805_PA');

All_FileNames = dir('/Volumes/Jia/You lab/Microscopy/Keyence/Morphology/20190805_PA');
FileNames = {All_FileNames.name};
FileNames = FileNames(1,6:end);
Splitted_FileNames = split(FileNames,["_","."]);
[dim1,dim2,dim3] = size(Splitted_FileNames);
Label = Splitted_FileNames(:,:,2);
%b=regexp(Splitted_FileNames(:,:,2),'\d*','split')
Classes = unique(Label);
Num_Class = length(Classes);
Date = unique(Splitted_FileNames(:,:,1));
Resolution = unique(Splitted_FileNames(:,:,3));
Objective = unique(Splitted_FileNames(:,:,4));
Zoom = unique(Splitted_FileNames(:,:,5));
Type = unique(Splitted_FileNames(:,:,7));
Destination_Folder = '/Volumes/Jia/You lab/Microscopy/Keyence/Morphology/20190805_PA_segmented/';
Cropped_FileNames = dir(Destination_Folder);
% index = 1;
index = length(Cropped_FileNames) + 1;

for k = 1: 1,
    count_per_class = length(find(strcmp(Label,Classes{2})));
    
    for j = 3: 3,
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % this algorithm uses edge detection
        % ref: https://www.mathworks.com/help/images/detecting-a-cell-using-image-segmentation.html
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Step 1: Read Image

        file_name = strcat(Date, '_',Classes{k},'_',Resolution,'_',Objective,'_',Zoom,'_',num2str(j,'%03d'), '.', Type);
        I = imread(file_name{1}); %'20190805_PAX1_highresolution_X4_X2_003.tif');
        [a,b] = size(I);
        I_crop = I(5000:a-5000, 5000:b-5000);
        %imshow(I_crop);
        
        % Step 2: Detect Cells
        [~,threshold] = edge(I_crop,'sobel');
        fudgeFactor = 1.3;
        BWs = edge(I_crop,'sobel',threshold * fudgeFactor);
        %imshow(BWs)
        
        % Step 3: Dilate the image
        se90 = strel('line',3,90);
        se0 = strel('line', 3,0);
        BWsdil = imdilate(BWs,[se90 se0]);
        %imshow(BWsdil)
        
        % Step 4: Fill interior gaps
        BWdfill = imfill(BWsdil,'holes');
        %imshow(BWdfill)
        
        % Step 5: Remove connected objects on borders
        BWnobord = imclearborder(BWdfill,4);
        %imshow(BWnobord)
        
        % Step 6: Smooth the object
        seD = strel('diamond',20);
        BWfinal = imerode(BWnobord,seD);
        BWfinal = imerode(BWfinal,seD);
        %imshow(BWfinal)
        
        % Step 7: Visualize segmentation
        % imshow(labeloverlay(I_crop,BWfinal))
        
        % Step 8: Locate cells, draw bounding box and remove noise
        BW = imclearborder(BWfinal);
        stats = struct2table(regionprops(BW,{'Area','Solidity','PixelIdxList', 'Centroid', 'BoundingBox'}));
        
        idx = stats.Area < 100000;
        for kk = find(idx)',
            BW(stats.PixelIdxList{kk}) = false;
        end
        %imshow(BW)
        
        imshow(labeloverlay(I_crop,BW))
        idx_cell = stats.Area > 100000;
        if length(find(idx_cell)) ~= 0,
            BoundingBox = stats.BoundingBox(find(idx_cell)',:);
            BoundingBox_large = zeros(length(find(idx_cell)),4);
            BoundingBox_large(:,1:2) = BoundingBox(:,1:2) - 100;
            BoundingBox_large(:,3:4) = BoundingBox(:,3:4)*1.5;

            for ii = 1: size(BoundingBox_large,1),
                h = rectangle('Position',BoundingBox_large(ii,:), 'EdgeColor','r');
                I_cell = imcrop(I_crop,BoundingBox_large(ii,:));
                File_Name = strcat(Destination_Folder,'Image_', num2str(index),'.tif');
                imwrite(I_cell, File_Name);
                index = index + 1;
            end
            VarTable = 
        end 
        
    end
end
