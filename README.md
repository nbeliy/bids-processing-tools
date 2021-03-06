A small collection of scripts that streamline work with bids-matlab datasets,
and designed to work with parsed json configuration files

### `data = crc_bids_query_data(BIDS, images, sub, id)`

Retrieves paths to files from `BIDS` dataset and satisfying
query stored in `images.query` structure (see bids-matlab doc)
for subjects cited in `sub`. 

If structure `images` have `number` field, it checks if 
number of retrieved paths is the same as `images.number`.
If it's not the case, an error will be raised.

Function returns the cellarray of found paths, and print out
number of retrieved paths prepended by `id`.


### `data = crc_bids_retrieve_data(BIDS, selection, subjects)`

Same as `crc_bids_query_data` but retrieves paths from substructures
of `selection`, if these substructures have `query` field.

Retrieved paths are stored into `data` structure, with each field
corresponds to a field name in `selection`.


###  `DERIV = crc_bids_gen_dervative(BIDS, outDir, name, selection, subjects)`

Generate a derivative dataset based on `BIDS` in `outDir/name`, and based
on queries stored in `selection` (see `crc_bids_retrieve_data`).

If Input dataset and output dataset have same path, do nothing and return a copy
of input dataset


### `merge_suffix(folder_path, varargin)`

Scan `folder_path` for bids-formatted files, and check for
multiple suffixes. 
If such files are found, suffixes are merged.

Optional parameter `overwrite` set to true (default is false),
will overwrite files if they already present.


