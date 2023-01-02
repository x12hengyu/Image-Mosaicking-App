function [mask, result_img] = backwardWarpImg(src_img, resultToSrc_H,...
                                              dest_canvas_width_height)
	src_height = size(src_img, 1);
	src_width = size(src_img, 2);
    src_channels = size(src_img, 3);
    dest_width = dest_canvas_width_height(1);
	dest_height	= dest_canvas_width_height(2);
    
    result_img = zeros(dest_height, dest_width, src_channels);
    mask = zeros(dest_height, dest_width);
    
    % this is the overall region covered by result_img
    [dest_X, dest_Y] = meshgrid(1:dest_width, 1:dest_height);
    
    % map result_img region to src_img coordinate system using the given
    % homography.
    src_pts = applyHomography(resultToSrc_H, [dest_X(:), dest_Y(:)]);
    
    % ---------------------------
    % START ADDING YOUR CODE HERE
    % ---------------------------

    % interpolate values between points
    src_interp1 = interp2(src_img(:,:,1), src_pts(:,1), src_pts(:,2));
    src_interp2 = interp2(src_img(:,:,2), src_pts(:,1), src_pts(:,2));
    src_interp3 = interp2(src_img(:,:,3), src_pts(:,1), src_pts(:,2));
    
    % fill the right region in 'result_img' with the src_img
    result_img(:,:,1) = reshape(src_interp1, dest_height, dest_width);
    result_img(:,:,2) = reshape(src_interp2, dest_height, dest_width);
    result_img(:,:,3) = reshape(src_interp3, dest_height, dest_width);
    
    % Set 'mask' to the correct values based on src_pts.
    result_img(isnan(result_img)) = 0; % interp2 return NaN for src_pts outside src_img
    result_img_gray = rgb2gray(result_img);
    mask = result_img_gray ~= mask;
    
    % ---------------------------
    % END YOUR CODE HERE    
    % ---------------------------
end