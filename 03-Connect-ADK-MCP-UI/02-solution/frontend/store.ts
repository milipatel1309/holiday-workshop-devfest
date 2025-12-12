import { create } from 'zustand';

export enum AppPhase {
  HERO = 0,    // Single photo
  GATHER = 1,  // Small group
  CHAOS = 2,   // Explosion
  FORMED = 3,  // Tree shape
}

interface AppState {
  phase: AppPhase;
  setPhase: (phase: AppPhase) => void;

  // Gesture State
  handPresent: boolean;
  handOpen: boolean; // True = Open (Chaos), False = Closed (Gather)
  handPosition: { x: number; y: number }; // Normalized -1 to 1
  handLandmarks: { x: number; y: number }[]; // 21 points normalized 0-1 (screen space)

  setHandState: (present: boolean, open: boolean, x: number, y: number, landmarks?: { x: number; y: number }[]) => void;

  // Camera Rig
  cameraZoom: number;
  setCameraZoom: (zoom: number) => void;

  // Customization
  treeState: {
    lights_color: string;
    ornament_texture: string;
    theme: string;
  };
  setTreeState: (newState: any) => void;
}

export const useStore = create<AppState>((set) => ({
  phase: AppPhase.HERO,
  setPhase: (phase) => set({ phase }),

  handPresent: false,
  handOpen: true,
  handPosition: { x: 0, y: 0 },
  handLandmarks: [],

  setHandState: (present, open, x, y, landmarks) => set({
    handPresent: present,
    handOpen: open,
    handPosition: { x, y },
    handLandmarks: landmarks || []
  }),

  cameraZoom: 1,
  setCameraZoom: (zoom) => set({ cameraZoom: zoom }),

  // Customization from Chat
  treeState: {
    lights_color: "warm_white",
    ornament_texture: "default_gold",
    theme: "emerald_gold"
  },
  setTreeState: (newState) => set((state) => ({ treeState: { ...state.treeState, ...newState } })),
}));