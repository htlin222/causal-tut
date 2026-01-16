## 演講主題

**觀察性研究的因果推論：給臨床醫師的實戰指南**

*Causal Inference from Observational Studies: A Practical Guide for Clinicians*

---

## 摘要

隨機對照試驗是建立因果關係的黃金標準，但臨床上許多重要問題無法透過 RCT 回答。當我們只有觀察性資料時，如何從「A 組和 B 組有差異」進階到「A 治療導致更好的結果」？本演講將介紹目前因果推論的主流方法架構，包含 Target Trial 思維、雙重穩健估計（TMLE/AIPW）、以及敏感度分析。我們將跳過繁瑣的數學推導，聚焦於：什麼情境該用什麼方法、資料該如何準備、以及如何用 R 在幾行程式碼內完成分析。演講結束後，您將獲得一份可直接套用的「最強配置菜單」，涵蓋連續、二元、存活、計數等常見臨床結果類型。

**關鍵字**：因果推論、傾向分數、雙重穩健估計、TMLE、敏感度分析、觀察性研究

---

## 演講大綱

### 第一部分：為什麼需要因果推論？（10 分鐘）

**1.1 開場情境**

- 案例：「回顧性資料顯示，使用新藥的病人存活率較高，這代表新藥有效嗎？」
- 問題：觀察到的差異 ≠ 因果效應

**1.2 關聯 vs 因果**

- 描述性問題：「用新藥的人和沒用的人，結果有沒有不同？」
- 因果性問題：「如果讓同一群人用新藥 vs 不用，結果會不會不同？」
- 核心困難：反事實 (counterfactual) 永遠觀察不到

**1.3 混淆的問題**

- 圖示：為什麼直接比較會有偏誤
- 醫師傾向開新藥給較輕症的病人 → 新藥組本來就會比較好

---

### 第二部分：研究設計思維（15 分鐘）

**2.1 Target Trial Emulation**

- 核心概念：「如果能做 RCT，你會怎麼設計？」
- 用觀察性資料模擬那個理想試驗

**2.2 Target Trial 七要素（帶範例填寫）**

| 要素 | 你要定義的 |
|------|-----------|
| 資格條件 | 誰可以納入？ |
| 治療策略 | 新藥 vs 什麼？ |
| 治療分配 | 病人如何被分組（觀察性）|
| 追蹤起點 | Time zero 是什麼時候？ |
| 結果 | 主要 outcome |
| 追蹤期間 | 追多久？ |
| 因果對比 | 要估計什麼？ATE? |

**2.3 DAG 因果圖（簡化版）**

- 三種變數：混淆因子、中介變數、碰撞變數
- 重點：哪些該調整、哪些不該調整
- 圖示範例即可，不需數學

**2.4 三大因果假設（用白話解釋）**

| 假設 | 白話意思 | 怎麼處理 |
|------|----------|----------|
| 一致性 | 治療定義要明確 | 研究設計 |
| 可交換性 | 沒有未測量混淆 | 調整 + 敏感度分析 |
| 正值性 | 每種人都有機會接受各治療 | 檢查 PS 分布 |

---

### 第三部分：方法概念（15 分鐘）

**3.1 傾向分數 (Propensity Score) 是什麼？**

- 白話：「根據病人特徵，預測他接受治療的機率」
- 用途：讓兩組變得可比較

**3.2 傳統方法的問題**

| 方法 | 做法 | 風險 |
|------|------|------|
| 單純迴歸調整 | 把混淆因子丟進模型 | 模型設錯就完了 |
| PS matching | 用 PS 配對 | 丟掉很多樣本 |
| PS weighting (IPW) | 用 PS 加權 | 極端權重不穩定 |

**3.3 雙重穩健估計（核心概念）**

- 同時建兩個模型：PS 模型 + 結果模型
- 好處：只要其中一個對，結果就對
- 「買保險」的概念

**3.4 TMLE vs AIPW**

- 都是雙重穩健
- TMLE 多一個 targeting 步驟，更穩定
- 實務上：選 TMLE 就對了

**3.5 Super Learner（一句話解釋）**

