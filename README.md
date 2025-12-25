# motorcycle-sparepart-object-detection-createml-ios
Live motorcycle sparepart detection using Create ML, Core ML, and UIKit.

## 🧠 Overview

This project is an iOS app that performs **real-time object detection for motorcycle spareparts** using a model trained with **Create ML**.

The dataset was **manually collected, annotated, and labeled** to ensure high-quality training data.

The app runs entirely **on-device (without internet)**, making it suitable for mobile and real-world use cases.

## 📸 Dataset Creation

All images in this project were **collected and prepared manually**.

- I personally captured motorcycle sparepart images using a mobile camera
- Each image was **annotated and labeled manually**
- Bounding boxes were drawn **one by one** for each sparepart class
- Total dataset size: **1,766 images**
- Dataset split:
  - Train: 70%
  - Validation: 15%
  - Test: 15%

This process helped ensure dataset quality and improved model generalization.

## 📊 Model Performance

| Metric | Value | Note |
|:------|:-----:|-----:|
| mAP | 0.82 | Good |
| Precision | 0.85 | High |
| Recall | 0.80 | Medium |

Use cases:
- Motorcycle spare part object detection
- iOS camera vision
- Training image dataset using CreateML Framework

⚠️ Requirements :
- iOS 13+
- iPhone (Camera access allowed)

Features :
- Real-time camera object detection
- Bounding box + label + confidence score
- On-device inference (Core ML)
- UIKit-based Programmatic UI
- Smooth frame processing
- Train / Validation / Test split support

Tech Stack :
- ML Training (CreateML Object Detection)
- Inference (CoreML)
- Dataset Tool (Roboflow)
- UI (UIKit)
- Programming Language (Swift)
- Camera (Vision)

Model Details :
- Model type: Create ML Object Detection
- Input: Camera frames
- Output:
  - Bounding boxes
  - Class labels
  - Confidence percentage scores

- Training split:
  - Train: 70%
  - Validation: 15%
  - Test: 15%

The dataset is labeled using bounding box annotation.

Dataset:
- Source: Custom / Roboflow
- Annotation: Bounding Box
- Format: Create ML compatible
Dataset tidak disertakan di repo (size & license).

📚 Learning Outcome

Project ini dibuat untuk:
- Hands-on experience in **manual data collection and annotation** (1,766 labeled images for 8 different class)
- Memahami Create ML Object Detection
- Integrasi Core ML + Vision di UIKit
- End-to-end ML workflow di iOS

👤 Author
Surya Ramadhani
Apple Developer Academy Graduate @Infinite Learning Cohort 2025 | AI/ML Enthusiast

GitHub: https://github.com/Surya221299
LinkedIn: https://www.linkedin.com/in/sur-ramdhan/
