from marathon import MarathonClient

marathon = MarathonClient(servers=['http://mesos-master0:8080'])

for app in marathon.list_apps():
    print app


