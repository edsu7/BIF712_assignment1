#!C:\Strawberry\perl\bin\perl.exe

package Element;

use strict;
use warnings;
#Create object hash for elements
sub new{
    my $class= shift;
    my $self = {
        _atomicName => shift,
        _atomicWeight => shift,
        _atomicValence => shift,
    };
    bless $self;
    return $self;
}
#customize elements
my $hydrogen = new Element ("H",1.0079,-1);#1
my $oxygen = new Element ("O",15.994,-2);#2
my $nitrogen = new Element ("N",14.0067,-3);#3
my $carbon = new Element ("C",12.0107,-4);#4

#place elements in array for easier calling
my @flaskElements = (
$hydrogen,$oxygen,$nitrogen,$carbon
);

#AA array for call up
my @aminoAcid = ([ 
89.0929,
133.1024,
147.1289,
165.1887,
75.0664,
155.1542,
146.1870,
131.1724,
132.1176,
115.1301,
146.1441,
174.2004,
105.0923,
119.1188,
117.1459,
204.2247,
181.1881,
],
[
"C3N1O2H3",
"C4N1O4H7",
"C5N1O4H9",
"C9N1O2H11",
"C2N1O2H5",
"C6N3O2H9",
"C6N1O2H13",
"C6N2O2H14",
"C4N2O3H8",
"C5N1O2H9",
"C5N2O3H10",
"C6N4O2H14",
"C3N1O3H7",
"C4N1O3H9",
"C5N1O2H11",
"C11N2O2H12",
"C9N1O3H11",
],
[
"Alanine",
"Aspartic acid",
"Glutamic acid",
"Phenylalanine",
"Glycine",
"Histidine",
"Isoleucine/Leucine",
"Lysine",
"Asparagine",
"Proline",
"Glutamine",
"Arginine",
"Serine",
"Threonine",
"Valine",
"Tryptophan",
"Tyrosine",
]);

my $time = 0;#keeps track of frequency
START:
my ($molecularWeight)= 0.00; #variables to keep track
my $valenceBalance= 0;
my @molecularFormula = ""; #keeps track of elements called
my $chosenOne = int(rand(4)); #generates random number
my $carbonCount=0; #keeps track of carbon

$time++;
#first iteration as to not break while loop
$molecularWeight += $flaskElements[$chosenOne]->{_atomicWeight};
$valenceBalance += $flaskElements[$chosenOne]->{_atomicValence};
push @molecularFormula, ($flaskElements[$chosenOne]->{_atomicName});

until($molecularWeight>=204.2247||$valenceBalance==0) #loop until fulfilling condition
{
    Phase2: 
    $time++;
    $chosenOne = int(rand(4));
    
    #carbon checker
    if ($chosenOne==3){
        $carbonCount++;
    }
	
    #fulfills double bond requirement when double bond ==3
    if ($carbonCount==3){
        $molecularWeight += ($flaskElements[$chosenOne]->{_atomicWeight});
        push @molecularFormula, ($flaskElements[$chosenOne]->{_atomicName});
		$carbonCount=0;
        goto Phase2; 
    }
	
    #Adds molecular weight
    $molecularWeight += ($flaskElements[$chosenOne]->{_atomicWeight});
	#adds to valence count
    $valenceBalance +=($flaskElements[$chosenOne]->{_atomicValence});
	#adds to formula string
    push @molecularFormula, ($flaskElements[$chosenOne]->{_atomicName});	
	
    #Checks for H2 gas to avoid pre-emptive ending 
	if ($molecularWeight == 2.0158){
		goto Phase2;
	}
	
    #accounts for for valence electrons used in bond formation
    $valenceBalance+= 2;
    
    #breaking valence balance and hydrogen addition
    if ($valenceBalance<=-5){
        push @molecularFormula,"H";
        push @molecularFormula,"H";
        push @molecularFormula,"H";
        $molecularWeight += $flaskElements[0]->{_atomicWeight}*3;
        $valenceBalance+=3;
        next;
    }
};
print "Molecular Weight : $molecularWeight\n";
print "Number of years past: $time\n";

my $myString = "";
#iterates through each element(carbon,nitrogen,oxygen,hydrogen) counting each occurance in the string
for (my $j=3;$j>=0;$j--){ 
    my $myCount = grep (/$flaskElements[$j]->{_atomicName}/,@molecularFormula);
    $myString = $myString . $flaskElements[$j]->{_atomicName} . $myCount;
    };
print $myString;
print "\n";

#compares counted molecules with aminoacid library; exits program if aa is found
for (my $k=0;$k<17;$k++){
    if ($myString eq $aminoAcid[1][$k]){
        print "You have found $aminoAcid[2][$k]\n";
        exit;
    }
}

#if program has yet to find aa re-iterates; if exceeds 3.8 billion years kills program
if ($time<3800000000){
    print "\n";
    goto START;
}
else {
    print "Life never formed on planet Earth!";
    exit;}



#TESTING AND CALCULATIONS
#1.A) Serine
#1.B) 6162 years
#1.C) (6162+1646+1866+3832+4533+2413+5100)/7
#     On average = 3650 Years
#2
# If the atoms are favoured to make bonds, amino acid formation is highly favourable. Stability,however,
#would be a different story as the conditions of a primordial world would be unknown. 
#3
#- Technically the less complex amino acids should appear more often. As each element is at random,
#chances increase exponentially when another element is added. As such one would expect alanine and glycine
#to appear more often. However in our case, serione and threonine appears more often suggesting a selection
#for oxygen?
#4
#- increasing max MW to allow for more complex molecules
#- decreasing amount of hydrogens added when valence amount exceeds three; Bigger range of molecules
#- increasing valence amount to allow for more complex molecules
#- getting rid of simpler AAs in @aminoAcid to allow for complex ones

#Oath:
#
#Student Assignment Submission Form
#==================================
#I/we declare that the attached assignment is wholly my/our
#own work in accordance with Seneca Academic Policy.  No part of this
#assignment has been copied manually or electronically from any
#other source (including web sites) or distributed to other students.
#
#Name(s):Edmund Su                                       Student ID(s):#104699160