function [ img ] = preprocessing( img )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
i=imresize(img,[640 640]);
applybw = @(i) im2bw(i.data,mean(double(i.data(:)))/1.05/255);
img=~blockproc(i,[40 40],applybw);
figure(1),imshow(img);

%img=bwareaopen(img,25);
[ilabel conn]=bwlabel(img,4);
iout=img;
for i=1:conn
    lab=find(ilabel==i);
    if length(lab)<50
        iout(lab)=0;
    end
end
img=iout;     
img=imclearborder(img);

end

