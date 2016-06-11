From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: move zone info into struct nf_conn
Date: Sat, 11 Jun 2016 21:57:35 +0200
Message-ID: <1465675055-7655-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:38035 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752080AbcFKT50 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 Jun 2016 15:57:26 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Curently we store zone information as a conntrack extension.
This has one drawback: for every lookup we need to fetch the zone data
from the extension area.

This change place the zone data directly into the main conntrack object
structure and then removes the zone conntrack extension.

The zone data is just 4 bytes, it fits into a padding hole before
the tuplehash info, so we do not even increase the nf_conn structure size.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack.h        |  3 +++
 include/net/netfilter/nf_conntrack_extend.h |  4 ----
 include/net/netfilter/nf_conntrack_zones.h  | 33 ++++++++++-------------------
 net/netfilter/nf_conntrack_core.c           | 33 ++---------------------------
 4 files changed, 16 insertions(+), 57 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index dd78bea..9c0ed3d 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -85,6 +85,9 @@ struct nf_conn {
 	spinlock_t	lock;
 	u16		cpu;
 
+#ifdef CONFIG_NF_CONNTRACK_ZONES
+	struct nf_conntrack_zone zone;
+#endif
 	/* XXX should I move this to the tail ? - Y.K */
 	/* These are my tuples; original and reply */
 	struct nf_conntrack_tuple_hash tuplehash[IP_CT_DIR_MAX];
diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
index 55d1504..b925395 100644
--- a/include/net/netfilter/nf_conntrack_extend.h
+++ b/include/net/netfilter/nf_conntrack_extend.h
@@ -15,9 +15,6 @@ enum nf_ct_ext_id {
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 	NF_CT_EXT_ECACHE,
 #endif
-#ifdef CONFIG_NF_CONNTRACK_ZONES
-	NF_CT_EXT_ZONE,
-#endif
 #ifdef CONFIG_NF_CONNTRACK_TIMESTAMP
 	NF_CT_EXT_TSTAMP,
 #endif
@@ -38,7 +35,6 @@ enum nf_ct_ext_id {
 #define NF_CT_EXT_SEQADJ_TYPE struct nf_conn_seqadj
 #define NF_CT_EXT_ACCT_TYPE struct nf_conn_acct
 #define NF_CT_EXT_ECACHE_TYPE struct nf_conntrack_ecache
-#define NF_CT_EXT_ZONE_TYPE struct nf_conntrack_zone
 #define NF_CT_EXT_TSTAMP_TYPE struct nf_conn_tstamp
 #define NF_CT_EXT_TIMEOUT_TYPE struct nf_conn_timeout
 #define NF_CT_EXT_LABELS_TYPE struct nf_conn_labels
diff --git a/include/net/netfilter/nf_conntrack_zones.h b/include/net/netfilter/nf_conntrack_zones.h
index bd46926..64a718b 100644
--- a/include/net/netfilter/nf_conntrack_zones.h
+++ b/include/net/netfilter/nf_conntrack_zones.h
@@ -9,12 +9,11 @@
 static inline const struct nf_conntrack_zone *
 nf_ct_zone(const struct nf_conn *ct)
 {
-	const struct nf_conntrack_zone *nf_ct_zone = NULL;
-
 #ifdef CONFIG_NF_CONNTRACK_ZONES
-	nf_ct_zone = nf_ct_ext_find(ct, NF_CT_EXT_ZONE);
+	return &ct->zone;
+#else
+	return &nf_ct_zone_dflt;
 #endif
-	return nf_ct_zone ? nf_ct_zone : &nf_ct_zone_dflt;
 }
 
 static inline const struct nf_conntrack_zone *
@@ -31,32 +30,22 @@ static inline const struct nf_conntrack_zone *
 nf_ct_zone_tmpl(const struct nf_conn *tmpl, const struct sk_buff *skb,
 		struct nf_conntrack_zone *tmp)
 {
-	const struct nf_conntrack_zone *zone;
-
+#ifdef CONFIG_NF_CONNTRACK_ZONES
 	if (!tmpl)
 		return &nf_ct_zone_dflt;
 
-	zone = nf_ct_zone(tmpl);
-	if (zone->flags & NF_CT_FLAG_MARK)
-		zone = nf_ct_zone_init(tmp, skb->mark, zone->dir, 0);
-
-	return zone;
+	if (tmpl->zone.flags & NF_CT_FLAG_MARK)
+		return nf_ct_zone_init(tmp, skb->mark, tmpl->zone.dir, 0);
+#endif
+	return nf_ct_zone(tmpl);
 }
 
-static inline int nf_ct_zone_add(struct nf_conn *ct, gfp_t flags,
-				 const struct nf_conntrack_zone *info)
+static inline void nf_ct_zone_add(struct nf_conn *ct,
+				  const struct nf_conntrack_zone *zone)
 {
 #ifdef CONFIG_NF_CONNTRACK_ZONES
-	struct nf_conntrack_zone *nf_ct_zone;
-
-	nf_ct_zone = nf_ct_ext_add(ct, NF_CT_EXT_ZONE, flags);
-	if (!nf_ct_zone)
-		return -ENOMEM;
-
-	nf_ct_zone_init(nf_ct_zone, info->id, info->dir,
-			info->flags);
+	ct->zone = *zone;
 #endif
-	return 0;
 }
 
 static inline bool nf_ct_zone_matches_dir(const struct nf_conntrack_zone *zone,
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index db2312e..c74dac7 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -327,16 +327,10 @@ struct nf_conn *nf_ct_tmpl_alloc(struct net *net,
 
 	tmpl->status = IPS_TEMPLATE;
 	write_pnet(&tmpl->ct_net, net);
-
-	if (nf_ct_zone_add(tmpl, flags, zone) < 0)
-		goto out_free;
-
+	nf_ct_zone_add(tmpl, zone);
 	atomic_set(&tmpl->ct_general.use, 0);
 
 	return tmpl;
-out_free:
-	kfree(tmpl);
-	return NULL;
 }
 EXPORT_SYMBOL_GPL(nf_ct_tmpl_alloc);
 
@@ -929,16 +923,13 @@ __nf_conntrack_alloc(struct net *net,
 	       offsetof(struct nf_conn, proto) -
 	       offsetof(struct nf_conn, __nfct_init_offset[0]));
 
-	if (zone && nf_ct_zone_add(ct, GFP_ATOMIC, zone) < 0)
-		goto out_free;
+	nf_ct_zone_add(ct, zone);
 
 	/* Because we use RCU lookups, we set ct_general.use to zero before
 	 * this is inserted in any list.
 	 */
 	atomic_set(&ct->ct_general.use, 0);
 	return ct;
-out_free:
-	kmem_cache_free(nf_conntrack_cachep, ct);
 out:
 	atomic_dec(&net->ct.count);
 	return ERR_PTR(-ENOMEM);
@@ -1342,14 +1333,6 @@ bool __nf_ct_kill_acct(struct nf_conn *ct,
 }
 EXPORT_SYMBOL_GPL(__nf_ct_kill_acct);
 
-#ifdef CONFIG_NF_CONNTRACK_ZONES
-static struct nf_ct_ext_type nf_ct_zone_extend __read_mostly = {
-	.len	= sizeof(struct nf_conntrack_zone),
-	.align	= __alignof__(struct nf_conntrack_zone),
-	.id	= NF_CT_EXT_ZONE,
-};
-#endif
-
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 
 #include <linux/netfilter/nfnetlink.h>
@@ -1532,9 +1515,6 @@ void nf_conntrack_cleanup_end(void)
 
 	nf_ct_free_hashtable(nf_conntrack_hash, nf_conntrack_htable_size);
 
-#ifdef CONFIG_NF_CONNTRACK_ZONES
-	nf_ct_extend_unregister(&nf_ct_zone_extend);
-#endif
 	nf_conntrack_proto_fini();
 	nf_conntrack_seqadj_fini();
 	nf_conntrack_labels_fini();
@@ -1771,11 +1751,6 @@ int nf_conntrack_init_start(void)
 	if (ret < 0)
 		goto err_seqadj;
 
-#ifdef CONFIG_NF_CONNTRACK_ZONES
-	ret = nf_ct_extend_register(&nf_ct_zone_extend);
-	if (ret < 0)
-		goto err_extend;
-#endif
 	ret = nf_conntrack_proto_init();
 	if (ret < 0)
 		goto err_proto;
@@ -1791,10 +1766,6 @@ int nf_conntrack_init_start(void)
 	return 0;
 
 err_proto:
-#ifdef CONFIG_NF_CONNTRACK_ZONES
-	nf_ct_extend_unregister(&nf_ct_zone_extend);
-err_extend:
-#endif
 	nf_conntrack_seqadj_fini();
 err_seqadj:
 	nf_conntrack_labels_fini();
-- 
2.7.3

