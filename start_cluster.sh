#!/bin/bash


pkill chef-zero
vagrant destroy -f
rm Berksfile.lock || true

IP=$(ip addr | grep inet | grep vboxnet1 | awk -F" " '{print $2}' | sed -e 's/\/.*$//')
#IP="192.168.1.236"
echo $IP

if [ -d ".chef" ]; then
	echo "dir .chef already exist"
	rm .chef -r
	mkdir .chef
else
	mkdir .chef
fi

if [ -f "tmp/chef-latest_amd64.deb" ]; then
	echo "dir chef.deb already exist"
else
	mkdir tmp
	wget https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/13.04/x86_64/chef_12.0.3-1_amd64.deb -O tmp/chef-latest_amd64.deb 
fi

cat > .chef/knife.rb <<-EOF 
	node_name               "workstation"
	chef_server_url         "http://${IP}:8889"
	client_key              "$PWD/.chef/test.pem"
	
EOF

cat > .chef/test.pem <<-EOF 
	-----BEGIN RSA PRIVATE KEY-----
	MIIEowIBAAKCAQEAzUE+/zJ+xXOjkfBbr0UxWInqQu/jRpfReA0rEwbI8bZGcxHn
	0E4OVgOoC8xFNauYeGDOsGv/5p/Fgu1xxvqt1CNDQFZ9HZIdsKeMotNf0otgitJt
	ehvz5Qe1wfh2pUaJp1yx8HOe/IACOhoy0bLBZ3Tyj7daHgrNRewijwCIUFAr4EiY
	vO6lXfg3yY4L0z+4a0sb5ptbfA1nKnPSSp37f/oLRr4f32aC+GAaFbxfPyOqMd3c
	OfMamOXB9WJFAH6wkzByNVVA6qY3bXvE2EVnKRmjwWFKfMsdTgMaKzj8zj7p/2wn
	15p4lbzlO746ZPBQ/U6ZPeB0iQr6jZRVjEUv8QIDAQABAoIBAExAkAHIpZX/JuZB
	sB4GC5YD7nadngaMwjHiWn1ACQjbGYMIROF7DhJgW16+rXuJ2yPlewPJq5DnDD5e
	reUpHcjwrLxLJUIGFWeaZ0HaWv/h7aTFFgzGM66DVb/Q6WrvMJZvdl+I5KiTecBS
	GU0UJoujw7UmfaEpjCcM2a3cmceTxqHoBGcY+kgGVAN2xj4tze0noKxWULo9zIG5
	1MMuwblVBLkY1laP3s/8kegxx/fPx/Lg2YjzhgGgd8b1XwztjII91xvAqbPUAymw
	0yNVtFAL57deEKr5KrNwvY5oBYf61OEeb+JhruZ6C2ioqiyk14kvdVfJ/Hk0ZKRA
	gpfQWw0CgYEA8ODzzUxA+6C0JTpMKHGjp4UgX6t5IzmJzeS/FQIAOGAoZ6oWU4Gz
	MxhrEpR7Qb+Pk4GFCVZXtNOWxjiBiDPoGYXLdHsXalwrQ8IqbbraDvZZ23kmIdml
	5TcYNSnxhnN9fIh5//3IuFj2ttq6x4rMIzZAiztAqy5aFk8BnHXZ098CgYEA2iPM
	uLD7X26sTcJcW00gaadTWusYqUlPvj8sQRL0X07PwaP6cFZxccEn3mUm6TlNHgga
	su06MKuS/5I36g/CjsTcXuXI++5TAb2tKp2Cpg/RNSXca+N3FuuCKzL/L3GZnuJM
	DkqqwnmvoOLz4NJOyEImXpo11pcWp2ZhRjYx9i8CgYEAgC92Dr6RplazB0yq0qsG
	6FMUE1VxNamdCBC/DzLtYxLo7aG6F95husM3179kiGykv16hqYJlUjl3dy0C4bSd
	w1dMGkSXBWbfL0PYyGQzPtsinoUuIb1tZzmWjFQxz9cN5IPMSMqJUnEledGUrDPU
	xrhMSMvTckVMc6q/tL+SmAkCgYABnh5YiEd077crZHOW4b2JywndNL0cFEUZHhLP
	8LoLMuRrhTHIP3vb4hjPl2RwelJOFLVN+mBiGAOhDY6Il9FTibYwpfeVlrDa5HMy
	S7S6Uoe0ozE9Q5SQgPKYK2qlCWygNwFlYbxecNSSltxEIIshBQyPywj3LGuoliPG
	h4RbVQKBgCH+CPil4nozq4nnTB5mdDQCcwBY0RBPNizvaaiZ7tTecXCmSemhUr06
	z1LynRzFlF9D4/sUfApuaUDrNglXFUt7lcJ5R7Z7sX0+/BYqsdFaRfAAuDZaCKMw
	ivC25dHkQsdmmagp40XpF5FBKOCicrwLiB73zeE3+Segdr4Tkp5h
	-----END RSA PRIVATE KEY-----
EOF


chef-zero -H $IP -d

knife role from file roles/*
knife environment from file environments/*

vagrant up
