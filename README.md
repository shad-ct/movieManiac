# 🎬 MovieManiac

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-blue.svg?style=for-the-badge)

**MovieManiac** is your ultimate companion for discovering movies and TV series. With a sleek, Tinder-style swipe interface, finding your next binge-watch has never been easier. Powered by the OMDb API, it helps you curate your personal library of favorites, watch lists, and seen content.

---

## ✨ Features

- **🔥 Swipe to Discover:**
  - **Swipe Right** to ❤️ Like.
  - **Swipe Left** to ❌ Dislike.
  - **Swipe Down** to ⏱️ Add to Watch Later.
  - **Swipe Up** to ✅ Mark as Watched.
  
- **📺 Movies & Series Support:** Toggle instantly between browsing Movies and TV Series.
  
- **📚 Smart Library:** Organize your content into:
  - **Liked Collection**
  - **Watch Later Queue**
  - **Watched History**

- **💬 Random Quotes:** Get daily inspiration (or a laugh) with random quotes from:
  - Anime
  - Lucifer
  - Parks and Recreation
  - Stranger Things

- **🌗 Dark Mode:** A premium, dark-themed UI designed for movie lovers.
- **💾 Offline Persistence:** Your lists are saved locally so you never lose track.

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- An OMDb API Key (The app includes a default one, but you may want to use your own).

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/shad-ct/movieManiac.git
   cd movieManiac
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

---

## 🛠️ Tech Stack

- **Framework:** Flutter
- **State Management:** Provider
- **Networking:** HTTP
- **UI Components:** `flutter_card_swiper`, `cached_network_image`, `google_fonts`
- **Local Storage:** `shared_preferences`

---

## 📷 Screenshots

| Swipe Interface Home | Quotes | Liked |
|-------------|---------------|-----------------|
| ![Home](https://github.com/user-attachments/assets/b8610090-1263-42d2-b37a-9e9d76349aaf) | ![quotes](https://github.com/user-attachments/assets/080a7242-569d-49d2-b44b-f457eec2b23a) | ![liked](https://github.com/user-attachments/assets/25db7238-40aa-4af2-9557-7eaacdb23455) |

| Watched | Watch Later|
|--------------|-----------|
| ![watched](https://github.com/user-attachments/assets/82c296c3-d6e4-4eb6-a5da-5da5b202e32f) | ![watch later](https://github.com/user-attachments/assets/53111747-bdd6-45bb-a0b2-4266241adf3d) |



---

## 🤝 Contributing

Contributions are welcome! If you have suggestions or find a bug, please open an issue or submit a pull request.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.
