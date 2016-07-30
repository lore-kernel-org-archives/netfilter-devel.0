From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next] netfilter: nf_dup4: remove redundant checksum recalculation
Date: Sat, 30 Jul 2016 19:44:12 +0800
Message-ID: <1469879052-15378-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:56928 "EHLO m12-17.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbcG3Lom (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Jul 2016 07:44:42 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

IP header checksum will be recalculated at ip_local_out, so
there's no need to calculated it here, remove it. Also update
code comments to illustrate it, and delete the misleading
comments about checksum recalculation.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 net/ipv4/netfilter/nf_dup_ipv4.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/nf_dup_ipv4.c b/net/ipv4/netfilter/nf_dup_ipv4.c
index ceb1873..cf986e1 100644
--- a/net/ipv4/netfilter/nf_dup_ipv4.c
+++ b/net/ipv4/netfilter/nf_dup_ipv4.c
@@ -74,21 +74,19 @@ void nf_dup_ipv4(struct net *net, struct sk_buff *skb, unsigned int hooknum,
 	nf_conntrack_get(skb->nfct);
 #endif
 	/*
-	 * If we are in PREROUTING/INPUT, the checksum must be recalculated
-	 * since the length could have changed as a result of defragmentation.
-	 *
-	 * We also decrease the TTL to mitigate potential loops between two
-	 * hosts.
+	 * If we are in PREROUTING/INPUT, decrease the TTL to mitigate potential
+	 * loops between two hosts.
 	 *
 	 * Set %IP_DF so that the original source is notified of a potentially
 	 * decreased MTU on the clone route. IPv6 does this too.
+	 *
+	 * IP header checksum will be recalculated at ip_local_out.
 	 */
 	iph = ip_hdr(skb);
 	iph->frag_off |= htons(IP_DF);
 	if (hooknum == NF_INET_PRE_ROUTING ||
 	    hooknum == NF_INET_LOCAL_IN)
 		--iph->ttl;
-	ip_send_check(iph);
 
 	if (nf_dup_ipv4_route(net, skb, gw, oif)) {
 		__this_cpu_write(nf_skb_duplicated, true);
-- 
2.5.5


