%
% Create the table of all networks
%
% OUTPUT FILES
%	skeleton/networks/table.html
%
% INPUT FILES
%	dat/NETWORKS	List of all networks
%

OUT = fopen('skeleton/networks/table.html', 'w');
if OUT < 0,  error('fopen');  end;
NETWORKS = fopen('dat/NETWORKS', 'r');
if NETWORKS < 0,  error('fopen');  end;

fprintf(OUT, '<TABLE>\n'); 
fprintf(OUT, '<TR><TD><TD><B>Name</B><TD><B>Attributes</B><TD align="right" title="Size – number of nodes"><B>n</B><TD align="right" title="Volume – number of edges"><B>m</B>\n');

while ~((network = fgetl(NETWORKS)) == -1)
  network
  meta = read_meta(network); 
  code= meta.code;
  name= meta.name;
  check_result = www_icon_check(network);
  text_icon_all = www_icon_all(network, meta); 

  try
    size= read_statistic('size', network);  size = size(1);
    text_size= www_format_statistic('size', size);
  catch err
    text_size= ''; 
  end

  try
    volume= read_statistic('volume', network);  volume = volume(1); 
    text_volume= www_format_statistic('volume', volume);
  catch
    text_volume= ''; 
  end

  fprintf(OUT, '<TR><TD><CODE>%s</CODE><TD><A href="%s/">%s</A><TD>%s %s<TD align="right">%s<TD align="right">%s\n', ...
	  code, network, name, check_result, ...
	  text_icon_all, ...
	  text_size, text_volume); 
end

fprintf(OUT, '</TABLE>\n'); 

if fclose(OUT) < 0,  error('fclose');  end;
if fclose(NETWORKS) < 0,  error('fclose');  end;
