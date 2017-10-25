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

while ~((statistic_full = fgetl(STATISTICS)) == -1)
  statistic_full 
  if 0 == sum(statistic_full == '+')
    statistic_base= statistic_full;
    index_statistic= 1; 
  else
    i = find(statistic_full == '+')
    statistic_base = statistic_full(1:i-1)
    text_index= statistic_full(i+1:end)
    index_statistic = str2num(text_index)
  end
  filename_in = sprintf('dat/statistic.%s.%s', statistic_base, network)
  ret_exist = exist(filename_in, 'file')
  if 2 ~= ret_exist,  continue;  end;
  values = read_statistic(statistic_base, network)
  if length(values) < index_statistic,  continue,  end; 
  value = values(index_statistic)
  text_statistic = konect_label_statistic(statistic_full, 'html-name');
  text_symbol = konect_label_statistic(statistic_full, 'html-short'); 
  text_value = www_format_statistic(statistic_full, value); 
  fprintf(OUT, '<TR><TD><A href="../../statistics/%s/">%s</A>\t<TD class="padleft" align="right">%s =<TD>%s\n', ...
	  statistic_base, text_statistic, text_symbol, text_value); 
end

fprintf(OUT, '</TABLE>\n'); 

if fclose(STATISTICS) < 0,  error(filename_statistics);  end; 
if fclose(OUT) < 0,  error(filename_out);  end;
