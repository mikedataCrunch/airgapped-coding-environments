# coding-environments: a workflow for an airgapped set up

This repository contains configurations of `python=3.8` coding environments for deep learning with `tensorflow` and `pytorch` managed through `conda`.

I have provided `.yml` files for both `cpu` and `gpu` versions which work on a `ubuntu 18.04` machine running a `NVIDIA Quadro P2200` GPU. The choice of package versions consider compatibility with a future deployment of scripts into a system that maintains support only for `python=3.8`.

## Background
Nowadays, the setting up of coding environments is becoming easier with continuous feature upgrades of package managers like `conda` and with the proliferation of pre-built containerized ecosystems. 

In the data science community, `Anaconda` and `RStudio` offers all the basic `python` and `R` packages that needed to work with structured data. For deep learning practictioners, the set up may be slightly more demanding as necessary software that unlocks the parallel processing capabilities of GPUs. Even so, setting up coding environments are made easy by pre-built and publicly available containerized systems that are maintained by NVIDIA. Suppose you want to set up an environment for a defined task, GPU hardware, and operating system, the workflow can be as simple as (1) going into a public repository of container images like Docker Hub, (2) pulling a befitting docker image, (3) and running that image as a docker container.

However, when working in institutions that favor a more defensive data strategy (i.e., tight cybersecurity policies), you may be required to work in an airgapped system; that is, without having access to the internet. So setting up the environment may not be as easy as a `conda env create -f environment.yml` or `pip install -r requirements.txt`. Simple `clone` and `pull` workflows that use the web may also be impossible in that airgapped machine--so, goodbye to pulls from hubs.

If you're lucky, you may have IT support that can do all of those setting up for you. But what if all you only have encrypted drives at your disposal? In the following seciton, I share a simple workflow that helped me set up a python environment for deep learning on an airgapped machine.

## Requirements

Before we get started with the steps, make sure that you have the following:
- Destination (`dst`) machine OS and source (`src`) machine OS are the same. In my case Ubuntu 22.04 (src) for an Ubuntu 18.04 (dst) was good enough. This is a `conda-pack` requirement. One explanation is filepaths differ between a Windows and a Linux machine; and, these filepaths end up as configs of environment variables. I'll leave it up to you to look up the rest of the reasons behind this compatibility requirement.
- `conda` installed in your `src` machine
- Familiarity with how python environments are set up using `conda install`, `conda env create`, and `pip`.
- Willingness to iterate and expirement on compatibility of dependencies between pip-install and conda-installed packages. I'll elaborate later on.

## Steps

1. Set up your `environment.yml` file and install the environment using: `conda env create -f environment.yml`. Make sure to include `conda-pack` in that file to install it (in case you do not have it in your base env).
2. Activate the environment: `source activate <env_name>` or `conda activate <env_name>` depending on which one is configured in your shell.
3. Pack the environment: `conda-pack`. This tarballs your environment.
4. Look for the `<env_name>.tar.gz` tarball.
5. Transfer `<env_name>.tar.gz` to the `dst` machine.
6. `mkdir <env_name>` 
7. Unpack to that directory: `tar -xzf <env_name>.tar.gz -C <env_name>
8. Activate the environment from the binary directory: `source ./<env_name>/bin/activate
9. Use the environment
10. Deactivate the environment: `source ./<env_name>/bin/deactivate`

## Additional info
- I found that you can be more explicit on which channels to get a specific package from by using this syntax in the `.yml` file: `<channel_name>::<package_name>`. You'll see that I used this a lot since I had problems with getting the pytorch cpu version instead of the cuda one when conda uses the `conda-forge` channel so I explicitly used the `pytorch` as channel by using `pytorch::pytorch`. You'll see this a few more times.
- You may get the shown below. In that case, packages intalled using `pip` (usually invoked later in the `.yml` file), conflicted with packages installed through `conda`. In my case for example, installing `mlflow` through `pip` also installs `pyarrow` as dependency and changed the `pyarrow` previously installed through `conda` channels. This can be fixed using `conda` to install a `pyarrow` version (or a another dependency) that works with the other higher level packages installed by both `pip` and `conda`.
```
CondaPackError:
Files managed by conda were found to have been deleted/overwritten in the
following packages:
```

Most environments install `conda-pack` to facilitate workflows in an air-gapped system.

## Future enhancements

A primary consideration in the use of `conda-pack` is that the source and destination machines should have the same operating systems. This can be facilitated by the use of a `docker` container as source machine where a `conda` environment will be created and packed. The container must mimic the specs of the destination machine at the OS level. This will be implemented in the future.
