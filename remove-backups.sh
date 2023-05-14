#!/bin/bash

find "/run/media/felipe/341A-4340/backups-sdfcscx" -type f -mtime +5 -exec rm {} \;
