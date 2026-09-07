# 화이트아웃 서바이벌 광고 게임 — 자료조사

작성일: 2026-09-05
목적: 광고에 나오는 미니게임(곰 사냥 → 고기 판매 → 업그레이드 → 나무 채집 → 판매 → 업그레이드)을
실제 게임으로 만들기 위한 사전 조사

---

## 1. 장르 확정: **Arcade Idle (아케이드 아이들)**

말씀하신 루프는 정확히 이 장르다. 하이브리드캐주얼의 한 갈래로,
**아케이드의 조작감**과 **아이들의 성장 곡선**을 합친 것.

> "아케이드 아이들은 아이들 진행 시스템·메타를 아케이드의 코어 루프·메커닉과 결합한 장르다."
> — Homa Games / ironSource

핵심은 **완전한 방치가 아니라는 것**이다. 플레이어가 조이스틱으로 캐릭터를 직접 움직여
나무를 베고, 통나무를 들고 판매대까지 걸어가서 팔고, 그 돈으로 도끼를 업그레이드한다.
"손이 바쁜데 숫자도 커지는" 이중 만족이 이 장르의 정체.

### 3층 구조

| 층 | 내용 | 담당 감정 |
|---|---|---|
| **액티브(아케이드)** | 조이스틱 이동, 채집, 스태킹, 운반 | 즉각적 조작 쾌감 |
| **아이들(진행)** | 헬퍼 고용, 자동 생산, 오프라인 수익 | "내가 없어도 자란다" |
| **메타(성장)** | 구역 언락, 자원 티어 해금, 업그레이드 트리 | 장기 목표 |

세 층 중 하나라도 빠지면 장르가 성립하지 않는다.
- 액티브만 → 그냥 하이퍼캐주얼, 리텐션 없음
- 아이들만 → 클리커, 조작감 없음
- 메타 없음 → 30분이면 끝남

---

## 2. 코어 루프 정밀 분해

```
[이동] 조이스틱으로 자원 지점 이동
   ↓
[채집] 탭/자동 — 나무 베기, 곰 사냥
   ↓
[스태킹] 캐릭터 등에 통나무/고기가 쌓임 ← 이 장르의 시그니처. 시각적 만족의 핵심
   ↓
[운반] 판매대까지 걸어감 (스택 한도 = 첫 업그레이드 대상)
   ↓
[판매] 아이템 하나씩 날아가며 코인으로 전환 ← 애니메이션이 보상감의 80%
   ↓
[업그레이드] 도끼 위력 / 이동속도 / 스택 한도 / 헬퍼 고용
   ↓
[언락] 새 구역, 새 자원 티어 (나무 → 곰 → 더 비싼 것)
   ↓ (반복, 각 사이클이 점점 짧아짐)
```

### 필수 메커닉 체크리스트

- [ ] 조이스틱 이동 (캐릭터가 **항상 움직이고 있어야** 함)
- [ ] 스태킹 — 등에 쌓이는 시각 표현
- [ ] 스택 한도 (초반의 주된 마찰. 업그레이드의 첫 동기)
- [ ] 판매대 & 코인 흡입 애니메이션
- [ ] 업그레이드 4종 이상 (도끼/속도/스택/헬퍼)
- [ ] 구역 언락 (돈 내고 맵 확장 — "탐험" 감정)
- [ ] 헬퍼/NPC 고용 (아이들 층 진입점)
- [ ] 오프라인 수익 (재접속 동기)

### 설계 철칙: **"No resource left behind"**

Supersonic 가이드의 핵심 원칙. **초반 자원이 후반에도 계속 쓰여야 한다.**
- 나쁜 예: 곰 고기 해금되면 나무는 쓸모없어짐 → 맵 절반이 죽은 공간
- 좋은 예: 곰 사냥에 **나무로 만든 함정**이 필요 → 나무 수요가 유지됨

이걸 안 하면 플레이어가 새 구역만 오가고, 이미 만든 콘텐츠의 절반이 버려진다.

---

## 3. 경제 수식 (밸런싱의 실체)

이 장르는 "재미"의 상당 부분이 **숫자 곡선 설계**다. 검증된 공식:

### 업그레이드 비용 — 지수 증가
```
cost_next = cost_base × (rate_growth ^ owned)
```
- `rate_growth` 권장: **1.07 ~ 1.15** (구매마다 7~15% 상승)
- AdVenture Capitalist의 레모네이드 가판대: `rate_growth = 1.07`, `cost_base = 4`, `production_base = 1.67/초`

### 생산량 — 선형 증가
```
production_total = (production_base × owned) × multipliers
```