- 讓多個模型投票，自動選最佳組合
- 不用煩惱該選 logistic 還是 random forest
- 程式碼一樣簡單，沒理由不用

---

### 第四部分：情境選擇菜單（10 分鐘）

**4.1 一張表搞定方法選擇**

| Outcome 類型 | 範例 | 估計什麼 | 方法 | R 套件 |
|--------------|------|----------|------|--------|
| 連續 | 血壓、HbA1c | 平均差 | TMLE | `tmle` |
| 二元 | 死亡 Y/N | Risk Diff / RR | TMLE | `tmle` |
| 存活 | 死亡時間 | Survival diff / HR | Survival TMLE | `survtmle` |
| 計數 | 住院次數 | Rate Ratio | IPW + Poisson | `WeightIt` |
| 重複測量 | 多時間點追蹤 | 軌跡差異 | IPW + GEE | `geepack` |

**4.2 Estimand 的選擇**

- ATE：所有人的平均效果
- ATT：實際接受治療者的效果
- 存活：Survival difference vs HR vs RMST

---

### 第五部分：資料準備（10 分鐘）

**5.1 資料格式要求**

```r
# 基本結構
df <- data.frame(
  id = ...,
  treatment = ...,    # 0/1
  outcome = ...,      # 依類型

  # 混淆因子（都是 baseline）
  age = ...,
  sex = ...,
  comorbidity = ...,
  baseline_severity = ...
)
```

**5.2 常見資料問題**

| 問題 | 解法 |
|------|------|
| 遺漏值 | Multiple imputation（先處理）|
| 混淆因子放錯時間點 | 只能用 baseline 的 |
| Time zero 不明確 | 仔細定義追蹤起點 |
| 治療定義模糊 | 明確定義什麼算「接受治療」|

**5.3 存活資料格式**

```r
df_surv <- data.frame(
  id = ...,
  treatment = ...,
  time = ...,         # 追蹤時間
  event = ...,        # 1=事件，0=設限
  # 混淆因子...
)
```

---

### 第六部分：R 實作示範（20 分鐘）

**6.1 連續結果完整範例**

```r
library(tmle)
library(SuperLearner)

SL.lib <- c("SL.glm", "SL.ranger", "SL.xgboost")

fit <- tmle(
  Y = df$outcome,
  A = df$treatment,
  W = df %>% select(age, sex, comorbidity, severity),
  Q.SL.library = SL.lib,
  g.SL.library = SL.lib,
  family = "gaussian"
)

fit$estimates$ATE
```

**6.2 二元結果**

```r
fit <- tmle(
  Y = df$death,
  A = df$treatment,
  W = df %>% select(age, sex, comorbidity, severity),
  Q.SL.library = SL.lib,
  g.SL.library = SL.lib,
  family = "binomial"
)

fit$estimates$ATE  # Risk Difference
fit$estimates$RR   # Risk Ratio
```

**6.3 存活結果**

```r
library(survtmle)

fit <- survtmle(
  ftime = df$time,
  ftype = df$event,
  trt = df$treatment,
  adjustVars = df %>% select(age, sex, comorbidity, severity),
  t0 = 365,
  SL.ftime = SL.lib,
  SL.ctime = SL.lib,
  SL.trt = SL.lib,
  method = "hazard"
)
```

**6.4 平衡診斷**

```r
library(cobalt)
library(WeightIt)

w <- weightit(treatment ~ age + sex + comorbidity + severity,
              data = df, method = "super", SL.library = SL.lib)

# SMD 檢查
bal.tab(w, thresholds = c(m = 0.1))

# 視覺化
love.plot(w, threshold = 0.1)
```

**6.5 PS 重疊檢查**

```r
ggplot(df, aes(x = ps, fill = factor(treatment))) +
  geom_density(alpha = 0.5) +
  labs(title = "Propensity Score Overlap")
```

---

### 第七部分：敏感度分析（10 分鐘）

**7.1 為什麼需要？**

- 再好的方法都無法處理「未測量混淆」
- 敏感度分析：量化「需要多強的未測量混淆才能推翻結論」

**7.2 E-value（最簡單實用）**

