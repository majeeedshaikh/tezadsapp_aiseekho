# TezAds (Autonomous Growth Operator) - Implementation Plan

## Overview
TezAds is an Autonomous Content-to-Action Agent built for the AI Seekho Hackathon (Challenge 1). It is a cross-platform mobile app built with Flutter that features a zero-backend, serverless architecture using direct on-device orchestration with Google AI Studio / Gemini API.

## Hackathon Submission Checklist
- [ ] **Mobile App Link**: Uploaded to online drive, accessible, and working.
- [ ] **Github Repository**: Public and accessible.
- [ ] **Demo Video (3-5 mins)**: Showcases workflow, agency, and innovation.
- [ ] **Antigravity Usage Video (2-3 mins)**: Screen recording of Antigravity usage.
- [ ] **README / Documentation**: Explains design, architecture, mock APIs, agents, and integrations.
- [ ] **Antigravity Trace / Logs**: Compressed zip files including implementation plans, task lists, and walkthroughs.

## Brand Identity Integration
- **Corporate Color Scheme**:
  - **Primary Canvas Background**: Deep Cyber Onyx Black (`#0B0B0E`)
  - **Accent/Focus Highlights**: Electric Indigo / Soft Tech Purple (`#7C7CE6`)
  - **Secondary Surface/Card Fill**: Dark Slate Grey (`#16161F`)
  - **High-Contrast Text**: Pearl White (`#F5F5FA`)
  - **Low-Contrast/Muted Text**: Dimmed Alloy Grey (`#8E8E9F`)
- **Logo Placements**:
  - `blacklogo.png`: Deployed in the app splash screen sequence and isolated light-themed component wrappers.
  - `whitelogo.png`: Permanently embedded in the ultra-premium upper left navigation rails or frosted top app bars against the onyx backdrop.

## Dynamic Ultra-Premium UI/UX Design
- **Glassmorphic Aesthetic**: Extensive use of multi-layered `BackdropFilter` with `ImageFilter.blur(sigmaX: 20, sigmaY: 20)` for high-fidelity, frosted glass panels.
- **Visual Hierarchy**: Use thin, semi-transparent borders with subtle linear gradients (`Border.all(color: Colors.white.withOpacity(0.08))`) for a premium Gemini-like layout.
- **Ambient Background Illumination**: Soft radial glow effects (`RadialGradient`) in canvas corners using blurred `#7C7CE6` tones to mimic organic energy pulses.
- **Agentic Trace (Stylized Terminal)**: Replace standard console dumps with a stylized terminal widget executing custom fade-in and typewriter text animations for real-time log tracking.
- **Split-Screen Blueprint Viewer**: An interactive multi-view slider comparing historical campaign performance gaps alongside structural TezAds tactical layouts.

## Core User Flow & Interface
1. **Ingestion Hub**:
   - File Upload Widget (.csv, .txt, .json) for raw business files.
   - Text Area: For users to describe their business pain point/goals.
   - *Pre-bundled Mock Datasets*: Single tap buttons for `assets/samples/` containing regional retail drops and performance logs.
2. **Antigravity Agentic Trace (Stylized Log Streaming UI)**:
   - Visual execution trace showing real-time internal operations (Parsing -> Analyzing -> Planning).
   - Displayed via custom fade-in typewriter animations in a premium terminal interface.
3. **The Action Hub (Interactive Split-Screen Viewer)**:
   - Compares Before vs. After states using a multi-view slider.
   - Simulates action: Mock campaign frameworks, localized adsets, and state logs.
   - Action Button: "Execute Autonomous Strategy".

## Architecture & Technical Safeties
- **Frontend**: Flutter Mobile Client (UI / State Management via Riverpod/BLoC).
- **Background Processing**: Enforce **Flutter Isolates** (background multi-threading) for client-side processing to ensure local file parsing (.csv, .json) never freezes the UI rendering thread.
- **Reactive Local DB**: Mock Ad Engine DB using Hive or Isar (NoSQL) for on-device state simulation. Explicitly tie the Gemini API / Google AI Studio function-calling tools to execute changes locally inside this store, forcing local notification triggers and live state chart updates upon campaign generation.
- **Runtime Layer**: Google Antigravity Runtime Layer
   - Direct Google AI Studio / Gemini API Bridging.
   - Local JSON Ingestion & Text Processing.
   - Execution Engine (Function Calling Execution).

## Multi-Agent Logic & Workflow Definitions
1. **The Fact Extraction & Context Consolidation Agent**
   - **Task**: Ingests raw payload string and user prompt.
   - **Logic**: Isolates numeric trends and correlates them to user complaints.
2. **The Strategy & Execution Planner**
   - **Task**: Formulates structural tactical corrections.
   - **Logic**: Autonomously calculates target parameters (e.g., geo-exclusions, adset splits, budget weights).
3. **The Execution & Tool Bridge Agent**
   - **Task**: Transforms strategies into state changes.
   - **Logic**: Translates the plan into structured JSON configuration and triggers local DB functions to simulate campaign launch.

## Development Phases

### Phase 1: Project Setup & Foundation
- Initialize Flutter project.
- Setup state management (Riverpod/BLoC) and routing.
- Setup local NoSQL database (Hive/Isar).
- Configure Gemini API / AI Studio integration.
- Setup branding assets and pre-bundle `assets/samples/` datasets.

### Phase 2: UI Development & Aesthetics
- Define global theme data (Onyx Black `#0B0B0E`, Electric Indigo `#7C7CE6`).
- Build glassmorphic panels and gradient borders.
- Build the **Ingestion Hub** (File upload, text input, sample data triggers).
- Build the **Agentic Trace** screen (Stylized terminal widget with typewriter effects).
- Build the **Action Hub** (Split-Screen Blueprint Viewer).

### Phase 3: Agent Integration & Concurrency
- Implement Flutter Isolates for non-blocking file parsing (.csv, .json).
- Implement Fact Extraction Agent.
- Implement Strategy Planner Agent.
- Implement Execution Agent connected directly to the reactive local DB.

### Phase 4: Data Flow & Simulation
- Ensure function calls write correctly to Hive/Isar.
- Trigger dynamic UI re-renders and local notifications on state updates.
- Verify the "Execute Autonomous Strategy" end-to-end flow.

### Phase 5: Polish, Testing, & Hackathon Deliverables
- Final aesthetic review (Radial glows, frosted glass).
- Record Demo Video and Antigravity Usage Video.
- Finalize README and documentation.
- Collect and zip Antigravity Trace/Logs.
- Build release APK/App Bundle and upload to drive.
