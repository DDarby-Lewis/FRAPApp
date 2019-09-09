function [Cell_Mask, Bleach_Mask, Cell_Boundary, Bleach_Boundary] =  getMaskandBoundary(footage, varargin)
%bleachMaskAndBoundry takes cell image and maps two outputs, a mask and a boundry
% Finds bleaching frame by calling bleachInstant.m function.
% 
% Created by Daniel Darby with thanks to Dr. Isabel Llorente Garcia.
% 
% Inputs:
% footage is an the (corrected) structure of frames under field 'image'
%
%cellMaskAndBoundry takes cell image and maps two outputs, a mask and a boundry
% 
% Created by Daniel Darby with thanks to Dr. Isabel Llorente Garcia.
% 
% Inputs:
% footage is an the (corrected) structure of frames under field 'image'
%

%% Call function cellMaskAndBoundary.m
[cM, cB] = cellMaskAndBoundary(footage,varargin);



