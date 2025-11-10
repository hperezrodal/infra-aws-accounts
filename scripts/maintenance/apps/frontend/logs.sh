#!/bin/bash
source $BASH_LIBRARY_PATH/lib-loader.sh

lib_k8s_view_pod_logs "frontend" "app=frontend"
  