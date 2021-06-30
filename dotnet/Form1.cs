using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Drawing.Imaging;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using SimplexNoise;

namespace SimplexNoiseTest
{
    public partial class Form1 : Form
    {
        float[,] noise;
        Random rng = new Random();
        Image img = null;

        public Form1()
        {
            InitializeComponent();

            noise = new float[Width, Height];
        }


        private void Form1_Load(object sender, EventArgs e)
        {
            CalculateNoise();
            UpdateImage();
        }


        private void Form1_Paint(object sender, PaintEventArgs e)
        {
            var g = e.Graphics;
            g.DrawImage(img, 0, 0, Width, Height);
        }

        private void Form1_Click(object sender, EventArgs e)
        {
            CalculateNoise();
            UpdateImage();
            this.Refresh();
        }

        private void CalculateNoise()
        {
            var scale = 0.0064f;
            noise = sumOctaves(4, Width, Height, 0.5f, scale);
        }

        // NOTE(Richo): Code adapted from https://cmaher.github.io/posts/working-with-simplex-noise/
        private float[,] sumOctaves(int num_iterations, int w, int h, float persistence, float scale)
        {
            var maxAmp = 0.0f;
            var amp = 1.0f;
            var freq = scale;
            var result = new float[w, h];

            for (int i = 0; i < num_iterations; ++i)
            {
                Noise.Seed = rng.Next();
                var noise = Noise.Calc2D(w, h, freq);
                for (int x = 0; x < w; x++)
                {
                    for (int y = 0; y < h; y++)
                    {
                        result[x, y] += (noise[x, y] / 255) * amp;
                    }
                }
                
                maxAmp += amp;
                amp *= persistence;
                freq *= 2;
            }

            for (int x = 0; x < w; x++)
            {
                for (int y = 0; y < h; y++)
                {
                    result[x, y] /= maxAmp;
                }
            }

            return result;
        }

        private void UpdateImage()
        {
            Bitmap bmp = new Bitmap(Width, Height);
            var data = bmp.LockBits(new Rectangle(0, 0, bmp.Width, bmp.Height), 
                ImageLockMode.WriteOnly, PixelFormat.Format32bppArgb);

            var water_deep = Color.FromArgb(3, 103, 176).ToArgb();
            var water_shallow = Color.FromArgb(23, 123, 196).ToArgb();
            var sand = Color.FromArgb(227, 225, 84).ToArgb();
            var forest = Color.FromArgb(36, 173, 60).ToArgb();
            var mountain = Color.FromArgb(62, 60, 57).ToArgb();
            var snow = Color.FromArgb(254, 254, 254).ToArgb();

            unsafe
            {
                byte* ptr = (byte*)data.Scan0;
                int height = bmp.Height;
                int width = bmp.Width;
                for (int y = 0; y < height; y++)
                {
                    int* row = (int*)ptr;
                    for (int x = 0; x < width; x++)
                    {
                        int* color = row++;
                        var n = noise[x, y];
                        if (n > 0.745f)
                        {
                            *color = snow;
                        }
                        else if (n > 0.65f)
                        {
                            *color = mountain;
                        }
                        else if (n > 0.498f)
                        {
                            *color = forest;
                        }
                        else if (n > 0.466f)
                        {
                            *color = sand;
                        }
                        else if (n > 0.366f)
                        {
                            *color = water_shallow;
                        }
                        else
                        {
                            *color = water_deep;
                        }
                        //*color = Color.FromArgb((int)(noise[x, y] * 255), 0, 0).ToArgb();
                        
                    }
                    ptr += data.Stride;
                }
            }

            bmp.UnlockBits(data); 
            img = bmp;
        }
    }
}
