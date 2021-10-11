function der_json = crc_bids_create_json(base_json, img_file, varargin)
%% Creates dervative json file based on base_json
%% with fields names and values contained in varagin
%%
%% Parameters
%% ----------
%% base_json: struct
%%    a parsed json from original file
%% deriv_file: chararray
%%    path to derivative file; derivative json structure 
%%    will be saved conserving same base name but extension changed to .json
%%    if empty ('' or []), json will not be saved on disc
%% varargin: optional parameters
%%    par_key: Name of field to add to basic structure; if name ends uo with
%%              '-add', new value will be appended to a previous entry;
%%              Will raise an error if previous values are not lists or chararray
%%    par_value: Value of the field to add
%%
%%  Returns:
%%  --------
%%  der_json: struct
%%      derivated json structure

  % generating output json name
  if isempty(img_file)
    out_file = '';
  else
    [path, basename, ~] = fileparts(img_file);
    pos = regexp(basename, '\.');

    if ~isempty(pos)
      basename = basename(1:pos(1) - 1);
    end
    out_file = fullfile(path, [basename '.json']);
  end

  der_json = base_json;

  for ii = 1:2:size(varargin, 2)
    par_key = varargin{ii};

    try
      par_value = varargin{ii+1};

      if bids.internal.ends_with(par_key, '-add')
        par_key = par_key(1: end - 4);
        if isfield(der_json, par_key)
          if ischar(der_json.(par_key))
            par_value = [der_json.(par_key) par_value]; %#ok<AGROW>
          else
            par_value = [der_json.(par_key); par_value]; %#ok<AGROW>
          end
        end
      end

      der_json.(par_key) = par_value;

    catch ME
      err_msg = sprintf('Failed to generate json for ''%s'' (%d)', ...
                        par_key, ii);
      if ~isempty(out_file)
        err_msg = [out_file ': ' err_msg]; %#ok<AGROW>
      end
      warning(err_msg);
      rethrow(ME);
    end
  end

  if ~isempty(out_file)
    spm_jsonwrite(out_file, der_json, 'indent', '  ');
  end

end
