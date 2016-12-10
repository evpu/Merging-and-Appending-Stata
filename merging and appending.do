clear all
macro drop _all
cd "C:/Users/.../your_directory"

* As an example, create file1, file2 and file3 that would be merged/appended on "id" variable
foreach i of numlist 1 2 3 {
    clear
    set obs `=2 * `i''
    gen id = _n
    gen var`i' = `i'
    save file`i', replace
}

* ************************************************************************
* 1. Merging. Suppose you just need to merge everything without performing any additional computations.
* Then create an empty file with one variable "id", in a loop merge on it all individual datasets.
* The "merged.dta" dataset can be saved in the vary last step after the loop.
* ************************************************************************

clear
gen id = .
foreach i of numlist 1 2 3 {
    merge 1:1 id using file`i', nogen
}
save merged, replace



* ************************************************************************
* 2. Appending. Suppose you need to do additional computations on each file before appending
* Then first save the empty "appended.dta" dataset, afterwards within the loop load each individual
* dataset, perform computations, append to "appended.dta" and save it.
* ************************************************************************
clear
gen id = .
save appended, replace
foreach i of numlist 1 2 3 {
    use file`i', clear
    * Here code to make computations as needed.
    append using appended
    save appended, replace
}

* ************************************************************************
* 3. Other tidbits - Obtaining list of files from a directory (e.g. here file1 file2 and file3) and appending them
* ************************************************************************
clear
local files : dir "C:/Users/.../your_directory" files "file*.dta"
gen id = .
foreach f of local files {
    append using `f'
}
save all_files, replace	


* ************************************************************************
* 4. Other tidbits - Can skip saving the initial empty file (from example 2) and instead use "capture" so that
* Stata would overlook the error when it tries to append something to a non-existing dataset. In the next line
* the dataset is saved, so on the subsequent runs of the loop we append files to it.
* This method is dangerous because if the dataset "appended2.dta" becomes engaged somewhere else (i.e. if for some
* reason Stata could not open it at the moment), then the loop will overwrite the file with a new (incomplete) one.
* ************************************************************************
clear
foreach f of local files {
    use `f', clear
    * Here code to make computations as needed.
    capture append using appended2
    save appended2, replace
}
