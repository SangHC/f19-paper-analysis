function [ UpperLeft, MiddleLeft, LowerLeft, UpperRight, MiddleRight, LowerRight ] = ComputeSixLungSegments( InputVolume )

%Creates 6 lung segments using transformed anatomic volume as input

%% Set up pre-segments
LeftSegment  = uint8(zeros(size(InputVolume)));
RightSegment = uint8(zeros(size(InputVolume)));
UpperThird   = uint8(zeros(size(InputVolume)));
MiddleThird  = uint8(zeros(size(InputVolume)));
LowerThird   = uint8(zeros(size(InputVolume)));

%% Get Right and Left Segments
% Compute column sums
for column = 1:128
    COLSUM(column) = sum(sum(InputVolume(:,column,:)));
end
% Get Middle column
ColsInsideLung = find(COLSUM>50);
SumsInsideLung = COLSUM(ColsInsideLung(1):ColsInsideLung(end));
[~,IndexCol] = min(SumsInsideLung);
MiddleColumn = ColsInsideLung(1)+IndexCol -1;
% Set up right and left segments
LeftSegment (: , 1:MiddleColumn   , :) = 1;
RightSegment(: , MiddleColumn+1:end , :) = 1;

%% Get upper, middle, lower 1/3 segments
% compute row sums
for row = 1:128
    ROWSUM(row) = sum(sum(InputVolume(row,:,:)));
end
% Get first and last column
RowsInsideLung = find(ROWSUM>0);
TopRow = RowsInsideLung(1); BottomRow = RowsInsideLung(end);
RowWidth = round((BottomRow-TopRow)/3);
% Set up upper, middle, lower third segments
UpperThird  (TopRow:TopRow+RowWidth+2 , : , :) = 1;
MiddleThird (TopRow+RowWidth+3:BottomRow-RowWidth-3 , : , :) = 1;
LowerThird (BottomRow-RowWidth-2:BottomRow , : , :) = 1;

%% Use .* with Input Volume to Get 6 Lung Segments
UpperLeft   = LeftSegment  .*UpperThird  .*InputVolume;
MiddleLeft  = LeftSegment  .*MiddleThird .*InputVolume;
LowerLeft   = LeftSegment  .*LowerThird  .*InputVolume;
UpperRight  = RightSegment .*UpperThird  .*InputVolume;
MiddleRight = RightSegment .*MiddleThird .*InputVolume;
LowerRight  = RightSegment .*LowerThird  .*InputVolume;

end

