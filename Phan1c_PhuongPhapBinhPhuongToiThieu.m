fprintf('Thiết kế bộ lọc thông thấp dùng phương pháp bình phương tối thiểu \n');
fprintf('Nhập thông số bộ lọc \n');
fs = input('Tần số lấy mẫu: ');
t_start = input('Thời gian bắt đầu: ');
t_end = input('Thời gian kết thúc: ');
t = t_start:1/fs:t_end;
f = input('Tần số của tín hiệu sin: ');
x = sin(2*pi*f*t) + 0.5*randn(size(t)); % Tín hiệu sin với nhiễu
num_taps = input('Độ dài của bộ lọc FIR/số lượng mẫu của hồi đáp FIR: ');
cutoff = input('Tần số cắt: ');

% Tạo vector của tần số đáp ứng mong muốn cho bộ lọc thông thấp
freq = [0, cutoff/(fs/2), (cutoff + 50)/(fs/2), 1];  % Chuẩn hóa tần số theo Nyquist
amp = [1, 1, 0, 0];                                 % Đáp ứng mong muốn: 1 ở băng thông, 0 ở băng cấm

% Thiết kế bộ lọc FIR thông thấp bằng phương pháp Least Square
b = firls(num_taps, freq, amp);

% Áp dụng bộ lọc FIR cho tín hiệu đầu vào
y = filter(b, 1, x);

% Vẽ biểu đồ so sánh tín hiệu đầu vào và tín hiệu sau khi lọc
figure;
subplot(2, 1, 1);
plot(t, x);
title('Tín hiệu đầu vào');
xlabel('Thời gian');
ylabel('Amplitude');

subplot(2, 1, 2);
plot(t, y);
title('Tín hiệu đầu ra sau khi lọc thông thấp');
xlabel('Thời gian');
ylabel('Amplitude');