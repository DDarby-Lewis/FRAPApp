function [fit_Gauss, gof, uncer] = fitGauss(I,h, varargin)
%CREATEFIT(T,FI)
%  Create a fit.
%
%  Data for 'Gaussian' fit:
%  Input:
%      I = y data, for FRAP this is intensity data, must be normalised to 
%      double. 
%      varargin:
%           time data of the same length as I data (has to go first if included)
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%      
%
%  See also FIT, CFIT, SFIT.


%% Handle varargins and initilise:

if length(varargin) < 2
    varargin{2} = [];
end
if length(varargin) < 1 %this occurs if there are no varargin
    varargin{1} = [];
end

if length(varargin) > 2
    error('fGauss:invar', 'Too many input arguments');
end

if isnumeric(varargin{1}) && ~isempty(varargin{1}) && length(varargin{1}) == length(I)
    t = varargin{1};
else
    t = [];
end
if isempty(h)
    h = axes;
end
axes(h)

[Ibleach,instant] = min(I);

%% Fit: 'Gaussian'

% if input  is full normalised:
if I(instant) == 0
    error('fGauss:full','data must be double normalised, or raw, but not full normalised');
end

Ibleach = sum(I(instant:(instant+5)))/6;

Ipre = mean(I(1:(instant-1)));
K = (Ibleach * lambertw(-Ipre*exp(-Ipre/Ibleach)/Ibleach) + Ipre)/Ibleach;

[xData, yData] = prepareCurveData( t, I );

% handle non zero time bleach event
xData = xData(instant:end);
yData = yData(instant:end);

if isempty(t)
    xData = xData - instant;
end

% Set up fittype and options.

ft = fittype(...
    'Ipre*((1+2*t/td)^-1)*(K^(-((1+2*t/td)^-1)))*gamma((1+2*t/td)^-1)*(chi2cdf(2*K,2*(1+2*t/td)^-1))',...
    'independent', 't', 'dependent', 'y','problem',{'Ipre','K'});

opts = fitoptions( ft );
opts.Display = 'Off';
opts.Lower = 0;
opts.StartPoint = 1;
opts.Upper = Inf;

% Fit model to data.
[fit_Gauss, gof] = fit(xData, yData, ft, opts, 'problem', {Ipre,K});


%% Calcculate curves

% Plot fit with data.
plot( fit_Gauss, xData, yData, 'predobs' );

% Title
title('Intensity vs Time Gaussian Fit')

% set the Uncertainties:
% set the Uncertainties:

con = confint(fit_Gauss,0.682);% 68.2% confidence interval for each fit parameter (lower and upper bounds as first and second rows).
err = (con(2,:)-con(1,:))/2; % Standard deviation of each fit parameter (probability to be between -STDEV and +STDEV is 68.2%).
uncer.td = err(1);

%% Making Graphs
% Label axes
axis([min(xData),max(xData),0,max(yData)+0.05])
ylabel( 'Intensity Data' );xlabel( 'Time/s' );
grid on
set(gca, 'GridLineStyle', '-');
grid(gca,'minor')

% % show GOF
% str1(1) = {'Goodness Of Fit Data:'};
% str1(2)= {[' sse:             ', num2str(gof.sse)]};
% str1(3)= {[' rsquare:      ', num2str(gof.rsquare)]};
% str1(4)= {[' dfe:             ', num2str(gof.dfe)]};
% str1(5)= {[' adjrsquare: ', num2str(gof.adjrsquare)]}; 
% str1(6)= {[' rmse:          ', num2str(gof.rmse)]};
% 
% text(xData(5), 1.025, str1,'FontWeight','bold','BackgroundColor', [1,1,1],'VerticalAlignment','top','HorizontalAlignment','left', 'FontSize', 8);

legend( h, 'Intensity Data', 'Gaussian Fit','95% Confidence', 'Uncertinty Bounds', 'Location', 'best');

