
# %load_ext rpy2.ipython

# %%R

puppies <- 15

for (number in 1:puppies) {
    if (number == 1){
        print(paste("There is", number, "puppy"))
        }
    else if (number == 7){
        print(paste("There are ", number, " puppies! That's my favourite number of puppies!"))
        }
    else print(paste("There are", number, "puppies"))
  
}