### 왜 이 조합인가
비용은 지수, 보상은 선형. 지수는 결국 어떤 다항식도 추월하므로
**반드시 벽에 부딪히게 설계돼 있다.** 그 벽이 곧 다음 구역 언락 / 프레스티지의 동기가 된다.
초반엔 생산이 비용을 앞질러 "쭉쭉 크는" 느낌, 후반엔 비용이 앞질러 "다음 단계로 가야 하는" 압력.

### 대량 구매 공식 (UI에 x10, MAX 버튼 넣을 때)
```
n개 구매 비용:     cost = b × r^k × (r^n − 1) / (r − 1)
살 수 있는 최대 수: max  = floor( log_r( c(r−1)/(b × r^k) + 1 ) )

b = 기본가, r = 성장률, k = 현재 보유 수, c = 보유 코인
```
루프 돌리지 말고 이 닫힌 식을 쓸 것.

### 멀티플라이어로 구형 자원 살리기
보유 수 25개, 50개 같은 지점에 ×2 보너스를 걸면
**오래된 생산자가 후반까지 유효**하게 유지된다. "No resource left behind"의 수학적 구현.

---

## 4. 시장 벤치마크 (실제 숫자)

| 지표 | 값 | 출처 |
|---|---|---|
| CPI | **~$0.50** | Supersonic |
| D0 플레이타임 | **1,200~1,800초** (20~30분) | Supersonic |
| Top 50 아케이드 아이들 월 매출 합 | $6.3M (2024.10 기준 기록치) | Udonis |
| Top 50 월 다운로드 | 6,000만+ | Udonis |
| 수익 모델 | 리워드 광고 + IAP 하이브리드 | Udonis |

**CPI $0.50은 이 장르의 큰 강점**이다. 하이브리드캐주얼 평균(Tier1 $2.50~$6.00)의 1/5 수준.
2026년 시장에서 신규 팀이 그나마 비벼볼 여지가 있는 이유가 여기 있다.

다만 Azur Games 2026 리포트의 경고는 유효하다 — 하이브리드캐주얼 붐은 신규 팀이 아니라
**기존 하이퍼캐주얼 개발자들이 옮겨탄 결과**였고, 같은 서브장르 안에서도 매출이 수십~수백 배 갈린다.

**주의**: 업계에서 흔히 인용되는 "5개월 / $35,000에 출시 가능"은 외주 스튜디오의
영업용 수치다(경험 있는 팀 기준). 1인 개발 기준이 아니다.

---

## 5. 레퍼런스 — 반드시 직접 해볼 것

문서 100장보다 이 장르 게임 3개를 30분씩 하는 게 낫다.
특히 **"업그레이드 하나 사고 싶어지는 순간"이 몇 초에 오는지** 재보시라.

### 테마가 정확히 일치 (나무/생존)
| 게임 | 플랫폼 | 비고 |
|---|---|---|
| **Lumbercraft** (Voodoo) | Android | **2,300만 다운로드.** 나무 베기 + 마을 건설 + 전투. 가장 가까움 |
| Idle Lumber Empire | Android/iOS | 타이쿤형 |
| Wood Cutting Idle Lumberjack | Android | |
| Idle Lumberjack 3D | 웹(SilverGames) | 설치 없이 즉시 |
| Idle Lumber Inc | 웹(Poki) | 설치 없이 즉시 |
| Idle Noob Lumberjack | 웹(CrazyGames) | 설치 없이 즉시 |

### 장르 완성도 최상위 (테마는 다르지만 구조를 배울 것)
- **My Perfect Hotel** — 이 장르의 교과서. 온보딩 설계가 특히 훌륭
- **Burger Please** / **Pizza Ready** — 2024 최상위 매출작

### 주요 퍼블리셔 (레퍼런스 소스)
Homa Games, SayGames(40억+ DL), Supercent, Voodoo

---

## 6. 기술 스택

| | Godot 4.x | Unity |
|---|---|---|
| 2D | 전용 파이프라인, 우위 | 3D 우선 설계 |
| **3D 캐주얼** | 가능하나 생태계 얇음 | **강점, 이 장르 사실상 표준** |
| 에셋 스토어 | 빈약 | 방대 (조이스틱, 스태킹, 아이들 템플릿 다수) |
| 광고 SDK 연동 | 직접 작업 | AdMob/ironSource/AppLovin 공식 지원 |
| 라이선스 | MIT 무료 | Runtime Fee 폐지, Pro는 유료 |
| 빌드 크기 | 작음 | 큼 |

