From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 3/7] Let xt_connlimit use nf_inet_addr
Date: Sat, 15 Dec 2007 13:20:36 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712151312000.22877@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0712070335240.1262@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0712070336490.1262@fbirervta.pbzchgretzou.qr>
 <475E6445.4090202@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:44368 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816AbXLOMUh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 15 Dec 2007 07:20:37 -0500
In-Reply-To: <475E6445.4090202@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Dec 11 2007 11:19, Patrick McHardy wrote:
>
> No way I'm adding patches to intoduce new revisions for this,
> the layout is exactly the same as before :) There must be
> a better way, like an anonymous union:
>
> struct xt_connlimit_info { 
>        union {
> 		union nf_inet_addr mask;
> 		union {
> 			__be32 v4_mask;
> 			__be32 v6_mask[4];
> 		}
> 	};
> 	...
> };
>

===

Make xt_connlimit use the new union nf_inet_addr.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 include/linux/netfilter/xt_connlimit.h |    9 +++++++--
 net/netfilter/xt_connlimit.c           |    7 +++----
 2 files changed, 10 insertions(+), 6 deletions(-)

Index: linux-2.6/include/linux/netfilter/xt_connlimit.h
===================================================================
--- linux-2.6.orig/include/linux/netfilter/xt_connlimit.h
+++ linux-2.6/include/linux/netfilter/xt_connlimit.h
@@ -5,8 +5,13 @@ struct xt_connlimit_data;
 
 struct xt_connlimit_info {
 	union {
-		__be32 v4_mask;
-		__be32 v6_mask[4];
+		union nf_inet_addr mask;
+#ifndef __KERNEL__
+		union {
+			__be32 v4_mask;
+			__be32 v6_mask[4];
+		};
+#endif
 	};
 	unsigned int limit, inverse;
 
Index: linux-2.6/net/netfilter/xt_connlimit.c
===================================================================
--- linux-2.6.orig/net/netfilter/xt_connlimit.c
+++ linux-2.6/net/netfilter/xt_connlimit.c
@@ -185,7 +185,7 @@ connlimit_mt(const struct sk_buff *skb, 
              bool *hotdrop)
 {
 	const struct xt_connlimit_info *info = matchinfo;
-	union nf_inet_addr addr, mask;
+	union nf_inet_addr addr;
 	struct nf_conntrack_tuple tuple;
 	const struct nf_conntrack_tuple *tuple_ptr = &tuple;
 	enum ip_conntrack_info ctinfo;
@@ -202,15 +202,14 @@ connlimit_mt(const struct sk_buff *skb, 
 	if (match->family == AF_INET6) {
 		const struct ipv6hdr *iph = ipv6_hdr(skb);
 		memcpy(&addr.ip6, &iph->saddr, sizeof(iph->saddr));
-		memcpy(&mask.ip6, info->v6_mask, sizeof(info->v6_mask));
 	} else {
 		const struct iphdr *iph = ip_hdr(skb);
 		addr.ip = iph->saddr;
-		mask.ip = info->v4_mask;
 	}
 
 	spin_lock_bh(&info->data->lock);
-	connections = count_them(info->data, tuple_ptr, &addr, &mask, match);
+	connections = count_them(info->data, tuple_ptr, &addr,
+	                         &info->mask, match);
 	spin_unlock_bh(&info->data->lock);
 
 	if (connections < 0) {
