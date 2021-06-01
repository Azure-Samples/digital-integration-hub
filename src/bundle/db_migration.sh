#!/bin/bash

# Set up env
export PGDB=$1
export PGHOST=$2
export PGPASSWORD=$3
export PGUSER=$4
export PGSSLMODE=require

# run the migration script command
npm run migrate_db --prefix=function