From: "Toshihiro Sonoda" <toshihiro@jp.fujitsu.com>
Subject: about ROUTE target
Date: Wed, 18 Sep 2002 00:24:10 +0900
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <002f01c25e5e$46745100$ecf8a8c0@monday>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hi, 

I want to re-route the packet to tunneling device in spite of the
packet's destination address. I know the ipt_ROUTE target, so
I set up the iptables and tunneling device in the following environment.


[ local pc]- LAN ->[  router ] <- WAN -> [ target pc ]   

LAN's network is 192.168.7.0/24.
WAN's network is 192.168.1.0/24.

LAN side IP address of the router is  192.168.7.1.
WAN side IP address of the router is 192.168.1.2.
target pc IP address is 192.168.1.3.

router is 2.4.18 kernel and I did p-o-m for ipt_ROUTE to the router.

I set the following command on the router.

# modprobe ip_gre
# iptunnel add tundev mode gre remote 192.168.1.3
# ifoconfig tundev 192.168.1.2
#
# modprobe ipt_ROUTE
# iptables -t nat -A PREROUTING -p icmp -j ROUTE --iface tundev

and I executed  "ping" to anather pc(ex, 192.168.1.10) on the local pc.

# ping 192.168.1.10

then, router(linux) was freezed.
 
I confirmed that ipt_route_target(), which is in "ipt_ROUTE.c", hook function 
in the ROUTE target was called in the router's linux kernel,
and ipgre_tunnel_xmit() in gre's tunneling device(ip_gre.c) was called.

But, the at the IPTUNNLE_XMIT() called in the ipgre_tunnel_xmit(), linux 
was freezed.

Do I mistake how to use the ROUTE target ?

thanks for your advice.

-
T.Sono
