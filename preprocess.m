function [ output_args ] = preprocess( source_file )
% preprocessing of the sudoko goes here
i=imread(source_file);
i=imresize(i,[640 640]);
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
 %%
[h theta rho]=hough(img);
p=houghpeaks(h,1);
line=houghlines(img,theta,rho,p);
line.theta
if (abs(line.theta)>90)
    i=imrotate(img,abs(line.theta)-90,'crop');
    figure(3),imshow(i);
else
    i=imrotate(img,90-abs(line.theta),'crop');
    figure(3),imshow(i);
end

%%
stat=regionprops(i,'Area','BoundingBox','PixelList','PixelIdxList');
maxarea=0;
for k=1:length(stat)
    if(stat(k).Area>maxarea)
        maxarea=stat(k).Area;
        imax=k;
    end
end

bbox=stat(imax).BoundingBox;

i1=imcrop(i,bbox);
figure(4),imshow(i1);hold on
[h theta rho]=hough(i1);
peaks=houghpeaks(h,20);
lines=houghlines(i1,theta,rho,peaks);
for k=1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
end

[b l]=bwboundaries(i1,'noholes');
amin=10 ;amax=100;
for i=1:length(b)
    if length(b)<amax && length(b)>amin
        boundary=b{i};
        plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2)
    end
end









