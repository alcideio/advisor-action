#!/usr/bin/env bash

# Copyright Alcide IO Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o errexit
set -o nounset
set -o pipefail

DEFAULT_KIND_VERSION=v0.7.0
DEFAULT_CLUSTER_NAME=chart-testing
KUBECTL_VERSION=v1.17.0

show_help() {
cat << EOF
Usage: $(basename "$0") <options>

    -h, --help                              Display help
    -v, --version                           The kind version to use (default: v0.7.0)"
    -c, --config                            The path to the kind config file"
    -i, --node-image                        The Docker image for the cluster nodes"
    -n, --cluster-name                      The name of the cluster to create (default: chart-testing)"
    -w, --wait                              The duration to wait for the control plane to become ready (default: 60s)"
    -l, --log-level                         The log level for kind [panic, fatal, error, warning, info, debug, trace] (default: warning)

EOF
}

main() {
    local version="$DEFAULT_KIND_VERSION"
    local config=
    local node_image=
    local cluster_name="$DEFAULT_CLUSTER_NAME"
    local wait=60s
    local log_level=

    parse_command_line "$@"

    install_kind
    install_kubectl
    create_kind_cluster

}

parse_command_line() {
    while :; do
        case "${1:-}" in
            -h|--help)
                show_help
                exit
                ;;
            -v|--version)
                if [[ -n "${2:-}" ]]; then
                    version="$2"
                    shift
                else
                    echo "ERROR: '-v|--version' cannot be empty." >&2
                    show_help
                    exit 1
                fi
                ;;
            -c|--config)
                if [[ -n "${2:-}" ]]; then
                    config="$2"
                    shift
                else
                    echo "ERROR: '--config' cannot be empty." >&2
                    show_help
                    exit 1
                fi
                ;;
            -i|--node-image)
                if [[ -n "${2:-}" ]]; then
                    node_image="$2"
                    shift
                else
                    echo "ERROR: '-i|--node-image' cannot be empty." >&2
                    show_help
                    exit 1
                fi
                ;;
            -n|--cluster-name)
                if [[ -n "${2:-}" ]]; then
                    cluster_name="$2"
                    shift
                else
                    echo "ERROR: '-n|--cluster-name' cannot be empty." >&2
                    show_help
                    exit 1
                fi
                ;;
            -w|--wait)
                if [[ -n "${2:-}" ]]; then
                    wait="$2"
                    shift
                else
                    echo "ERROR: '--wait' cannot be empty." >&2
                    show_help
                    exit 1
                fi
                ;;
            -l|--log-level)
                if [[ -n "${2:-}" ]]; then
                    log_level="$2"
                    shift
                else
                    echo "ERROR: '--log-level' cannot be empty." >&2
                    show_help
                    exit 1
                fi
                ;;
            *)
                break
                ;;
        esac

        shift
    done
}

alcide_download_advisor(){
    echo "Downloading Alcide Advisor"
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        # Linux
        local os="linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OSX
        local os="darwin"
    else
        echo "Unsupported OS, Currently Alcide Advisor is supported on Linux or MacOS only"
        exit
    fi

    curl -o kube-advisor https://alcide.blob.core.windows.net/generic/stable/$os/advisor
    chmod +x kube-advisor
}

alcide_scan_cluster(){
    local outdir=$1
    local context=$2
    
    ./kube-advisor --eula-sign validate cluster --namespace-include="*" --outfile $outdir/$context.html
}


main "$@"
