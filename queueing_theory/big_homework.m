clear;
clc;

%�������趨
lambda_1 = 1;
lambda_2 = 1;
miu_1 = 0.2;
miu_2 = 0.2;
M_1 = 3;
M_2 = 3;
L_1 =20;
L_2 = 20;

prob = [];
test_num = 1000;
map = zeros(10,10);

%ime1 = get_time1(miu_1,5000,M_1);

for lambda_1 = 0.1:0.1:1
for lambda_2 = 0.1:0.1:1
    times = test_num;
    for k = 1:1:test_num
        first_1 = count(miu_1,miu_2,lambda_2,L_1,L_2,M_1,M_2);
        result_1 = first_1;
        %disp('��ȥ1��'),disp(result_1);
        first_2 = count(miu_2,miu_1,lambda_1,L_2,L_1,M_2,M_1);
        result_2 = first_2;
        %disp('��ȥ2��'),disp(result_2);
        if result_1 < result_2
            times(k) = 1;
        else
            times(k) = 0;
        end
    end
    times = sum(times > 0, 2)*1.0/test_num;
    disp(times)
    prob = [prob,times];
    %disp(miu_1/0.1);
    %disp(miu_2/0.1);
    map(int32(lambda_1/0.1),int32(lambda_2/0.1)) = times;
    %map(L_1/5+1,L_2/5+1) = times;
end
end
%L_1 = 1:1:100;
%M_1 = 1:1:10;
%M_2 = 2:1:10;
%L_2 = 0:1:50;
%lambda_1 = 0.01:0.05:2.01;
%figure;
%plot(L_2,prob);
%axis([min(L_2),max(L_2),0,1]);
map = map > 0.5;
figure;
pcolor(map);
ylabel('L_1');
xlabel('L_2');


function time = count(miu_1,miu_2,lambda,L_1,L_2,M_1,M_2)
    time1 = get_time1(miu_1,L_1,M_1);%�õ��ڵص�1�Ŷӵ�ʱ��T
    num2 = get_num2(lambda,miu_2,L_2,M_2,time1);%ģ����Tʱ���ڵص�2����仯
    if num2 >= 0    %����ص�2�Ķ��г��ȴ���0
        time2 = get_time1(miu_2,num2,M_2);
    else            %����ص�2û�����Ŷ�
        time2 = exprnd(1/miu_2);
    end
    time = time1 + time2;%����ʱΪ�����ص���ʱ֮��
end

function num = get_num2(lambda,miu,L,M,time)
    t = 0;          %ʱ��
    len = L;        %���г���
    flag = 0;       %��¼�������˿ͻ��Ƿ��������һ���˿�
    while(t < time) 
        if len >= 0 %�����г��ȴ���0��˵�����й�̨���ڷ���
            cus_t = exprnd(1/lambda);
            serve_t = exprnd(1/miu/M);
        elseif len >= -M && len < 0 %�����г���Ϊ���������й�̨���У�����Ч�ʻ�仯
            cus_t = exprnd(1/lambda);
            serve_t = exprnd(1/miu/(M+len));%���²�����ķֲ�
        end
        seed = cus_t < serve_t; 
        if seed == 1        %�����˿�����ʱ��С�ڷ�������ʱ��ʱ�����г���+1
            flag = 1;
            len = len + 1;
            t = t + cus_t;
        else                %%�����˿�����ʱ����ڷ�������ʱ��ʱ�����г���+1
            flag = 2;
            len = len - 1;
            t = t + serve_t;
        end
    end
    %��Ϊ��whileѭ������˻��+1��-1�������Ҫ����
    if flag == 1
        len = len - 1;
    else
        len = len + 1;
    end
    num = len;
end

function time = get_time1(miu,L,M)
    num = M + L + 1;%��ǰ�ص�1��������
    t = 0;          %ʱ��
    for i = 1:1:num %��ÿһλ�˿ͽ��в���
        t = t + exprnd(1/miu/M);
    end
    time = t;
end


function time = get_time(miu,L,M)
    serve = zeros(M,200);
    for i = 1:1:M %��ʼ��
        serve(i,1) = exprnd(1/miu);
    end
    serve_L_t = exprnd(miu,1,L+1);%���ɶ�����ÿһ��������Ҫ�ķ���ʱ��
    flag = -1; %���ڼ�¼��L+1���������к�
    for i = 1:1:length(serve_L_t)
        serve_sum = sum(serve,2); %�������
        [m,min_index] = min(serve_sum); %����е���Сֵ�����
        add_index = sum(serve(min_index,:)>0);  %ȷ���¼���Ԫ�ص������
        serve(min_index,add_index+1) = serve_L_t(i);%�����е�һ���˷���������
        if i == length(serve_L_t)
            flag = min_index;
        end
    end
    sum_t = sum(serve,2);%�������
    time = sum_t(flag); %��õ�L+1��������ʱ��
end








