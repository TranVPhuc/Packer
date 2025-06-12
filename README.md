# Tạo Jenkins + Jenkins Agent AMI với Packer 

## 📦 Mục tiêu
- Tự động build AMI bằng Packer
- Launch EC2 instance từ AMI đã có sẵn Jenkins
- Khởi chạy, truy cập jenkins UI và thiết lập 1 agent.
- Build một Jenkins agent ami tự động kết nối đến master.

## 📁 Cấu trúc thư mục
### Jenkins master
├── packer-template.pkr.hcl # Template Packer định nghĩa AMI.

### Jenkins agent
├── secrets.auto.pkrvars.hcl # Chứa các thông tin như jenkins url, agent token, agent name.  
├── packer-template.pkr.hcl # Template Packer định nghĩa AMI.

## 🚀 Build AMI
- Sử dụng 2 command sau để tiến hành build AMI:
+ `packer init .`  
+ `packer build ami-template.pkr.hcl`

## Result
![Result](./Screenshoot1.png)