**권장: Unity.**
앞선 조사(핀 뽑기/2D 퍼즐)에서는 Godot을 권했지만 **이 장르는 판단이 뒤집힌다.**
- 아케이드 아이들은 **3D 로우폴리가 사실상 표준**이고
- 조이스틱·스태킹·수익화 SDK 같은 정형화된 부품이 Unity 에셋 스토어에 이미 다 있다
- Mind Studios 등 이 장르 전문 스튜디오도 Unity를 씁니다

단, **웹 배포가 1순위**이거나 이미 Godot에 익숙하시면 Godot 2D 탑다운으로도 충분히 성립한다.
스태킹·조이스틱은 2D로도 표현 가능하다.

---

## 7. MVP 제안 (검증 가능한 최소 범위)

**성공 기준을 먼저 정의한다:**
> "플레이어가 아무 설명 없이 시작해서, 3분 안에 첫 업그레이드를 스스로 구매하고,
>  그 직후 '한 번만 더'를 누른다."

이걸 만족하는 최소 구성:

1. 맵 1개, 나무 3그루, 판매대 1개
2. 조이스틱 이동 + 자동 채집(근접 시)
3. 스태킹 (한도 3개로 시작 — 짜증나야 한다)
4. 업그레이드 2종: **스택 한도**, **도끼 속도**
5. 코인 흡입 애니메이션 + 사운드

여기까지가 이 장르의 재미가 있는지 없는지 판별되는 지점이다.
곰 사냥·헬퍼·구역 언락·오프라인 수익은 **전부 그 다음**이다.

---

## 부록: WOS 광고의 다른 유형들 (참고용)

Century Games는 일일 크리에이티브 약 2,000개를 돌리며 여러 장르의 가짜 광고를 동시에 쓴다.
이번 건과는 무관하지만 기록해둔다.

- **A. 문 고르기 러너** — fakeadgames.com이 WOS를 "Snow-Door Runner"로 분류(Lie Score 9/10). 원조 Join Clash(2021)
- **B. 핀 뽑기** — 원조 Hero Wars/Evony(2019). PocketGamer 분석: "호기심+문제해결+아슬아슬한 죽음"
- **C. 선 긋기 방어** — Save the Doge. 광고가 진실인 드문 사례

### 법적 경계
- 메커닉 차용은 자유 (게임 규칙은 저작권 대상 아님)
- 에셋·UI·캐릭터 복제, "화이트아웃 서바이벌" 상표 사용은 불가
- 역설: 광고대로 만들면 **정직한 쪽**이 된다

---

## 출처

- [Arcade Idle: Creating the new Hybridcasual genre — Homa / ironSource](https://medium.com/ironsource-levelup/arcade-idle-creating-the-new-hybridcasual-genre-10d7f9dac21f)
- [Idle Arcade: Analyzing the Trending Hybrid Casual Genre — Udonis](https://www.blog.udonis.co/mobile-marketing/mobile-games/arcade-idle)
- [How to Ideate and Build a Profitable Idle Arcade Game — Supersonic](https://supersonic.com/learn/blog/how-to-ideate-and-build-a-profitable-idle-arcade-game/)
- [A Guide to Building an Arcade Idle Game like My Perfect Hotel — Mind Studios](https://games.themindstudios.com/post/how-to-make-arcade-idle-game/)
- [The Math of Idle Games, Part I — Kongregate](https://www.sirpinski.com/the-math-of-idle-games-part-i/)
- [Math — the backbone of Idle Games — Dik Medvešček Murovec](https://medvescekmurovec.medium.com/math-the-backbone-of-idle-games-part-1-f46b54706cf1)
- [Balancing Tips: How We Managed Math on Idle Idol — Game Developer](https://www.gamedeveloper.com/design/balancing-tips-how-we-managed-math-on-idle-idol)
- [Top 7 Idle Game Mechanics — Mobile Free To Play](https://mobilefreetoplay.com/top-7-idle-game-mechanics/)
- [Hypercasual and hybrid casual in 2026 (full report) — Azur Games](https://azurgames.com/blog/hypercasual-and-hybrid-casual-in-2026-full-report/)
- [Lumbercraft — Google Play](https://play.google.com/store/apps/details?id=com.noorgames.timbercraft)
- [Idle Lumber Inc — Poki](https://poki.com/en/g/idle-lumber-inc)
- [Fake Ad Games 아카이브](https://fakeadgames.com/)
- [The evolution of pull-the-pin — PocketGamer.biz](https://www.pocketgamer.biz/the-evolution-of-pull-the-pin-why-is-this-a-good-thing-for-the-games-industry/)
- [Whiteout Survival Mobile Advertising Analysis — InsightRackr](https://blog.insightrackr.com/en/docs/WhiteoutSurvivalIntelligence)
