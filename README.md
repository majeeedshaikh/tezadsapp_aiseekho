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

## ⚙️ Architectural Overview & Technical Deep Dive
TezAds uses a **Zero-Backend Serverless Architecture** that runs entirely on the device. By eliminating middleware, we achieve near-instantaneous execution loops between the user and the underlying LLM.

### 1. Frontend UI/UX (Flutter & Glassmorphism)
*   **Aesthetic Engine**: Developed using a highly premium, glowing glassmorphic "Apple-level" aesthetic. We utilize native `BackdropFilter` combined with `ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0)` for realistic frosted glass components.
*   **Dynamic Layouts**: Features auto-expanding Gemini-style prompt input fields (`minLines`, `maxLines` bounded scaling) and dynamically wrapped flex boxes (`Expanded`, `Flexible`) to guarantee pixel-perfect responsiveness across all screen sizes without overflow.
*   **Animation Physics**: Uses custom `TweenAnimationBuilder` and implicit animations to handle complex transitions, such as the glowing agent containers and real-time streaming typewriter terminal text during the agentic reasoning phase.

### 2. State Management (Riverpod + GoRouter)
*   **Asynchronous Orchestration**: We utilize `flutter_riverpod` (`AsyncNotifierProvider`) to manage the highly complex, multi-stage asynchronous agent execution. 
*   **State Machine Lifecycle**: The Riverpod controller (`AgentWorkflowController`) handles discrete state mutations (`isProcessing`, `isCompleted`, `currentTask`, `logs`) and broadcasts them to the UI, guaranteeing that complex asynchronous streams trigger isolated UI re-renders without blocking user interactions.
*   **Type-Safe Routing**: Managed by `go_router` for deep linking and declarative navigation between the Ingestion Hub, Agent Trace, and Action Hub blueprints.

### 3. Concurrency (Flutter Isolates)
*   **Background Ingestion**: Mobile devices can freeze if the main thread parses massive files. TezAds utilizes **Flutter Isolates** (`compute()` function) to parse large CSV mock datasets in entirely isolated background threads. This ensures the 120fps UI never drops a frame, even when ingesting tens of thousands of rows of telemetry data.

### 4. Local Reactive Database (Hive NoSQL)
*   **Persistence**: Uses `hive_flutter` as an ultra-fast, lightweight NoSQL key-value store.
*   **Reactive UI Binding**: We cache agent states, campaign metrics, and execution history here. Because Hive allows synchronous reading, we achieve instant UI state hydration on boot.

---

## 🤖 The 5-Agent Pipeline
The core intelligence of TezAds is the `AgentWorkflowController`, which sequences five distinct AI personas operating sequentially. Each agent passes its structured output as context to the next agent:

1. ☁️ **Data Ingestion Agent**: Parses raw CSV telemetry, sanitizes numeric formats, drops null rows, and normalizes unstructured user prompts into a structured schema.
2. 🔍 **Diagnostic AI (Gemini Flash)**: Ingests the sanitized data and detects anomalies (e.g., Regional CPC spikes). It utilizes contrastive reasoning to isolate the root cause.
3. 🧠 **Strategy Planner (Gemini Flash)**: Ingests the Diagnostic report. Formulates tactical, multi-variable adjustments such as dynamic budget shifting, audience geo-exclusions, and pacing constraints.
4. ⚖️ **Safety & Compliance (Deterministic)**: A crucial "If/Else" boundary layer. Validates the proposed strategy against hardcoded daily spend velocity limits and platform safety policies. Prevents LLM hallucinations from executing destructive ad bids.
5. ⚙️ **Execution Bridge**: The final compiler. It forces the abstract plan to collapse into a strictly formatted JSON payload (mimicking the Meta Graph API schema) and deploys it directly to the Action Hub blueprint UI.

---

## 🔌 Integrations & APIs (Mock vs Real)

### 1. Real AI Integration (Google Gemini API)
*   **Implementation**: Fully integrated via the native `google_generative_ai` Flutter SDK.
*   **Configuration**: We deploy the `gemini-flash-latest` model for its ultra-low latency, which is critical for real-time chat interactions.
*   **Hackathon Safety Net (The Sandbox Interceptor)**: We built a robust, custom caching interceptor. If the free-tier Gemini API hits a `429 Too Many Requests` or `Quota Exceeded` limit during a high-stakes live demo, the Riverpod controller seamlessly catches the `GenerativeAIException` and serves a pre-compiled, high-fidelity mock JSON trace. This guarantees 100% presentation uptime.

### 2. Mock Integrations (Meta Ads Manager Sandbox)
*   **Mock Ingestion**: Instead of pulling live Meta API data (which requires complex, slow OAuth approvals), we feed the system pre-bundled, highly realistic CSV telemetry (`assets/samples/regional_retail_drops.csv`).
*   **Mock Execution Hub**: The final "Deploy to Ads Manager" action updates the local Hive NoSQL database instead of making a live `POST` to the Meta Graph API. This satisfies the hackathon constraints while perfectly demonstrating the data flow.

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
