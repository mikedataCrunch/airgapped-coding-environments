# coding-environments

This repository contains configurations of python coding environments that are managed through `conda`.

Most environments install `conda-pack` to facilitate workflows in an air-gapped system.

### Future enhancements

A primary consideration in the use of `conda-pack` is that the source and destination machines should have the same operating systems. This can be facilitated by the use of a `docker` container as source machine where a `conda` environment will be created and packed. The container must mimic the specs of the destination machine at the OS level. This will be implemented in the future.
