clear;
clc;
Ts = 1;
t = 1:1:1000;
t_50 = zeros(50,length(t));

for i = 1:1:50				%����50���������
    t_50(i,1:length(t))= t(1:end);
end
sita = random('unif',0,1,50,2)*2*pi;  %��������0-2pi�������λ
e = randn(50,length(t));  %��������Ϊ1W�ĵ�����
e_fft = fft(e)*10^(-1);  %ת��Ƶ����й��ʵ���
e = ifft(e_fft);  %��Ƶ��ת��ʱ��
w = [0.34*pi 0.36*pi]; %��������Ƶ��
A = [10 5];   %���������źŵķ���
x = A(1)*sin(w(1)*t_50+sita(1)) + A(2)*sin(w(2)*t_50+sita(2))+e;
figure;       %��һ�����ɵ��������
plot(t,x(1,:));
title("������̵�һ������ʵ��");
xlabel("t(s)");
ylabel("����");

Sx = (abs(fft(x',2000)).^2)/length(t); %�õ�Sx
fs = 2000;     %fft�Ĳ�������
f = ((0:999)/2000);  %����Ƶ������
sx = Sx';    %Sx��һ��Ϊһ��������fft�����ת��һ�·��㴦��
figure;     %��Sx�����г�=64������ͼ��������������=1W
hold on;    %����ͬһ��ͼ��
xlabel("f(Hz)");
ylabel("dB");
title("Sx(w),���г�=64������ͼ��������������=0.0001W");
for i = 1:1:50
    plot(f,10*log10(sx(i,1:fs/2)));
end

figure;hold on;
title("Sx(w),���г�=64��MUSIC��������������=0.0001W");
xlabel("f(Hz)");
ylabel("dB");
for i = 1:1:50
test = x(i,:)';
[s_width,s_length] = size(test);
Rx = test*test';
[V,D] = eig(Rx);
D = diag(D);
[D,pin]=sort(D,'descend');
Vn = V(:,pin(6:s_width,1));
w = 0.1:0.0001:0.2;
len = [0:length(t)-1]';
A_theta = exp(-1j*len*2*pi*w);
p_all = diag(A_theta'*A_theta)./diag(A_theta'*Vn*Vn'*A_theta);
p(i,:)=p_all;
plot(w,abs(p_all));
end

figure;     %����Ĳ����ǽ�����ͼ������MUSIC����
subplot(2,1,1),hold on;  %����ͬһ��ͼ��(subplot)
xlabel("f(Hz)");
ylabel("dB");
title("Sx(w),���г�=1000������ͼ���������ȱ�Ϊ2����������Ϊ0.01W");
% title("Sx(w),���г�=64������ͼ��������������Ϊ0.0001W");
for i = 1:1:50
    plot(f,10*log10(sx(i,1:fs/2)));
end

%��MUSIC�������ڵڶ���ͼ��
subplot(2,1,2),hold on;
xlabel("f(Hz)");
ylabel("dB");
title("Sx(w),���г�=1000��MUSIC���������ȱ�Ϊ2����������Ϊ0.01W");
% title("Sx(w),���г�=64��MUSIC��������������Ϊ0.0001W");
for i = 1:1:50
    plot(w,abs(p(i,:)));
end








