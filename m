From: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
Subject: Re: [PATCH] ROUTE target fixes for --iif
Date: Wed, 5 May 2004 10:43:33 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040505144333.GA17752@ti64.telemetry-investments.com>
References: <20040504200151.GA30514@ti64.telemetry-investments.com> <1083758659.2743.8.camel@descartes.info.ucl.ac.be>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="LQksG6bCIzRHxTLp"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Cedric de Launois <delaunois@info.ucl.ac.be>
Content-Disposition: inline
In-Reply-To: <1083758659.2743.8.camel@descartes.info.ucl.ac.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 05, 2004 at 02:04:19PM +0200, Cedric de Launois wrote:
> Concerning the TTL, what happens if you re-inject the packet
> on the same interface ? If you don't decrement the TTL, you
> might introduce a loop, no ? Could you check this ?
 
D'oh!  You are of course correct that it will loop (and I've verified that
it does).  I had previously been using

	iptables -t mangle -A PREROUTING -i hdlc\+ -j TTL --ttl-inc 1

to get the desired behavior, but changed ROUTE because the above seemed
inelegant.   The original behavior is indeed the safer course.  The attached
patch backs out the TTL change.

> > I'm using the ROUTE target --iif functionality, in combination with the
> > teql round-robin packet scheduler, to remap incoming packets on multiple
> > interfaces (in this case hdlc[0-3]) to teql0.  [teql only schedules outgoing
> > packets; incoming packets appear on the underlying interfaces.]
> 
> Great, maybe could you detail this example so that it can be
> added in the netfilter pom documentation ?

Sure.

The teql per-packet round-robin scheduler is used to aggregate
the sending bandwidth on several slave interfaces; see the top of
linux/net/sched/sch_teql.c for usage and caveats.
[For Ethernet, the bonding driver is preferred.]

Per-packet scheduling is most useful when a single flow might exceed
the bandwidth of the individual interfaces, as is commonly the case with
T1 links.

Using WAN interfaces hdlc[0-3] on a 4 T1/E1 WAN card, one might do
the following:

	modprobe sch_teql
	for i in 0 1 2 3
		ip link set dev hdlc${i} up
		sysctl -w net.ipv4.conf.hdlc${i}.rp_filter=0
		tc qdisc add dev hdlc${i} root teql0
	done
	ip link set dev teql0 up
	sysctl -w net.ipv4.conf.teql0.rp_filter=0
	ip address add $IPADDR peer $REMIP dev teql0
	ip route add default via $REMIP dev teql0

Since teql0 is a send-only interface, incoming packets appear on the slave
hdlc* interfaces, and the usual caveats regarding asymmetric routing apply.
E.g., Quagga OSPF implements its own reverse-path filtering neighbor logic;
replies from peers that are received on the wrong interface are dropped.

The following rule causes all incoming packets on the hdlc* interfaces to appear
to have been received on teql0:

	iptables -t mangle -A PREROUTING -i hdlc\+ -j TTL --ttl-inc 1
	iptables -t mangle -A PREROUTING -i hdlc\+ -j ROUTE --iif teql0

The TTL increment is required to avoid dropping packets, as multicast
and broadcast packets are typically sent with TTL = 1.  In this example,
Quagga also sets TTL = 1 on packets that it sends to its peers.

Regards,

	Bill Rugolsky

--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="netfilter-route-target-ttl-backout.patch"

--- patch-o-matic-ng/ROUTE/linux/net/ipv4/netfilter/ipt_ROUTE.c.ttl	2004-05-04 15:09:35.000000000 -0400
+++ patch-o-matic-ng/ROUTE/linux/net/ipv4/netfilter/ipt_ROUTE.c	2004-05-05 09:44:20.000000000 -0400
@@ -249,8 +249,8 @@
 	/* If we are at PREROUTING or INPUT hook
 	 * the TTL isn't decreased by the IP stack
 	 */
-	if (route_info->iif[0] == '\0' && (hooknum == NF_IP_PRE_ROUTING ||
-	    hooknum == NF_IP_LOCAL_IN)) {
+	if (hooknum == NF_IP_PRE_ROUTING ||
+	    hooknum == NF_IP_LOCAL_IN) {
 
 		struct iphdr *iph = skb->nh.iph;
 
--- patch-o-matic-ng/ROUTE/linux-2.6/net/ipv4/netfilter/ipt_ROUTE.c.ttl	2004-05-04 15:11:07.000000000 -0400
+++ patch-o-matic-ng/ROUTE/linux-2.6/net/ipv4/netfilter/ipt_ROUTE.c	2004-05-05 09:45:18.000000000 -0400
@@ -251,8 +251,8 @@
 	/* If we are at PREROUTING or INPUT hook
 	 * the TTL isn't decreased by the IP stack
 	 */
-	if (route_info->iif[0] == '\0' && (hooknum == NF_IP_PRE_ROUTING ||
-	    hooknum == NF_IP_LOCAL_IN)) {
+	if (hooknum == NF_IP_PRE_ROUTING ||
+	    hooknum == NF_IP_LOCAL_IN) {
 
 		struct iphdr *iph = skb->nh.iph;
 

--LQksG6bCIzRHxTLp--
