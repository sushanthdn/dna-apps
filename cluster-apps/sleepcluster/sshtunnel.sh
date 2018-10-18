#!/usr/bin/env bash

dx ssh --suppress-running-check job-FKfYkQj0YpP6k77Z1kZqFFgq -o 'StrictHostKeyChecking no' -f -L 2000:localhost:4040 -L 3000:localhost:50070 -L 41000:localhost:41000  -N