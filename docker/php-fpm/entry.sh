#!/bin/bash

nohup php artisan schedule:work &

exec $@