#!/bin/bash

find "/run/media/felipe/341A-4340" -type f -mtime +5 -exec rm {} \;
