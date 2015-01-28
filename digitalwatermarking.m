function[]=digitalwatermarking(input_image,watermark)
%%function to compute or to show digital watermatking in images

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   showing or hiding info in images                                      %
%   last segment can be commented if dont want to extract back.           %
%       by ankit singh                                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



i1=imread(watermark); % image to be watermarked
%resize the image
i1=imresize(i1,[ 256 256]);
% image on which water mark is to be placed
i2=imread(input_image); 
%resizing the image 
i2=imresize(i2,[ 256 256]);

%%getting individual image depth planes of both images
for i=1:8
a{i}=bitget(i1,i)*2^(i-1);
b{i}=bitget(i2,i)*2^(i-1);
end


%% showing up images of the individual depth planes

for i=1:8
  figure(1), subplot(2,4,i),imshow(a{i});
  figure(2),subplot(2,4,i),imshow(b{i});
    
end



%% water marked image to be constructed

newimage=b{8}+b{7}+b{6}+b{5}+b{4}+a{8}*(2^(-7))+a{7}*(2^(-6))+a{6}*(2^(-5));
figure(3),imshow(newimage);



%% reverse process to extract the watermark
 for i=1:8
    c{i}=bitget(newimage,i)*2^(i-1);
 end

 %showing up water mark image
 watermark=c{1}*2^7+c{2}*2^6+c{3}*2^5;
 figure(4),imshow(watermark);
end 
%%
 