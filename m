From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Connection tracking bug with DNAT?
Date: Wed, 7 Apr 2004 00:57:04 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404070041380.15387-100000@filer.marasystems.com>
References: <20040406160739.33702.qmail@web21327.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Old Cowhand <oldcowhanddoug@yahoo.com>
In-Reply-To: <20040406160739.33702.qmail@web21327.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 6 Apr 2004, Old Cowhand wrote:

> Do you have a configuration that accomplishes these?
> 
> The destination address of the traffic MUST NOT be an
> address configured on the NAT gateway.  The simplest
> example is from my original post:
> 
>                                    |--Web server
>        eth0                   eth1 |  192.168.64.15/24
> PC---------------Linux 2.4.19-------
> 172.16.1.2/30    172.16.1.1/30     |
>                  192.168.64.1/24   |--Web server
>                                       192.168.64.5/24
> 
> My DNAT rule:
> 
> iptables -t nat -A PREROUTING -s 172.16.1.2 -d 192.168.64.5 -p tcp --dport 80 -j DNAT --to 192.168.64.15

The exact same rule works fine here.. and is a type of rule I use quite 
often.

and no, I certainly do not have the server IPs configured on the gateway.



client:

# ip addr show
2: eth0: <BROADCAST,MULTICAST,ALLMULTI,UP> mtu 1544 qdisc pfifo_fast qlen 1000
    link/ether 00:00:ea:a5:b8:35 brd ff:ff:ff:ff:ff:ff
    inet 172.16.1.2/30 scope global eth0

# ip ro ls
172.16.1.0/30 dev eth0  proto kernel  scope link  src 172.16.1.2 
default via 172.16.1.1 dev eth0 

gw:

# ip addr show
2: eth0: <BROADCAST,MULTICAST,ALLMULTI,UP> mtu 1544 qdisc pfifo_fast qlen 1000
    link/ether 00:00:33:0b:c1:52 brd ff:ff:ff:ff:ff:ff
    inet 172.16.1.1/30 scope global eth0
3: eth1: <BROADCAST,MULTICAST,ALLMULTI,UP> mtu 1544 qdisc pfifo_fast qlen 1000
    link/ether 00:00:1f:8a:6e:7c brd ff:ff:ff:ff:ff:ff
    inet 192.168.64.1/24 scope global eth1

# ip ro ls
172.16.1.0/30 dev eth0  proto kernel  scope link  src 172.16.1.1 
192.168.64.0/24 dev eth1  proto kernel  scope link  src 192.168.64.1 

# iptables-save
*nat
:PREROUTING ACCEPT [4:240]
:POSTROUTING ACCEPT [1:60]
:OUTPUT ACCEPT [0:0]
-A PREROUTING -s 172.16.1.2 -d 192.168.64.5 -p tcp -m tcp --dport 80 -j DNAT --to-destination 192.168.64.15 
COMMIT

server:

# ip addr 
2: eth0: <BROADCAST,MULTICAST,ALLMULTI,UP> mtu 1544 qdisc pfifo_fast qlen 1000
    link/ether 00:00:0a:26:67:1b brd ff:ff:ff:ff:ff:ff
    inet 192.168.64.15/24 scope global eth0
# ip ro ls
192.168.64.0/24 dev eth0  proto kernel  scope link  src 192.168.64.15 
default via 192.168.64.1 dev eth0 

server listening on port 80.


Connection from 172.16.1.2 to 192.168.64.5 tcp port 80 gets properly sent
to 192.168.64.15 port 80 instead of the requested address.

192.168.64.5 not even up and running, but also works if there is a server 
running with this IP.

Regards
Henrik
