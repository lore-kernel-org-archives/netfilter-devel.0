From: Toth Szabolcs <totya@mail.ajkanet.hu>
Subject: Help! ip traffic accounting and bidirection with iptables ??
Date: Fri, 13 Dec 2002 17:42:44 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.21.0212131702290.24104-100000@eagle.ajkanet.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hi All !

I have the following network schema :

         firewall
         _________
 INET    |   |	 |     LAN 
<------>ETH0 |   ETH1<----->
1.2.3.5  |   |   |    192.168.0.0/16
         ---------
	  server

I measure the ip traffic for each user who are in the LAN segment.
I measure all traffic that goes to , come from the server and INET.

I used unil now ipchains. The following rules make it possible for me to
see seperated the incoming and outgoing traffic on each user ip:

pkts	bytes
1125     208155 -          all  ------ 0xFF 0x00  eth1 				192.168.2.10         0.0.0.0/0             n/a
1542    1153702 -          all  ------ 0xFF 0x00  eth1 				0.0.0.0/0            192.168.2.10          n/a
---------------

ipchains -N acct
ipchains -A input -j acct -s 192.168.0.0/16 -b
ipchains -A output -j acct -s 192.168.0.0/16 -b

ipchains -A acct -p all -s 192.168.0.19  -i eth1 -b
ipchains -A acct -p all -s 192.168.2.10  -i eth1 -b
ipchains -A acct -p all -s 192.168.2.26  -i eth1 -b
ipchains -A acct -p all -s 192.168.2.42  -i eth1 -b
ipchains -A acct -p all -s 192.168.2.58  -i eth1 -b
......
.....
.....
(n+1)

Now I would change to iptables but I have a problem that I can not solve.
I can not measure the ip traffic / seperated for incoming and outgoing !!/ 
in ONE rule beacuse there is now "-b" /bidirection/ option in the 
iptables.

Now I use the following rules in iptables:

iptables -N acct
iptables -A acct -d 192.168.2.10
iptables -A acct -s 192.168.2.10
........
.......
(2n+1)

iptables -A INPUT -i eth1 -s 192.168.0.0/16 -j acct
iptables -A FORWARD -j acct
iptables -A OUTPUT -o eth1 -d 192.168.0.0/16 -j acct

If anybody know a better solution please write me: totya@ajkanet.hu
