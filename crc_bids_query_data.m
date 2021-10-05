function data = crc_bids_query_data(BIDS, images, sub, id)
%% Utility function that retrives data from BIDS dataset
%% and compares it with expected number
%%
%%  images must be a struct with query sub-structure, following
%%    starndard definition of bids-matlab
%%    if 'number' field is present in images, then output of query
%%    is compared with it and an error will be raised in case of mismatch
%%  sub must contain a cellarray of requested sub id 
%%    or be empty for all subjects
%%  id is identification name to print if data retrieval fails

  try
    if ~isempty(sub)
      images.query.sub = sub;
    end

    data = bids.query(BIDS, 'data', images.query);

    if isfield(images, 'number')
      if images.number > 0
        assert(size(data, 1) == images.number, ...
               'expected %d files, recievd %d', ...
               images.number, size(data, 1));
      end
    else
      assert(size(data, 1) > 0, '0 images selected');
    end

    fprintf('%s: Selected %d images\n', id, size(data, 1));
  catch ME
    err.identifier = ME.identifier;
    err.message = sprintf('%s: Data retrieval failed: %s', id, ME.message);
    err.stack = ME.stack;
    rethrow(err);
  end

end
