function [fit_Rect, gof, uncer] = fitRect(I,h,w, varargin)
%CREATEFIT(T,FI)
%  Create a fit.
%
%  Data for 'Rectangle' fit:
%  Input:
%      I = y data, for FRAP this is intensity data, must be normalised to 
%      full or double. If double normalised will convert to full.
%      h = handle for Image
%      varargin:
%           time data of the same length as I data (has to go first if included)
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%      
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 15-Jul-2014 15:59:28

%% Handle varargins:

if length(varargin) < 2
    varargin{2} = [];
end
if length(varargin) < 1 %this occurs if there are no varargin
    varargin{1} = [];
end

if length(varargin) > 2
    error('fRect:invar', 'Too many input arguments');
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

[~,instant] = min(I);

%% Fit: 'Rect'
% if I(instant) ~= 0
%     I = (I - I((instant)))/(1 - I((instant))); % full norms double data
% end

[xData, yData] = prepareCurveData( t, I );

% handle non zero time bleach event
xData = xData(instant:end);
yData = yData(instant:end);

% Set up fittype and options.

if I(instant) == 0
    ft = fittype('A*(1-sqrt(w^2/(w^2+4*pi*D*x)))', 'independent', 'x', 'dependent', 'y', 'problem', 'w');
    opts = fitoptions( ft );
    opts.Lower = [0,0];
    opts.StartPoint = [0,1];
    opts.Upper = [1,Inf];
    % Fit model to data.
    [fit_Rect, gof] = fit( xData, yData, ft, opts, 'problem', w);


    % Calculate curves

    % Plot fit with data.
    plot( fit_Rect, xData, yData, 'predobs' );

    % Title
    title('Intensity vs Time Rectangular Fit')


else
    ft = fittype('C + A*(1-sqrt(w^2/(w^2+4*pi*D*t)))', 'independent', 't', 'dependent', 'y', 'problem', 'w');
    opts = fitoptions( ft );
    opts.Lower = [0,0,0];
    opts.StartPoint = [0,0,1];
    opts.Upper = [Inf,1,Inf];
    
    % Fit model to data.
    [fit_Rect, gof] = fit( xData, yData, ft, opts, 'problem', w);


    % Calculate curves

    % Plot fit with data.
    plot( fit_Rect, xData, yData, 'predobs' );

    % Title
    title('Intensity vs Time Rectangular Fit')


end
opts.Display = 'Off';

% set the Uncertainties:

con = confint(fit_Rect,0.682);% 68.2% confidence interval for each fit parameter (lower and upper bounds as first and second rows).
err = (con(2,:)-con(1,:))/2; % Standard deviation of each fit parameter (probability to be between -STDEV and +STDEV is 68.2%).
if I(instant)==0
    uncer.A = err(1);
    uncer.D = err(2);
else
    uncer.C = err(1);
    uncer.A = err(2);
    uncer.D = err(3);
end

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

legend( h, 'Intensity Data', 'Rectangle Fit','95% Confidence', 'Uncertinty Bounds', 'Location', 'best');


