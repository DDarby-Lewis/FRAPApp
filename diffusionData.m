function [Data,sData] = diffusionData(fit,uncer,gof,w,mobhalf)
%Prodces diffusion constnt and other data

Data.formula = formula(fit);

conams = coeffnames(fit);
covals = coeffvalues(fit);
probnams = probnames(fit);
probvals = probvalues(fit);

%% Diffusion Constant:

if strcmp(conams(1),'td')&&length(conams)==1
    % Gaussian Fitting
    D = (w^2)/(4*fit.td);
    uncer.D = (4*fit.td)^(-1) * sqrt((2*uncer.w*w)^2 + (w^2*uncer.td/fit.td)^2);
    
    sformula = '$$ f(t) = I_{pre} \cdot (1+2t/\tau_D)^{-1} \cdot K^{-(1+2t/\tau_D)^{-1}} \cdot \Gamma((1+2t/\tau_D)^{-1}) \cdot D_{\chi^{2}}(2K,2(1+2t/\tau_D)^{-1})$$';

elseif strcmp(conams(2),'tau')||strcmp(conams(3),'tau')
    % Uniform Circle Fitting
    if length(conams) ==3 
        sformula = '$$f(t) = A \cdot e^{-2\tau/t} \cdot [I_0(2\tau/t)+ I_1(2\tau/t)]$$';
    else
        sformula = '$$f(t) = C + A \cdot e^{-2\tau/t} \cdot [I_0(2\tau/t)+ I_1(2\tau/t)]$$';
    end
    D = (w^2)/(4*fit.tau);
    uncer.D = (4*fit.tau)^(-1) * sqrt((2*uncer.w*w)^2 + (w^2*uncer.tau/fit.tau)^2);

elseif strcmp(conams(2),'D')||strcmp(conams(3),'D')
    % Rectangular Fitting
    if length(conams) ==3
        sformula = '$$f(t) = A \cdot (1-\sqrt{w^2/(w^2+4\pi D t))}$$';
    else
        sformula = '$$f(t) = C + A \cdot (1-\sqrt{w^2/(w^2+4\pi D t))}$$';
    end
    D = fit.D;
elseif length(conams) ==3 && strcmp(conams(1),'I0')
    sformula = '$$ f(t) = I_0 - a\cdot e^{-bt}$$';
    D = 0.224*(w^2)/(mobhalf.halflife);
    uncer.D = 0.224*(mobhalf.halflife)^(-1) * sqrt((2*uncer.w*w)^2 + (w^2*uncer.halflife/mobhalf.halflife)^2);
elseif length(conams) ==5 && strcmp(conams(1),'I0')
    % double expoential
    sformula = '$$ f(t) = I_0 - a\cdot e^{-bt} - c\cdot e^{-dt}$$';
    D = 0.224*(w^2)/(mobhalf.halflife);
    uncer.D = 0.224*(mobhalf.halflife)^(-1) * sqrt((2*uncer.w*w)^2 + (w^2*uncer.halflife/mobhalf.halflife)^2);
end


for k = 1:length(conams)
    Data.(cell2mat(conams(k))) = [covals(k), uncer.(cell2mat(conams(k)))];
end
for k = 1:length(probnams)
    Data.(cell2mat(probnams(k))) = probvals(k);
end

if ~isempty(mobhalf)
    mobhalfnames = fields(mobhalf);
    for k = 1:length(mobhalfnames)
        Data.(cell2mat(mobhalfnames(k))) = [mobhalf.(cell2mat(mobhalfnames(k))), uncer.(cell2mat(mobhalfnames(k)))];
    end
end

Data.D = [D,uncer.D];
Data.w = [w,uncer.w];
    
namsData = fieldnames(Data);
sData = cell(length(namsData),1);
for k = 1:length(namsData)
    sData{k} = strcat(cell2mat(namsData(k)),' =','(',num2str(Data.(cell2mat(namsData(k)))(1) ) );
    if strcmp(namsData(k),'formula')
        sData{k} = sformula;
    elseif strcmp(namsData(k),'td')
        sData{k} = strcat('$$\tau_D$$',' =','(',num2str(Data.(cell2mat(namsData(k)))(1) ) );
    elseif strcmp(namsData(k),'K')
        sData{k} = strcat('$$K$$',' =','(',num2str(Data.(cell2mat(namsData(k)))(1) ) ,')');
    elseif strcmp(namsData(k),'Ipre')
        sData{k} = strcat('$$I_{pre}$$',' =','(',num2str(Data.(cell2mat(namsData(k)))(1) ),')' );
    elseif strcmp(namsData(k),'tau')
        sData{k} = strcat('$$\tau$$',' =','(',num2str(Data.(cell2mat(namsData(k)))(1) ) );
    end
    if length(Data.(cell2mat(namsData(k))))>1 && ~strcmp(namsData(k),'formula')
        sData{k} = strcat(sData{k}, ' $$\pm$$', num2str(Data.(cell2mat(namsData(k)))(2) ), ')');
    end
    if strcmp(namsData(k),'D')
        sData{k} = strcat(sData{k},'$$/m^2s^{-1}$$' );
    elseif strcmp(namsData(k),'w')
        sData{k} = strcat(sData{k},'$$/m$$' );
    elseif strcmp(namsData(k),'td')
        sData{k} = strcat(sData{k},'$$/s$$' );
    elseif strcmp(namsData(k),'tau')
        sData{k} = strcat(sData{k},'$$/s$$' );
    elseif strcmp(namsData(k),'halflife')
        sData{k} = strcat(sData{k},'$$/s$$' );
    elseif strcmp(namsData(k),'b')
        sData{k} = strcat(sData{k},'$$/s^{-1}$$' );
    elseif strcmp(namsData(k),'d')
        sData{k} = strcat(sData{k},'$$/s^{-1}$$' );
    end
end
