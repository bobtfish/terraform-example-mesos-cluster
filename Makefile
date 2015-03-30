.PHONEY: all

all: ssh_key
	true

ssh_key: id_rsa id_rsa.pub

id_rsa:
	ssh-keygen -t rsa -f id_rsa -N ''

id_rsa.pub:
	ssh-keygen -y -f id_rsa > id_rsa.pub

clean:
	rm id_rsa id_rsa.pub

