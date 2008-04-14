From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 23/41]: Add partial checksum validation helper
Date: Mon, 14 Apr 2008 12:16:49 +0200 (MEST)
Message-ID: <20080414101646.32717.46829.sendpatchset@localhost.localdomain>
References: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36296 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbYDNKQu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:16:50 -0400
In-Reply-To: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: Add partial checksum validation helper

Move the UDP-Lite conntrack checksum validation to a generic helper
similar to nf_checksum() and make it fall back to nf_checksum()
in case the full packet is to be checksummed and hardware checksums
are available. This is to be used by DCCP conntrack, which also
needs to verify partial checksums.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit e291ad784a87e67b09bb6e5fe9668b79cf43953c
tree 7d1e5502cb4d7c5fa8fbb9831641dbf81666b4ff
parent 3eee75c01a5589393289a81daf19215a45f802b9
author Patrick McHardy <kaber@trash.net> Thu, 20 Mar 2008 15:15:53 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 14 Apr 2008 12:10:52 +0200

 include/linux/netfilter.h                  |   22 +++++++++++++++
 net/ipv4/netfilter.c                       |   37 ++++++++++++++++++++-----
 net/ipv6/netfilter.c                       |   42 +++++++++++++++++++++++-----
 net/netfilter/nf_conntrack_proto_udplite.c |   33 +++++-----------------
 4 files changed, 94 insertions(+), 40 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 66bc520..e4c6659 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -234,6 +234,11 @@ struct nf_afinfo {
 	unsigned short	family;
 	__sum16		(*checksum)(struct sk_buff *skb, unsigned int hook,
 				    unsigned int dataoff, u_int8_t protocol);
+	__sum16		(*checksum_partial)(struct sk_buff *skb,
+					    unsigned int hook,
+					    unsigned int dataoff,
+					    unsigned int len,
+					    u_int8_t protocol);
 	int		(*route)(struct dst_entry **dst, struct flowi *fl);
 	void		(*saveroute)(const struct sk_buff *skb,
 				     struct nf_queue_entry *entry);
@@ -263,6 +268,23 @@ nf_checksum(struct sk_buff *skb, unsigned int hook, unsigned int dataoff,
 	return csum;
 }
 
+static inline __sum16
+nf_checksum_partial(struct sk_buff *skb, unsigned int hook,
+		    unsigned int dataoff, unsigned int len,
+		    u_int8_t protocol, unsigned short family)
+{
+	const struct nf_afinfo *afinfo;
+	__sum16 csum = 0;
+
+	rcu_read_lock();
+	afinfo = nf_get_afinfo(family);
+	if (afinfo)
+		csum = afinfo->checksum_partial(skb, hook, dataoff, len,
+						protocol);
+	rcu_read_unlock();
+	return csum;
+}
+
 extern int nf_register_afinfo(const struct nf_afinfo *afinfo);
 extern void nf_unregister_afinfo(const struct nf_afinfo *afinfo);
 
diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index 9a904c6..f8edacd 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -182,21 +182,44 @@ __sum16 nf_ip_checksum(struct sk_buff *skb, unsigned int hook,
 	}
 	return csum;
 }
-
 EXPORT_SYMBOL(nf_ip_checksum);
 
+static __sum16 nf_ip_checksum_partial(struct sk_buff *skb, unsigned int hook,
+				      unsigned int dataoff, unsigned int len,
+				      u_int8_t protocol)
+{
+	const struct iphdr *iph = ip_hdr(skb);
+	__sum16 csum = 0;
+
+	switch (skb->ip_summed) {
+	case CHECKSUM_COMPLETE:
+		if (len == skb->len - dataoff)
+			return nf_ip_checksum(skb, hook, dataoff, protocol);
+		/* fall through */
+	case CHECKSUM_NONE:
+		skb->csum = csum_tcpudp_nofold(iph->saddr, iph->daddr, protocol,
+					       skb->len - dataoff, 0);
+		skb->ip_summed = CHECKSUM_NONE;
+		csum = __skb_checksum_complete_head(skb, dataoff + len);
+		if (!csum)
+			skb->ip_summed = CHECKSUM_UNNECESSARY;
+	}
+	return csum;
+}
+
 static int nf_ip_route(struct dst_entry **dst, struct flowi *fl)
 {
 	return ip_route_output_key(&init_net, (struct rtable **)dst, fl);
 }
 
 static const struct nf_afinfo nf_ip_afinfo = {
-	.family		= AF_INET,
-	.checksum	= nf_ip_checksum,
-	.route		= nf_ip_route,
-	.saveroute	= nf_ip_saveroute,
-	.reroute	= nf_ip_reroute,
-	.route_key_size	= sizeof(struct ip_rt_info),
+	.family			= AF_INET,
+	.checksum		= nf_ip_checksum,
+	.checksum_partial	= nf_ip_checksum_partial,
+	.route			= nf_ip_route,
+	.saveroute		= nf_ip_saveroute,
+	.reroute		= nf_ip_reroute,
+	.route_key_size		= sizeof(struct ip_rt_info),
 };
 
 static int ipv4_netfilter_init(void)
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index aed51bc..8c6c5e7 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -121,16 +121,44 @@ __sum16 nf_ip6_checksum(struct sk_buff *skb, unsigned int hook,
 	}
 	return csum;
 }
