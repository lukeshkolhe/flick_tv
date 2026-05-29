# Home Screen UI Plan

Reference: [Screen recording](https://drive.google.com/file/d/1vrmnfr2j1vwE1nQyh6cSyF1stJdBkwJ1/view) (~8.5s, Blinkit Money–style onboarding).

This document captures what to build on the home screen and how to implement it in Flutter. Branding should use **Flick TV** (or assignment-specific naming) instead of “blinkit” where shown below.

---

## Target experience

The screen uses a **staged intro animation**, then settles on a scrollable marketing / wallet-style layout.

### Animation phases

| Phase | Timing (approx.) | What appears |
|-------|------------------|--------------|
| 1 | 0.0–0.3s | Near-black background; circular back button (top-left) |
| 2 | 0.3–1.0s | Golden dotted gradient at top; confetti; 3D wallet with ₹ |
| 3 | 1.0–1.8s | Brand label (e.g. `flick`) below wallet |
| 4 | 1.8–2.5s | Large `MONEY` title (bold, wide letter-spacing) |
| 5 | 2.5–3.5s | Hero shifts up; settings icon (top-right) |
| 6 | 3.5–5.0s | Three feature cards stagger in |
| 7 | 5.0s+ | Green **Add Money** CTA; **Claim Gift Card** row; footer watermark |

### Final layout (static end state)

```
┌─────────────────────────────┐
│ ← back          settings ⚙  │
│   ··· golden dot pattern ···│
│         [wallet ₹]          │
│         flick / MONEY       │
│  ┌─────────────────────┐    │
│  │ icon │ Single tap... │   │  ×3 feature cards
│  └─────────────────────┘    │
│  [      Add Money       ]   │  primary CTA
│  ┌ gift │ Claim Gift Card >│
│  Enjoy seamless one tap...  │  low-opacity watermark
└─────────────────────────────┘
```

---

## Visual spec

| Element | Value / notes |
|---------|----------------|
| Background | `#121212` (near black) |
| Card surface | `#2B2B2B`, corner radius 12–16 |
| Primary CTA | `#3C8224`, full width, height ~52 |
| Top accent | Golden gradient + fading dot grid (`CustomPainter` or asset) |
| Title “MONEY” | ~42sp, w800, letter-spacing ~6 |
| Brand label | ~16sp, w600, white |
| Body / subtitle | Light grey, 2 lines max per card |
| Nav buttons | 40×40 circle, `white @ 12%` opacity |
| Footer watermark | Large grey text, opacity ~0.15 |

### Feature cards (content)

1. **Single tap payments** — “Enjoy seamless payments without the wait for OTPs”
2. Second benefit (icon: tap / NFC on phone) — align copy with product brief
3. Third benefit (icon: refund / coins on phone) — align copy with product brief

### Assets needed

- Wallet hero (PNG @2x/3x or SVG)
- Three small feature icons (or placeholder icons until art is ready)
- Gift box icon for gift-card row
- Optional: confetti as particle layer or Lottie

---

## Flutter widget breakdown

| Widget / file | Responsibility |
|---------------|----------------|
| `HomeScreen` | `Scaffold`, `SafeArea`, animation orchestration |
| `MoneyBackground` | Base color + top gradient + dot pattern |
| `ConfettiLayer` | Optional particles (package or lightweight `Stack`) |
| `MoneyHero` | Wallet image + brand + `MONEY` title |
| `FeatureCard` | Reusable row: icon box + title + subtitle |
| `GiftCardTile` | Gift icon + title + chevron |
| `HomeTopBar` | Back + settings circular buttons |

### Layout approach

- Root: `Stack` — background → confetti → scrollable / animated content.
- Main column: `Column` or `CustomScrollView` for hero + cards + CTAs on small screens.
- Intro: single `AnimationController` (~4–5s) with `Interval` curves, or `flutter_animate` for less boilerplate.

### Suggested dependencies (optional)

```yaml
# confetti: ^0.7.0
# flutter_animate: ^4.5.0
# flutter_svg: ^2.0.0
# google_fonts: ^6.2.1
```

Register assets in `pubspec.yaml` under `assets/images/`.

---

## Implementation order

1. **Static final frame** — colors, hero, cards, CTA, gift row (no animation).
2. **Background + top bar** — gradient, dots, back/settings.
3. **Intro animation** — controller + staged fades/slides.
4. **Polish** — confetti, haptics, accessibility labels, scroll on short devices.
5. **Wire domain** — load feature list from use case / repository (see [ARCHITECTURE.md](./ARCHITECTURE.md)).

---

## Acceptance checklist

- [ ] Dark theme matches reference contrast
- [ ] Back button visible from frame 1
- [ ] Hero + `MONEY` match spacing and weight
- [ ] Three cards with consistent padding and radius
- [ ] Primary CTA full width and tappable
- [ ] Gift card row navigates or shows placeholder action
- [ ] Animation completes without overflow on small phones
- [ ] `Semantics` / screen reader labels on buttons and cards
