
# Get latest version of rstan
install.packages("rstan", repos = c("https://mc-stan.org/r-packages/", getOption("repos")))
# Install Kaltoa
devtools::install_git(url = "https://gitlab.com/RTbecard/kaltoa.git", build_manual = T, force = T)
