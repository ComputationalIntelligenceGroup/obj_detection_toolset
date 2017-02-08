// @Integer(value=255) thrHoles
// @Integer(label="Radius of median filter") radius
// @ImagePlus img
// @File(label="Select the input directory", style="directory") imagesDir
// @File(label="Select an output directory for the holes img", style="directory") outFolderH
// @File(label="Select an output directory for the holes csv", style="directory") outFolderHcsv



setBatchMode(true);
run("Conversions...", " "); //avoid scaling when converting
list = getFileList(imagesDir);
for (i = 0; i < list.length; i++){
  if ( !endsWith(list[i],"/") ){
   IJ.log(list[i]);
   showProgress((i+1)/(list.length));
   open(imagesDir + "/"+ list[i]);
   width=getWidth();
   height=getHeight();   
   nslice=nSlices();
   title=getTitle();
   titleC = replace(title," ","_");
   rename("temp");
   run("Duplicate...", "duplicate range="+1+"-"+nslice+" title=temp1");
   selectWindow("temp1");
   run("Macro...", "code=v=-v+255 stack"); //invert intnsity
   run("Median...", "radius="+radius+" stack");
   run("Macro...", "code=[if (v<"+thrHoles+") v=0] stack");
   run("Macro...", "code=[if (v>="+thrHoles+") v=255] stack");
   //run("Minimum...", "radius=15 stack");
   //run("Maximum...", "radius=15 stack");
   run("Enhance Contrast...", "saturated=0 normalize process_all");
   run("Merge Channels...", "c1=temp1 c4=temp create keep");
   run("Stack to RGB", "slices");
   rename("holesRGB_"+titleC);

   selectWindow("temp1");
   run("Macro...", "code=[if (v==255) v=1] stack");
   run("Z Project...", "projection=[Sum Slices]");
   run("8-bit");
   saveAs("Text Image", dirHoles+"/holes_"+titleC);
   rename("holes_"+title);
   save(outFolderH + "/holes_"+titleC);
   saveAs("Text Image", outFolderHcsv+"/holes_"+titleC);
   close("*");
  }
} 
setBatchMode("exit and display");
