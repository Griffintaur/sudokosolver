function [  ] = region( img )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

figure(3),imshow(img);hold on
stat=regionprops(img,'Area','BoundingBox','PixelList','PixelIdxList','Extrema');
len=length(stat);
maxarea=0;
for k=1:length(stat)
    if(stat(k).Area>maxarea)
        maxarea=stat(k).Area;
        imax=k;
    end
end
bbox=stat(imax).BoundingBox;
bx=stat(imax).Extrema;
movingpoints=[ceil(bx(7,:));ceil(bx(4,:));ceil(bx(2,:));ceil(bx(1,:))];
movingpoints=double(round(movingpoints))
%%
tform=cp2tform(movingpoints,0.5+[0 0; 9 0; 9 9; 0 9],'projective');
for n = 0.5 + 0:9
    [x,y] = tforminv(tform,[n n],[0.5 9.5]);
    plot(x,y,'g'); 
end
for n = 0.5 + 0:9
    [x,y] = tforminv(tform,[0.5 9.5],[n n]);
    plot(x,y,'b'); 
end

%%
A_tmin = 30; % Bounds for the digit pixel area
A_tmax = 1000;
digitbox_minarea = 20; % Bounds for the digit bounding box area
digitbox_maxarea = 25^2;

kgood = zeros(1,len);
Pnew = zeros(len,2);
        for k = 1:len
            if stat(k).Area < A_tmax && stat(k) > digitbox_minarea && stat(k) < digitbox_maxarea ...
                    && stat(k).BoundingBox(3) < 40 && stat(k).BoundingBox(4) < 40 ...
                    && stat(k).BoundingBox(3) > 1 && stat(k).BoundingBox(4) > 1
                
                Pnew(k,:) = [stat(k).BoundingBox(1)+stat(k).BoundingBox(3)/2 stat(k).BoundingBox(2)+stat(k).BoundingBox(4)/2];
                
                
                if inpolygon(Pnew(k,1),Pnew(k,2),movingpoints(:,1),movingpoints(:,2))
                    h_digitcircles(k) = plot(Pnew(k,1),Pnew(k,2),'ro','markersize',24);
                end
                
            end
        end
T = cp2tform(movingpoints(1:4,:),[0.5 0.5; 9.5 0.5; 9.5 9.5; 0.5 9.5],'projective');
Plocal = (tformfwd(T,Pnew));
Plocal = round(2*Plocal)/2;

del = find(sum(Plocal - floor(Plocal) > 0 |  Plocal < 1 | Plocal > 9,2)) ;
Pnew(del,:) = [];

delete(nonzeros(h_digitcircles(del)));

figure(15);
T = cp2tform(pts(1:4,:),500*[0 0; 1 0; 1 1; 0 1],'projective');
IT = imtransform(double(I),T);
imshow(IT);
end

