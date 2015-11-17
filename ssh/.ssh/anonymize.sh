#!/bin/bash

cat config | sed 's#Host .*#Host XXX#g' > config.anonymized