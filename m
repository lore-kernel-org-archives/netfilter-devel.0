From: Karl Hiramoto <karl@hiramoto.org>
Subject: [RFC 3/4] nf_conntrack: add nf_queue extension
Date: Sat, 24 Jul 2010 17:44:44 +0200
Message-ID: <1279986285-11665-4-git-send-email-karl@hiramoto.org>
References: <1279986285-11665-1-git-send-email-karl@hiramoto.org>
Cc: Karl Hiramoto <karl@hiramoto.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from hapkido.dreamhost.com ([66.33.216.122]:54256 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab0GXPqI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 24 Jul 2010 11:46:08 -0400
Received: from homiemail-a30.g.dreamhost.com (mailbigip.dreamhost.com [208.97.132.5])
	by hapkido.dreamhost.com (Postfix) with ESMTP id 7C95917C791
	for <netfilter-devel@vger.kernel.org>; Sat, 24 Jul 2010 08:46:06 -0700 (PDT)
In-Reply-To: <1279986285-11665-1-git-send-email-karl@hiramoto.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

if CONFIG_NF_QUEUE_CONNBYTES_BYPASS add conntrack extensions to allow bypass nf_queue

Signed-off-by: Karl Hiramoto <karl@hiramoto.org>
---
 include/net/netfilter/nf_conntrack_extend.h |    2 +
 net/netfilter/nf_conntrack_core.c           |   37 ++++++++++++++++++++++++++-
 2 files changed, 38 insertions(+), 1 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
index 32d15bd..81f3698 100644
--- a/include/net/netfilter/nf_conntrack_extend.h
+++ b/include/net/netfilter/nf_conntrack_extend.h
@@ -11,6 +11,7 @@ enum nf_ct_ext_id {
 	NF_CT_EXT_ACCT,
 	NF_CT_EXT_ECACHE,
 	NF_CT_EXT_ZONE,
+	NF_CT_EXT_QUEUE,
 	NF_CT_EXT_NUM,
 };
 
@@ -19,6 +20,7 @@ enum nf_ct_ext_id {
 #define NF_CT_EXT_ACCT_TYPE struct nf_conn_counter
 #define NF_CT_EXT_ECACHE_TYPE struct nf_conntrack_ecache
 #define NF_CT_EXT_ZONE_TYPE struct nf_conntrack_zone
+#define NF_CT_EXT_QUEUE_TYPE struct nf_conntrack_queue
 
 /* Extensions: optional stuff which isn't permanently in struct. */
 struct nf_ct_ext {
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index eeeb8bc..5b7b105 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -42,6 +42,7 @@
 #include <net/netfilter/nf_conntrack_extend.h>
 #include <net/netfilter/nf_conntrack_acct.h>
 #include <net/netfilter/nf_conntrack_ecache.h>
+#include <net/netfilter/nf_conntrack_queue.h>
 #include <net/netfilter/nf_conntrack_zones.h>
 #include <net/netfilter/nf_nat.h>
 #include <net/netfilter/nf_nat_core.h>
@@ -632,6 +633,11 @@ struct nf_conn *nf_conntrack_alloc(struct net *net, u16 zone,
 		nf_ct_zone->id = zone;
 	}
 #endif
+
+#if defined(CONFIG_NF_QUEUE_CONNBYTES_BYPASS)
+	if (!nf_ct_ext_add(ct, NF_CT_EXT_QUEUE, gfp))
+		goto out_free;
+#endif
 	/*
 	 * changes to lookup keys must be done before setting refcnt to 1
 	 */
@@ -639,11 +645,14 @@ struct nf_conn *nf_conntrack_alloc(struct net *net, u16 zone,
 	atomic_set(&ct->ct_general.use, 1);
 	return ct;
 
-#ifdef CONFIG_NF_CONNTRACK_ZONES
+#if defined(CONFIG_NF_QUEUE_CONNBYTES_BYPASS) \
+	|| defined(CONFIG_NF_CONNTRACK_ZONES)
+
 out_free:
 	kmem_cache_free(net->ct.nf_conntrack_cachep, ct);
 	return ERR_PTR(-ENOMEM);
 #endif
+
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_alloc);
 
@@ -1010,6 +1019,14 @@ static struct nf_ct_ext_type nf_ct_zone_extend __read_mostly = {
 };
 #endif
 
+#if defined(CONFIG_NF_QUEUE_CONNBYTES_BYPASS)
+static struct nf_ct_ext_type nf_conntrack_queue_extend __read_mostly = {
+	.len    = sizeof(struct nf_conntrack_queue),
+	.align  = __alignof__(struct nf_conntrack_queue),
+	.id     = NF_CT_EXT_QUEUE,
+};
+#endif
+
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 
 #include <linux/netfilter/nfnetlink.h>
@@ -1194,6 +1211,11 @@ static void nf_conntrack_cleanup_init_net(void)
 #ifdef CONFIG_NF_CONNTRACK_ZONES
 	nf_ct_extend_unregister(&nf_ct_zone_extend);
 #endif
+
+#if defined(CONFIG_NF_QUEUE_CONNBYTES_BYPASS)
+	nf_ct_extend_unregister(&nf_conntrack_queue_extend);
+#endif
+
 }
 
 static void nf_conntrack_cleanup_net(struct net *net)
@@ -1362,6 +1384,15 @@ static int nf_conntrack_init_init_net(void)
 	if (ret < 0)
 		goto err_extend;
 #endif
+
+#if defined(CONFIG_NF_QUEUE_CONNBYTES_BYPASS)
+	ret = nf_ct_extend_register(&nf_conntrack_queue_extend);
+	if (ret < 0) {
+		printk(KERN_ERR "nfnetlink_queue: failed to register CT ext.\n");
+		goto err_extend_queue;
+	}
+#endif
+
 	/* Set up fake conntrack: to never be deleted, not in any hashes */
 #ifdef CONFIG_NET_NS
 	nf_conntrack_untracked.ct_net = &init_net;
@@ -1372,7 +1403,11 @@ static int nf_conntrack_init_init_net(void)
 
 	return 0;
 
+#if defined(CONFIG_NF_QUEUE_CONNBYTES_BYPASS)
+err_extend_queue:
+#endif
 #ifdef CONFIG_NF_CONNTRACK_ZONES
+	nf_ct_extend_unregister(&nf_ct_zone_extend);
 err_extend:
 	nf_conntrack_helper_fini();
 #endif
-- 
1.7.1

