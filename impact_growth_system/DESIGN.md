---
name: Impact & Growth System
colors:
  surface: '#f8f9ff'
  surface-dim: '#cbdbf5'
  surface-bright: '#f8f9ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#eff4ff'
  surface-container: '#e5eeff'
  surface-container-high: '#dce9ff'
  surface-container-highest: '#d3e4fe'
  on-surface: '#0b1c30'
  on-surface-variant: '#3d4947'
  inverse-surface: '#213145'
  inverse-on-surface: '#eaf1ff'
  outline: '#6d7a77'
  outline-variant: '#bcc9c6'
  surface-tint: '#006a61'
  primary: '#00685f'
  on-primary: '#ffffff'
  primary-container: '#008378'
  on-primary-container: '#f4fffc'
  inverse-primary: '#6bd8cb'
  secondary: '#0051d5'
  on-secondary: '#ffffff'
  secondary-container: '#316bf3'
  on-secondary-container: '#fefcff'
  tertiary: '#825100'
  on-tertiary: '#ffffff'
  tertiary-container: '#a36700'
  on-tertiary-container: '#fffbff'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#89f5e7'
  primary-fixed-dim: '#6bd8cb'
  on-primary-fixed: '#00201d'
  on-primary-fixed-variant: '#005049'
  secondary-fixed: '#dbe1ff'
  secondary-fixed-dim: '#b4c5ff'
  on-secondary-fixed: '#00174b'
  on-secondary-fixed-variant: '#003ea8'
  tertiary-fixed: '#ffddb8'
  tertiary-fixed-dim: '#ffb95f'
  on-tertiary-fixed: '#2a1700'
  on-tertiary-fixed-variant: '#653e00'
  background: '#f8f9ff'
  on-background: '#0b1c30'
  surface-variant: '#d3e4fe'
typography:
  display-lg:
    fontFamily: Inter
    fontSize: 48px
    fontWeight: '800'
    lineHeight: '1.1'
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '700'
    lineHeight: '1.2'
    letterSpacing: -0.01em
  headline-lg-mobile:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '700'
    lineHeight: '1.2'
  headline-md:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '600'
    lineHeight: '1.3'
  body-lg:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '400'
    lineHeight: '1.6'
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: '1.5'
  label-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '600'
    lineHeight: '1.4'
    letterSpacing: 0.01em
  label-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '500'
    lineHeight: '1.4'
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 8px
  xs: 4px
  sm: 12px
  md: 24px
  lg: 40px
  xl: 64px
  gutter: 20px
  margin-mobile: 16px
  margin-desktop: auto
  max-width-content: 1200px
---

## Brand & Style
The design system is built to bridge the gap between professional networking and community-driven action. It targets passionate individuals looking for structured, meaningful volunteer opportunities. The personality is **optimistic, reliable, and motivating**.

The visual style is a hybrid approach:
- **Productivity Minimalism (Notion-inspired):** High use of whitespace, clear information hierarchy, and a focus on content over decoration.
- **Professional Connectivity (LinkedIn-inspired):** Trustworthy structural layouts and a focus on personal profiles and achievements.
- **Subtle Gamification (Duolingo-inspired):** Use of vibrant accent gradients, rounded UI elements, and expressive visual feedback for progress and milestones.

The goal is to make the act of volunteering feel like a professional advancement while maintaining the warmth of a social community.

## Colors
The palette uses a sophisticated mix of teals and blues to establish trust and professional energy. 

- **Primary Teal (#0D9488):** Used for main actions, active states, and success indicators.
- **Secondary Blue (#2563EB):** Used for navigation, links, and profile-related elements.
- **Gradients:** A linear gradient of Primary Teal to Secondary Blue is used for "High Impact" moments like progress bars, hero headers, and primary call-to-action buttons.
- **Tertiary Amber (#F59E0B):** Reserved specifically for gamified elements, such as badges, points, and streak notifications, to provide a warm "reward" contrast.
- **Neutrals:** Soft grays are used for borders and secondary text to maintain a low-friction, clean interface.

## Typography
This design system utilizes **Inter** for its exceptional legibility and systematic feel. The type scale is designed to feel structured yet approachable.

- **Headlines:** Feature tight letter-spacing and heavy weights to create a sense of importance and momentum.
- **Body Text:** Set with generous line height to ensure readability in long-form volunteer descriptions or community posts.
- **Labels:** Used for metadata, badges, and small UI controls. These often utilize slightly heavier weights (SemiBold) to remain legible at smaller scales.

## Layout & Spacing
The layout follows a **fluid grid** model with a maximum content width of 1200px for desktop to maintain readability.

- **Rhythm:** A strict 8px baseline grid ensures vertical consistency across all components.
- **Desktop:** 12-column grid with 24px gutters. Sidebars are typically fixed at 280px for navigation or profile summaries.
- **Mobile:** Single column layout with 16px horizontal margins. 
- **Containers:** Content is grouped into logical sections using generous padding (24px - 32px) to prevent the UI from feeling cluttered, mimicking the "breathable" nature of modern productivity tools.

## Elevation & Depth
Depth is conveyed through a combination of **tonal layering** and **ambient shadows**.

- **Surface 0:** The main background (#F8FAFC), used to provide a cool, calm foundation.
- **Surface 1:** Pure white (#FFFFFF) cards and containers. These use a very soft, diffused shadow (0px 4px 20px rgba(0, 0, 0, 0.04)) to appear slightly lifted.
- **Surface 2 (Interactive):** When a user hovers over a card or button, the shadow deepens and the element may scale slightly (1.02x) to provide a tactile, gamified response.
- **Glassmorphism:** Navigation bars and sticky headers use a subtle backdrop blur (12px) with a semi-transparent white fill (80% opacity) to maintain context of the content scrolling beneath them.

## Shapes
The shape language is consistently rounded to evoke a "friendly" and "accessible" feeling. 

- **Standard Elements:** Buttons and input fields use a 0.5rem (8px) radius.
- **Containers:** Main content cards and profile sections use a 1rem (16px) radius for a softer, modern appearance.
- **Gamified Elements:** Badges and progress bar caps use fully rounded "pill" shapes to differentiate them from functional UI components.

## Components
- **Buttons:** Primary buttons feature a Teal-to-Blue gradient with white text. Secondary buttons use a subtle gray outline or a soft teal tint background.
- **Cards:** Rounded (16px) with a 1px border (#E2E8F0) and the "Surface 1" shadow. Cards for "Impact Stats" may include a subtle colored top-border to categorize different types of achievements.
- **Progress Bars:** Thick (12px height) tracks with a primary gradient fill. The track background is a soft gray (#F1F5F9).
- **Badges:** Small, pill-shaped markers for skills (e.g., "Leadership," "Teaching"). Use a light tint of the Primary color with dark text.
- **Input Fields:** Minimalist style with a 1px border that shifts to Primary Teal on focus. Labels are placed above the field in `label-md` style.
- **Lists:** Used for volunteer opportunities. Each item is a "Flat Card" with clear vertical separation, utilizing the `body-md` for descriptions and `label-sm` for date/location metadata.
- **Avatars:** Circular with a 2px white border and a soft shadow, often accompanied by a small "Level" badge in the corner for gamification.