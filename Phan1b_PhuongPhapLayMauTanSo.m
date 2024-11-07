fprintf('Thiết kế bộ lọc thông thấp sử dụng phương pháp lấy mẫu tần số \n');
fprintf('Nhập các tham số của bộ lọc \n');
M = input('Số lượng mẫu: '); % Số lượng mẫu
Wp = input('Tần số cắt của dải thông: '); % Tần số cắt của dải thông
fprintf('Tần số của sóng sine cần lọc \n');
f1 = input('Tần số thứ nhất: ');
f2 = input('Tần số thứ hai: ');
f3 = input('Tần số thứ ba: ');
fs = 2000; % Tần số lấy mẫu

% Thiết kế bộ lọc thông thấp
m = 0:M/2; % Điểm mẫu
Wm = 2 * pi * m / (M + 1); % Tần số cắt
Ad = double(Wm <= Wp); % Chỉ định độ lớn cho thông thấp
Hd = Ad .* exp(-1j * 0.5 * M * Wm); % Vector mẫu tần số H(k)
Hd = [Hd conj(fliplr(Hd(2:end)))]; % Kết hợp với phần phức liên hợp để tạo ra đối xứng Hermitian
h = real(ifft(Hd)); % Lấy mẫu ngược để có h(n)

% Đồ thị đáp ứng biên độ của bộ lọc
w = linspace(0, pi, 1000); % Lấy 1000 điểm giữa 0 và pi
H = freqz(h, 1, w); % Biên độ và tần số của bộ lọc
figure;
plot(w/pi, 20*log10(abs(H))); % Biểu diễn biên độ theo dB
xlabel('Tần số chuẩn hóa'); ylabel('Độ lợi (dB)'); title('Đáp ứng biên độ của bộ lọc thông thấp');
axis([0 1 -50 0]);

% Tạo tín hiệu đầu vào là tổng ba sóng sine
t = 0:1/fs:0.25; % Thời gian
s = sin(2 * pi * f1 * t) + sin(2 * pi * f2 * t) + sin(2 * pi * f3 * t); % Tín hiệu ban đầu

% Đồ thị tín hiệu trước khi lọc (miền thời gian và tần số)
figure;
subplot(2, 1, 1);
plot(t, s);
xlabel('Thời gian (giây)'); ylabel('Biên độ'); title('Tín hiệu trước khi lọc (Miền thời gian)');

% Biến đổi Fourier để xem tín hiệu trong miền tần số
Sf = fft(s, 512); % FFT tín hiệu
Af = abs(Sf(1:256)); % Lấy biên độ
f = (0:255) * fs / 512; % Trục tần số

subplot(2, 1, 2);
plot(f, Af);
xlabel('Tần số (Hz)'); ylabel('Biên độ'); title('Tín hiệu trước khi lọc (Miền tần số)');

% Lọc tín hiệu
sf = filter(h, 1, s); % Lọc tín hiệu với bộ lọc thiết kế

% Đồ thị tín hiệu sau khi lọc (miền thời gian và tần số)
figure;
subplot(2, 1, 1);
plot(t, sf);
xlabel('Thời gian (giây)'); ylabel('Biên độ'); title('Tín hiệu sau khi lọc (Miền thời gian)');
axis([0.2 0.25 -2 2]); % Giới hạn hiển thị

% FFT tín hiệu sau khi lọc
Ssf = fft(sf, 512);
Af_sf = abs(Ssf(1:256));

subplot(2, 1, 2);
plot(f, Af_sf);
xlabel('Tần số (Hz)'); ylabel('Biên độ'); title('Tín hiệu sau khi lọc (Miền tần số)');