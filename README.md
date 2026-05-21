# TezAds: Autonomous Growth Operator 🚀

TezAds is an autonomous, agentic mobile application designed to revolutionize Meta Ads optimization. Built natively in Flutter and powered by **Google Gemini API**, TezAds acts as an autonomous growth marketer in your pocket. 

Submitted for the **AI Seekho Hackathon** (Challenge: Autonomous Content-to-Action Agent).

---

## 🛑 The Problem We Are Solving

Modern digital marketing is painfully manual. When anomalies occur (e.g., a massive spike in CPA in a specific region, or bidding collisions), human operators take hours or days to:
1. Extract data from dashboards.
2. Formulate a mitigation strategy.
3. Verify compliance and budgets.
4. Execute the changes in the Meta Ads Manager.

By the time the human reacts, thousands of dollars in ad spend have already been wasted. 

## 💡 Our Solution

TezAds introduces a **Multi-Agent Orchestration Pipeline**. Instead of displaying static charts, TezAds allows users to chat with the system, attach raw telemetry (CSV/PDF), and deploy autonomous AI agents to handle the entire optimization lifecycle instantly.

---

## ⚙️ Architecture & Technical Stack

TezAds uses a **Zero-Backend Serverless Architecture** that runs entirely on the device:

*   **Frontend**: Flutter (Dart) with a highly premium, glowing glassmorphic "Apple-level" UI design.
*   **State Management**: Riverpod (`flutter_riverpod`) & GoRouter for seamless asynchronous execution.
*   **Local Reactive DB**: Hive NoSQL for instant UI state changes and Hackathon-safe data caching.
*   **AI Engine**: Google AI Studio / Gemini API directly bridged to the client using `google_generative_ai`.

### The 5-Agent Pipeline
Our core innovation is the `AgentWorkflowController`, which sequences five distinct AI personas:
1. ☁️ **Data Ingestion**: Parses raw CSV telemetry and sanitizes formats.
2. 🔍 **Diagnostic AI**: Detects anomalies (e.g., Regional CPC spikes) and isolates root causes.
3. 🧠 **Strategy Planner**: Formulates dynamic budget shifts and pacing constraints.
4. ⚖️ **Safety & Compliance**: A crucial "If/Else" review loop to validate the strategy against daily spend velocity limits and platform policies.
5. ⚙️ **Execution Bridge**: Generates the final, structured JSON payload deployed directly to the Action Hub.

---

## 🤖 How We Built This With Antigravity

This application was architected, written, and continuously iterated in real-time alongside **Antigravity**, Google DeepMind's Advanced Agentic Coding Assistant. 

We heavily utilized Antigravity for:
*   **Complex UI/UX Engineering**: Antigravity generated the complex, animated UI components, including the dynamic auto-expanding Gemini-style textfield, the frosted glass Profile/Settings Modals, and the incredibly complex `AgentTraceScreen` featuring scaling glowing containers with real-time text-streaming animations.
*   **Pipeline Orchestration**: Antigravity engineered the asynchronous `flutter_riverpod` state controller that perfectly synchronizes the 5-step agent execution, managing state between `isProcessing` and `isCompleted`.
*   **Failsafe "Hackathon Demo" Layer**: Antigravity proactively implemented a bulletproof error-catching mechanism. By intercepting API rate limits from the free-tier Gemini API, it seamlessly falls back to a cached simulation, guaranteeing 100% reliability during live presentation pitches without breaking the user experience.

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
