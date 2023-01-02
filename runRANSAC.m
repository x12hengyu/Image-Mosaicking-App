function [inliers_id, H] = runRANSAC(Xs, Xd, ransac_n, eps)
%RUNRANSAC
    num_pts = size(Xs, 1);
    pts_id = 1:num_pts;
    inliers_id = [];
    H = [];
    inliers_max = 0;
    
    for iter = 1:ransac_n
        % ---------------------------
        % START ADDING YOUR CODE HERE
        % ---------------------------

        % randomly choose 4 samples
        random_idxes = randi([1 num_pts],1,4);
        
        % calculate homography with selected samples
        H_3x3 = computeHomography(Xs(random_idxes,:), Xd(random_idxes,:));
        
        % find numbers of inliers
        inliers_cnt = 0;
        cur_inliers_id = [];
        % iterate points
        for i = pts_id
            % compute dst point
            homo_Xd = applyHomography(H_3x3, Xs(i,:));
            
            % find distance between actural and computed dst
            error = norm(homo_Xd - Xd(i, :));
            % match bound
            if error <= eps
                inliers_cnt = inliers_cnt + 1;
                cur_inliers_id = [cur_inliers_id; i];
            end
        end
           
        % save the most matches inliers
        if inliers_cnt >= inliers_max
            inliers_id = cur_inliers_id;
            H = H_3x3;
            inliers_max = inliers_cnt;
        end
        
        % ---------------------------
        % END ADDING YOUR CODE HERE
        % ---------------------------
    end    
end
