# Perubahan Teknis

Ringkasan patch dibanding Linuwu-Sense/DAMX awal:

- Tambah field quirk `an515_58_rgb_fix`.
- Aktifkan quirk tersebut untuk `Nitro AN515-58`.
- Tambah struct `an515_58_static_rgb_param` untuk payload static RGB.
- `per_zone_mode` pada AN515-58:
  - poll gaming sys info
  - enable semua zone dengan `ACER_WMID_SET_GAMING_LED_METHODID`
  - kirim warna static tiap zone via method `6`
  - aktifkan static mode via method `20`
- `four_zone_mode` pada AN515-58:
  - payload 16-byte mengikuti layout `facer_rgb.py`
  - breathing mode mempertahankan speed
  - wave mode memakai byte direction khusus pada index 3
- Power profile:
  - ganti deteksi AC utama ke `power_supply_is_system_supplied()`
  - WMI `BAT_STATUS` hanya fallback
  - memperbaiki `quiet` dan `balanced-performance` yang sebelumnya ditolak sebagai `Operation not supported`

Hasil testing:

```text
RGB static: OK
RGB breathing: OK
quiet profile: OK, bertahan >4 detik
balanced-performance profile: OK, bertahan >4 detik
balanced profile: OK
```

