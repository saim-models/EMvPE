function [RT, node, y_KN, y_CN, y_SN, input_SN, input_CN, input_KN] = run_PE_SAIM(para, templates, input_image, seed)

RT = 0;
node = 0;
rng(seed)

[im_n, im_m] = size(input_image);
[temp_k, temp_n, temp_m] = size(templates);
x_KN = zeros(para.duration,temp_k);
input_KN = zeros(para.duration,temp_k);
%input_KN = zeros(para.duration,temp_n, temp_m);

y_KN = zeros(para.duration,temp_k);

x_CN = zeros(para.duration,temp_n, temp_m);
input_CN = zeros(para.duration,temp_n, temp_m);
y_CN = zeros(para.duration,temp_n, temp_m);

x_SN = zeros(para.duration,im_n, im_m);
input_SN = zeros(para.duration,im_n, im_m);
y_SN = zeros(para.duration,im_n, im_m);

epsilon_KN1 = zeros(temp_k, temp_n, temp_m);
epsilon_KN2 = zeros(temp_k, temp_n, temp_m);

test_threshold  = 1;

input_image_larger = zeros(im_n + temp_n-1,im_m + temp_m-1);
input_image_larger(floor((temp_n-1)/2)+1:end-floor((temp_n-1)/2),floor((temp_m-1)/2)+1:end-floor((temp_m-1)/2)) = input_image;

% initialisation
y_KN(1,:) = para.KN.weight_init;
x_KN(1,:) = inverse_sigmoid(squeeze(y_KN(1,:)), para.KN.m, para.KN.s);

for k=1:temp_k
    temp2(k,:,:) = para.CN.weight_init(k) * templates(k,:,:);
end


%  INIT
y_CN(1,:,:) = sum(temp2,1);



x_CN(1,:,:) = y_CN(1,:,:);

y_SN(1,:,:) = 1/(im_n*im_m) * ones(im_n, im_m);
x_SN(1,:,:) = inverse_sigmoid(squeeze(y_SN(1,:,:)), para.SN.m, para.SN.s);


for t=1:para.duration
    
    y_KN(t,:) = sigmoid(x_KN(t,:), para.KN.m, para.KN.s);
    y_CN(t,:,:) = x_CN(t,:,:);
    y_SN(t,:,:) = sigmoid(x_SN(t,:,:), para.SN.m, para.SN.s);

     
    
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
    
    CN_temp = squeeze(y_CN(t,:,:));
    
    % knowledge network
    for k=1:temp_k
        epsilon_KN1(k,:,:) = CN_temp - y_KN(t,k) * squeeze(templates(k,:,:));
        epsilon_KN2(k,:) = epsilon_KN1(k,:);
        sum2(k,:) = squeeze(epsilon_KN2(k,:)) .* squeeze(templates(k,:));

        epsilon_KN3(k,:,:) = -(CN_temp - y_KN(t,k) * squeeze(templates(k,:,:))) ;
        
    end
    
    in_KN = para.KN.a * (sum(y_KN(t,:))  - 1) - para.KN.b *(sum(sum2,2))';
    input_KN(t,:) = para.KN.b *(sum(sum2,2));


    % content network
    % sigma pi
    temp1_SN = squeeze(y_SN(t,:,:));
    temp5 = conv2(input_image_larger, temp1_SN(end:-1:1, end:-1:1), 'valid');
    
    in_CN =   -para.CN.b * (temp5 - CN_temp) + para.KN.b * squeeze(sum(epsilon_KN3,1));
    input_CN(t,:,:) = -(-para.CN.b * (temp5 - CN_temp) + para.KN.b * squeeze(sum(epsilon_KN3,1)));
    
    
    % selection network
    temp6 = temp5 - CN_temp;
    temp7 = conv2(input_image_larger, temp6(end:-1:1, end:-1:1), 'valid');
    input_SN2(t,:,:) = temp7;
    
    in_SN = para.SN.a * (sum(y_SN(t,:))  - 1)  + para.CN.b * squeeze(input_SN2(t,:,:)) + para.SN.b;
    input_SN(t,:,:) = - para.CN.b *squeeze(input_SN2(t,:,:));

    
    % Euler
    % note that brownian_hopfield_euler feed the input negatively
    % That's why input_SN and input_KN are not reverse the sign to reflect the real sign
    % of the input.
    x_KN(t+1,:) = brownian_hopfield_euler(squeeze(x_KN(t,:)), squeeze(in_KN), para.KN.tau, para.KN.sigma);
    x_CN(t+1,:,:) = brownian_hopfield_euler(squeeze(x_CN(t,:,:)), squeeze(in_CN), para.CN.tau, para.CN.sigma);
    x_SN(t+1,:,:) = brownian_hopfield_euler(squeeze(x_SN(t,:,:)), squeeze(in_SN), para.SN.tau, para.SN.sigma);
    
end