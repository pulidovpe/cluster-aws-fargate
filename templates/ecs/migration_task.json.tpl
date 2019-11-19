[
  {
    "name": "${app_name}",
    "image": "${app_image}",
    "command": [ "flask", "manage_db", "recreate" ],
    "memory": 512,
    "networkMode": "awsvpc",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${log_group}",
          "awslogs-region": "${aws_region}",
          "awslogs-stream-prefix": "erp"
        }
    },
    "portMappings": [
      {
        "containerPort": 5432,
        "hostPort": 5432
      }
    ],
    "environment": [
      {
        "name": "APP_SETTINGS",
        "value": "${environment}"
      },
      {
        "name": "POSTGRES_URL",
        "value": "${database_url}"
      },
      {
        "name": "POSTGRES_PORT",
        "value": "5432"
      },
      {
        "name": "POSTGRES_USER",
        "value": "${database_username}"
      },
      {
        "name": "POSTGRES_PASSWORD",
        "value": "${database_password}"
      },
      {
        "name": "POSTGRES_DB",
        "value": "${database_name}"
      }
    ]
  }
]
