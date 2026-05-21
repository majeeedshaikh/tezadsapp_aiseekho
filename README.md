# TezAds: Autonomous Growth Operator 🚀

TezAds is an autonomous, agentic mobile application designed to revolutionize digital ad optimization. Built natively in Flutter and powered by the **Google Gemini API**, TezAds acts as an autonomous growth marketer in your pocket. 

Submitted for the **AI Seekho Hackathon** (Challenge 1: Autonomous Content-to-Action Agent).

---

## 🛑 The Problem We Are Solving
Modern digital marketing is painfully manual. When anomalies occur (e.g., a massive spike in CPA in a specific region, or bidding collisions), human operators take hours or days to:
1. Extract and analyze data from complex Meta/Google dashboards.
2. Formulate a mitigation strategy.
3. Verify compliance and remaining budgets.
4. Execute the technical changes in the Ads Manager.

By the time the human reacts, thousands of dollars in ad spend have already been wasted. **TezAds closes this gap to zero.**

## 💡 Overall Design of the Solution
TezAds introduces a **Multi-Agent Orchestration Pipeline**. Instead of displaying static charts, TezAds allows users to:
1. **Ingest Telemetry**: Upload raw ad performance data (CSV, PDF, JSON).
2. **Chat & Diagnose**: Talk to the AI to define business goals or point out issues.
3. **Deploy Autonomous Agents**: Let the AI handle the entire optimization lifecycle instantly.
4. **Action & Verify**: View a split-screen blueprint of the AI's proposed changes before they are committed.

---

## ⚙️ Architectural Overview
TezAds uses a **Zero-Backend Serverless Architecture** that runs entirely on the device.

*   **Frontend UI/UX**: Flutter (Dart) utilizing a highly premium, glowing glassmorphic "Apple-level" aesthetic. Uses `BackdropFilter` for frosted glass elements and custom radial glow physics.
*   **State Management**: `flutter_riverpod` combined with `GoRouter`. This ensures that complex asynchronous agent streams trigger isolated UI re-renders without blocking the user.
*   **Local Reactive Database (Hive)**: Uses `hive_flutter` as a lightweight NoSQL store to cache agent states, campaign metrics, and user preferences. Provides instant reactive state updates.
*   **Concurrency**: Uses **Flutter Isolates** to parse large CSV mock datasets in background threads, ensuring the 60fps/120fps UI never drops a frame.

---

## 🤖 The 5-Agent Pipeline
The core intelligence of TezAds is the `AgentWorkflowController`, which sequences five distinct AI personas operating sequentially:

1. ☁️ **Data Ingestion Agent**: Parses raw CSV telemetry, sanitizes formats, and standardizes unstructured user inputs.
2. 🔍 **Diagnostic AI**: Detects anomalies (e.g., Regional CPC spikes) and isolates the root causes using the Gemini API.
3. 🧠 **Strategy Planner**: Formulates dynamic budget shifts, audience exclusion logic, and pacing constraints based on the diagnostics.
4. ⚖️ **Safety & Compliance**: A crucial "If/Else" review loop. Validates the proposed strategy against daily spend velocity limits and platform safety policies.
5. ⚙️ **Execution Bridge**: Generates the final, structured JSON payload that perfectly mimics a Meta Ads Manager API push, deployed directly to the Action Hub UI.

---

## 🔌 Integrations & APIs (Mock vs Real)

### 1. Real AI Integration (Google Gemini API)
*   **Implementation**: Integrated via the `google_generative_ai` Flutter SDK.
*   **Usage**: Drives the core reasoning engines of the Diagnostic and Strategy Planner agents.
*   **Hackathon Safety Net**: We built a custom caching interceptor. If the free-tier Gemini API hits a `429 Rate Limit` during a live demo, the app seamlessly catches the exception and serves a cached, high-fidelity mock JSON trace, ensuring the UI/UX never breaks on stage.

### 2. Mock Integrations (Meta Ads Manager / Local Storage)
*   **Data Ingestion**: Instead of pulling live Meta API data (which requires complex OAuth approval), we feed the system pre-bundled, highly realistic CSV datasets (`assets/samples/regional_retail_drops.csv`).
*   **Execution Hub**: The final "Deploy" step updates the local Hive NoSQL database instead of making a live `POST` to the Meta Graph API, satisfying the hackathon sandbox requirements.

---

## ✨ How We Built This With Antigravity (AI Vibe Coding)
This application was architected, written, and continuously iterated in real-time alongside **Antigravity**, Google DeepMind's Advanced Agentic Coding Assistant. 

We heavily utilized Antigravity for:
*   **Complex UI/UX Engineering**: Generating the complex, animated UI components (dynamic Gemini-style textfields, frosted glass modals, scaling glowing containers).
*   **Pipeline Orchestration**: Engineering the asynchronous `flutter_riverpod` state controller that perfectly synchronizes the 5-step agent execution.
*   **Failsafe Sandbox Logic**: Implementing the bulletproof rate-limit caching mechanism that protects the live presentation pitches.

---

## 🚀 How to Run Locally

1. Ensure Flutter is installed (`flutter doctor`).
2. Clone this repository and run `flutter pub get`.
3. *(Important)* Open `lib/core/services/gemini_agent_service.dart` and insert your Gemini API Key in the initialization logic.
4. Run the app: `flutter run`.

## 📦 Hackathon Deliverables

- **Mobile App Link**: [Insert Drive Link Here]
- **Demo Video**: [Insert YouTube/Drive Link Here]
- **Antigravity Trace Video**: [Insert Screen Recording Link Here]
- **Antigravity Trace Zip**: Included in `antigravity_trace.zip` in the root folder.
