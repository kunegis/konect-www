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

filename_out = sprintf('skeleton/statistics/%s/table.html', statistic); 
OUT = fopen(filename_out, 'w');
if OUT < 0,  error(filename_out);  end;

filename_networks = 'dat/NETWORKS'; 
NETWORKS = fopen(filename_networks, 'r');
if NETWORKS < 0,  error(filename_networks);  end; 

fprintf(OUT, '<TABLE>\n'); 

count=0

while ~((network = fgetl(NETWORKS)) == -1)
  filename_in = sprintf('dat/statistic.%s.%s', statistic, network)
  ret_exist = exist(filename_in, 'file')
  if 2 ~= ret_exist,  continue;  end;
  values = read_statistic(statistic, network); 
  value = values(1); 
  meta= read_meta(network); 
  name= meta.name;
  text_value = www_format_statistic(statistic, value); 
  fprintf(OUT, '<TR><TD><A href="../../networks/%s/">%s</A><TD class="padleft">%s\n', ...
	  network, name, text_value);
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

