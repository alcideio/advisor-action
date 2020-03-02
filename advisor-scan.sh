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

SCRIPT_DIR=$(dirname -- "$(readlink -f "${BASH_SOURCE[0]}" || realpath "${BASH_SOURCE[0]}")")

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

main() {
    args=()

    if [[ -n "${INPUT_FAIL_ON_CRITICAL:-}" ]]; then
        args+=(--run-mode=pipeline)
    fi

    if [[ -n "${INPUT_OUTPUT_FILE:-}" ]]; then
        args+=(--outfile "${INPUT_OUTPUT_FILE}")
    fi

    if [[ -n "${INPUT_INCLUDE_NAMESPACES:-}" ]]; then
        args+=(--namespace-include "${INPUT_INCLUDE_NAMESPACES}")
    fi   

    if [[ -n "${INPUT_EXCLUDE_NAMESPACES:-}" ]]; then
        args+=(--namespace-exclude "${INPUT_EXCLUDE_NAMESPACES}")
    fi   

    if [[ -n "${INPUT_POLICY_PROFILE:-}" ]]; then
        args+=(--policy-profile "${INPUT_POLICY_PROFILE}")
    fi

    if [[ -n "${INPUT_POLICY_PROFILE_ID:-}" ]]; then
        args+=(--profile-id "${INPUT_POLICY_PROFILE_ID}")
        args+=(--alcide-api-key "${INPUT_ALCIDE_APIKEY}")
        args+=(--alcide-api-server "${INPUT_ALCIDE_APISERVER}")        
    fi

    # Download fresh scanner
    alcide_download_advisor 

    # Scan the cluster
    ./kube-advisor --eula-sign validate cluster  "${args[@]}"
}

main

