#!/bin/bash

#Deploy infrastructure
terraform destroy

# Build website
cd web
terraform destroy
