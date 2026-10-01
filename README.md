# Website quảng bá iLSQ

Trang tĩnh HTML/CSS/JavaScript, dành cho GitHub Pages của repo phát hành `autotdk/ilsq`. Không cần npm hay build. Bộ màu và biểu tượng dùng chung với ứng dụng. Ảnh giao diện chứa bảng ngọc mẫu, được ghi rõ là minh họa.

## Chạy thử trên máy

Tại thư mục website, chạy `python -m http.server 8080`, rồi mở `http://localhost:8080`. Không mở bằng file:// vì trình duyệt có thể chặn fetch XML.

Website đọc file `update.xml` ở cùng thư mục với `index.html`. File chuẩn có gốc `<item>`; lấy `<version>` và `<url>`. Nếu chưa có manifest, mạng lỗi hoặc XML sai, nút tải dùng link trực tiếp `https://github.com/autotdk/ilsq/releases/latest/download/iLSQ.exe` và không hiển thị phiên bản giả. Phiên bản được chèn bằng `textContent`.

## Đưa lên GitHub Pages

1. Chép **nội dung** thư mục website vào gốc nhánh main của repo `autotdk/ilsq`: index.html, styles.css, app.js, 404.html, .nojekyll và assets/.
2. Giữ `update.xml` ở gốc repo đó. Dùng manifest do `scripts/prepare_release.py` tạo sau khi build và upload iLSQ.exe vào GitHub Release. Không đưa manifest thử nghiệm lên production và không ghi đè bằng file mẫu cũ.
3. Trong repo: Settings → Pages → Deploy from a branch → main → / (root) → Save.
4. Trang dự kiến: https://autotdk.github.io/ilsq/. Kiểm tra nút tải, phiên bản và giao diện trên điện thoại sau khi Pages triển khai xong.

Website **không kèm update.xml** để tránh ghi đè manifest thật khi cập nhật thiết kế. Có thể chép manifest local vào thư mục website chỉ để preview; xóa bản tạm trước khi deploy. `scripts/prepare_website.py` sẽ tạo gói sạch trong artifacts/website/ và không chứa manifest.

## Sửa nội dung

- index.html: giới thiệu, tính năng, hướng dẫn và FAQ. Mục ghi chú cập nhật đã được bỏ theo yêu cầu.
- styles.css: layout responsive và bộ màu.
- app.js: đọc manifest, phiên bản và link tải dự phòng.
- assets/icon.png, icon.ico: biểu tượng iLSQ.
- assets/interface.png: ảnh giao diện; cập nhật khi UI thay đổi.

Các nút tải trỏ trực tiếp đến file iLSQ.exe: dùng URL trong manifest hoặc asset iLSQ.exe của Release mới nhất. Release phải có asset đúng tên iLSQ.exe; repo chưa có file phát hành thì link tải chưa dùng được. Trang không có thu thập tài khoản, form đăng nhập, tracker hoặc thư viện ngoài. Chỉ thêm tính năng vào phần quảng bá khi ứng dụng đã có tính năng đó.
