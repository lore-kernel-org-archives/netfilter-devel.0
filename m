From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 12/12]: Convert conntrack/ipt_REJECT to new checksumming
	functions
Date: Thu,  6 Apr 2006 12:05:09 +0200 (MEST)
Message-ID: <20060406100509.17409.82693.sendpatchset@localhost.localdomain>
References: <20060406100452.17409.37120.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060406100452.17409.37120.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Convert conntrack/ipt_REJECT to new checksumming functions

Besides removing lots of duplicate code, all converted users benefit
from improved HW checksum error handling. Tested with and without
HW checksums in almost all combinations.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 841bf618050f12d9230c6fee4186c632b3bf786a
tree 6af5e18f6f57ee30e011a59d689df94008775660
parent b204de98f3e9d2f9d47141c6a1036a2a27729329
author Patrick McHardy <kaber@trash.net> Thu, 06 Apr 2006 11:44:05 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 06 Apr 2006 11:44:05 +0200

 net/ipv4/netfilter/ip_conntrack_proto_icmp.c   |   23 +++--------
 net/ipv4/netfilter/ip_conntrack_proto_tcp.c    |    7 +--
 net/ipv4/netfilter/ip_conntrack_proto_udp.c    |    7 +--
 net/ipv4/netfilter/ipt_REJECT.c                |    9 ----
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |   20 +---------
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |   12 +-----
 net/netfilter/nf_conntrack_proto_tcp.c         |   50 ++----------------------
 net/netfilter/nf_conntrack_proto_udp.c         |   50 ++----------------------
 8 files changed, 25 insertions(+), 153 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c b/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
index 3021af0..d8b14a9 100644
--- a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
@@ -224,25 +224,14 @@ icmp_error(struct sk_buff *skb, enum ip_
 	}
 
 	/* See ip_conntrack_proto_tcp.c */