```r
library(EValue)

# 二元結果（RR）
evalues.RR(1.5, lo = 1.2, hi = 1.9, true = 1)

# 存活結果（HR）
evalues.HR(0.7, lo = 0.5, hi = 0.9, true = 1)

# 連續結果（先轉換）
d <- abs(ate) / sd(Y)
rr <- exp(0.91 * d)
evalues.RR(rr, lo = rr_lo, hi = rr_hi, true = 1)
```

**7.3 如何解讀 E-value**

- E-value = 2.5 表示：
  - 需要一個 RR ≥ 2.5（對 treatment）且 RR ≥ 2.5（對 outcome）的未測量混淆
  - 才能完全解釋掉觀察到的效果
- 越大 = 越穩健
- 經驗法則：E-value > 2 通常算不錯

---

### 第八部分：結果報告（5 分鐘）

**8.1 Methods 怎麼寫**

> We estimated the average treatment effect using targeted maximum likelihood estimation (TMLE) with Super Learner for both propensity score and outcome models. The ensemble included logistic regression, random forest, and gradient boosting. Covariate balance was assessed using standardized mean differences (threshold < 0.1). Sensitivity to unmeasured confounding was evaluated using E-values.

**8.2 必備圖表**

| 圖表 | 內容 |
|------|------|
| Table 1 | Baseline characteristics（原始 + 加權後）|
| Figure 1 | PS overlap plot |
| Figure 2 | Love plot（SMD 平衡圖）|
| Figure 3 | 結果圖（forest plot / KM curve）|
| Table 2 | 主結果 + 95% CI + E-value |

**8.3 結果報告範例**

> The estimated risk difference was −5.2% (95% CI: −8.1% to −2.3%, p = 0.001), indicating the new drug reduced mortality by approximately 5 percentage points. All standardized mean differences were below 0.1 after weighting. The E-value was 2.8, suggesting that substantial unmeasured confounding would be required to explain away the observed effect.

---

### 第九部分：總結與 Q&A（5 分鐘）

**9.1 帶走的一張圖**

```
┌─────────────────────────────────────────────────────────┐
│              觀察性研究因果推論流程                       │
├─────────────────────────────────────────────────────────┤
│                                                         │
│   1. Target Trial 設計                                  │
│         ↓                                               │
│   2. DAG 畫出因果假設                                    │
│         ↓                                               │
│   3. 資料準備（baseline 混淆因子）                        │
│         ↓                                               │
│   4. TMLE + Super Learner                               │
│      ┌─────────────────────────────────┐                │
│      │ 連續    → tmle(..., gaussian)   │                │
│      │ 二元    → tmle(..., binomial)   │                │
│      │ 存活    → survtmle()            │                │
│      │ 計數    → IPW + Poisson         │                │
│      └─────────────────────────────────┘                │
│         ↓                                               │
│   5. 檢查：PS overlap + SMD < 0.1                        │
│         ↓                                               │
│   6. E-value 敏感度分析                                  │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

**9.2 常見問題**

| 問題 | 回答 |
|------|------|
| 樣本數要多少？ | 沒有絕對標準，但每組 > 100 較穩定 |
| 混淆因子要放幾個？ | 根據 DAG 決定，不是越多越好 |
| Reviewer 不熟 TMLE？ | 附 PS matching 當 sensitivity analysis |
| PS 重疊很差怎麼辦？ | 考慮 trimming 或 overlap weights |

**9.3 延伸資源**

- Hernán & Robins "Causal Inference: What If"（免費線上）
- `tlverse` 教學網站
- Miguel Hernan 的 edX 課程

---

## 演講時間分配

| 部分 | 時間 |
|------|------|
| 為什麼需要因果推論 | 10 min |
| 研究設計思維 | 15 min |
| 方法概念 | 15 min |
| 情境選擇菜單 | 10 min |
| 資料準備 | 10 min |
| R 實作示範 | 20 min |
| 敏感度分析 | 10 min |
| 結果報告 | 5 min |
| 總結與 Q&A | 5 min |
| **總計** | **100 min** |

---

需要我把這份大綱做成投影片檔案或講稿嗎？
