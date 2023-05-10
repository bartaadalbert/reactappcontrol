#!/bin/bash

container_id_or_name=$1

if [ -z "${container_id_or_name}" ]; then
    container_ids=$(docker ps --format "{{.ID}}")
else
    container_id=$(docker ps --format "{{.ID}}" --filter "name=${container_id_or_name}")
    if [ -z "${container_id}" ]; then
        echo "No running container found with the specified name or ID."
        exit 1
    fi
    container_ids=("${container_id}")
fi

for container_id in ${container_ids[@]}; do
    container_name=$(docker ps --format "{{.Names}}" --filter "id=${container_id}")
    image_name=$(docker ps --format "{{.Image}}" --filter "id=${container_id}")
    description=$(docker inspect --format '{{index .Config.Labels "com.example.description"}}' "${image_name}")
    container_status=$(docker inspect --format "{{.State.Status}}" "${container_id}")
    container_uptime=$(docker inspect --format "{{.State.StartedAt}}" "${container_id}")
    environment_vars=$(docker inspect --format "{{range .Config.Env}}{{println .}}{{end}}" "${container_id}")
    port_mappings=$(docker inspect --format "{{json .NetworkSettings.Ports}}" "${container_id}")
    mount_points=$(docker inspect --format "{{json .Mounts}}" "${container_id}")
    cmd_entrypoint=$(docker inspect --format "{{json .Config.Cmd}} {{json .Config.Entrypoint}}" "${container_id}")
    network_settings=$(docker inspect --format "{{json .NetworkSettings.Networks}}" "${container_id}")

    echo "Container ID: ${container_id}"
    echo "Container Name: ${container_name}"
    echo "Description: ${description}"
    echo "Status: ${container_status}"
    echo "Uptime: ${container_uptime}"
    echo "Environment Variables:"
    echo "${environment_vars}"
    echo "Port Mappings: ${port_mappings}"
    echo "Mount Points: ${mount_points}"
    echo "Command and Entry Point: ${cmd_entrypoint}"
    echo "Network Settings: ${network_settings}"
    echo "---------------"
done
