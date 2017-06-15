**Micron-scale spatial distribution and speciation of sulfate in sedimentary carbonates**

Catherine V. Rose, Samuel M. Webb, Matthew Newville, Antonio Lanzirotti, Jocelyn A. Richardson, Nicholas J. Tosca, Jeffrey G. Catalano, Alexander S. Bradley, David A. Fike

These files contain the R code used to process synchrotron sulfate concentrations, and compare the  and compare the concentrations among the various ROIs

Text files contain the data for the two sectors analyzed. These are referred to as the "Heart" sector and the "Anvil sector". 

Questions regarding these files should be addressed to

Alex Bradley abradley@eps.wustl.edu

The included files are:

***Heart_SO4conc1.txt***: synchrotron sulfate concentrations for Heart sector. This is a tab-delimited file. The first column is the y-coordinate (in microns), the second column is the x-coordinate, the third column is the sulfate concentration in ppm, and the fourth column is the number identifier for the region of interest (ROI) encoded by synchrotron software (roi.raw). The roi.raw is encoded here as roi.raw = 2^(roi - 1), where roi varies from 1 to 9. As reported in the text, Heart sector contains ROIs = 1 to 9. 

***Anvil_SO4conc1.txt***: synchrotron sulfate concentrations for Anvil sector. This is a tab-delimited file. The first column is the y-coordinate (in microns), the second column is the x-coordinate, the third column is the sulfate concentration in ppm, and the fourth column is the number identifier for the region of interest (ROI) encoded by synchrotron software (roi.raw). The roi.raw is encoded here as roi.raw = 2^(roi - 1), where roi varies from 1 to 10. As reported in the text, for the Anvil sector we convert the roi.raw to a roi (1 to 10) and then add 9 to each Anvil ROI, yielding the numbers 10 to 19. This avoids duplicating ROIs with the Heart sector.  

***synchrotron.analysis.R***: This file imports the two sector datafiles, and computes qqnorms, and produces boxplots. It also computes the MLE best fit mean and standard deviation for each ROI after excluding outliers. The functions used to do this are defined in sync.roi.functions.R

***sync.roi.functions.R***: defines functions used by synchrotron.analysis.R

***README.md***: this file
