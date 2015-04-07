.PHONEY: all

all: ssh_key admin_iprange.txt
	true

ssh_key: id_rsa id_rsa.pub

id_rsa:
	ssh-keygen -t rsa -f id_rsa -N ''

id_rsa.pub:
	ssh-keygen -y -f id_rsa > id_rsa.pub

admin_iprange.txt:
	echo $$(curl 'http://api.ipify.org?format=text' 2>/dev/null)/32 > admin_iprange.txt

clean:
	rm id_rsa id_rsa.pub admin_iprange.txt

