<p align="center">
  <img src="https://raw.githubusercontent.com/cert-manager/cert-manager/d53c0b9270f8cd90d908460d69502694e1838f5f/logo/logo-small.png" height="256" width="256" alt="cert-manager project logo" />
</p>

# cert-manager base images

⚠️ This repo is an internal part of the cert-manager project's build processes. You shouldn't generally need to use this repo
unless you're actively developing cert-manager or one of its subprojects.

This repository contains [apko](https://apko.dev) build automation for the [cert-manager](https://cert-manager.io) base images.

The resulting images can be found here:

- [quay.io/jetstack/base-static](https://quay.io/repository/jetstack/base-static)
- [quay.io/jetstack/base-static-csi](https://quay.io/repository/jetstack/base-static-csi)

## ⚠️ Issue with Scheduled GitHub Actions

Scheduled GitHub actions disable themselves after [60 days of repository inactivity](https://docs.github.com/en/actions/administering-github-actions/usage-limits-billing-and-administration#disabling-and-enabling-workflows):

> In a public repository, scheduled workflows are automatically disabled when no repository activity has occurred in 60 days.

This repo uses a lot of automation to maintain the base images, with the side-effect that very little work is needed in this repo on a regular basis
and so there's a risk that this disablement will happen on this repo.

As an initial low-tech solution to this problem, we have calendar reminders to create a PR for this repo at least every 60 days.

<!-- Counter to bump for the low tech solution mentioned above: 1 -->
