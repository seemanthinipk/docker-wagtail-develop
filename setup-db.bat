docker-compose exec web ./manage.py migrate --noinput
docker-compose exec web ./manage.py load_initial_data
docker-compose exec web ./manage.py update_index
