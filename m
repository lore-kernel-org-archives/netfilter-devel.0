From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 3/7] xt_connlimit rev 1
Date: Fri, 7 Dec 2007 03:40:59 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712070336490.1262@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0712070335240.1262@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39537 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbXLGClB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Dec 2007 21:41:01 -0500
In-Reply-To: <Pine.LNX.4.64.0712070335240.1262@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Make xt_connlimit use the new union nf_inet_addr in revision 1.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 include/linux/netfilter/xt_connlimit.h |   10 ++
 net/netfilter/xt_connlimit.c           |  153 +++++++++++++++++++++++++++------
 2 files changed, 136 insertions(+), 27 deletions(-)

Index: linux-2.6/include/linux/netfilter/xt_connlimit.h
===================================================================
--- linux-2.6.orig/include/linux/netfilter/xt_connlimit.h
+++ linux-2.6/include/linux/netfilter/xt_connlimit.h
@@ -1,6 +1,8 @@
 #ifndef _XT_CONNLIMIT_H
 #define _XT_CONNLIMIT_H
 
+#include <linux/netfilter/x_tables.h>
+
 struct xt_connlimit_data;
 
 struct xt_connlimit_info {
@@ -14,4 +16,12 @@ struct xt_connlimit_info {
 	struct xt_connlimit_data *data __attribute__((aligned(8)));
 };
 
+struct xt_connlimit_match_info_v1 {
+	union nf_inet_addr mask;
+	u_int32_t limit;
+	u_int8_t invert;
+
+	struct xt_connlimit_data *data __attribute__((aligned(8)));
+};
+
 #endif /* _XT_CONNLIMIT_H */
Index: linux-2.6/net/netfilter/xt_connlimit.c
===================================================================
--- linux-2.6.orig/net/netfilter/xt_connlimit.c
+++ linux-2.6/net/netfilter/xt_connlimit.c
@@ -179,10 +179,10 @@ static int count_them(struct xt_connlimi
 }
 
 static bool
-connlimit_mt(const struct sk_buff *skb, const struct net_device *in,
-             const struct net_device *out, const struct xt_match *match,
-             const void *matchinfo, int offset, unsigned int protoff,
-             bool *hotdrop)
+connlimit_mt_v0(const struct sk_buff *skb, const struct net_device *in,
+                const struct net_device *out, const struct xt_match *match,
+                const void *matchinfo, int offset, unsigned int protoff,
+                bool *hotdrop)
 {
 	const struct xt_connlimit_info *info = matchinfo;
 	union nf_inet_addr addr, mask;
@@ -227,57 +227,155 @@ connlimit_mt(const struct sk_buff *skb, 
 }
 
 static bool
-connlimit_mt_check(const char *tablename, const void *ip,
-                   const struct xt_match *match, void *matchinfo,
-                   unsigned int hook_mask)
+connlimit_mt(const struct sk_buff *skb, const struct net_device *in,
+             const struct net_device *out, const struct xt_match *match,
+             const void *matchinfo, int offset, unsigned int protoff,
+             bool *hotdrop)
 {
-	struct xt_connlimit_info *info = matchinfo;
+	const struct xt_connlimit_match_info_v1 *info = matchinfo;
+	struct nf_conntrack_tuple tuple;
+	const struct nf_conntrack_tuple *tuple_ptr = &tuple;
+	enum ip_conntrack_info ctinfo;
+	const struct nf_conn *ct;
+	union nf_inet_addr addr;
+	int connections;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (ct != NULL)
+		tuple_ptr = &ct->tuplehash[0].tuple;
+	else if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb),
+				    match->family, &tuple))
+		goto hotdrop;
+
+	if (match->family == AF_INET6) {
+		const struct ipv6hdr *iph = ipv6_hdr(skb);
+		memcpy(&addr.ip6, &iph->saddr, sizeof(iph->saddr));
+	} else {
+		const struct iphdr *iph = ip_hdr(skb);
+		addr.ip = iph->saddr;
+	}
+
+	spin_lock_bh(&info->data->lock);
+	connections = count_them(info->data, tuple_ptr, &addr,
+	                         &info->mask, match);
+	spin_unlock_bh(&info->data->lock);
+
+	if (connections < 0) {
+		/* kmalloc failed, drop it entirely */
+		*hotdrop = true;
+		return false;
+	}
+
+	return (connections > info->limit) ^ info->invert;
+
+ hotdrop:
+	*hotdrop = true;
+	return false;
+}
+
+static struct xt_connlimit_data *
+connlimit_mt_check_generic(unsigned int family)
+{
+	struct xt_connlimit_data *data;
 	unsigned int i;
 
-	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
+	if (nf_ct_l3proto_try_module_get(family) < 0) {
 		printk(KERN_WARNING "cannot load conntrack support for "
-		       "address family %u\n", match->family);
-		return false;
+		       "address family %u\n", family);
+		return NULL;
 	}
 
 	/* init private data */
