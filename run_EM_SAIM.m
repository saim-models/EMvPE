function [RT, node, y_KN, y_CN, y_SN, input_SN, input_CN, input_KN] = run_EM_SAIM(para, templates, input_image, seed)

rng(seed)
dbstop if error

[im_n, im_m] = size(input_image);
[temp_k, temp_n, temp_m] = size(templates);
x_KN = zeros(para.duration,temp_k);
x_CN = zeros(para.duration,temp_n, temp_m);
x_SN = zeros(para.duration,im_n, im_m);

y_KN = zeros(para.duration,temp_k);
y_CN = zeros(para.duration,temp_n, temp_m);
y_SN = zeros(para.duration,im_n, im_m);

input_KN = zeros(para.duration,temp_k);
input_CN = zeros(para.duration,temp_n, temp_m);
input_SN = zeros(para.duration,im_n, im_m);

test_threshold  = 1;

match = zeros(1,temp_k);

input_image_larger = zeros(im_n + temp_n-1,im_m + temp_m-1);
input_image_larger(floor((temp_n-1)/2)+1:end-floor((temp_n-1)/2),floor((temp_m-1)/2)+1:end-floor((temp_m-1)/2)) = input_image;

% initialisation
y_KN(1,:) = para.KN.weight_init;
x_KN(1,:) = inverse_sigmoid(squeeze(y_KN(1,:)), para.KN.m, para.KN.s);

for k=1:temp_k
    temp2(k,:,:) = para.CN.weight_init(k) * templates(k,:,:);
end
y_CN(1,:,:) = sum(temp2,1);
x_CN(1,:,:) = y_CN(1,:,:);

y_SN(1,:,:) = 1/(temp_n*temp_m) * ones(im_n, im_m);
x_SN(1,:,:) = inverse_sigmoid(y_SN(1,:,:), para.SN.m, para.SN.s);

RT = 0;
node = 0;
temp2 = zeros(temp_k, temp_n, temp_m);
topdown_KN = zeros(para.duration, temp_n, temp_m);

for t=1:para.duration

    y_KN(t,:) = sigmoid(x_KN(t,:), para.KN.m, para.KN.s);
    y_CN(t,:,:) = x_CN(t,:,:);
    y_SN(t,:,:) = sigmoid(x_SN(t,:,:), para.SN.m, para.SN.s);
    

    % Stopping and threshold criteria
    if test_threshold == 1 && squeeze(y_KN(t,1)) > para.threshold
        RT = t;
        node = 1;
        if para.stop_at_threshold == 1
            break;
        else
            test_threshold = 0;
        end
    end
    
    if test_threshold == 1 && squeeze(y_KN(t,2)) > para.threshold
        RT = t;
        node = 2;
        if para.stop_at_threshold == 1
            break;
        else
            test_threshold = 0;
        end
    end

    % knowdge network
    for i=1:temp_k
        match(i) = squeeze(templates(i,:)) * squeeze(y_CN(t,:))';
    end
    in_KN = para.KN.a * (sum(y_KN(t,:)) - 1) - para.KN.b * match;
    input_KN(t,:) = para.KN.b * match;

    
    temp1 = squeeze(y_SN(t,:,:));

    for k=1:temp_k
        temp2(k,:,:) = squeeze(y_KN(t,k))' * templates(k,:,:);
    end
    topdown_KN(t,:,:) = squeeze(sum(temp2,1));
    
    % Contents Network
    in_CN = -para.KN.b * squeeze(topdown_KN(t,:,:)) - para.CN.b * conv2(input_image_larger, temp1(end:-1:1, end:-1:1), 'valid');
    input_CN(t,:,:) = +para.KN.b * squeeze(topdown_KN(t,:,:)) + para.CN.b * conv2(input_image_larger, temp1(end:-1:1, end:-1:1), 'valid');
    
    
    % selection network
    temp1 = squeeze(y_CN(t,:,:));
    in_SN = para.SN.a * (sum(y_SN(t,:))  - 1)  - para.CN.b * conv2(input_image_larger, temp1(end:-1:1, end:-1:1), 'valid') + para.SN.b;
    input_SN(t,:,:) =  para.CN.b * conv2(input_image_larger, temp1(end:-1:1, end:-1:1), 'valid');
    
    % Euler
    % note that brownian_hopfield_euler feed the input negatively
    % That's why input_SN and input_KN reverse the sign to reflect the real sign
    % of the input.
    x_KN(t+1,:) = brownian_hopfield_euler(squeeze(x_KN(t,:)), in_KN, para.KN.tau, para.KN.sigma);
    x_CN(t+1,:,:) = brownian_hopfield_euler(squeeze(x_CN(t,:,:)), squeeze(in_CN), para.CN.tau, para.CN.sigma);
    x_SN(t+1,:,:) = brownian_hopfield_euler(squeeze(x_SN(t,:,:)), in_SN, para.SN.tau, para.SN.sigma);  
end