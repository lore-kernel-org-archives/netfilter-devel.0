From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 15/18] Netfilter: Fix for UDP and TCP NAT on nonlinear skbs
Date: Wed, 05 Jan 2005 14:37:00 +1100
Message-ID: <1104896221.20582.83.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Linus Torvalds <torvalds@osdl.org>
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

Name: Fix for UDP and TCP NAT on nonlinear skbs
Status: Tested under nfsim
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

UDP and TCP refer to potentially stale pointers after calling
skb_ip_make_writable(), and UDP calls it with the wrong len argument.
All found by nfsim.

Index: linux-2.6.10-bk1-Netfilter/net/ipv4/netfilter/ip_nat_proto_udp.c
===================================================================
--- linux-2.6.10-bk1-Netfilter.orig/net/ipv4/netfilter/ip_nat_proto_udp.c	2004-12-29 23:07:37.000000000 +1100
+++ linux-2.6.10-bk1-Netfilter/net/ipv4/netfilter/ip_nat_proto_udp.c	2005-01-04 19:19:58.036153920 +1100
@@ -90,20 +90,20 @@
 	struct iphdr *iph = (struct iphdr *)((*pskb)->data + iphdroff);
 	struct udphdr *hdr;
 	unsigned int hdroff = iphdroff + iph->ihl*4;
-	u_int32_t oldip;
-	u_int16_t *portptr;
+	u32 oldip, oldsrc = iph->saddr, olddst = iph->daddr;
+	u16 *portptr;
 
-	if (!skb_ip_make_writable(pskb, hdroff + sizeof(hdr)))
+	if (!skb_ip_make_writable(pskb, hdroff + sizeof(*hdr)))
 		return 0;
 
 	hdr = (void *)(*pskb)->data + hdroff;
 	if (maniptype == IP_NAT_MANIP_SRC) {
 		/* Get rid of src ip and src pt */
-		oldip = iph->saddr;
+		oldip = oldsrc;
 		portptr = &hdr->source;
 	} else {
 		/* Get rid of dst ip and dst pt */
-		oldip = iph->daddr;
+		oldip = olddst;
 		portptr = &hdr->dest;
 	}
 	if (hdr->check) /* 0 is a special case meaning no checksum */
Index: linux-2.6.10-bk1-Netfilter/net/ipv4/netfilter/ip_nat_proto_tcp.c
===================================================================
--- linux-2.6.10-bk1-Netfilter.orig/net/ipv4/netfilter/ip_nat_proto_tcp.c	2004-12-29 23:07:37.000000000 +1100
+++ linux-2.6.10-bk1-Netfilter/net/ipv4/netfilter/ip_nat_proto_tcp.c	2005-01-04 19:23:51.765621640 +1100
@@ -91,8 +91,8 @@
 	struct iphdr *iph = (struct iphdr *)((*pskb)->data + iphdroff);
 	struct tcphdr *hdr;
 	unsigned int hdroff = iphdroff + iph->ihl*4;
-	u_int32_t oldip;
-	u_int16_t *portptr, oldport;
+	u32 oldip, oldsrc = iph->saddr, olddst = iph->daddr;
+	u16 *portptr, oldport;
 	int hdrsize = 8; /* TCP connection tracking guarantees this much */
 
 	/* this could be a inner header returned in icmp packet; in such
@@ -108,11 +108,11 @@
 
 	if (maniptype == IP_NAT_MANIP_SRC) {
 		/* Get rid of src ip and src pt */
-		oldip = iph->saddr;
+		oldip = oldsrc;
 		portptr = &hdr->source;
 	} else {
 		/* Get rid of dst ip and dst pt */
-		oldip = iph->daddr;
+		oldip = olddst;
 		portptr = &hdr->dest;
 	}
 
