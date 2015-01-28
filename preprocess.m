function [ output_args ] = preprocess( source_file )
% preprocessing of the sudoko goes here
i=imread(source_file);
img=preprocessing(i);
%%
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
%i=rotate(img);
%class(b)
%bp=boundary;
%i=imfill(i,bp);
%i=bwmorph(i,'skel',inf);
%=bwmorph(i,'endpoints');
%figure(9),imshow(i);
%%
region(img);

























    






