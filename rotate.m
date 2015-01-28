function [ i] = rotate( img )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
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

end

