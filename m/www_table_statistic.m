%
% Create the table of the list of networks for one statistic.
%
% PARAMETERS
%	$statistic
% 
% INPUT FILES
%	dat/NETWORKS
%	dat/statistic.$statistic.$network 	for $network in [dat/NETWORKS]
%
% OUTPUT FILES
%	skeleton/statistics/$statistic/table.html
%	skeleton/statistics/$statistic/count
%

statistic = getenv('statistic');

[consts symbols_format symbols_weights labels_format labels_weights int_format int_weights] = konect_consts(); 

filename_out = sprintf('skeleton/statistics/%s/table.html', statistic); 
OUT = fopen(filename_out, 'w');
if OUT < 0,  error(filename_out);  end;

filename_networks = 'dat/NETWORKS'; 
NETWORKS = fopen(filename_networks, 'r');
if NETWORKS < 0,  error(filename_networks);  end; 

symbol= konect_label_statistic(statistic, 'html-short');
align = 'right'; 

fprintf(OUT, '<TABLE>\n'); 
fprintf(OUT, '<TR><TD><B>Name</B><TD class="padleft"><B>Attributes</B><TD class="padleft" align="%s"><B>%s</B>\n', ...
	align, symbol);

count=0

while ~((network = fgetl(NETWORKS)) == -1)
  filename_in = sprintf('dat/statistic.%s.%s', statistic, network)
  ret_exist = exist(filename_in, 'file')
  if 2 ~= ret_exist,  continue;  end;
  values = read_statistic(statistic, network);  value = values(1); 
  format= read_statistic('format', network); 
  weights= read_statistic('weights', network); 
  meta= read_meta(network); 
  name= meta.name;
  icon_category = www_icon_category(meta.category); 
  text_value = www_format_statistic(statistic, value); 
  text_format= int_format{format};
  text_weights= int_weights{weights}; 
  title_format = labels_format{format};
  title_weights = labels_weights{weights};
  fprintf(OUT, '<TR><TD><A href="../../networks/%s/">%s</A><TD class="padleft">%s <IMG class="icon" src="${root}/ic/icon-format-%s.png" title="%s"> <IMG class="icon" src="${root}/ic/icon-weights-%s.png" title="%s"><TD class="padleft" align="%s">%s\n', ...
	  network, name, icon_category, text_format, title_format, text_weights, title_weights, align, text_value);
  count = count + 1; 
end

fprintf(OUT, '</TABLE>\n'); 

if fclose(OUT) < 0,  error(filename_out);  end;
if fclose(NETWORKS) < 0,  error(filename_networks);  end;

filename_count = sprintf('skeleton/statistics/%s/count', statistic);
COUNT = fopen(filename_count, 'w');
if COUNT < 0,  error(sprintf('fopen(%s)', filename_count));  end;
fprintf(COUNT, '%u\n', count);
if fclose(COUNT) < 0,  error(sprintf('fclose(%s)', filename_count));  end;

