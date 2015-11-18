#!/bin/bash

cat password-store.private | sed 's#.*@.*:#redacted@redacted.tld:#g;s#/.*/#/path-to/#g' > password-store.anonymized
