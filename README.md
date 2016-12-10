# Merging and Appending datasets in Stata
Merging several datasets in a loop might be not very straightforward because there must exist an original dataset on which all the following ones are merged.
I have seen a variety of approaches to address this. For example, first working with dataset 1, saving it, then in a loop merging datasets 2 to N. Or looping over 1 to N, but within the loop creating additional if-statements to treat the first iteration of the loop differently (to save the first file) than the subsequent (to merge the remaining files).

The code in "merging and appending.do" provides what in my opinion is the most efficient way to merge several files using a loop.

In essence, first creating a file that contains zero observations and has defined variables on which the datasets are going to be merged ("id" in this example)
    clear
    gen id = .
and then in a loop merging onto it the remaining files:
    foreach i of numlist 1 2 3 {
        merge 1:1 id using `file`i'', nogen
    }
    save merged, replace

The additional examples show a version of this for cases when some additional operations need to be applied to each dataset before merging, how to get from some directory a list of files for merging, and how to use "capture" to also solve this problem, but in a riskier way.
