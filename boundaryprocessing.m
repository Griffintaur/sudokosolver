function [ img ] = boundaryprocessing( img )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

figure(2),imshow(img);hold on
[b l]=bwboundaries(img,'noholes');
max=0;
for i=1:length(b)
    match=length(b{i});
    if match>max
        max=match;
        boundary=b{i};
    end
end
 plot(boundary(:,2), boundary(:,1), 'g', 'LineWidth', 2);
 hold off;
end

