%1. IMPORT DATA - ASSUME ITs CALLED 'plotIt'  (CSV of X Y Z points)
%2. DEPENDS ON PLOTCUBE - http://www.mathworks.com/matlabcentral/fileexchange/15161-plotcube

% 0.10 M version
% fig = figure('Position', [100, 100, 1049, 895]);
% for n = 1:length(plotIt)
%     plotcube([1 1 1], plotIt(n,:), .6, [0 0.5 plotIt(n,3)/16]);
%     axis([0 50 0 50 0 25]);  % AXIS SIZE
%     M(n) = getframe
% end

% 2.0 M version
% fig = figure('Position', [100, 100, 1049, 895]);
% for n = 1:length(plotIt)
%     plotcube([1 1 1], plotIt(n,:), .6, [0 0.5 plotIt(n,3)/5]);
%     axis([0 2 0 2 0 2]);  % AXIS SIZE
%     M(n) = getframe;
% end

fig = figure('Position', [100, 100, 1049, 895]);
for n = 1:length(plotIt)
    plotcube([1 1 1], plotIt(n,:), .6, [0 .5 plotIt(n,3)/5]);
    axis([0 10 0 7 0 4]);  % AXIS SIZE
    M(n) = getframe;
end




% figure
% movie(M,5,6)  % 5 = number of times, 6 = fps

%movie2avi(M,'myavifile2.avi', 'fps', 1)  % SAVE MOVIE TO FILE