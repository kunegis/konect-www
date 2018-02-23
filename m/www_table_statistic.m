%
% Create the table of the list of networks for one statistic.
%
% PARAMETERS
%	$statistic
% 
% INPUT FILES
%	dat/NETWORKS
%	dat/STATISTICS
%	dat/statistic.$statistic.$network 	for $network in [dat/NETWORKS]
%
% OUTPUT FILES
%	skeleton/statistics/$statistic/table.html
%	skeleton/statistics/$statistic/count
%

statistic = getenv('statistic');

[consts symbols_format symbols_weights labels_format labels_weights int_format int_weights] = konect_consts(); 
[logarithmic integer percent negative] = konect_data_statistic();

filename_out = sprintf('skeleton/statistics/%s/table.html', statistic); 
OUT = fopen(filename_out, 'w');
if OUT < 0,  error(filename_out);  end;

filename_networks = 'dat/NETWORKS'; 
NETWORKS = fopen(filename_networks, 'r');
if NETWORKS < 0,  error(filename_networks);  end; 

% Determine whether to left- or right-align the column 
if integer.(statistic)
  align = 'right';
elseif percent.(statistic)
  align = 'left'; 
else
  align = 'right'; 
end

symbol= konect_label_statistic(statistic, 'html-short');
title= konect_label_statistic(statistic, 'html-name'); 
fprintf(OUT, '<TABLE>\n'); 
fprintf(OUT, '<TR><TD><B>Name</B><TD class="padleft"><B>Attributes</B><TD class="padleft" align="%s"><B title="%s">%s</B>', ...
	align, title, symbol);

% Determine the list of statistics to show -- the main statistic and its
% substatistics
substatistics = [1]; % Index of substatistics to show 
filename_statistics = 'dat/STATISTICS'; 
STATISTICS = fopen(filename_statistics, 'r');
while ~((s = fgetl(STATISTICS)) == -1)
  i = find(s == '+');
  if length(i) == 0,  continue;  end;
  if ! strcmp(statistic, s(1:i-1)),  continue;  end;
  substatistics = [ substatistics ; str2num(s(i+1:end)) ];
  symbol_substatistic= konect_label_statistic(s, 'html-short');
  title_substatistic= konect_label_statistic(s, 'html-name'); 
  fprintf(OUT, '<TD class="padleft" align="%s"><B title="%s">%s</B>', ...
	  align, title_substatistic, symbol_substatistic); 
end
if STATISTICS < 0,  error(sprintf('fopen(%s)', filename_statistics));  end;
if fclose(STATISTICS) < 0,  error(sprintf('fclose(%s)', filename_statistics));  end;
substatistics
fprintf(OUT, '\n'); 

count=0
while ~((network = fgetl(NETWORKS)) == -1)
  filename_in = sprintf('dat/statistic.%s.%s', statistic, network)
  ret_exist = exist(filename_in, 'file')
  if 2 ~= ret_exist,  continue;  end;
  values = read_statistic(statistic, network);
  format= read_statistic('format', network); 
  weights= read_statistic('weights', network); 
  meta= read_meta(network); 
  name= meta.name;
  icon_category = www_icon_category(meta.category); 
  text_format= int_format{format};
  text_weights= int_weights{weights}; 
  title_format = labels_format{format};
  title_weights = labels_weights{weights};
  text_icon_all = www_icon_all(network, meta); 

  fprintf(OUT, '<TR><TD><A href="../../networks/%s/">%s</A><TD class="padleft">%s', ...
	  network, name, text_icon_all); 

  for i = 1 : length(substatistics)
    fprintf(OUT, '<TD class="padleft" align="%s">', align); 
    if substatistics(i) > length(values),  continue;  end; 
    value= values(substatistics(i)); 
    if i == 1
      substatistic = statistic;
    else
      if isnan(value),  continue;  end; 
      substatistic = sprintf('%s+%u', statistic, i); 
    end
    text_value = www_format_statistic(substatistic, value); 
    fprintf(OUT, '%s', text_value);
  end
  fprintf(OUT, '\n'); 
  count = count + 1; 
end

fprintf(OUT, '</TABLE>\n'); 

if fclose(NETWORKS) < 0,  error(filename_networks);  end;
if fclose(OUT) < 0,  error(filename_out);  end;

filename_count = sprintf('skeleton/statistics/%s/count', statistic);
COUNT = fopen(filename_count, 'w');
if COUNT < 0,  error(sprintf('fopen(%s)', filename_count));  end;
fprintf(COUNT, '%u\n', count);
if fclose(COUNT) < 0,  error(sprintf('fclose(%s)', filename_count));  end;