-
 EXPORT_SYMBOL(nf_ip6_checksum);
 
+static __sum16 nf_ip6_checksum_partial(struct sk_buff *skb, unsigned int hook,
+				       unsigned int dataoff, unsigned int len,
+				       u_int8_t protocol)
+{
+	struct ipv6hdr *ip6h = ipv6_hdr(skb);
+	__wsum hsum;
+	__sum16 csum = 0;
+
+	switch (skb->ip_summed) {
+	case CHECKSUM_COMPLETE:
+		if (len == skb->len - dataoff)
+			return nf_ip6_checksum(skb, hook, dataoff, protocol);
+		/* fall through */
+	case CHECKSUM_NONE:
+		hsum = skb_checksum(skb, 0, dataoff, 0);
+		skb->csum = ~csum_unfold(csum_ipv6_magic(&ip6h->saddr,
+							 &ip6h->daddr,
+							 skb->len - dataoff,
+							 protocol,
+							 csum_sub(0, hsum)));
+		skb->ip_summed = CHECKSUM_NONE;
+		csum = __skb_checksum_complete_head(skb, dataoff + len);
+		if (!csum)
+			skb->ip_summed = CHECKSUM_UNNECESSARY;
+	}
+	return csum;
+};
+
 static const struct nf_afinfo nf_ip6_afinfo = {
-	.family		= AF_INET6,
-	.checksum	= nf_ip6_checksum,
-	.route		= nf_ip6_route,
-	.saveroute	= nf_ip6_saveroute,
-	.reroute	= nf_ip6_reroute,
-	.route_key_size	= sizeof(struct ip6_rt_info),
+	.family			= AF_INET6,
+	.checksum		= nf_ip6_checksum,
+	.checksum_partial	= nf_ip6_checksum_partial,
+	.route			= nf_ip6_route,
+	.saveroute		= nf_ip6_saveroute,
+	.reroute		= nf_ip6_reroute,
+	.route_key_size		= sizeof(struct ip6_rt_info),
 };
 
 int __init ipv6_netfilter_init(void)
diff --git a/net/netfilter/nf_conntrack_proto_udplite.c b/net/netfilter/nf_conntrack_proto_udplite.c
index 9dd03c7..c3eaee6 100644
--- a/net/netfilter/nf_conntrack_proto_udplite.c
+++ b/net/netfilter/nf_conntrack_proto_udplite.c
@@ -127,32 +127,13 @@ static int udplite_error(struct sk_buff *skb, unsigned int dataoff,
 	}
 
 	/* Checksum invalid? Ignore. */
-	if (nf_conntrack_checksum && !skb_csum_unnecessary(skb) &&
-	    hooknum == NF_INET_PRE_ROUTING) {
-		if (pf == PF_INET) {
-			struct iphdr *iph = ip_hdr(skb);
-
-			skb->csum = csum_tcpudp_nofold(iph->saddr, iph->daddr,
-						       udplen, IPPROTO_UDPLITE, 0);
-		} else {
-			struct ipv6hdr *ipv6h = ipv6_hdr(skb);
-			__wsum hsum = skb_checksum(skb, 0, dataoff, 0);
-
-			skb->csum = ~csum_unfold(
-				csum_ipv6_magic(&ipv6h->saddr, &ipv6h->daddr,
-						udplen, IPPROTO_UDPLITE,
-						csum_sub(0, hsum)));
-		}
-
-		skb->ip_summed = CHECKSUM_NONE;
-		if (__skb_checksum_complete_head(skb, dataoff + cscov)) {
-			if (LOG_INVALID(IPPROTO_UDPLITE))
-				nf_log_packet(pf, 0, skb, NULL, NULL, NULL,
-					      "nf_ct_udplite: bad UDPLite "
-					      "checksum ");
-			return -NF_ACCEPT;
-		}
-		skb->ip_summed = CHECKSUM_UNNECESSARY;
+	if (nf_conntrack_checksum && hooknum == NF_INET_PRE_ROUTING &&
+	    nf_checksum_partial(skb, hooknum, dataoff, cscov, IPPROTO_UDP,
+	    			pf)) {
+		if (LOG_INVALID(IPPROTO_UDPLITE))
+			nf_log_packet(pf, 0, skb, NULL, NULL, NULL,
+				      "nf_ct_udplite: bad UDPLite checksum ");
+		return -NF_ACCEPT;
 	}
 
 	return NF_ACCEPT;
