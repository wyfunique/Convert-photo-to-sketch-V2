function S = drawLines( gradient ) 
%   Implementation of algorithm part 1 in paper Lu, Cewu, Li Xu and Jiaya Jia. ¡°Combining sketch and tone for pencil drawing production.¡± Expressive (2012). 
%   gradient: G in the paper
%   Most of the variable names are identical to the symbols used in the paper
    gradient = double(gradient);
    size_ratio = 1/30;
    num_kernels = 8;
    [m, n, c] = size(gradient);
    if c > 1
        disp('Input gradient must be gray scale image');
        return
    end
    kernel_width = floor(min(m, n) * size_ratio);
    directions = [[1, 1]; [1, -1]; [1, 0]; [0, 1]; [1, 0.5]; [1, -0.5]; [0.5, 1]; [0.5, -1]];
    Gi_set = zeros(m, n, num_kernels);
    Li_set = zeros(kernel_width, kernel_width, num_kernels);
    for i = 1 : num_kernels
        deltaX = directions(i, 1);
        deltaY = directions(i, 2);
        Li = getConvKernel(deltaX, deltaY, kernel_width);
        % Compute convolution
        Gi = filter2(Li, gradient, 'same');
        Gi_set(:, :, i) = Gi;
        Li_set(:, :, i) = Li;
    end
    Ci_set = zeros(m, n, num_kernels);
    
    for row = 1 : m
        for col = 1 : n
            [max_val, idx] = max(Gi_set(row, col, :));
            Ci_set(row, col, idx) = gradient(row, col);
            for i = 1 : num_kernels
                if i ~= idx
                    Ci_set(row, col, i) = 0;
                end
            end
        end
    end
        
    S_prime = zeros(m, n);
    for i = 1 : num_kernels
        S_prime = S_prime + filter2(Li_set(:, :, i), Ci_set(:, :, i));
    end
    
    S = double(uint8(ones(m, n) * 255) - uint8(S_prime));
    S = S ./ 255.0;    
end

function kernel = getConvKernel(deltaX, deltaY, width)
% Compute the convolution kernel for the direction indicated by (deltaX, deltaY)
    kernel = zeros(width, width);
    center = [floor(width / 2) + 1, floor(width / 2) + 1];    
    i = center(1);
    j = center(2);
    while 1 <= i && i <= width && 1 <= j && j <= width
        kernel(floor(i), floor(j)) = 1;
        i = i + deltaX;
        j = j + deltaY;
    end
    i = center(1);
    j = center(2);
    while 1 <= i && i <= width && 1 <= j && j <= width
        kernel(floor(i), floor(j)) = 1;
        i = i - deltaX;
        j = j - deltaY;
    end
    kernel = kernel ./ (sum(sum(kernel)));
end
