v = VideoReader('finger.mp4');
frames = v.NumberOfFrames;
a = linspace(0,0,4);
max1 = 0 , max2 = 0 , max3 = 0 ;

for i = 1:10:frames

img = read(v,i);

% The color thresholing part may vary according to the backgroung of the
% video and lightning condition
RGB = read(v,i);
RGB = imcrop(RGB,[434.5 185.5 957 895]);  
%createMask  Threshold RGB image using auto-generated code from colorThresholder app.
%  [BW,MASKEDRGBIMAGE] = createMask(RGB) thresholds image RGB using
%  auto-generated code from the colorThresholder app. The colorspace and
%  range for each channel of the colorspace were set within the app. The
%  segmentation mask is returned in BW, and a composite of the mask and
%  original RGB images is returned in maskedRGBImage.

% Auto-generated by colorThresholder app on 28-Mar-2019
%------------------------------------------------------


% Convert RGB image to chosen color space
I = rgb2ycbcr(RGB);

% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.000;
channel1Max = 134.000;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.000;
channel2Max = 255.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.000;
channel3Max = 143.000;

% Create mask based on chosen histogram thresholds
sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
BW = sliderBW;

% Initialize output masked image based on input image.
maskedRGBImage = RGB;

% Set background pixels where BW is false to zero.
maskedRGBImage(repmat(~BW,[1 1 3])) = 0;
%  se = strel('disk',10)
%  BW = imclose(BW,se);
 BW = ~BW;
%  [J,rect] = imcrop(BW)
  
% BW = imcrop(BW,[434.5 185.5 957 895]);  
 
 se = strel('disk',45);
 b1 = imopen(BW,se);
 
 %finding centroid of the palm
 s = regionprops(b1,'centroid');

centroids1 = cat(1,s.Centroid);
 
 BW = BW - b1;
 se = strel('disk',22)
 BW = imerode(BW,se);
% centroid determination of different elements
L = bwlabel(BW);
 s = regionprops(L,'centroid');

centroids2 = cat(1,s.Centroid);

 cc = bwconncomp(BW,4);
 number = cc.NumObjects;
 
 %finding the angle between the fingers so that we can have asl digit count
 %for 6 7 8 9 and 10
%  if( number == 3)
%  for j=1:2
%      y = centroids1(1,2);
%      x = centroids1(1,1);
%      y1 = centroids2(j,2);
%      x1 = centroids2(j,1);
%      y2 = centroids2(j+1,2);
%      x2 = centroids2(j+1,1);
%      m1 = (y1 - y)/(x1 - x);
%      m2 = (y2 - y)/(x2 - x);
%      a(1,j) = abs(atand((m2-m1)/(1+m1*m2)));
% 
%  
%      if( a(1,1)<=44 &&a(1,1)>=37 )
%          number=7;
%      else if ( a(1,2)>=33 && a(1,2)<=43 && a(1,1)>=15 &&a(1,1)<=25 )
%              number=8;
%          end
%      end
%  end 
%  end
% adding texts to video
  text_str=cell(1,1);
    text_str{1}=['Finger Count=' num2str(number)];
position=[23 34];
box_color={'red'};
img=insertText(img,position,text_str,'fontSize',70,'BoxColor', box_color,'BoxOpacity',0.5,'TextColor','white');
imshow(img);
 end

