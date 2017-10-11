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
fprintf(OUT, '<TR><TD><TD><B>Name</B><TD><B>Category</B><TD><TD><TD align="right"><B>n</B><TD align="right"><B>m</B>\n');

while ~((network = fgetl(NETWORKS)) == -1)
  meta = read_meta(network); 
  code= meta.code;
  name= meta.name;
  category= meta.category;
  format= read_statistic('format', network); 
  weights= read_statistic('weights', network); 
  size= read_statistic('size', network);  size = size(1);
  volume= read_statistic('volume', network);  volume = volume(1); 
  text_size= www_format_statistic('size', size);
  text_volume= www_format_statistic('volume', volume); 
  fprintf(OUT, '<TR><TD><CODE>%s</CODE><TD><A href="%s/">%s</A><TD>%s<TD>%u<TD>%u<TD align="right">%s<TD align="right">%s\n', ...
	  code, network, name, category, format, weights, text_size, text_volume); 
end

fprintf(OUT, '</TABLE>\n'); 

if fclose(OUT) < 0,  error('fclose');  end;
if fclose(NETWORKS) < 0,  error('fclose');  end;
