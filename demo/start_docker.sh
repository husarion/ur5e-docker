docker stop $(docker ps -q)

docker compose -f compose.ur5e.yaml -f compose.velodyne.yaml -f compose.vnc.yaml -f compose.rviz.yaml up --build
