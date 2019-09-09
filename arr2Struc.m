function[image_data] = arr2Struc(footage)
% converts 3D array to a strcture of images for use with Dr. Isabel's original functions
image_data = struct('image',[]);
for p = 1: size(footage,3)
    image_data(p).frame_data = frame; 
end