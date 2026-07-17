function mergeConfigs(sourceConfig, newConfig) {
  for (var key in sourceConfig) {
    if (Array.isArray(sourceConfig[key])) {
      if (!newConfig.hasOwnProperty(key)) {
        newConfig[key] = sourceConfig[key].slice();
      }
    } else if (typeof sourceConfig[key] === "object" && sourceConfig[key] !== null) {
      if (!newConfig.hasOwnProperty(key)) {
        newConfig[key] = {};
      }
      mergeConfigs(sourceConfig[key], newConfig[key]);
    } else {
      if (!newConfig.hasOwnProperty(key)) {
        newConfig[key] = sourceConfig[key];
      }
    }
  }
  return newConfig;
}

function getRandomColor(h, s, l, a) {
  h = h ?? Math.random();
  s = s ?? Math.random();
  l = l ?? Math.random();
  a = a ?? 1.0;
  return Qt.hsla(h, s, l, a);
}

function scaleSaturation(color, saturation) {
  return Qt.hsla(color.hslHue, saturation, color.hslLightness, color.a);
}

function scaleLightness(color, lightness) {
  return Qt.hsla(color.hslHue, color.hslSaturation, lightness, color.a);
}

function adjustColor(color, saturationEnabled, saturation, lightnessEnabled, lightness, alpha) {
  if (saturationEnabled) {
    color = scaleSaturation(color, saturation);
  }
  if (lightnessEnabled) {
    color = scaleLightness(color, lightness);
  }
  if (alpha !== 1.0) {
    color = Qt.hsla(color.hslHue, color.hslSaturation, color.hslLightness, alpha);
  }
  return color;
}


function hexToRgb(hex) {
  var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
  return result
    ? {
      r: parseInt(result[1], 16),
      g: parseInt(result[2], 16),
      b: parseInt(result[3], 16),
    }
    : null;
}

function rgbToQtColor(rgb) {
  return Qt.rgba(rgb.r / 255, rgb.g / 255, rgb.b / 255, 1);
}

function hexToQtColor(hex) {
  return rgbToQtColor(hexToRgb(hex));
}

function getColor(lineColor, index, systemColor) {
  let color = Qt.rgba(1, 1, 1, 0);
  switch (lineColor.sourceType) {
    case Enum.ColorSourceType.Custom:
      color = hexToQtColor(lineColor.custom);
      break;
    case Enum.ColorSourceType.System:
      color = systemColor;
      break;
    case Enum.ColorSourceType.Random:
      color = getRandomColor();
      break;
    case Enum.ColorSourceType.List:
      const colorIndex = index % lineColor.list.length;
      color = hexToQtColor(lineColor.list[colorIndex]);
      break;
  }

  color = adjustColor(color, lineColor.saturationEnabled, lineColor.saturation, lineColor.lightnessEnabled, lineColor.lightness, lineColor.alpha);

  return color;
}

