#!/bin/bash

# couchdb import
cdbimport() {
  SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
  . "$SCRIPT_DIR"/cdbimport_conf.sh
  database_name=$1

  export_url=${source_url}${database_name}'/_all_docs?include_docs=true'
  data=$(curl -u ${source_username}:${source_password} $export_url --location)
  data=$(echo $data | jq -r '.rows|.[]|.doc' | jq -s 'del(.[]._rev)|{docs: .}')
  echo $data | POST -sS ${import_url}${database_name}'/_bulk_docs' -c "application/json" -C "${import_username}"':'"${import_password}"
}
cdbimport "$1"
