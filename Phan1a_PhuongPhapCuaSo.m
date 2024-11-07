disp('Nhập thông số kĩ thuật của bộ lọclọc');
d = input('Nhập độ gợn d = d1 = d2 = ');
d2 = d;
d1 = d;
wp = input('Nhập tần số dải thông wp = ');
ws = input('Nhập tần sổ dải cắt ws = ');
Fs = 1000;
Ts = 1 / Fs;
dwm = ws - wp; % độ rộng của vùng chuyển tiếp wp và ws;
Peak = 20 * log10(d); % Tính độ lớn của đỉnh

% Chọn cửa sổ thích hợp dựa vào độ gợn
if (Peak > -30)
    disp('Chọn cửa sổ tam giác');
    opt = 1;
    m = ceil(4 * pi / dwm);
end
if ((Peak > -49) && (Peak < -30))
    disp('Chọn cửa sổ Hanning');
    opt = 2;
    m = ceil(8 * pi / dwm);
end
if ((Peak > -63) && (Peak < -49))
    disp('Chọn cửa sổ Hamming');
    opt = 3;
    m = ceil(8 * pi / dwm);
end
if (Peak < -63)
    disp('Chọn cửa sổ Blackman');
    opt = 4;
    m = ceil(12 * pi / dwm);
end

% chọn bộ lọc loại 1 nên m lẻ
if (rem(m, 2) == 0)
    m = m + 1;
end
fprintf('\nBậc m của bộ lọc là %0.0f\n', m);

% tìm được hàm cửa sổ w(n) tương ứng
w = zeros(m, 1);
switch opt
    case 1 % Cửa sổ tam giác
        for i = 0:1:m-1
            w(i + 1) = 1 - 2 * abs((i - (m - 1) / 2) / (m - 1));
        end
    case 2 % Cửa sổ Hanning
        for i = 0:1:m-1
            w(i + 1) = 0.5 * (1 - cos(2 * pi * i / (m - 1)));
        end
    case 3 % Cửa sổ Hamming
        for i = 0:1:m-1
            w(i + 1) = 0.54 - 0.46 * cos(2 * pi * i / (m - 1));
        end
    case 4 % Cửa sổ Blackman
        for i = 0:1:m-1
            w(i + 1) = 0.42 - 0.5 * cos(2 * pi * i / (m - 1)) + 0.08 * cos(4 * pi * i / (m - 1));
        end
end

% Tính đáp ứng xung của bộ lọc lý tưởng
wc = (wp + ws) / 2;
a = (m - 1) / 2; % tính pha tuyến tính
h = zeros(m, 1);
for i = 0:1:(m - 1)
    if i == a
        h(i + 1) = wc / pi;
    else
        h(i + 1) = sin(wc * (i - a)) / (pi * (i - a));
    end
end

% Tính hd(n)
hd = h .* w; 

% Biểu đồ h(n), w(n), hd(n)
n = 0:1:m - 1;
figure(1); 
stem(n, h);
title('Biểu đồ đáp ứng xung của bộ lọc lý tưởng');
xlabel('n'); ylabel('h(n)');
xlim auto;

figure(2); 
stem(n, w);
title('Biểu đồ hàm cửa sổ');
xlabel('n'); ylabel('w(n)');
xlim auto;

figure(3); 
stem(n, hd);
title('Biểu đồ đáp ứng xung của bộ lọc FIR');
xlabel('n'); ylabel('hd(n)');
xlim auto;

% sử dụng tín hiệu dạng chirp để so sánh tín hiệu đầu vào và đầu ra
T = 2;
t = 0:Ts:T;

% Tạo tín hiệu chirp từ tần số 10 Hz đến 1000 Hz
f0 = 10;
f1 = Fs;
x = chirp(t, f0, T, f1); % tín hiệu đầu vào dạng chirp
y = filter(hd, 1, x); % tín hiệu đầu ra sau khi lọc

%so sánh tín hiệu đầu vào và đầu ra
figure(4);
subplot(2, 1, 1);
plot(t, x);
title('Tín hiệu đầu vào dạng chirp');
xlabel('Thời gian (s)');
ylabel('Biên độ');
grid on;

subplot(2, 1, 2);
plot(t, y);
title('Tín hiệu đầu ra sau khi lọc');
xlabel('Thời gian (s)');
ylabel('Biên độ');
grid on;