# 3D 모델 조달 조사

작성일: 2026-09-07
목적: 지금의 절차적(코드로 조립한) 도형을 실제 3D 모델로 교체할지, 한다면 어디서 가져올지

---

## 0. 지금 상태와 결정할 것

현재 게임은 **에셋 0개**다. 나무·곰·캐릭터·텐트를 전부 cone/sphere/capsule/box로 코드에서 조립한다.

| | 지금 (절차적) | 모델 도입 후 |
|---|---|---|
| 파일 크기 | HTML 1개 + three.js 740KB | + 수 MB |
| 로딩 | 없음 | 비동기 로딩·로딩화면 필요 |
| 아트 품질 | 형태·조명·툰으로만 승부 | 확실히 올라감 |
| 수정 비용 | 숫자 하나 고치면 끝 | Blender 왕복 |
| 드로우콜 | ~300 | 관리 안 하면 급증 |

**드로우콜이 이미 경계선이다.** 업계 통설은 100 이하면 안전, 500 넘으면 흔들림. 지금 300이니
모델을 그냥 얹기만 하면 넘어간다. `InstancedMesh`로 묶는 작업이 세트로 따라와야 한다.

---

## 1. 조달처 (전부 CC0 = 상업 이용·출처 표기 불필요)

| 출처 | 규모 | 포맷 | 이 게임에 맞는 것 |
|---|---|---|---|
| **[Kenney](https://kenney.nl/)** | 40,000+ 에셋 | OBJ/FBX/**glTF** | Nature Kit(330), Survival Kit(70+), Mini Characters(25) |
| **[Quaternius](https://quaternius.com/)** | 1,400+ 모델 | FBX/OBJ/**glTF**/Blend | Stylized Nature MegaKit(110+), Ultimate Animated Animals(12종), Universal Animation Library |
| **[KayKit](https://kaylousberg.itch.io/)** | 팩 단위 | FBX/**glTF** | Adventurers(캐릭터 4종 리깅), Character Animations |
| **[Poly Pizza](https://poly.pizza/)** | 수천 개 | FBX/glTF | 구 Google Poly 아카이브 + 커뮤니티. **로그인 없이 개별 다운로드** |
| **[Poly Haven](https://polyhaven.com/)** | — | glTF | HDRI·텍스처 위주 (모델은 적음) |
| **[OpenGameArt](https://opengameart.org/)** | 혼재 | 제각각 | 라이선스가 CC0/CC-BY/GPL 섞여 있음 — **개별 확인 필수** |

> Kenney·Quaternius·KayKit·Poly Haven은 **이미 glTF/GLB로 배포**한다. 변환 작업이 없다.

### 라이선스 주의

- **CC0** — 마음대로. 출처 표기도 불필요. (위 표의 Kenney/Quaternius/KayKit)
- **OpenGameArt는 팩마다 다르다.** CC-BY면 출처 표기 의무, GPL이면 소스 공개 의무가 붙는다.
- **Mixamo** — 게임에 넣어 배포는 자유. 다만 **원본 애니메이션 파일을 재배포/재판매하는 것은 금지**.
- Sketchfab은 무료 모델이라도 CC-BY가 많다. 다운로드 전 라이선스 확인.

---

## 2. 이 게임에 필요한 목록과 실제 후보

| 필요한 것 | 후보 | 비고 |
|---|---|---|
| 침엽수(눈 덮인) | Kenney **Nature Kit** / Quaternius **Stylized Nature MegaKit**(트리 40종) | 둘 다 충분 |
| 바위·눈더미 | 같은 팩 (Nature MegaKit에 바위 27종) | |
| 얼음 결정 | 마땅한 팩 없음 | **절차적 유지 권장** (지금 것도 괜찮다) |
| 텐트·모닥불·통나무 | Kenney **Survival Kit**(70+) | 이름 그대로 딱 맞음 |
| 플레이어 캐릭터 | KayKit **Adventurers** / Quaternius **Ultimate Animated Character** | 리깅+애니메이션 포함 |
| 걷기·채집 애니메이션 | KayKit **Character Animations** / Quaternius **Universal Animation Library** | CC0, 리타게팅 가능 |
| **곰** | ⚠ **없음** | 아래 참고 |

### 곰 문제 — 확인한 사실

Quaternius **Animated Animal Pack의 12종에 곰은 없다.** 실제 목록:

> Cow, Donkey, Deer, Alpaca, Bull, Fox, **Shiba Inu**, Stag, **Husky**, **Wolf**, White Horse, Horse

선택지 셋:
1. **곰 → 늑대로 교체.** 팩에 있고, 설원 생존 테마에 더 맞고, 애니메이션까지 딸려 온다. **가장 싸다.**
2. Poly Pizza에서 곰 개별 검색 (`poly.pizza/search/bear`) — 있지만 **스타일이 다른 팩과 안 맞을 위험**
3. 곰은 지금처럼 절차적으로 유지

---

## 3. 가장 큰 위험: 스타일 불일치

여러 출처를 섞으면 **폴리 밀도·색 채도·비율이 제각각**이라 한 장면에 놓았을 때 붕 뜬다.
지금의 절차적 그래픽은 적어도 **일관성은 완벽**하다. 이걸 잃는 게 모델 도입의 진짜 비용이다.

원칙: **한 팩 안에서 최대한 해결하고, 모자란 것만 절차적으로 채운다.**

- Kenney 계열로 통일 → Nature Kit + Survival Kit + Mini Characters (같은 작가, 같은 톤)
- Quaternius 계열로 통일 → Stylized Nature MegaKit + Ultimate Animated Character/Animals

두 계열을 섞지 말 것.

---

## 4. 기술 사항

### 포맷
**GLB 하나로 간다.** 메시·머티리얼·텍스처가 한 바이너리에 들어가고 three.js가 바로 읽는다.
(FBX/OBJ는 로더가 무겁거나 머티리얼이 깨진다)

### 로딩
```js
import {GLTFLoader} from './vendor/GLTFLoader.js';
const gltf = await new GLTFLoader().loadAsync('assets/tree.glb');
scene.add(gltf.scene);
```
`GLTFLoader`는 three.js 배포본의 `examples/jsm`에 있다 — **vendor에 같이 받아 둬야** 지금의
"네트워크 불필요" 상태가 유지된다.

### 드로우콜 — 여기가 핵심
나무 13그루를 각각 `scene.add`하면 13× (메시 수)만큼 드로우콜이 늘어난다.
**`InstancedMesh`로 묶으면 나무 전체가 1콜.** 지금 ~300콜이니 이 작업 없이는 도입하면 안 된다.

### 압축
- **Draco** — 지오메트리 90% 감소, 대신 디코딩 시간이 붙는다
- **Meshopt** — 압축률 비슷한데 디코딩이 빠름. gzip과 합치면 Draco에 근접
- 이 게임 규모(로우폴리 수십 개)면 **압축 없이도 충분할 가능성이 높다.** 재 보고 결정할 것

### 애니메이션
- **Mixamo** — 2026년 7월 기준 여전히 무료(Adobe ID 필요), 오토리거 동작.
  다만 **2015년 인수 후 사실상 방치**돼 있고 Fuse는 2020년에 단종됐다.
- CC0 대안: Quaternius **Universal Animation Library**, KayKit **Character Animations**
- three.js는 `AnimationMixer`로 glTF 애니메이션을 그대로 재생한다

---

## 5. 권장안

**전면 교체는 권하지 않는다.** 단계적으로, 효과가 큰 순서로.

### 1단계 — 캐릭터만 (효과 최대)
지금 가장 아쉬운 게 캐릭터다. KayKit Adventurers + Character Animations를 넣으면
걷기·채집 애니메이션이 진짜가 된다. 나무·지형은 그대로 둬도 위화감이 적다.

### 2단계 — 나무·바위
Kenney Nature Kit. 단 **`InstancedMesh` 전환을 같이** 해야 한다.

### 3단계 — 곰 → 늑대
Quaternius Animated Animal Pack. 애니메이션 포함.

### 끝까지 절차적으로 남길 것
얼음 결정, 판매 발판, 관문, 함정 — 맞는 에셋이 없거나 지금 것으로 충분하다.

---

## 6. 그래서, 할 만한가

| | |
|---|---|
| **하면 좋은 이유** | 캐릭터 애니메이션은 코드로 못 따라간다. 아트 격차의 대부분이 여기서 난다 |
| **안 해도 되는 이유** | 지금도 일관성 있고, 로딩 0에 파일 하나로 완결돼 있다 |
| **진짜 비용** | 모델 다운로드가 아니라 **스타일 통일 + InstancedMesh 전환 + 로딩 화면** |

포트폴리오·학습이 목적이면 1단계만 해도 체감이 크다.
지금처럼 "파일 하나로 완결"을 중요하게 본다면 그대로 두는 것도 합리적인 선택이다.

---

## 출처

- [Kenney](https://kenney.nl/) / [Nature Kit](https://kenney.nl/assets/nature-kit) / [Survival Kit](https://kenney.nl/assets/survival-kit) / [Mini Characters](https://kenney.nl/assets/mini-characters)
- [Quaternius](https://quaternius.com/) / [Ultimate Animated Animals](https://quaternius.com/packs/ultimateanimatedanimals.html) / [Stylized Nature MegaKit](https://quaternius.itch.io/stylized-nature-megakit) / [Universal Animation Library](https://quaternius.com/packs/universalanimationlibrary.html)
- [KayKit Character Animations](https://kaylousberg.itch.io/kaykit-animations) / [KayKit Adventurers](https://kaylousberg.itch.io/kaykit-adventurers)
- [Poly Pizza](https://poly.pizza/) / [Animated Animal Pack 번들](https://poly.pizza/bundle/Animated-Animal-Pack-ILAPXeUYiS)
- [awesome-cc0 목록](https://github.com/madjin/awesome-cc0)
- [three.js GLTFLoader 문서](https://threejs.org/docs/pages/GLTFLoader.html) / [DRACOLoader 문서](https://threejs.org/docs/pages/DRACOLoader.html)
- [100 Three.js Performance Tips (2026)](https://www.utsubo.com/blog/threejs-best-practices-100-tips)
- [Mixamo FAQ (Adobe)](https://helpx.adobe.com/creative-cloud/faq/mixamo-faq.html) / [Mixamo와 대안 (2026)](https://app.cinevva.com/guides/free-character-animations-rigging)
