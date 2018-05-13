% creates 6 segments for f19

% fun 6 segments = makesegments(moving-transformed)

%% Set up segments
InputVolume  = MOVING_transformed;
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
[MinimumColValue,IndexCol] = min(SumsInsideLung);
MiddleColumn = ColsInsideLung(1)+IndexCol -1;
% Set up right and left segments
LeftSegment (: , 1:MiddleColumn   , :) = 1;
RightSegment(: , MiddleColumn:end , :) = 1;

%% Get upper, middle, lower 1/3 segments
% compute row sums
for row = 1:128
    ROWSUM(row) = sum(sum(anat_out(row,:,:)));
end
% Get first and last column
RowsInsideLung = find(ROWSUM>0);
TopRow = RowsInsideLung(1); BottomRow = RowsInsideLung(end);
RowWidth = round((BottomRow-TopRow)/3)
% Set up upper, middle, lower third segments
UpperThird  (TopRow:TopRow+RowWidth , : , :) = 1;
MiddleThird (TopRow+RowWidth+1:TopRow+2*RowWidth +1 , : , :) = 1;
LowerThird (TopRow+2*RowWidth +2:BottomRow , : , :) = 1;

%% Use .* to Get All 6 Segments
UpperLeftSegment   = LeftSegment  .*UpperThird  .*InputVolume;
MiddleLeftSegment  = LeftSegment  .*MiddleThird .*InputVolume;
LowerLeftSegment   = LeftSegment  .*LowerThird  .*InputVolume;
UpperRightSegment  = RightSegment .*UpperThird  .*InputVolume;
MiddleRightSegment = RightSegment .*MiddleThird .*InputVolume;
LowerRightSegment  = RightSegment .*LowerThird  .*InputVolume;



figure(4);clf
imshow(UpperRightSegment(:,:,9),[])