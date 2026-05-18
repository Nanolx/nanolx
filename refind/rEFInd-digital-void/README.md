# 🌌 rEFInd Theme: Digital Void

[rEFInd](https://www.rodsbooks.com/refind/) boot manager theme that is dark, immersive, and cyberpunk-inspired. Features high-quality, AI-generated digital void environments with data streams and neon light trails. Paired with sharp, minimalist icons for a clean and modern multi-boot experience..

## 📸 Preview

<img width="3866" height="2160" alt="screenshot 1" src="https://github.com/user-attachments/assets/eda578e1-291a-41cf-9419-8082e9b814c5" />
<img width="3866" height="2160" alt="screenshot 2" src="https://github.com/user-attachments/assets/7f168ad7-1728-4451-a12f-ae81d8aedc31" />
<img width="3866" height="2160" alt="screenshot 3" src="https://github.com/user-attachments/assets/ac1c3ab6-9cf7-4829-a5e1-ac2870577041" />


## ✨ Features

* **7 High-Resolution Background Variants:** Choose your vibe (Blue, Red, Green/Default, Yellow, Matrix, etc.).
* **Clean & Minimalist Icons:** High contrast, transparent backgrounds, easy to read.
* **Plug & Play:** Pre-configured `theme.conf` included.
* **Multi-Boot Ready:** Looks great with Windows, Linux, macOS, and custom distros.

---

## ⚙️ Installation

**1. Locate your rEFInd directory**
Usually, this is located on your EFI partition. On most Linux systems, it is mounted at:
`/boot/efi/EFI/refind/`

**2. Create a themes folder (if it doesn't exist)**
Inside your `refind` directory, create a folder named `themes`.

**3. Copy the theme**
Copy the entire `rEFInd-digital-void` folder from this repository into your new `themes` directory.
Path should look like this: `/boot/efi/EFI/refind/themes/rEFInd-digital-void/`

**4. Enable the theme**
Open your main rEFInd configuration file (`/boot/efi/EFI/refind/refind.conf`) with a text editor (root privileges required) and add this line at the very bottom:

```text
include themes/rEFInd-digital-void/theme.conf
```

---

## ⚠️ IMPORTANT: Fix Pixelation / Scaling Issues

To ensure the backgrounds look crisp and are not stretched or pixelated, you **must** set your exact screen resolution in the main rEFInd config file.

Open your main `refind.conf` (NOT the `theme.conf`) and look for the `resolution` setting. Uncomment it (remove the `#`) and set it to your monitor's exact resolution.

*Example for a 1080p (FHD) display:*
```text
resolution 1920 1080
```

*Example for a 1440p (2K/QHD) display:*
```text
resolution 2560 1440
```

*Example for a 4K (UHD) display:*
```text
resolution 3840 2160
```

Save the file and reboot. Your theme will now load in perfect quality!

---

## 🎨 Changing the Background Picture

By default, the theme uses `background.png`. 
If you want to use one of the other 6 color variants included in the folder, simply open the `theme.conf` inside the `rEFInd-digital-void` folder and change the `banner` line to the file you want.

*Example (changing to the red variant):*
```text
banner themes/rEFInd-digital-void/background.red.png
```

## 📜 Credits & License

* **Backgrounds:** Generated and curated by myself.
* **Icons:** The base icons and selection frames are taken from the excellent [rEFInd-minimal-rog](https://github.com/Paradox-AT/rEFInd-minimal-rog) theme created by Paradox-AT.
* **License:** This project is open-source and available under the MIT License. See the `LICENSE` file for details.
