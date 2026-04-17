#!/bin/bash
python3 -u load_tweets.py --db=postgresql://postgres:pass@localhost:15457/postgres --inputs $1
