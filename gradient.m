function grad = gradient(img)
    grad_x = double(singleGradient(img, 0));
    grad_y = double(singleGradient(img, 1));
    grad = arrayfun(@sqrt, grad_x.*grad_x+grad_y.*grad_y);
    grad = uint8(grad);
end

function grad = singleGradient( img, axis )
% Compute gradient along the given axis 
    [m, n, c] = size(img);
    
    if c > 1
        grad = rgb2gray(img);
    else
        grad = img;
    end
    
    if axis == 0 % x-axis
        shifted_gray = circshift(grad, [0 -1]);
        shifted_gray(:, n, :) = zeros(m, 1);
        grad = shifted_gray - grad;
        grad(:, n, :) = -grad(:, n, :);
    elseif axis == 1
        shifted_gray = circshift(grad, [-1 0]);
        shifted_gray(m, :, :) = zeros(1, n);
        grad = shifted_gray - grad;
        grad(m, :, :) = -grad(m, :, :);
    else
        disc('invalid axis type');
        grad = zeros(m, n);
    end
end