-	if (hooknum != NF_IP_PRE_ROUTING)
-		goto checksum_skipped;
-
-	switch (skb->ip_summed) {
-	case CHECKSUM_HW:
-		if (!(u16)csum_fold(skb->csum)) 
-			break;
-		/* fall through */
-	case CHECKSUM_NONE:
-		skb->csum = 0;
-		if (__skb_checksum_complete(skb)) {
-			if (LOG_INVALID(IPPROTO_ICMP))
-				nf_log_packet(PF_INET, 0, skb, NULL, NULL, NULL,
-					      "ip_ct_icmp: bad ICMP checksum ");
-			return -NF_ACCEPT;
-		}
+	if (hooknum == NF_IP_PRE_ROUTING &&
+	    nf_ip_checksum(skb, hooknum, skb->nh.iph->ihl * 4, 0)) {
+		if (LOG_INVALID(IPPROTO_ICMP))
+			nf_log_packet(PF_INET, 0, skb, NULL, NULL, NULL,
+				      "ip_ct_icmp: bad ICMP checksum ");
+		return -NF_ACCEPT;
 	}
 
-checksum_skipped:
 	/*
 	 *	18 is the highest 'known' ICMP type. Anything else is a mystery
 	 *
diff --git a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
index e0dc370..062b252 100644
--- a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
+++ b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
@@ -870,11 +870,8 @@ static int tcp_error(struct sk_buff *skb
 	 * and moreover root might send raw packets.
 	 */
 	/* FIXME: Source route IP option packets --RR */
-	if (hooknum == NF_IP_PRE_ROUTING
-	    && skb->ip_summed != CHECKSUM_UNNECESSARY
-	    && csum_tcpudp_magic(iph->saddr, iph->daddr, tcplen, IPPROTO_TCP,
-			         skb->ip_summed == CHECKSUM_HW ? skb->csum
-			      	 : skb_checksum(skb, iph->ihl*4, tcplen, 0))) {
+	if (hooknum == NF_IP_PRE_ROUTING &&
+	    nf_ip_checksum(skb, hooknum, iph->ihl * 4, IPPROTO_TCP)) {
 		if (LOG_INVALID(IPPROTO_TCP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL, NULL,
 				  "ip_ct_tcp: bad TCP checksum ");
diff --git a/net/ipv4/netfilter/ip_conntrack_proto_udp.c b/net/ipv4/netfilter/ip_conntrack_proto_udp.c
index 55b7d32..7089986 100644
--- a/net/ipv4/netfilter/ip_conntrack_proto_udp.c
+++ b/net/ipv4/netfilter/ip_conntrack_proto_udp.c
@@ -120,11 +120,8 @@ static int udp_error(struct sk_buff *skb
 	 * because the semantic of CHECKSUM_HW is different there 
 	 * and moreover root might send raw packets.
 	 * FIXME: Source route IP option packets --RR */
-	if (hooknum == NF_IP_PRE_ROUTING
-	    && skb->ip_summed != CHECKSUM_UNNECESSARY
-	    && csum_tcpudp_magic(iph->saddr, iph->daddr, udplen, IPPROTO_UDP,
-			         skb->ip_summed == CHECKSUM_HW ? skb->csum
-			      	 : skb_checksum(skb, iph->ihl*4, udplen, 0))) {
+	if (hooknum == NF_IP_PRE_ROUTING &&
+	    nf_ip_checksum(skb, hooknum, iph->ihl * 4, IPPROTO_UDP)) {
 		if (LOG_INVALID(IPPROTO_UDP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL, NULL,
 				  "ip_ct_udp: bad UDP checksum ");
diff --git a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
index 4269a54..0bba3c2 100644
--- a/net/ipv4/netfilter/ipt_REJECT.c
+++ b/net/ipv4/netfilter/ipt_REJECT.c
@@ -106,7 +106,6 @@ static void send_reset(struct sk_buff *o
 	struct rtable *rt;
 	u_int16_t tmp_port;
 	u_int32_t tmp_addr;
-	unsigned int tcplen;
 	int needs_ack;
 	int hh_len;
 
@@ -124,13 +123,7 @@ static void send_reset(struct sk_buff *o
 		return;
 
 	/* Check checksum */
-	tcplen = oldskb->len - iph->ihl * 4;
-	if (((hook != NF_IP_LOCAL_IN && oldskb->ip_summed != CHECKSUM_HW) ||
-	     (hook == NF_IP_LOCAL_IN &&
-	      oldskb->ip_summed != CHECKSUM_UNNECESSARY)) &&
-	    csum_tcpudp_magic(iph->saddr, iph->daddr, tcplen, IPPROTO_TCP,
-	                      oldskb->ip_summed == CHECKSUM_HW ? oldskb->csum :
-	                      skb_checksum(oldskb, iph->ihl * 4, tcplen, 0)))
+	if (nf_ip_checksum(oldskb, hook, iph->ihl * 4, IPPROTO_TCP))
 		return;
 
 	if ((rt = route_reverse(oldskb, oth, hook)) == NULL)
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index 52dc175..4b0d361 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -235,30 +235,14 @@ icmp_error(struct sk_buff *skb, unsigned
 	}
 
 	/* See ip_conntrack_proto_tcp.c */
-	if (hooknum != NF_IP_PRE_ROUTING)
-		goto checksum_skipped;
-
-	switch (skb->ip_summed) {
-	case CHECKSUM_HW:
-		if (!(u16)csum_fold(skb->csum))
-			break;
+	if (hooknum == NF_IP_PRE_ROUTING &&
+	    nf_ip_checksum(skb, hooknum, dataoff, 0)) {
 		if (LOG_INVALID(IPPROTO_ICMP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL, NULL,
 				      "nf_ct_icmp: bad HW ICMP checksum ");
 		return -NF_ACCEPT;
-	case CHECKSUM_NONE:
-		if ((u16)csum_fold(skb_checksum(skb, 0, skb->len, 0))) {
-			if (LOG_INVALID(IPPROTO_ICMP))
-				nf_log_packet(PF_INET, 0, skb, NULL, NULL,
-					      NULL,
-					      "nf_ct_icmp: bad ICMP checksum ");
-			return -NF_ACCEPT;
-		}
-	default:
-		break;
 	}
 
-checksum_skipped:
 	/*
 	 *	18 is the highest 'known' ICMP type. Anything else is a mystery
 	 *
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index 09945c3..86c6703 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -233,21 +233,13 @@ icmpv6_error(struct sk_buff *skb, unsign
 		return -NF_ACCEPT;
 	}
 
-	if (hooknum != NF_IP6_PRE_ROUTING)
-		goto skipped;
-
-	/* Ignore it if the checksum's bogus. */
-	if (csum_ipv6_magic(&skb->nh.ipv6h->saddr, &skb->nh.ipv6h->daddr,
-			    skb->len - dataoff, IPPROTO_ICMPV6,
-			    skb_checksum(skb, dataoff,
-					 skb->len - dataoff, 0))) {
+	if (hooknum == NF_IP6_PRE_ROUTING &&
+	    nf_ip6_checksum(skb, hooknum, dataoff, IPPROTO_ICMPV6)) {
 		nf_log_packet(PF_INET6, 0, skb, NULL, NULL, NULL,
 			      "nf_ct_icmpv6: ICMPv6 checksum failed\n");
 		return -NF_ACCEPT;
 	}
 
-skipped:
-
 	/* is not error message ? */
 	if (icmp6h->icmp6_type >= 128)
 		return NF_ACCEPT;
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 6492ed6..69899f2 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -799,8 +799,7 @@ static int tcp_error(struct sk_buff *skb
 		     unsigned int dataoff,
 		     enum ip_conntrack_info *ctinfo,
 		     int pf,
-		     unsigned int hooknum,
-		     int(*csum)(const struct sk_buff *,unsigned int))
+		     unsigned int hooknum)
 {
 	struct tcphdr _tcph, *th;
 	unsigned int tcplen = skb->len - dataoff;
@@ -830,9 +829,8 @@ static int tcp_error(struct sk_buff *skb
 	 */
 	/* FIXME: Source route IP option packets --RR */
 	if (((pf == PF_INET && hooknum == NF_IP_PRE_ROUTING) ||
-	     (pf == PF_INET6 && hooknum  == NF_IP6_PRE_ROUTING))
-	    && skb->ip_summed != CHECKSUM_UNNECESSARY
-	    && csum(skb, dataoff)) {
+	     (pf == PF_INET6 && hooknum  == NF_IP6_PRE_ROUTING)) &&
+	    nf_checksum(skb, hooknum, dataoff, IPPROTO_TCP, pf)) {
 		if (LOG_INVALID(IPPROTO_TCP))
 			nf_log_packet(pf, 0, skb, NULL, NULL, NULL,
 				  "nf_ct_tcp: bad TCP checksum ");
@@ -851,44 +849,6 @@ static int tcp_error(struct sk_buff *skb
 	return NF_ACCEPT;
 }
 
-static int csum4(const struct sk_buff *skb, unsigned int dataoff)
-{
-	return csum_tcpudp_magic(skb->nh.iph->saddr, skb->nh.iph->daddr,
-				 skb->len - dataoff, IPPROTO_TCP,
-			         skb->ip_summed == CHECKSUM_HW ? skb->csum
-			      	 : skb_checksum(skb, dataoff,
-						skb->len - dataoff, 0));
-}
-
-static int csum6(const struct sk_buff *skb, unsigned int dataoff)
-{
-	return csum_ipv6_magic(&skb->nh.ipv6h->saddr, &skb->nh.ipv6h->daddr,
-			       skb->len - dataoff, IPPROTO_TCP,
-			       skb->ip_summed == CHECKSUM_HW
-			       ? csum_sub(skb->csum,
-					  skb_checksum(skb, 0, dataoff, 0))
-			       : skb_checksum(skb, dataoff, skb->len - dataoff,
-					      0));
-}
-
-static int tcp_error4(struct sk_buff *skb,
-		      unsigned int dataoff,
-		      enum ip_conntrack_info *ctinfo,
-		      int pf,
-		      unsigned int hooknum)
-{
-	return tcp_error(skb, dataoff, ctinfo, pf, hooknum, csum4);
-}
-
-static int tcp_error6(struct sk_buff *skb,
-		      unsigned int dataoff,
-		      enum ip_conntrack_info *ctinfo,
-		      int pf,
-		      unsigned int hooknum)
-{
-	return tcp_error(skb, dataoff, ctinfo, pf, hooknum, csum6);
-}
-
 /* Returns verdict for packet, or -1 for invalid. */
 static int tcp_packet(struct nf_conn *conntrack,
 		      const struct sk_buff *skb,
@@ -1218,7 +1178,7 @@ struct nf_conntrack_protocol nf_conntrac
 	.print_conntrack 	= tcp_print_conntrack,
 	.packet 		= tcp_packet,
 	.new 			= tcp_new,
-	.error			= tcp_error4,
+	.error			= tcp_error,
 #if defined(CONFIG_NF_CT_NETLINK) || \
     defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.to_nfattr		= tcp_to_nfattr,
@@ -1239,7 +1199,7 @@ struct nf_conntrack_protocol nf_conntrac
 	.print_conntrack 	= tcp_print_conntrack,
 	.packet 		= tcp_packet,
 	.new 			= tcp_new,
-	.error			= tcp_error6,
+	.error			= tcp_error,
 #if defined(CONFIG_NF_CT_NETLINK) || \
     defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.to_nfattr		= tcp_to_nfattr,
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 831d206..d93edbf 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -103,8 +103,7 @@ static int udp_new(struct nf_conn *connt
 static int udp_error(struct sk_buff *skb, unsigned int dataoff,
 		     enum ip_conntrack_info *ctinfo,
 		     int pf,
-		     unsigned int hooknum,
-		     int (*csum)(const struct sk_buff *, unsigned int))
+		     unsigned int hooknum)
 {
 	unsigned int udplen = skb->len - dataoff;
 	struct udphdr _hdr, *hdr;
@@ -136,9 +135,8 @@ static int udp_error(struct sk_buff *skb
 	 * and moreover root might send raw packets.
 	 * FIXME: Source route IP option packets --RR */
 	if (((pf == PF_INET && hooknum == NF_IP_PRE_ROUTING) ||
-	     (pf == PF_INET6 && hooknum == NF_IP6_PRE_ROUTING))
-	    && skb->ip_summed != CHECKSUM_UNNECESSARY
-	    && csum(skb, dataoff)) {
+	     (pf == PF_INET6 && hooknum == NF_IP6_PRE_ROUTING)) &&
+	    nf_checksum(skb, hooknum, dataoff, IPPROTO_UDP, pf)) {
 		if (LOG_INVALID(IPPROTO_UDP))
 			nf_log_packet(pf, 0, skb, NULL, NULL, NULL,
 				"nf_ct_udp: bad UDP checksum ");
@@ -148,44 +146,6 @@ static int udp_error(struct sk_buff *skb
 	return NF_ACCEPT;
 }
 
-static int csum4(const struct sk_buff *skb, unsigned int dataoff)
-{
-	return csum_tcpudp_magic(skb->nh.iph->saddr, skb->nh.iph->daddr,
-				 skb->len - dataoff, IPPROTO_UDP,
-				 skb->ip_summed == CHECKSUM_HW ? skb->csum
-				 : skb_checksum(skb, dataoff,
-						skb->len - dataoff, 0));
-}
-
-static int csum6(const struct sk_buff *skb, unsigned int dataoff)
-{
-	return csum_ipv6_magic(&skb->nh.ipv6h->saddr, &skb->nh.ipv6h->daddr,
-			       skb->len - dataoff, IPPROTO_UDP,
-			       skb->ip_summed == CHECKSUM_HW
-			       ? csum_sub(skb->csum,
-					  skb_checksum(skb, 0, dataoff, 0))
-			       : skb_checksum(skb, dataoff, skb->len - dataoff,
-					      0));
-}
-
-static int udp_error4(struct sk_buff *skb,
-		      unsigned int dataoff,
-		      enum ip_conntrack_info *ctinfo,
-		      int pf,
-		      unsigned int hooknum)
-{
-	return udp_error(skb, dataoff, ctinfo, pf, hooknum, csum4);
-}
-
-static int udp_error6(struct sk_buff *skb,
-		      unsigned int dataoff,
-		      enum ip_conntrack_info *ctinfo,
-		      int pf,
-		      unsigned int hooknum)
-{
-	return udp_error(skb, dataoff, ctinfo, pf, hooknum, csum6);
-}
-
 struct nf_conntrack_protocol nf_conntrack_protocol_udp4 =
 {
 	.l3proto		= PF_INET,
@@ -197,7 +157,7 @@ struct nf_conntrack_protocol nf_conntrac
 	.print_conntrack	= udp_print_conntrack,
 	.packet			= udp_packet,
 	.new			= udp_new,
-	.error			= udp_error4,
+	.error			= udp_error,
 #if defined(CONFIG_NF_CT_NETLINK) || \
     defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.tuple_to_nfattr	= nf_ct_port_tuple_to_nfattr,
@@ -216,7 +176,7 @@ struct nf_conntrack_protocol nf_conntrac
 	.print_conntrack	= udp_print_conntrack,
 	.packet			= udp_packet,
 	.new			= udp_new,
-	.error			= udp_error6,
+	.error			= udp_error,
 #if defined(CONFIG_NF_CT_NETLINK) || \
     defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.tuple_to_nfattr	= nf_ct_port_tuple_to_nfattr,
