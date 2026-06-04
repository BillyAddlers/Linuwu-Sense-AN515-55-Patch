# Linuwu-Sense Fix untuk Acer Nitro AN515-58

Paket ini berisi Linuwu-Sense/DAMX kernel module yang sudah dipatch untuk Acer Nitro AN515-58 dengan keyboard RGB 4-zone.

Patch ini dibuat dari hasil testing langsung pada:

- Model: `Nitro AN515-58`
- Kernel saat testing: `6.18.34-1-lts`
- Module: `linuwu_sense`
- RGB keyboard: 4-zone, kompatibel dengan jalur Jafar/facer

## Fitur yang Sudah Terbukti Jalan

- Fan control Linuwu/DAMX tetap jalan.
- Battery limiter/control Linuwu/DAMX tetap jalan.
- RGB static per-zone jalan.
- RGB breathing mode jalan.
- Dynamic RGB payload disesuaikan dengan implementasi Jafar.
- Power profile `quiet`, `balanced`, dan `balanced-performance` tidak balik sendiri ke `balanced`.

## Perubahan Penting

Patch ini menambahkan/fix:

- Quirk khusus `AN515-58`.
- Static RGB 4-zone memakai WMI method `6` dengan payload `{zone, red, green, blue}`.
- Enable semua zone memakai `SET_GAMING_LED`, bukan `GET_GAMING_LED`.
- Static mode activation memakai payload 16-byte ke method `20` seperti `facer_rgb.py`.
- Dynamic mode payload dibuat sama dengan Jafar untuk AN515-58.
- Breathing mode tidak memaksa `speed=0` pada AN515-58.
- Deteksi AC power memakai Linux power supply API lebih dulu, bukan WMI `BAT_STATUS` yang salah baca di AN515-58.

## Install

Jalankan dari folder ini:

```bash
make
sudo make install
```

Atau pakai script install + reload:

```bash
sudo ./scripts/install-and-reload.sh
```

Kalau module lama masih aktif dan hasil patch belum kebaca, reload manual:

```bash
sudo systemctl stop linuwu_sense.service 2>/dev/null || true
sudo rmmod linuwu_sense 2>/dev/null || true
sudo modprobe linuwu_sense
sudo systemctl start linuwu_sense.service 2>/dev/null || true
```

Cek versi runtime sama dengan file module:

```bash
cat /sys/module/linuwu_sense/srcversion
modinfo /lib/modules/$(uname -r)/kernel/drivers/platform/x86/linuwu_sense.ko | grep '^srcversion'
```

## Tes RGB

Set warna static 4-zone:

```bash
sudo ./scripts/test-rgb-static.sh
```

Hasil yang diharapkan:

- Zone 1 merah
- Zone 2 hijau
- Zone 3 biru
- Zone 4 putih

Tes breathing magenta:

```bash
sudo ./scripts/test-rgb-breathing.sh
```

Manual command:

```bash
BASE=/sys/module/linuwu_sense/drivers/platform:acer-wmi/acer-wmi
echo ff0000,00ff00,0000ff,ffffff,100 | sudo tee "$BASE/four_zoned_kb/per_zone_mode"
echo 1,4,100,0,255,0,255 | sudo tee "$BASE/four_zoned_kb/four_zone_mode"
```

## Tes Power Profile

Mode yang tersedia pada AN515-58 ini:

```text
quiet
balanced
balanced-performance
```

Cek:

```bash
cat /sys/firmware/acpi/platform_profile_choices
cat /sys/firmware/acpi/platform_profile
```

Set profile:

```bash
sudo ./scripts/set-power-profile.sh quiet
sudo ./scripts/set-power-profile.sh balanced
sudo ./scripts/set-power-profile.sh balanced-performance
```

Catatan: jika UI DAMX punya label `Performance`, map ke `balanced-performance`, bukan `performance`.

## Troubleshooting

Jika RGB tidak muncul:

```bash
ls /sys/module/linuwu_sense/drivers/platform:acer-wmi/acer-wmi/four_zoned_kb
dmesg | grep -iE 'linuwu|acer|wmi|rgb|keyboard|error|fail'
```

Jika power profile balik ke `balanced`, cek AC:

```bash
cat /sys/class/power_supply/ACAD/online
```

Harus `1` saat charger terpasang.

Jika module tidak bisa load karena konflik:

```bash
lsmod | grep -E 'linuwu|facer|acer_wmi'
```

Jangan load `facer` dan `linuwu_sense` bersamaan.

## Rollback

Uninstall module patch:

```bash
sudo make uninstall
```

Atau load kembali module kernel bawaan:

```bash
sudo rmmod linuwu_sense 2>/dev/null || true
sudo modprobe acer_wmi
```

## Catatan

Patch ini fokus pada Acer Nitro AN515-58. Model lain bisa saja memakai WMI payload berbeda, jadi jangan anggap aman untuk semua Acer Nitro/Predator tanpa testing.

Reference yang dipakai untuk jalur RGB:

- JafarAkhondali `acer-predator-turbo-and-rgb-keyboard-linux-module`
- `docs/facer_rgb_reference.py`