-	info->data = kmalloc(sizeof(struct xt_connlimit_data), GFP_KERNEL);
-	if (info->data == NULL) {
-		nf_ct_l3proto_module_put(match->family);
-		return false;
+	data = kmalloc(sizeof(struct xt_connlimit_data), GFP_KERNEL);
+	if (data == NULL) {
+		nf_ct_l3proto_module_put(family);
+		return NULL;
 	}
 
-	spin_lock_init(&info->data->lock);
-	for (i = 0; i < ARRAY_SIZE(info->data->iphash); ++i)
-		INIT_LIST_HEAD(&info->data->iphash[i]);
+	spin_lock_init(&data->lock);
+	for (i = 0; i < ARRAY_SIZE(data->iphash); ++i)
+		INIT_LIST_HEAD(&data->iphash[i]);
 
-	return true;
+	return data;;
 }
 
-static void
-connlimit_mt_destroy(const struct xt_match *match, void *matchinfo)
+static bool
+connlimit_mt_check_v0(const char *tablename, const void *ip,
+                      const struct xt_match *match, void *matchinfo,
+                      unsigned int hook_mask)
 {
 	struct xt_connlimit_info *info = matchinfo;
+	info->data = connlimit_mt_check_generic(match->family);
+	return info->data != NULL;
+}
+
+static bool
+connlimit_mt_check(const char *tablename, const void *ip,
+                   const struct xt_match *match, void *matchinfo,
+                   unsigned int hook_mask)
+{
+	struct xt_connlimit_match_info_v1 *info = matchinfo;
+	info->data = connlimit_mt_check_generic(match->family);
+	return info->data != NULL;
+}
+
+static void
+connlimit_mt_destroy_generic(struct xt_connlimit_data *data)
+{
 	struct xt_connlimit_conn *conn;
 	struct xt_connlimit_conn *tmp;
-	struct list_head *hash = info->data->iphash;
+	struct list_head *hash = data->iphash;
 	unsigned int i;
 
-	nf_ct_l3proto_module_put(match->family);
-
-	for (i = 0; i < ARRAY_SIZE(info->data->iphash); ++i) {
+	for (i = 0; i < ARRAY_SIZE(data->iphash); ++i)
 		list_for_each_entry_safe(conn, tmp, &hash[i], list) {
 			list_del(&conn->list);
 			kfree(conn);
 		}
-	}
 
-	kfree(info->data);
+	kfree(data);
+}
+
+static void
+connlimit_mt_destroy_v0(const struct xt_match *match, void *matchinfo)
+{
+	struct xt_connlimit_info *info = matchinfo;
+	nf_ct_l3proto_module_put(match->family);
+	connlimit_mt_destroy_generic(info->data);
+}
+
+static void
+connlimit_mt_destroy(const struct xt_match *match, void *matchinfo)
+{
+	struct xt_connlimit_match_info_v1 *info = matchinfo;
+	nf_ct_l3proto_module_put(match->family);
+	connlimit_mt_destroy_generic(info->data);
 }
 
 static struct xt_match connlimit_mt_reg[] __read_mostly = {
 	{
 		.name       = "connlimit",
+		.revision   = 0,
+		.family     = AF_INET,
+		.checkentry = connlimit_mt_check_v0,
+		.match      = connlimit_mt_v0,
+		.matchsize  = sizeof(struct xt_connlimit_info),
+		.destroy    = connlimit_mt_destroy_v0,
+		.me         = THIS_MODULE,
+	},
+	{
+		.name       = "connlimit",
+		.revision   = 0,
+		.family     = AF_INET6,
+		.checkentry = connlimit_mt_check_v0,
+		.match      = connlimit_mt_v0,
+		.matchsize  = sizeof(struct xt_connlimit_info),
+		.destroy    = connlimit_mt_destroy_v0,
+		.me         = THIS_MODULE,
+	},
+	{
+		.name       = "connlimit",
+		.revision   = 1,
 		.family     = AF_INET,
 		.checkentry = connlimit_mt_check,
 		.match      = connlimit_mt,
@@ -287,6 +385,7 @@ static struct xt_match connlimit_mt_reg[
 	},
 	{
 		.name       = "connlimit",
+		.revision   = 1,
 		.family     = AF_INET6,
 		.checkentry = connlimit_mt_check,
 		.match      = connlimit_mt,
