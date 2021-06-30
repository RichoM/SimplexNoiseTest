
function updateImage() {
  let ctx = world.getContext("2d");
  const w = Math.min(1024, window.innerWidth);
  const h = Math.min(1024, window.innerHeight);
  world.width = w;
  world.height = h;

  // Colors
  let water_deep = [3, 103, 176];
  let water_shallow = [23, 123, 196];
  let sand = [227, 225, 84];
  let forest = [36, 173, 60];
  let mountain = [62, 60, 57];
  let snow = [254, 254, 254];

  let img_data = ctx.getImageData(0, 0, w, h);
  let noise = calculateNoise(w, h);
  for (let y = 0; y < h; y++) {
    for (let x = 0; x < w; x++) {
      let color;
      let i = (y * w) + x;
      let n = noise[i];
      if (n > 0.745) { color = snow; }
      else if (n > 0.65) { color = mountain; }
      else if (n > 0.498) { color = forest; }
      else if (n > 0.466) { color = sand; }
      else if (n > 0.366) { color = water_shallow; }
      else { color = water_deep; }

      img_data.data[i * 4 + 0] = color[0];
      img_data.data[i * 4 + 1] = color[1];
      img_data.data[i * 4 + 2] = color[2];
      img_data.data[i * 4 + 3] = 255;
    }
  }
  ctx.putImageData(img_data, 0, 0);
}

function calculateNoise(w, h) {
  let scale = 0.0064;
  return sumOctaves(4, w, h, 0.5, scale);
}

// NOTE(Richo): Code adapted from https://cmaher.github.io/posts/working-with-simplex-noise/
function sumOctaves(num_iterations, w, h, persistence, scale) {
  let maxAmp = 0.0;
  let amp = 1.0;
  let freq = scale;
  let result = new Float32Array(w * h);
  let simplex = new SimplexNoise();

  for (let i = 0; i < num_iterations; ++i) {
    for (let x = 0; x < w; x++) {
      for (let y = 0; y < h; y++) {
        result[(y * w) + x] += (simplex.noise2D(x * freq, y * freq) * 0.5 + 0.5) * amp;
      }
    }
    maxAmp += amp;
    amp *= persistence;
    freq *= 2;
  }

  for (let x = 0; x < w; x++) {
    for (let y = 0; y < h; y++) {
      result[(y * w) + x] /= maxAmp;
    }
  }

  return result;
}

window.onload = updateImage;
world.onclick = updateImage;
