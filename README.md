# CASPEN (Cash Spending Note) 
Aplikasi Mobile Pencatatan Pengeluaran Harian Menggunakan Flutter dan Dart

1.	Overview
Aplikasi ini merupakan sebuah mobile app berbasis Flutter yang dirancang untuk membantu pengguna dalam mencatat dan memantau transaksi keuangan harian secara lebih mudah. Aplikasi ini dibuat untuk memenuhi tugas bootcamp yang diselenggarakan oleh Nusacodes. Dan sebagai pilot project untuk pembelajaran penulis secara pribadi.

3.	Latar belakang
Perkembangan teknologi mobile yang pesat telah membuka peluang besar dalam pengembangan aplikasi yang dapat diakses kapan saja dan di mana saja. Salah satu teknologi yang kini banyak digunakan adalah Flutter, framework open-source dari Google yang memungkinkan pengembangan aplikasi lintas platform dengan satu basis kode menggunakan bahasa Dart.
Sebagai bagian dari proses pembelajaran dalam mengikuti program pelatihan pemrograman mobile yang diselenggarakan oleh Nusacodes, saya mengembangkan sebuah aplikasi pencatatan transaksi keuangan pribadi. Aplikasi ini bertujuan sebagai sarana praktik langsung dalam memahami konsep dasar pengembangan aplikasi mobile menggunakan Flutter dan Dart, termasuk penerapan state management, desain UI, navigasi, serta pengelolaan data.
Dengan mengangkat kasus penggunaan nyata, yaitu pencatatan transaksi keuangan harian, proyek ini diharapkan dapat memberikan pemahaman yang lebih mendalam dan aplikatif terhadap materi yang dipelajari selama pelatihan. Selain itu, aplikasi ini juga memberikan gambaran bagaimana membangun sebuah produk digital sederhana namun bermanfaat.

4.	Tujuan
a)	Media Pembelajaran Flutter dan Dart
Aplikasi ini dikembangkan sebagai bagian dari proses belajar mengenai pengembangan aplikasi mobile menggunakan Flutter dan Dart, yang merupakan salah satu pendekatan modern dalam membangun aplikasi Android maupun lintas platform secara efisien.
b)	Sebagai Pilot Project
Proyek ini juga berfungsi sebagai pilot project atau proyek percontohan untuk mengaplikasikan secara langsung konsep-konsep yang telah dipelajari, mulai dari perancangan antarmuka, manajemen state, hingga interaksi pengguna.
c)	Memenuhi Tugas dari Nusacodes
Pengembangan aplikasi ini ditujukan untuk memenuhi tugas akhir dalam program pelatihan yang diselenggarakan oleh Nusacodes, sebagai bentuk implementasi dan evaluasi atas materi yang telah diajarkan selama proses pelatihan berlangsung.
 
5.	Permasalahan
Dalam proses pengembangan aplikasi ini, penulis menghadapi beberapa tantangan, terutama karena masih berada pada tahap awal dalam mempelajari pengembangan aplikasi mobile. Beberapa permasalahan yang dihadapi antara lain:
1.	Istilah dan Konsep Baru
Sebagai pemula, banyak istilah teknis baru dalam Flutter dan Dart yang perlu dipahami terlebih dahulu, seperti state management, widgets lifecycle, dan konsep navigasi.
2.	Pemahaman Mendalam Dibutuhkan
Pengembangan aplikasi tidak hanya memerlukan kemampuan menulis kode, tetapi juga pemahaman mendalam terhadap struktur dan arsitektur aplikasi Flutter yang efisien dan scalable.
3.	Koneksi dan Keamanan
Salah satu tantangan utama adalah dalam hal pengamanan koneksi dan integrasi dengan database atau API eksternal. Penulis perlu memahami bagaimana melakukan koneksi ke API secara aman, mengelola data dengan benar, serta menerapkan prinsip-prinsip dasar keamanan dalam komunikasi data.
 
5.	Teknologi dan Arsitektur
Dalam pengembangan aplikasi ini, digunakan berbagai teknologi dan library dari ekosistem Flutter dan Dart yang mendukung proses pembuatan aplikasi mobile secara efisien, modern, dan modular. Berikut adalah penjelasan masing-masing teknologi yang digunakan:
Bahasa dan Framework
•	Flutter: Framework UI open-source dari Google untuk membangun aplikasi secara cross-platform dengan tampilan native.
•	Dart: Bahasa pemrograman yang digunakan oleh Flutter untuk membangun logika dan antarmuka aplikasi.
Library Pihak Ketiga
•	cupertino_icons: Digunakan untuk menampilkan ikon dengan gaya iOS agar tampilan aplikasi lebih konsisten di berbagai platform.
•	google_fonts: Memberikan akses ke berbagai jenis font dari Google Fonts, sehingga tampilan teks dapat disesuaikan dan lebih menarik.
•	calendar_appbar: Library untuk menambahkan tampilan AppBar dengan fitur kalender interaktif, memudahkan pemilihan tanggal dalam aplikasi.
•	intl: Digunakan untuk format tanggal dan angka yang sesuai dengan lokal pengguna (internationalization).
•	provider: Library untuk mengelola state management secara efisien dan terstruktur.
Database dan Penyimpanan Lokal
•	drift (sebelumnya dikenal sebagai moor): Library ORM (Object Relational Mapping) yang mempermudah pengelolaan database SQLite dengan pendekatan reactive programming.
•	sqflite: Plugin Flutter untuk mengakses SQLite secara langsung, digunakan sebagai backend dari Drift.
•	path_provider: Digunakan untuk mengakses direktori perangkat seperti documents dan cache, tempat penyimpanan file database.
•	path: Digunakan untuk mengelola dan memanipulasi path (lokasi file) dengan aman dan efisien.
 
