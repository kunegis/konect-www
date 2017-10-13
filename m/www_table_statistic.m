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
%

statistic = getenv('statistic');

filename_out = sprintf('skeleton/statistics/%s/table.html', statistic); 
OUT = fopen(filename_out, 'w');
if OUT < 0,  error(filename_out);  end;

filename_networks = 'dat/NETWORKS'; 
NETWORKS = fopen(filename_networks, 'r');
if NETWORKS < 0,  error(filename_networks);  end; 

fprintf(OUT, '<TABLE>\n'); 

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
end

fprintf(OUT, '</TABLE>\n'); 

if fclose(OUT) < 0,  error(filename_out);  end;
if fclose(NETWORKS) < 0,  error(filename_networks);  end;
