%
% Create the "metadata" section of one network page.
%
% PARAMETERS
%	$network
%
% OUTPUT FILES
%	skeleton/networks/$network/metadata.html
%
% INPUT FILES 
%

network = getenv('network');

filename = sprintf('skeleton/networks/%s/metadata.html', network); 

OUT = fopen(filename, 'w');
if OUT < 0,  error(sprintf('fopen "%s"', filename));  end;

[consts symbols_format symbols_weights labels_format labels_weights int_format int_weights] = konect_consts();
[tag_list tag_text tag_name] = konect_data_tag();
[cat_colors cat_vertices cat_edges cat_markers cat_letters cat_longname] = konect_data_category(); 

meta = read_meta(network); 
tags = get_tags(meta); 

[check_icon check_text] = www_icon_check(network);

format = read_statistic('format', network);  format = format(1); 
weights = read_statistic('weights', network);  weights = weights(1); 

fprintf(OUT, '%s\n', '<TABLE>'); 

%
% Identity
%

fprintf(OUT, '<TR><TD>Code<TD class="padleft"><TD><CODE>%s</CODE>\n', meta.code); 
fprintf(OUT, '<TR><TD>Internal name<TD><TD><CODE>%s</CODE>\n', network); 
fprintf(OUT, '<TR><TD>Name<TD><TD>%s\n', meta.name); 
if isfield(meta, 'url')
  fprintf(OUT, '<TR><TD>Data source<TD><TD>'); 
  urls = regexp(meta.url, 'http[^, ]+', 'match'); 
  for i = 1 : length(urls)
    url = urls{i};
    fprintf(OUT, '<A href="%s">%s</A>', url, url);
    if i < length(urls)
      fprintf(OUT, ', '); 
    end
  end
  fprintf(OUT, '\n'); 
end
fprintf(OUT, '<TR><TD>Consistency check<TD class="padleft">%s<TD>%s\n', check_icon, check_text); 

%
% Semantics
%

fprintf(OUT, '<TR><TD><A href="${root}/categories/">Category</A><TD class="padleft"><A href="${root}/categories/%s/">%s</A><TD><A href="${root}/categories/%s/">%s</A>\n', meta.category, www_icon_category(meta.category), meta.category, cat_longname.(meta.category)); 
if isfield(meta, 'timeiso')
  text_timeiso = regexprep(meta.timeiso, '/', ' ⋯ '); 
  fprintf(OUT, '<TR><TD>Dataset timestamp <TD><TD>%s\n', text_timeiso); 
end
if isfield(meta, 'entity_names')
  en= meta.entity_names;
  en= www_format_entrel_names(en); 
%%  en= regexprep(en, ',', ', '); 
%%  en= regexprep(en, '^\s*', '');
%%  if length(en) >= 1 && en(1) >= 'a' && en(1) <= 'z'
%%    en(1) = en(1) + ('A' - 'a'); 
%%  end
  fprintf(OUT, '<TR><TD>Node meaning<TD><TD>%s\n', en); 
end
if isfield(meta, 'relationship_names')
  en= meta.relationship_names;
  en= www_format_entrel_names(en); 
%%  en= regexprep(en, ',', ', '); 
%%  en= regexprep(en, '^\s*', '');
%%  if length(en) >= 1 && en(1) >= 'a' && en(1) <= 'z'
%%    en(1) = en(1) + ('A' - 'a'); 
%%  end
  fprintf(OUT, '<TR><TD>Edge meaning<TD><TD>%s\n', en); 
end
fprintf(OUT, '<TR><TD>Network format<TD class="padleft"><IMG class="icon" src="${root}/ic/icon-format-%s.png"><TD>%s\n', ...
	int_format{format}, labels_format{format}); 
fprintf(OUT, '<TR><TD>Edge type<TD class="padleft"><IMG class="icon" src="${root}/ic/icon-weights-%s.png"><TD>%s\n', ...
	int_weights{weights}, labels_weights{weights}); 
if has_timestamps(network)
  fprintf(OUT, '<TR><TD>Temporal data <TD class="padleft"><IMG class="icon" src="${root}/ic/icon-timestamps.png"><TD>Edges are annotated with timestamps\n'); 
end

%
% Tags that are always shown (Structural)
%

if format == consts.ASYM
  fprintf(OUT, '<TR><TD>%s', tag_name.nonreciprocal); 
  if isfield(tags, 'nonreciprocal')
    fprintf(OUT, '<TD class="padleft"><IMG class="icon" src="${root}/ic/icon-tag-nonreciprocal.png"><TD>Does not contain reciprocal edges\n'); 
  else
    fprintf(OUT, '<TD class="padleft"><IMG class="icon" src="${root}/ic/icon-no.png"><TD>Contains reciprocal edges\n'); 
  end
  fprintf(OUT, '<TR><TD>%s', tag_name.acyclic); 
  if isfield(tags, 'acyclic')
    fprintf(OUT, '<TD class="padleft"><IMG class="icon" src="${root}/ic/icon-tag-acyclic.png"><TD>Does not contain directed cycles\n'); 
  else
    fprintf(OUT, '<TD class="padleft"><IMG class="icon" src="${root}/ic/icon-no.png"><TD>Contains directed cycles\n'); 
  end
end
if format ~= consts.BIP
  fprintf(OUT, '<TR><TD>%s', tag_name.loop); 
  if isfield(tags, 'loop')
    fprintf(OUT, '<TD class="padleft"><IMG class="icon" src="${root}/ic/icon-tag-loop.png"><TD>Contains loops\n'); 
  else
    fprintf(OUT, '<TD class="padleft"><IMG class="icon" src="${root}/ic/icon-no.png"><TD>Does not contain loops\n'); 
  end
end

%
% Tags that are only shown when present
%

for i = 1 : length(tag_list)
  tag = tag_list{i};
  if strcmp(tag, 'nonreciprocal'),  continue;  end;
  if strcmp(tag, 'acyclic'      ),  continue;  end;
  if strcmp(tag, 'loop'         ),  continue;  end;
  if isfield(tags, tag)
    text_name = tag_name.(tag);
    text_explanation = tag_text.(tag);
    fprintf(OUT, '<TR><TD>%s <TD class="padleft"><IMG class="icon" src="${root}/ic/icon-tag-%s.png"><TD>%s\n', ...
	    text_name, tag, text_explanation); 
  end
end

fprintf(OUT, '</TABLE>\n'); 

if fclose(OUT) < 0,  error(sprintf('fclose "%s"', filename));  end;
