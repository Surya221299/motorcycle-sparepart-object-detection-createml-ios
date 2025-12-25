#  🏍️ motorcycle-sparepart-object-detection-createml-ios
Live motorcycle sparepart detection using Create ML, Core ML, and UIKit.

## 🧠 Overview

This project is an iOS app that performs **real-time object detection for motorcycle spareparts** using a model trained with **Create ML**.

The dataset was **manually collected, annotated, and labeled** to ensure high-quality training data.

The app runs entirely **on-device (without internet)**, making it suitable for mobile and real-world use cases.

## 📸 Dataset Creation

All images in this project were **collected and prepared manually**.

- Images were captured manually using a **mobile camera**
- Each image was annotated and **labeled manually**
- Bounding boxes were drawn one by one for each class
- Number of classes: 8 motorcycle sparepart classes
- Total dataset size: 1,766 images

This process helped ensure dataset quality and improved model generalization.

## 🏷️ Dataset Split

| Split | Percentage | Description |
|------|-----------|-------------|
| Train | 70% | Used to train the object detection model |
| Validation | 15% | Used for tuning and evaluation during training |
| Test | 15% | Used for final performance evaluation |


## 📊 Model Performance

| Metric | Value | Interpretation |
|:------|:-----:|---------------:|
| mAP | 0.50 | Medium detection accuracy |
| Precision | 0.90 | High prediction correctness |
| Recall | 0.50 | Medium object coverage |


## 🎯 Use Cases

Motorcycle sparepart object detection
iOS real-time camera vision
Practical Create ML object detection workflow


## ✨ Features :
- Real-time camera object detection
- Bounding box + label + confidence score
- On-device inference (Core ML)
- UIKit-based Programmatic UI
- Smooth frame processing
- Train / Validation / Test split support

## 🏗 Tech Stack

| Component | Technology |
|--------|-----------|
| ML Training | Create ML (Object Detection) |
| Inference | Core ML |
| Vision | Vision Framework |
| UI | UIKit |
| Programming Language | Swift |
| Dataset Tool | Roboflow |
| Platform | iOS |


## 🤖 Model Details

- Model type: Create ML Object Detection
- Input: Camera frames
- Output:
  - Bounding boxes
  - Class labels
  - Confidence scores

- Annotation type: Bounding box

The dataset is labeled using bounding box annotation.

## 🗃️ Dataset

- Source: Custom dataset (captured manually)
- Annotation: Bounding box
- Format: Create ML compatible
Dataset is not included in this repository due to size and licensing constraints.

## 📚 Learning Outcome

This project was built to gain hands-on experience in:

- Manual dataset creation and annotation (1,766 labeled images across 8 classes)
- Create ML Object Detection pipeline
- Integrating Core ML and Vision in UIKit
- End-to-end on-device ML workflow on iOS

## ⚠️ Requirements :
- iOS 13+
- iPhone (Camera access allowed)

# 🧑‍💻 Author
## Surya Ramadhani

##🎓 Apple Developer Academy Graduate @Infinite Learning Cohort 2025 | AI/ML Enthusiast

GitHub: https://github.com/Surya221299

LinkedIn: https://www.linkedin.com/in/sur-ramdhan/
