function [res, nvoxels, reldiff] = crc_compare_images(ref_img, test_img)
  %% Compare two nifti images and print out discrepancies
  %% Compares dimentions, orientations, scaling and images
  %% themselves, voxel-by-voxel
  %%
  %% Parameters:
  %% -----------
  %%  ref_img: char, or spm_vol
  %%    reference image
  %%  test_img: char, or spm_vol
  %%    test image

  res = true;
  nvoxels = 0;
  reldiff = 0;

  ref_vol = spm_vol(ref_img);
  test_vol = spm_vol(test_img);
  fprintf('Comparing\n\t%s\n\t%s\n', ref_vol(1).fname, test_vol(1).fname);

  % check Number of volumes
  if numel(ref_vol) ~= numel(test_vol)
    warning('Mismatching number of volumes');
    warning('%d vs %d', numel(ref_vol), numel(test_vol));
  end

  ref_vol = ref_vol(1);
  test_vol = test_vol(1);

  % Checking fields
  metadata = {'dim', 'dt', 'pinfo', 'mat', 'n'};
  for i = 1:size(metadata, 1)
    fname = metadata{i};
    if any(ref_vol.(fname) ~= test_vol.(fname))
      warning('Mismatching image field %s', fname);
      disp(ref_vol.(fname));
      disp(test_vol.(fname));
      res = false;
    end
  end

  % Checking image itself
  ref_vv = spm_read_vols(ref_vol);
  test_vv = spm_read_vols(test_vol);

  if any(size(ref_vv) ~= size(test_vv))
    warning('Image dimention mismatches. Unable to compare.');
    disp(size(ref_vv));
    disp(size(test_vv));
    res = false;
    return;
  end


  if ~isequaln(ref_vv, test_vv)
    diff = abs(ref_vv - test_vv);
    nz = nnz(diff);
    [m, i] = max(diff(:));
    res = false;
    nvoxels = nz;
    reldiff = sum(diff(:)) / nz;
    warning(['%d voxels are not same\n',...
             'Average deviation is %g\n',...
             'Maximum deviation is %g at %d, compared to %g'],...
            nz, reldiff, m, i, ref_vv(i));
  end
end
