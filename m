From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 10/11] Netfilter:  Use a bit in conntrack status to
	indicate sequence number adjustment
Date: Mon, 17 Jan 2005 16:46:15 +1100
Message-ID: <1105940775.3954.33.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Name: Use a bit in conntrack status to indicate sequence number adjustment
Status: Tested under nfsim
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Rather than calling the sequence adjustment code on every connection
which has a helper, we can set a status bit on the conntrack when we
change the length of a TCP packet, and use that to indicate that we
should call the routine.

Index: linux-2.6.11-rc1-bk4-Netfilter/net/ipv4/netfilter/ip_nat_core.c
===================================================================
--- linux-2.6.11-rc1-bk4-Netfilter.orig/net/ipv4/netfilter/ip_nat_core.c	2005-01-17 16:09:38.479803944 +1100
+++ linux-2.6.11-rc1-bk4-Netfilter/net/ipv4/netfilter/ip_nat_core.c	2005-01-17 16:14:14.209886600 +1100
@@ -380,9 +380,7 @@
 	unsigned long statusbit;
 	enum ip_nat_manip_type mtype = HOOK2MANIP(hooknum);
 
-	/* FIXME: use a bit in status for this. */
-	if (ct->helper
-	    && ct->tuplehash[0].tuple.dst.protonum == IPPROTO_TCP
+	if (test_bit(IPS_SEQ_ADJUST_BIT, &ct->status)
 	    && (hooknum == NF_IP_POST_ROUTING || hooknum == NF_IP_LOCAL_IN)) {
 		DEBUGP("ip_nat_core: adjusting sequence number\n");
 		/* future: put this in a l4-proto specific function,
Index: linux-2.6.11-rc1-bk4-Netfilter/net/ipv4/netfilter/ip_nat_helper.c
===================================================================
--- linux-2.6.11-rc1-bk4-Netfilter.orig/net/ipv4/netfilter/ip_nat_helper.c	2005-01-17 15:57:58.371236624 +1100
+++ linux-2.6.11-rc1-bk4-Netfilter/net/ipv4/netfilter/ip_nat_helper.c	2005-01-17 16:14:14.209886600 +1100
@@ -192,11 +192,14 @@
 	tcph->check = tcp_v4_check(tcph, datalen, iph->saddr, iph->daddr,
 				   csum_partial((char *)tcph, datalen, 0));
 
-	adjust_tcp_sequence(ntohl(tcph->seq),
-			    (int)rep_len - (int)match_len,
-			    ct, ctinfo);
-	/* Tell connection tracking about seq change, to expand window */
-	ip_conntrack_tcp_update(*pskb, ct, CTINFO2DIR(ctinfo));
+	if (rep_len != match_len) {
+		set_bit(IPS_SEQ_ADJUST_BIT, &ct->status);
+		adjust_tcp_sequence(ntohl(tcph->seq),
+				    (int)rep_len - (int)match_len,
+				    ct, ctinfo);
+		/* Tell TCP window tracking about seq change */
+		ip_conntrack_tcp_update(*pskb, ct, CTINFO2DIR(ctinfo));
+	}
 	return 1;
 }
 			
@@ -363,11 +366,6 @@
 	this_way = &ct->nat.info.seq[dir];
 	other_way = &ct->nat.info.seq[!dir];
 
-	/* No adjustments to make?  Very common case. */
-	if (!this_way->offset_before && !this_way->offset_after
-	    && !other_way->offset_before && !other_way->offset_after)
-		return 1;
-
 	if (!skb_ip_make_writable(pskb, (*pskb)->nh.iph->ihl*4+sizeof(*tcph)))
 		return 0;
 
Index: linux-2.6.11-rc1-bk4-Netfilter/include/linux/netfilter_ipv4/ip_conntrack.h
===================================================================
--- linux-2.6.11-rc1-bk4-Netfilter.orig/include/linux/netfilter_ipv4/ip_conntrack.h	2005-01-17 16:14:12.358168104 +1100
+++ linux-2.6.11-rc1-bk4-Netfilter/include/linux/netfilter_ipv4/ip_conntrack.h	2005-01-17 16:14:14.210886448 +1100
@@ -51,6 +51,10 @@
 
 	/* Both together. */
 	IPS_NAT_MASK = (IPS_DST_NAT | IPS_SRC_NAT),
+
+	/* Connection needs TCP sequence adjusted. */
+	IPS_SEQ_ADJUST_BIT = 6,
+	IPS_SEQ_ADJUST = (1 << IPS_SEQ_ADJUST_BIT),
 };
 
 #ifdef __KERNEL__
