From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 60/64]: xt_connlimit: use the new union nf_inet_addr
Date: Tue, 18 Dec 2007 00:47:34 +0100 (MET)
Message-ID: <20071217234734.23601.52593.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39066 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933450AbXLQXrg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:47:36 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: xt_connlimit: use the new union nf_inet_addr

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 561162888ca9bb1ca4a95c41e7d4e03aae0d79c7
tree 251a0a045ca50713e3000a59c958e882f153a981
parent d1c627416f8e9632c67483522e7e2dbbebc89fe1
author Jan Engelhardt <jengelh@computergmbh.de> Mon, 17 Dec 2007 14:58:55 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:25:00 +0100

 include/linux/netfilter/xt_connlimit.h |    9 +++++++--
 net/netfilter/xt_connlimit.c           |    7 +++----
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/include/linux/netfilter/xt_connlimit.h b/include/linux/netfilter/xt_connlimit.h
index 37e933c..315d2dc 100644
--- a/include/linux/netfilter/xt_connlimit.h
+++ b/include/linux/netfilter/xt_connlimit.h
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
 
diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index b7a6846..6a9e2a3 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -185,7 +185,7 @@ connlimit_mt(const struct sk_buff *skb, const struct net_device *in,
              bool *hotdrop)
 {
 	const struct xt_connlimit_info *info = matchinfo;
-	union nf_inet_addr addr, mask;
+	union nf_inet_addr addr;
 	struct nf_conntrack_tuple tuple;
 	const struct nf_conntrack_tuple *tuple_ptr = &tuple;
 	enum ip_conntrack_info ctinfo;
@@ -202,15 +202,14 @@ connlimit_mt(const struct sk_buff *skb, const struct net_device *in,
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
