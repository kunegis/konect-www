%
% Create the statistics table for one network.
%
% PARAMETERS
%	$network
%
% INPUT FILES 
%	dat/STATISTICS
%	dat/statistics.*.$network
%
% OUTPUT FILES
%	skeleton/networks/$network/statistics.html
%

network = getenv('network') 

filename_out= sprintf('skeleton/networks/%s/statistics.html', network); 
OUT = fopen(filename_out, 'w');
if OUT < 0,  error(filename_out);  end;

filename_statistics = 'dat/STATISTICS'; 
STATISTICS = fopen(filename_statistics, 'r');
if STATISTICS < 0,  error(filename_statistics);  end;

fprintf(OUT, '<TABLE>\n'); 

while ~((statistic = fgetl(STATISTICS)) == -1)
  filename_in = sprintf('dat/statistic.%s.%s', statistic, network)
  ret_exist = exist(filename_in, 'file')
  if 2 ~= ret_exist,  continue;  end;
  values = read_statistic(statistic, network); 
  value = values(1); 
  statistic_base = regexprep(statistic, '\+.*$', '');
  text_statistic = konect_label_statistic(statistic, 'html-name');
  text_symbol = konect_label_statistic(statistic, 'html-short'); 
  text_value = www_format_statistic(statistic, value); 
  fprintf(OUT, '<TR><TD><A href="../../statistics/%s/">%s</A>\t<TD class="padleft" align="right">%s =<TD>%s\n', ...
	  statistic_base, text_statistic, text_symbol, text_value); 
end

fprintf(OUT, '</TABLE>\n'); 

if fclose(STATISTICS) < 0,  error(filename_statistics);  end; 
if fclose(OUT) < 0,  error(filename_out);  end;
