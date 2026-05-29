## MKTG 580: Marketing Aanlytics Fundamentals
## Conjoint Analysis

###############
## Project Forte Hotel ##
## Full profiles: Total 216 profiles (3 x 3 x 3 x 4 x 2)
## Using Fractional Factorial Design: Reducing the number of profiles to evaluate
## But, profles (bundles) are already provided in the data set (Forte Hotel Data (Conjoint, 1 Ratings).xls)
## So, we don't need to create factorial design, but need to make sure that profiles correctly reflect the data
###############

library(conjoint)

# Declare five variables: room, amenity, leisure, extras and delivery
# Include levels of attributes
hotel<-expand.grid(room=c("small suite","large room","room office"),amenity=c("internet","speaker phone", "room fax"),
                     leisure=c("exercise room","pool", "exercise + pool"),
                     extras=c("shoe shine","tape library","fruit cheese","newspaper"),
                     delivery=c("yes", "no"))
hotel
dim(hotel)

####################### NO need to do this for our project
# Fractional Factorial Design: Very Important #########
journeyfactdesign<-caFactorialDesign(data=hotel,type="fractional") 
journeyfactdesign<-caFactorialDesign(data=hotel,type="orthogonal") 
journeyfactdesign

## encoding variable levels of the fractional design
prof=caEncodedDesign(design=journeyfactdesign) 
prof 
###########################

### Questionnaire Develpment and DATA Collection#########################
### Using the above profiles, you can develop a questionnaire
### Collect Data 
### Input format: (1) using semi colon (2) comma separate value, (3) etc
#########################################################################

# data loading
# colon separated data: using read.csv2
# comma and tab separated data: using read.csv
# Make sure that the following excel files are ready for loading

## I copied and pasted data from Forte Hotel Conjoint excel files to new excel files 
## and save each as a csv file, respectively:
## (1) forte_preferences.csv  (2) forte_profiles.csv (3) forte_levels.csv
## (4) forte_simulation1.csv  (5) forte_simulation2.csv
  

preferences=read.csv("forte_preferences.csv", header=TRUE) 
profiles=read.csv("forte_profiles.csv", header=TRUE) 
levelnames=read.csv("forte_levels.csv", header=TRUE) 
simulation1=read.csv("forte_simulation1.csv", header=TRUE)  # for exiting hotels
simulation2=read.csv("forte_simulation2.csv", header=TRUE)  # for new hotels being considered

preferences
profiles 
levelnames
simulation1
simulation2

dim(preferences)
dim(profiles)
dim(levelnames)
dim(simulation1)
dim(simulation2)

# Measurement of part-worths utilities (all respondents): 
partutilities=caPartUtilities(y=preferences,x=profiles,z=levelnames) 
print(head(partutilities))

# Measurement of total utilities (all respondents):
totalutilities=caTotalUtilities(y=preferences,x=profiles) 
print(head(totalutilities)) 

# Determining the relative importance of features (for the respondent No.26, Nissa):
importance=caImportance(y=preferences[26,],x=profiles) 
print(importance)

# Using the Conjoint function for the respondent No. 26
Conjoint(preferences[26,],profiles,levelnames) 


# # Using the Conjoint function for all respondents
Conjoint(y=preferences,x=profiles,z=levelnames)
 


### ---------------------------
### Segmentation of respondents
### ---------------------------

### Segmentation using k-means method - the default division into 2 segments: 

segments<-caSegmentation(preferences,profiles) 
print(segments$seg) 


### Segmentation using k-means method - division into 3 segments:
segments<-caSegmentation(preferences,profiles,c=3) 
print(segments$seg)

## Visualization of the division into 2 segments: 

summary(segments)
require(fpc)  
plotcluster(segments$util,segments$sclu) 

require(fpc) 
require(broom) 
require(ggplot2) 
dcf<-discrcoord(segments$util,segments$sclu) 
assignments<-augment(segments$segm,dcf$proj[,1:2]) 
ggplot(assignments)+geom_point(aes(x=X1,y=X2,color= .cluster))+labs(color="Cluster Assignment",title="K-Means Clustering Results")


### Market share analysis of simulation profiles
### using maximum utility model, BTL probability model (Bradley-Terry-Luce Model) and logit model:

ShowAllSimulations(sym=simulation1,y=preferences,x=profiles)
ShowAllSimulations(sym=simulation2,y=preferences,x=profiles)
caLogit(simulation1, preferences, profiles)

# End




