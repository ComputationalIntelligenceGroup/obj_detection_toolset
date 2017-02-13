// @Integer(value=255) thrHoles
// @Integer(label="Radius of median filter") radius
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
   run("Macro...", "code=[if (v>="+thrHoles+") v=1] stack");
   //run("Minimum...", "radius=15 stack");
   //run("Maximum...", "radius=15 stack");
   selectWindow("temp1");    
   if (nslice>1){
     run("Z Project...", "projection=[Sum Slices]");
   }
   run("8-bit");
   rename("holes_"+titleC);
   save(outFolderH + "/holes_"+titleC);
   saveAs("Text Image", outFolderHcsv+"/holes_"+titleC);
   close("*");
  }
} 
setBatchMode("exit and display");
