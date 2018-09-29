load('normdist.mat')

hAxes = axes('NextPlot','add',...           %# Add subsequent plots to the axes,
             'DataAspectRatio',[1 1 1],...  %#   match the scaling of each axis,
             'XLim',[0 70],...               %#   set the x axis limit,
             'YLim',[0 eps],...             %#   set the y axis limit (tiny!),
             'Color','none');               %#   and don't use a background color
figure;
plot(S1,0,'bo','MarkerSize',10);  %# Plot data set 1
plot(S2,0,'ro','MarkerSize',10);  %# Plot data set 1
plot(T ,0,'ks','MarkerSize',10);  %# Plot data set 1
