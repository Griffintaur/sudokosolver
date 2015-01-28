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
%class(b)
%bp=boundary;
%i=imfill(i,bp);
%i=bwmorph(i,'skel',inf);
%=bwmorph(i,'endpoints');
%figure(9),imshow(i);
%%
stat=regionprops(img,'Area','BoundingBox','PixelList','PixelIdxList','Extrema');
maxarea=0;
for k=1:length(stat)
    if(stat(k).Area>maxarea)
        maxarea=stat(k).Area;
        imax=k;
    end
end

bbox=stat(imax).BoundingBox
fixedpoints=[stat(imax).BoundingBox(1)  stat(imax).BoundingBox(2);
             stat(imax).BoundingBox(1) stat(imax).BoundingBox(1)+stat(imax).BoundingBox(3);
            stat(imax).BoundingBox(1)+stat(imax).BoundingBox(3) stat(imax).BoundingBox(2)+stat(imax).BoundingBox(4);
            stat(imax).BoundingBox(2)+stat(imax).BoundingBox(4) stat(imax).BoundingBox(1)]
  
   i=imcrop(img,stat(imax).BoundingBox)  ;
   figure(8),imshow(i);
        pt=stat(imax).Extrema
pts=[pt(1,:) ;pt(2,:);pt(4,:);pt(7,:)]
T = cp2tform(pts,0.5 + [0 0; 9 0; 9 9; 0 9],'projective');
for n = 0.5 + 0:9, [x,y] = tforminv(T,[n n],[0.5 9.5]); plot(x,y,'b'); end
for n = 0.5 + 0:9, [x,y] = tforminv(T,[0.5 9.5],[n n]); plot(x,y,'b'); end
j=imwarp(i,T,'OutputView',imref2d(size(i)));
R=imref2d(size(i),[1 size(i,2)],[1 size(i,1)]);
j=imwarp(i,R,T,'OutputView',R);
figure(5),imshow(j);
        

%i=imcrop(i,bbox);
figure(4),imshow(i);hold on
[h theta rho]=hough(i);
peaks=houghpeaks(h,20);
lines=houghlines(i,theta,rho,peaks);
for k=1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
end

[b l]=bwboundaries(i,'noholes');
amin=10 ;amax=100;boundary={};
for i=1:length(b)
    if length(b)<amax && length(b)>amin
        boundary=b{i};
       
        plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2)
    end
end
DIAG1 = sum(stat(imax).PixelList,2);
DIAG2 = diff(stat(imax).PixelList,[],2);

























    