Arsitektur Aplikasi
Aplikasi ini dibangun dengan pola separation of concerns, memisahkan antara:
•	UI Layer: Menangani tampilan dan interaksi pengguna menggunakan widget.
•	State Management: Dikelola menggunakan Provider untuk menjaga konsistensi data antar komponen.
•	Data Layer: Menggunakan Drift sebagai abstraction layer untuk database SQLite.
Pendekatan ini bertujuan untuk menghasilkan kode yang lebih modular, mudah diuji, dan lebih terorganisir.
 
6.	Tantangan Dalam Pengembangan Sistem
Dalam proses pengembangan aplikasi ini, beberapa tantangan teknis dan non-teknis dihadapi, terutama karena pengembang merupakan pemula dalam bidang pemrograman mobile menggunakan Flutter dan Dart. Adapun tantangan yang dihadapi antara lain:
1. Pemahaman Teknologi Baru
Sebagai pemula, memahami konsep dasar Flutter dan Dart merupakan tantangan awal. Banyak istilah baru, seperti widget tree, state management, hot reload, hingga struktur folder Flutter yang membutuhkan waktu untuk dipahami secara menyeluruh.
2. Manajemen State dan Navigasi
Mengatur state antar halaman (misalnya berpindah antar halaman Home dan Category) menjadi tantangan penting, terutama agar data tetap konsisten dan tidak saling tumpang tindih. Selain itu, implementasi navigasi yang efisien juga perlu dipelajari dengan seksama.
3. Penggunaan Library Pihak Ketiga
Penggunaan beberapa library seperti calendar_appbar, drift, dan provider memerlukan pemahaman terhadap dokumentasi dan cara integrasi masing-masing. Kesalahan kecil dalam konfigurasi dapat menyebabkan error yang cukup membingungkan.
4. Database dan Penyimpanan Lokal
Membuat dan mengelola database lokal menggunakan drift dan sqflite memerlukan pemahaman mengenai konsep relasi tabel, query SQL, serta bagaimana cara sinkronisasi data dengan UI secara real-time.
5. Koneksi dan Keamanan
Meskipun aplikasi ini saat ini masih berfokus pada penyimpanan lokal, proses belajar mengenai keamanan koneksi dan integrasi ke API eksternal menjadi salah satu tantangan ke depan, khususnya terkait dengan pengamanan data dan penggunaan protokol yang aman.
6. Error Handling dan Debugging
Kemampuan melakukan debugging secara efisien sangat penting dalam pengembangan Flutter. Kesalahan kecil seperti overflow layout, kesalahan deklarasi widget, atau kesalahan logika sering kali memerlukan waktu lama untuk dianalisis dan diperbaiki. 
7.	Kesimpulan
Aplikasi mobile yang dikembangkan ini merupakan bagian dari proses pembelajaran teknologi Flutter dan Dart, yang diselenggarakan oleh Nusacodes. Melalui pengembangan aplikasi ini, penulis memperoleh pengalaman langsung dalam membangun aplikasi Android, mulai dari pengelolaan tampilan antarmuka, manajemen data lokal dengan database SQLite melalui drift, hingga pemanfaatan berbagai library pihak ketiga.
Meskipun menghadapi berbagai tantangan seperti pemahaman istilah teknis baru, integrasi dengan database, serta pengelolaan state dan navigasi, proses ini memberikan banyak pelajaran berharga yang memperkaya pengetahuan dan keterampilan penulis dalam pengembangan aplikasi mobile modern.
Sebagai pilot project, aplikasi ini berhasil menjadi fondasi awal untuk eksplorasi lebih lanjut terhadap pemrograman mobile, dan diharapkan dapat dikembangkan lebih lanjut baik dari sisi fitur, keamanan, maupun integrasi dengan API eksternal ke depannya.

8.	Daftar Pustaka
1.	Google. (n.d.). Flutter - Build apps for any screen. Retrieved from https://flutter.dev
2.	Dart Dev. (n.d.). Dart Programming Language. Retrieved from https://dart.dev
3.	pub.dev. (n.d.). Flutter Packages and Plugins. Retrieved from https://pub.dev
4.	Nusacodes. (2025). Kelas Belajar Flutter dan Dart - Nusacodes Academy. Materi pelatihan internal. Retrieved from https://nusacodes.com
5.	Dewakoding. (n.d.). Tutorial Pemrograman dan Flutter. Retrieved from https://dewakoding.com
6.	Reso Coder. (n.d.). Flutter & Dart tutorials for developers. Retrieved from https://resocoder.com
7.	drift.dev. (n.d.). Drift - reactive persistence library for Dart & Flutter. Retrieved from https://drift.simonbinder.eu
8.	Stack Overflow. (n.d.). Discussions and Solutions related to Flutter and Dart Development. Retrieved from https://stackoverflow.com

 
