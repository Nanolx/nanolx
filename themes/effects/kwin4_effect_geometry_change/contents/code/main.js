"use strict";

class GeometryChangeEffect {
  constructor() {
    effect.configChanged.connect(this.loadConfig.bind(this));
    // animationEnded(window, animationId)
    effect.animationEnded.connect(this._onAnimationEnded.bind(this));

    const manageFn = this.manage.bind(this);
    effects.windowAdded.connect(manageFn);
    effects.stackingOrder.forEach(manageFn);

    // cleanup when windows are deleted
    effects.windowDeleted.connect((w) => {
      if (w && w.geometryChangeData) {
        w.geometryChangeData = null;
      }
    });

    this.userResizing = false;
    this.loadConfig();
  }

  loadConfig() {
    const duration = effect.readConfig("Duration", 250);
    this.duration = animationTime(duration);
    this.excludedWindowClasses = effect.readConfig("ExcludedWindowClasses", "krunner,yakuake")
      .split(",")
      .map(s => s.trim())
      .filter(Boolean);
  }

  manage(window) {
    // per-window bookkeeping
    window.geometryChangeData = {
      createdTime: Date.now(),
      animationIds: {},
      maximizedStateAboutToChange: false,
    };

    window.windowFrameGeometryChanged.connect(this.onWindowFrameGeometryChanged.bind(this));
    window.windowMaximizedStateAboutToChange.connect(this.onWindowMaximizedStateAboutToChange.bind(this));
    window.windowStartUserMovedResized.connect(this.onWindowStartUserMovedResized.bind(this));
    window.windowFinishUserMovedResized.connect(this.onWindowFinishUserMovedResized.bind(this));
  }

  _onAnimationEnded(window, animationId) {
    if (!window || !window.geometryChangeData) return;
    const g = window.geometryChangeData;
    if (!g.animationIds) return;

    const key = String(animationId);
    if (g.animationIds[key]) {
      delete g.animationIds[key];
    }

    // when our set is empty, restore blur role
    if (Object.keys(g.animationIds).length === 0) {
      g.animationIds = {};
      window.setData(Effect.WindowForceBlurRole, null);
    }
  }

  isWindowClassExluded(windowClass) {
    if (!windowClass) return false;
    return windowClass.split(" ").some(part => this.excludedWindowClasses.includes(part));
  }

  onWindowFrameGeometryChanged(window, oldGeometry) {
    if (!window || !window.geometryChangeData) return;

    const windowTypeSupportsAnimation = window.normalWindow || window.dialog || window.modal;
    const isUserMoveResize = window.move || window.resize || this.userResizing;
    const maximizationChange = window.geometryChangeData.maximizedStateAboutToChange;
    window.geometryChangeData.maximizedStateAboutToChange = false;

    if (
      !window.managed ||
      !window.visible ||
      !window.onCurrentDesktop ||
      window.minimized ||
      !windowTypeSupportsAnimation ||
      (isUserMoveResize && !maximizationChange) ||
      this.isWindowClassExluded(window.windowClass)
    ) {
      return;
    }

    const now = Date.now();
    const windowAgeMs = now - window.geometryChangeData.createdTime;
    if (windowAgeMs < 0) {
      window.geometryChangeData.createdTime = now;
    } else if (windowAgeMs < 10) {
      return;
    }

    const newGeometry = window.geometry;
    const xDelta = newGeometry.x - oldGeometry.x;
    const yDelta = newGeometry.y - oldGeometry.y;
    const widthDelta = newGeometry.width - oldGeometry.width;
    const heightDelta = newGeometry.height - oldGeometry.height;

    if (xDelta === 0 && yDelta === 0 && widthDelta === 0 && heightDelta === 0) {
      return;
    }

    const prevIds = Object.keys(window.geometryChangeData.animationIds || {}).map(id => {
      const n = Number(id);
      return Number.isFinite(n) ? n : id;
    });

    if (prevIds.length > 0) {
      try {
        cancel(prevIds);
      } catch (e) {
        print("GeometryChangeEffect: cancel() threw:", e);
      }
      // wipe our bookkeeping — canceled animations won't fire animationEnded for us.
      window.geometryChangeData.animationIds = {};
    }
    // -----------------------------------------------------------------

    const widthRatio = oldGeometry.width / newGeometry.width;
    const heightRatio = oldGeometry.height / newGeometry.height;

    const animations = [
      {
        type: Effect.Translation,
        from: {
          value1: -xDelta - widthDelta / 2,
          value2: -yDelta - heightDelta / 2,
        },
        to: {
          value1: 0,
          value2: 0,
        },
      },
      {
        type: Effect.Scale,
        from: {
          value1: widthRatio,
          value2: heightRatio,
        },
        to: {
          value1: 1,
          value2: 1,
        },
      },
    ];

    const result = animate({
      window: window,
      duration: this.duration,
      curve: QEasingCurve.OutExpo,
      animations: animations,
    });

    let ids = [];
    if (Array.isArray(result)) {
      ids = result;
    } else if (result !== undefined && result !== null) {
      ids = [result];
    }

    for (let i = 0; i < ids.length; ++i) {
      const idKey = String(ids[i]);
      window.geometryChangeData.animationIds[idKey] = true;
    }
    if (ids.length > 0) {
      window.setData(Effect.WindowForceBlurRole, true);
    }
  }

  onWindowMaximizedStateAboutToChange(window, horizontal, vertical) {
    if (!window || !window.geometryChangeData) return;
    window.geometryChangeData.maximizedStateAboutToChange = true;
  }

  onWindowStartUserMovedResized(window) {
    this.userResizing = true;
  }

  onWindowFinishUserMovedResized(window) {
    this.userResizing = false;
  }
}

new GeometryChangeEffect();
