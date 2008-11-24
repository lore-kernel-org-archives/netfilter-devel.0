From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 1/2] netfilter: nfmark routing in OUTPUT, mangle, NFQUEUE
Date: Mon, 24 Nov 2008 21:46:46 +0100
Message-ID: <1227559607-3077-2-git-send-email-eric@inl.fr>
References: <1227559607-3077-1-git-send-email-eric@inl.fr>
Cc: Laurent Licour <laurent@licour.com>, Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:39499 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752519AbYKXUqu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Nov 2008 15:46:50 -0500
In-Reply-To: <1227559607-3077-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Laurent Licour <laurent@licour.com>

This patch let nfmark to be evaluated for routing decision for OUTPUT
packet, in mangle table, when process paquet in NFQUEUE
Until now, only change (in NFQUEUE process) on fields src_addr,
dest_addr and tos could make netfilter to reevalute the routing.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 net/ipv4/netfilter.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index 6efdb70..3f2fc81 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -125,6 +125,7 @@ struct ip_rt_info {
 	__be32 daddr;
 	__be32 saddr;
 	u_int8_t tos;
+	__u32 mark;
 };
 
 static void nf_ip_saveroute(const struct sk_buff *skb,
@@ -138,6 +139,7 @@ static void nf_ip_saveroute(const struct sk_buff *skb,
 		rt_info->tos = iph->tos;
 		rt_info->daddr = iph->daddr;
 		rt_info->saddr = iph->saddr;
+		rt_info->mark = skb->mark;
 	}
 }
 
@@ -150,6 +152,7 @@ static int nf_ip_reroute(struct sk_buff *skb,
 		const struct iphdr *iph = ip_hdr(skb);
 
 		if (!(iph->tos == rt_info->tos
+		      && skb->mark == rt_info->mark
 		      && iph->daddr == rt_info->daddr
 		      && iph->saddr == rt_info->saddr))
 			return ip_route_me_harder(skb, RTN_UNSPEC);
-- 
1.5.6.3

