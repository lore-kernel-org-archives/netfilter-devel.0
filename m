From: Rolf Fokkens <fokkensr@fokkensr.vertis.nl>
Subject: PATCH: extra conntrack stats
Date: Sat, 19 Apr 2003 23:42:01 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200304192142.h3JLg1S03466@fokkensr.vertis.nl>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi!

This patch adds a little statistical information to the connection tracking:
the number of packets and bytes that have gone throught each connection.

We've been using the connection tracking info so far to count concurrently
connected users on an Oracle environment. Now our customer would like us to
measure the size of print jobs and the nunmber of print jobs - this patch may
be an option for us. Of course one can also measure other kinds of traffic.

It might even be possible now to limit the amount of data that has gone 
throught a connection by implementing other targets.

Well, it's a small patch that may not do any harm and please some people.

Cheers,

Rolf

diff -ruN linux-2.4.20.orig/include/linux/netfilter_ipv4/ip_conntrack_tuple.h linux-2.4.20/include/linux/netfilter_ipv4/ip_conntrack_tuple.h
--- linux-2.4.20.orig/include/linux/netfilter_ipv4/ip_conntrack_tuple.h	Mon Feb 25 20:38:13 2002
+++ linux-2.4.20/include/linux/netfilter_ipv4/ip_conntrack_tuple.h	Fri Apr 18 20:26:48 2003
@@ -60,6 +60,8 @@
 		/* The protocol. */
 		u_int16_t protonum;
 	} dst;
+
+	unsigned long npackets, nbytes;
 };
 
 enum ip_conntrack_dir
diff -ruN linux-2.4.20.orig/net/ipv4/netfilter/ip_conntrack_core.c linux-2.4.20/net/ipv4/netfilter/ip_conntrack_core.c
--- linux-2.4.20.orig/net/ipv4/netfilter/ip_conntrack_core.c	Fri Nov 29 00:53:15 2002
+++ linux-2.4.20/net/ipv4/netfilter/ip_conntrack_core.c	Sat Apr 19 15:13:34 2003
@@ -140,6 +140,8 @@
 	else if (iph->ihl * 4 + 8 > len)
 		return 0;
 
+	tuple->npackets = 0;
+	tuple->nbytes = 0;
 	tuple->src.ip = iph->saddr;
 	tuple->dst.ip = iph->daddr;
 	tuple->dst.protonum = iph->protocol;
@@ -158,6 +160,8 @@
 	inverse->src.ip = orig->dst.ip;
 	inverse->dst.ip = orig->src.ip;
 	inverse->dst.protonum = orig->dst.protonum;
+	inverse->npackets = 0;
+	inverse->nbytes = 0;
 
 	return protocol->invert_tuple(inverse, orig);
 }
@@ -760,7 +764,10 @@
 		if (IS_ERR(h))
 			return (void *)h;
 	}
-
+	WRITE_LOCK(&ip_conntrack_lock);
+	h->tuple.npackets ++;
+	h->tuple.nbytes += skb->len;
+	WRITE_UNLOCK(&ip_conntrack_lock);
 	/* It exists; we have (non-exclusive) reference. */
 	if (DIRECTION(h) == IP_CT_DIR_REPLY) {
 		*ctinfo = IP_CT_ESTABLISHED + IP_CT_IS_REPLY;
diff -ruN linux-2.4.20.orig/net/ipv4/netfilter/ip_conntrack_standalone.c linux-2.4.20/net/ipv4/netfilter/ip_conntrack_standalone.c
--- linux-2.4.20.orig/net/ipv4/netfilter/ip_conntrack_standalone.c	Fri Nov 29 00:53:15 2002
+++ linux-2.4.20/net/ipv4/netfilter/ip_conntrack_standalone.c	Sat Apr 19 11:51:26 2003
@@ -48,8 +48,11 @@
 {
 	int len;
 
-	len = sprintf(buffer, "src=%u.%u.%u.%u dst=%u.%u.%u.%u ",
-		      NIPQUAD(tuple->src.ip), NIPQUAD(tuple->dst.ip));
+	len = sprintf(buffer, "src=%u.%u.%u.%u dst=%u.%u.%u.%u "
+			      "packets=%lu bytes=%lu ",
+		      NIPQUAD(tuple->src.ip), NIPQUAD(tuple->dst.ip),
+		      tuple->npackets, tuple->nbytes
+		      );
 
 	len += proto->print_tuple(buffer + len, tuple);
 
