[
  {
    "name": "${app_name}",
    "image": "${app_image}",
    "cpu": ${fargate_cpu},
    "memory": ${fargate_memory},
    "networkMode": "awsvpc",    
    "memoryReservation": 512,
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
        "containerPort": ${app_port},
        "hostPort": ${app_port}
      }
    ],
    "entryPoint": [
      "python", "main.py"
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
      },
      {
        "name": "JWT_SECRET_KEY",
        "value": "${jwt_secret}"
      },
      {
        "name": "JWT_TIME_TOKEN",
        "value": "${jwt_time_token}"
      },
      {
        "name": "MAIL_SERVER",
        "value": "${mail_server}"
      },
      {
        "name": "MAIL_PORT",
        "value": "${mail_port}"
      },
      {
        "name": "MAIL_USERNAME",
        "value": "${mail_username}"
      },
      {
        "name": "MAIL_PASSWORD",
        "value": "${mail_password}"
      },
      {
        "name": "MAIL_USE_TLS",
        "value": "${mail_use_tls}"
      },
      {
        "name": "MAIL_USE_SSL",
        "value": "${mail_use_ssl}"
      },
      {
        "name": "SEED_TEST",
        "value": "${seed_test}"
      }
    ]
  }
]
