# How to Deploy to Overleaf and Compile Your PDF

Follow these exact steps to compile your paper into a PDF and view all the metrics and images using Overleaf:

## Step 1: Create a New Project in Overleaf
1. Log in to [Overleaf](https://www.overleaf.com/).
2. Click **New Project** -> **Blank Project**.
3. Name it SAKE-IoT Paper and create it.
4. Overleaf will generate a default main.tex file.

## Step 2: Upload Your Paper Content
1. Open your local latex_content.tex file.
2. Select all text (Ctrl+A) and copy it (Ctrl+C).
3. Go back to Overleaf, select all text in the main.tex file (Ctrl+A), and paste your copied content (Ctrl+V), completely replacing the default text.

## Step 3: Create an Images Folder in Overleaf
Overleaf needs your images exactly where the paper is looking for them.
1. In the left-hand files panel of Overleaf, click the **New Folder** icon (a folder with a little plus sign).
2. Name the folder **exactly** esults (all lowercase).
3. We will modify the path in the LaTeX file so it just looks for esults/sim_latency.png.

## Step 4: Upload Your Images to the Results Folder
1. Click the native esults folder you just created in Overleaf so it is selected.
2. Click the **Upload** icon (a piece of paper with an up arrow).
3. Drag and drop these three specific images from your computer:
   - C:\Users\aloob\Downloads\Research Backup\simulation\results\sim_latency.png
   - C:\Users\aloob\Downloads\Research Backup\simulation\results\sim_bandwidth_bar.png
   - C:\Users\aloob\Downloads\Research Backup\simulation\results\sim_energy.png

## Step 5: Fix the Image Paths in Your Code
Right now, your LaTeX code looks for images on your local hard drive like this: ../simulation/results/sim_latency.png. On Overleaf, they are just inside the esults folder.

1. In the Overleaf editor, press Ctrl+F to open the "Find and Replace" tool.
2. In the "**Find**" box, type exactly: ../simulation/results/
3. In the "**Replace**" box, type exactly: esults/
4. Click the **Replace All** button (or "All").

## Step 6: Compile the Paper!
1. Click the big green **Recompile** button at the top right (or press Ctrl+S).
2. Overleaf will process the LaTeX file and generate the PDF on the right side of the screen.
3. Scroll through the PDF. You will see:
   - Your metric images (Latency, Bandwidth, Energy) rendered beautifully.
   - The TikZ protocol flow diagram (Figure 4) generated natively.
   - The Cooja metrics and Nine-Metric table perfectly formatted in Section 8.