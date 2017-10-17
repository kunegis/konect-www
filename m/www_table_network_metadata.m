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
  fprintf(OUT, '<TR><TD>Source<TD><TD><A href="%s">%s</A>\n', meta.url, meta.url); 
end
fprintf(OUT, '<TR><TD>Consistency check<TD class="padleft">%s<TD>%s\n', check_icon, check_text); 

%
% Semantics
%

fprintf(OUT, '<TR><TD>Category<TD class="padleft">%s<TD>%s\n', www_icon_category(meta.category), meta.category); 
if isfield(meta, 'timeiso')
  text_timeiso = regexprep(meta.timeiso, '/', ' ⋯ '); 
  fprintf(OUT, '<TR><TD>Dataset timestamp <TD><TD>%s\n', text_timeiso); 
end
if isfield(meta, 'entity_names')
  fprintf(OUT, '<TR><TD>Node meaning<TD><TD>%s\n', meta.entity_names); 
end
if isfield(meta, 'relationship_names')
  fprintf(OUT, '<TR><TD>Edge meaning<TD><TD>%s\n', meta.relationship_names); 
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

## if tag=tournament sh/has-tag ; then
## 	printf '%s\n' '<TR><TD>Tournament <TD class="padleft"><IMG class="icon" src="${root}/ic/icon-tag-tournament.png"><TD>The graph is a tournament:  all pairs of nodes are connected by a directed edge'
## fi
## if tag=trianglefree sh/has-tag ; then
## 	printf '%s\n' '<TR><TD>Triangles <TD class="padleft"><IMG class="icon" src="${root}/ic/icon-tag-trianglefree.png"><TD>Does not contain triangles'
## fi
## if tag=zeroweight sh/has-tag ; then
## 	printf '%s\n' '<TR><TD>Zero weights <TD class="padleft"><IMG class="icon" src="${root}/ic/icon-tag-zeroweight.png"><TD>Edges may have weight zero'
## fi

## #
## # Extraction 
## #

## if tag=incomplete sh/has-tag ; then
## 	printf '%s\n' '<TR><TD>Completeness <TD class="padleft"><IMG class="icon" src="${root}/ic/icon-tag-incomplete.png"><TD>This network is incomplete'
## fi
## if tag=join sh/has-tag ; then
## 	printf '%s\n' '<TR><TD>Join <TD class="padleft"><IMG class="icon" src="${root}/ic/icon-tag-join.png"><TD>This network is the join of an underlying network'
## fi
## if tag=path sh/has-tag ; then
## 	printf '%s\n' '<TR><TD>Path <TD class="padleft"><IMG class="icon" src="${root}/ic/icon-tag-path.png"><TD>The edges in this network form paths'
## fi
## if tag=missingorientation sh/has-tag ; then
## 	printf '%s\n' '<TR><TD>Orientation <TD class="padleft"><IMG class="icon" src="${root}/ic/icon-tag-missingorientation.png"><TD>The network is not directed, but the underlying data is'
## fi
## if tag=missingmultiplicity sh/has-tag ; then
## 	printf '%s\n' '<TR><TD>Multiplicity <TD class="padleft"><IMG class="icon" src="${root}/ic/icon-tag-missingmultiplicity.png"><TD>The network does not have multiple edges, but the underlying data has'
## fi
## if tag=kcore sh/has-tag ; then
## 	printf '%s\n' '<TR><TD><I>k</I>-core <TD class="padleft"><IMG class="icon" src="${root}/ic/icon-tag-kcore.png"><TD>Only nodes with degree &gt;&nbsp;<I>k</I> are included'
## fi
## if tag=lcc sh/has-tag ; then
## 	printf '%s\n' '<TR><TD>Largest connected component <TD class="padleft"><IMG class="icon" src="${root}/ic/icon-tag-lcc.png"><TD>Only the largest connected component of the original data is included'
## fi

fprintf(OUT, '</TABLE>\n'); 

if fclose(OUT) < 0,  error(sprintf('fclose "%s"', filename));  end;
