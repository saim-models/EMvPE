function h = plot_know(varargin)
%PLOT_KNOW plots the time course of activation in the knowledge network.
%
%
% Labels:
% symbols
% legends
% step
data = varargin{1};
[timesteps number_templates] = size(data);
time = ones(number_templates,1) * [1:timesteps];
time = time';
j = findcstr(varargin, 'symbols');
if isempty(j)
    for i=1:number_templates
        symbols{i}='';
    end
else
    for i=j+1:j+number_templates
        symbols{i-j} = varargin{i};
    end
    
end

j = findcstr(varargin, 'legends');
if isempty(j)
    for i=1:number_templates
        legends{i}='';
    end
else
    for i=j+1:j+number_templates
        legends{i-j} = varargin{i};
    end
    
end
j = findcstr(varargin, 'step');
if isempty(j)
    step = timesteps;
    step = 1;

else
    step = round(varargin{j+1}*timesteps);
    
end

command = sprintf('%s', 'h1 = plot(');

for i=1:number_templates
    command = sprintf('%s time(1:%d:end,%d), squeeze(data(1:%d:end,%d)),''%s'',', command,step,i,step, i, symbols{i});
%    command = sprintf('%s time(1:end,%d), squeeze(data(1:end,%d)),''%s'',', command,i, i, symbols{i});
%    command = sprintf('%stime(:,%d), squeeze(data(:,%d)),', command,i, i);
end
command = sprintf('%s, ''color'', ''k''%s', command(1:end-1), ');');

eval(command);
    gca.ActivePositionProperty = 'outerposition';

xlabel('time');
ylabel('Activation');
%drawnow;
legend(h1, legends{:},'location','southeast');


h = gca;
%% 
return
command = sprintf('%s', 'h1 = plot(');
for i=1:number_templates
    command = sprintf('%stime(1:%d:end,%d), squeeze(data(1:%d:end,%d)),''%s'',', command,step,i, step, i, symbols{i});
end

command = sprintf('%s, ''color'', ''k''%s', command(1:end-1), ');');

eval(command);
hold on
legend(h1, legends{:},'location','northwest');
return
set(gca,'ColorOrderIndex',1)
