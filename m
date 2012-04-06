From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 2/2] net: netfilter: handle invalid packets consistently in conntrack
Date: Fri,  6 Apr 2012 16:57:33 +0200
Message-ID: <1333724253-32261-3-git-send-email-kadlec@blackhole.kfki.hu>
References: <1333724253-32261-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:52204 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754296Ab2DFO5m (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Apr 2012 10:57:42 -0400
In-Reply-To: <1333724253-32261-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

IPv6 conntrack marked invalid packets as INVALID and let the user
drop those by an explicit rule, while IPv4 conntrack dropped such
packets itself.

IPv4 conntrack is changed so that it marks INVALID packets and lets
the user to drop them.

Invalid packet logging support added to catch why the packet is marked
as INVALID.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |   26 ++++++++++++++++-------
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    8 +++++-
 2 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index af7cdc7..97ad520 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -74,23 +74,33 @@ static int ipv4_get_l4proto(const struct net *net,
 	struct iphdr _iph;
 
 	iph = skb_header_pointer(skb, nhoff, sizeof(_iph), &_iph);
-	if (iph == NULL)
-		return -NF_DROP;
+	if (iph == NULL) {
+		if (LOG_INVALID(net, IPPROTO_RAW))
+			nf_log_packet(NFPROTO_IPV4, 0, skb, NULL, NULL, NULL,
+				"nf_conntrack_ipv4: can't get IP header\n");
+		return -NF_ACCEPT;
+	}
 
 	/* Conntrack defragments packets, we might still see fragments
 	 * inside ICMP packets though. */
-	if (iph->frag_off & htons(IP_OFFSET))
-		return -NF_DROP;
+	if (iph->frag_off & htons(IP_OFFSET)) {
+		if (LOG_INVALID(net, IPPROTO_RAW))
+			nf_log_packet(NFPROTO_IPV4, 0, skb, NULL, NULL, NULL,
+				"nf_conntrack_ipv4: can't handle fragment\n");
+		return -NF_ACCEPT;
+	}
 
 	*dataoff = nhoff + (iph->ihl << 2);
 	*protonum = iph->protocol;
 
 	/* Check bogus IP headers */
 	if (*dataoff > skb->len) {
-		pr_debug("nf_conntrack_ipv4: drop bogus IPv4 packet: "
-			 "nhoff %u, ihl %u, skblen %u\n",
-			 nhoff, iph->ihl << 2, skb->len);
-		return -NF_DROP;
+		if (LOG_INVALID(net, IPPROTO_RAW))
+			nf_log_packet(NFPROTO_IPV4, 0, skb, NULL, NULL, NULL,
+				"nf_conntrack_ipv4: bogus IPv4 packet: "
+				"nhoff %u, ihl %u, skblen %u\n",
+				nhoff, iph->ihl << 2, skb->len);
+		return -NF_ACCEPT;
 	}
 
 	return NF_ACCEPT;
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index c65c060..c106fab 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -126,7 +126,9 @@ static int ipv6_get_l4proto(const struct net *net,
 
 	if (skb_copy_bits(skb, nhoff + offsetof(struct ipv6hdr, nexthdr),
 			  &pnum, sizeof(pnum)) != 0) {
-		pr_debug("ip6_conntrack_core: can't get nexthdr\n");
+		if (LOG_INVALID(net, IPPROTO_RAW))
+			nf_log_packet(NFPROTO_IPV6, 0, skb, NULL, NULL, NULL,
+				"nf_conntrack_ipv6: can't get nexthdr\n");
 		return -NF_ACCEPT;
 	}
 	protoff = nf_ct_ipv6_skip_exthdr(skb, extoff, &pnum, skb->len - extoff);
@@ -135,7 +137,9 @@ static int ipv6_get_l4proto(const struct net *net,
 	 * except of IPv6 & ext headers. but it's tracked anyway. - YK
 	 */
 	if ((protoff < 0) || (protoff > skb->len)) {
-		pr_debug("ip6_conntrack_core: can't find proto in pkt\n");
+		if (LOG_INVALID(net, IPPROTO_RAW))
+			nf_log_packet(NFPROTO_IPV6, 0, skb, NULL, NULL, NULL,
+				"nf_conntrack_ipv6: can't find proto in pkt\n");
 		return -NF_ACCEPT;
 	}
 
-- 
1.7.0.4

