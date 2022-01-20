Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF8B8C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jan 2022 12:07:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231989AbiATMHT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Jan 2022 07:07:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbiATMHS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jan 2022 07:07:18 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD301C061574
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Jan 2022 04:07:17 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nAWDk-0002kg-4k; Thu, 20 Jan 2022 13:07:16 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/4] netfilter: conntrack: move extension sizes into core
Date:   Thu, 20 Jan 2022 13:07:00 +0100
Message-Id: <20220120120702.15939-3-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220120120702.15939-1-fw@strlen.de>
References: <20220120120702.15939-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

No need to specify this in the registration modules, we already
collect all sizes for build-time checks on the maximum combined size.

After this change, all extensions except nat have no meaningful content
in their nf_ct_ext_type struct definition.

Next patch handles nat, this will then allow to remove the dynamic
register api completely.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack_extend.h |  1 -
 net/netfilter/nf_conntrack_acct.c           |  1 -
 net/netfilter/nf_conntrack_core.c           | 37 ---------
 net/netfilter/nf_conntrack_ecache.c         |  1 -
 net/netfilter/nf_conntrack_extend.c         | 86 ++++++++++++++++++---
 net/netfilter/nf_conntrack_helper.c         |  1 -
 net/netfilter/nf_conntrack_labels.c         |  1 -
 net/netfilter/nf_conntrack_seqadj.c         |  1 -
 net/netfilter/nf_conntrack_timeout.c        |  1 -
 net/netfilter/nf_conntrack_timestamp.c      |  1 -
 net/netfilter/nf_nat_core.c                 |  1 -
 net/netfilter/nf_synproxy_core.c            |  1 -
 net/sched/act_ct.c                          |  1 -
 13 files changed, 76 insertions(+), 58 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
index 705a4487f023..87d818414092 100644
--- a/include/net/netfilter/nf_conntrack_extend.h
+++ b/include/net/netfilter/nf_conntrack_extend.h
@@ -83,7 +83,6 @@ struct nf_ct_ext_type {
 	void (*destroy)(struct nf_conn *ct);
 
 	enum nf_ct_ext_id id;
-	u8 len;
 };
 
 int nf_ct_extend_register(const struct nf_ct_ext_type *type);
diff --git a/net/netfilter/nf_conntrack_acct.c b/net/netfilter/nf_conntrack_acct.c
index c9b20b86711c..4b5048ee84f2 100644
--- a/net/netfilter/nf_conntrack_acct.c
+++ b/net/netfilter/nf_conntrack_acct.c
@@ -23,7 +23,6 @@ module_param_named(acct, nf_ct_acct, bool, 0644);
 MODULE_PARM_DESC(acct, "Enable connection tracking flow accounting.");
 
 static const struct nf_ct_ext_type acct_extend = {
-	.len	= sizeof(struct nf_conn_acct),
 	.id	= NF_CT_EXT_ACCT,
 };
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 894a325d39f2..e301227eabcb 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -47,7 +47,6 @@
 #include <net/netfilter/nf_conntrack_timeout.h>
 #include <net/netfilter/nf_conntrack_labels.h>
 #include <net/netfilter/nf_conntrack_synproxy.h>
-#include <net/netfilter/nf_conntrack_act_ct.h>
 #include <net/netfilter/nf_nat.h>
 #include <net/netfilter/nf_nat_helper.h>
 #include <net/netns/hash.h>
@@ -2626,39 +2625,6 @@ int nf_conntrack_set_hashsize(const char *val, const struct kernel_param *kp)
 	return nf_conntrack_hash_resize(hashsize);
 }
 
-static __always_inline unsigned int total_extension_size(void)
-{
-	/* remember to add new extensions below */
-	BUILD_BUG_ON(NF_CT_EXT_NUM > 10);
-
-	return sizeof(struct nf_ct_ext) +
-	       sizeof(struct nf_conn_help)
-#if IS_ENABLED(CONFIG_NF_NAT)
-		+ sizeof(struct nf_conn_nat)
-#endif
-		+ sizeof(struct nf_conn_seqadj)
-		+ sizeof(struct nf_conn_acct)
-#ifdef CONFIG_NF_CONNTRACK_EVENTS
-		+ sizeof(struct nf_conntrack_ecache)
-#endif
-#ifdef CONFIG_NF_CONNTRACK_TIMESTAMP
-		+ sizeof(struct nf_conn_tstamp)
-#endif
-#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
-		+ sizeof(struct nf_conn_timeout)
-#endif
-#ifdef CONFIG_NF_CONNTRACK_LABELS
-		+ sizeof(struct nf_conn_labels)
-#endif
-#if IS_ENABLED(CONFIG_NETFILTER_SYNPROXY)
-		+ sizeof(struct nf_conn_synproxy)
-#endif
-#if IS_ENABLED(CONFIG_NET_ACT_CT)
-		+ sizeof(struct nf_conn_act_ct_ext)
-#endif
-	;
-};
-
 int nf_conntrack_init_start(void)
 {
 	unsigned long nr_pages = totalram_pages();
@@ -2666,9 +2632,6 @@ int nf_conntrack_init_start(void)
 	int ret = -ENOMEM;
 	int i;
 
-	/* struct nf_ct_ext uses u8 to store offsets/size */
-	BUILD_BUG_ON(total_extension_size() > 255u);
-
 	seqcount_spinlock_init(&nf_conntrack_generation,
 			       &nf_conntrack_locks_all_lock);
 
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 1cf2c8cd6a4a..9ececc9b45f9 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -305,7 +305,6 @@ void nf_conntrack_ecache_work(struct net *net, enum nf_ct_ecache_state state)
 static int nf_ct_events __read_mostly = NF_CT_EVENTS_DEFAULT;
 
 static const struct nf_ct_ext_type event_extend = {
-	.len	= sizeof(struct nf_conntrack_ecache),
 	.id	= NF_CT_EXT_ECACHE,
 };
 
diff --git a/net/netfilter/nf_conntrack_extend.c b/net/netfilter/nf_conntrack_extend.c
index c62f477c6533..69a6cafcb045 100644
--- a/net/netfilter/nf_conntrack_extend.c
+++ b/net/netfilter/nf_conntrack_extend.c
@@ -13,10 +13,82 @@
 #include <linux/skbuff.h>
 #include <net/netfilter/nf_conntrack_extend.h>
 
+#include <net/netfilter/nf_conntrack_helper.h>
+#include <net/netfilter/nf_conntrack_acct.h>
+#include <net/netfilter/nf_conntrack_seqadj.h>
+#include <net/netfilter/nf_conntrack_ecache.h>
+#include <net/netfilter/nf_conntrack_zones.h>
+#include <net/netfilter/nf_conntrack_timestamp.h>
+#include <net/netfilter/nf_conntrack_timeout.h>
+#include <net/netfilter/nf_conntrack_labels.h>
+#include <net/netfilter/nf_conntrack_synproxy.h>
+#include <net/netfilter/nf_conntrack_act_ct.h>
+#include <net/netfilter/nf_nat.h>
+
 static struct nf_ct_ext_type __rcu *nf_ct_ext_types[NF_CT_EXT_NUM];
 static DEFINE_MUTEX(nf_ct_ext_type_mutex);
 #define NF_CT_EXT_PREALLOC	128u /* conntrack events are on by default */
 
+static const u8 nf_ct_ext_type_len[NF_CT_EXT_NUM] = {
+	[NF_CT_EXT_HELPER] = sizeof(struct nf_conn_help),
+#if IS_ENABLED(CONFIG_NF_NAT)
+	[NF_CT_EXT_NAT] = sizeof(struct nf_conn_nat),
+#endif
+	[NF_CT_EXT_SEQADJ] = sizeof(struct nf_conn_seqadj),
+	[NF_CT_EXT_ACCT] = sizeof(struct nf_conn_acct),
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+	[NF_CT_EXT_ECACHE] = sizeof(struct nf_conntrack_ecache),
+#endif
+#ifdef CONFIG_NF_CONNTRACK_TIMESTAMP
+	[NF_CT_EXT_TSTAMP] = sizeof(struct nf_conn_acct),
+#endif
+#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
+	[NF_CT_EXT_TIMEOUT] = sizeof(struct nf_conn_tstamp),
+#endif
+#ifdef CONFIG_NF_CONNTRACK_LABELS
+	[NF_CT_EXT_LABELS] = sizeof(struct nf_conn_labels),
+#endif
+#if IS_ENABLED(CONFIG_NETFILTER_SYNPROXY)
+	[NF_CT_EXT_SYNPROXY] = sizeof(struct nf_conn_synproxy),
+#endif
+#if IS_ENABLED(CONFIG_NET_ACT_CT)
+	[NF_CT_EXT_ACT_CT] = sizeof(struct nf_conn_act_ct_ext),
+#endif
+};
+
+static __always_inline unsigned int total_extension_size(void)
+{
+	/* remember to add new extensions below */
+	BUILD_BUG_ON(NF_CT_EXT_NUM > 10);
+
+	return sizeof(struct nf_ct_ext) +
+	       sizeof(struct nf_conn_help)
+#if IS_ENABLED(CONFIG_NF_NAT)
+		+ sizeof(struct nf_conn_nat)
+#endif
+		+ sizeof(struct nf_conn_seqadj)
+		+ sizeof(struct nf_conn_acct)
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+		+ sizeof(struct nf_conntrack_ecache)
+#endif
+#ifdef CONFIG_NF_CONNTRACK_TIMESTAMP
+		+ sizeof(struct nf_conn_tstamp)
+#endif
+#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
+		+ sizeof(struct nf_conn_timeout)
+#endif
+#ifdef CONFIG_NF_CONNTRACK_LABELS
+		+ sizeof(struct nf_conn_labels)
+#endif
+#if IS_ENABLED(CONFIG_NETFILTER_SYNPROXY)
+		+ sizeof(struct nf_conn_synproxy)
+#endif
+#if IS_ENABLED(CONFIG_NET_ACT_CT)
+		+ sizeof(struct nf_conn_act_ct_ext)
+#endif
+	;
+}
+
 void nf_ct_ext_destroy(struct nf_conn *ct)
 {
 	unsigned int i;
@@ -41,7 +113,6 @@ void nf_ct_ext_destroy(struct nf_conn *ct)
 void *nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 {
 	unsigned int newlen, newoff, oldlen, alloc;
-	struct nf_ct_ext_type *t;
 	struct nf_ct_ext *new;
 
 	/* Conntrack must not be confirmed to avoid races on reallocation. */
@@ -58,16 +129,8 @@ void *nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 		oldlen = sizeof(*new);
 	}
 
-	rcu_read_lock();
-	t = rcu_dereference(nf_ct_ext_types[id]);
-	if (!t) {
-		rcu_read_unlock();
-		return NULL;
-	}
-
 	newoff = ALIGN(oldlen, __alignof__(struct nf_ct_ext));
-	newlen = newoff + t->len;
-	rcu_read_unlock();
+	newlen = newoff + nf_ct_ext_type_len[id];
 
 	alloc = max(newlen, NF_CT_EXT_PREALLOC);
 	new = krealloc(ct->ext, alloc, gfp);
@@ -91,6 +154,9 @@ int nf_ct_extend_register(const struct nf_ct_ext_type *type)
 {
 	int ret = 0;
 
+	/* struct nf_ct_ext uses u8 to store offsets/size */
+	BUILD_BUG_ON(total_extension_size() > 255u);
+
 	mutex_lock(&nf_ct_ext_type_mutex);
 	if (nf_ct_ext_types[type->id]) {
 		ret = -EBUSY;
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index e8f6a389bd01..6fe94f18a4ac 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -551,7 +551,6 @@ void nf_nat_helper_unregister(struct nf_conntrack_nat_helper *nat)
 EXPORT_SYMBOL_GPL(nf_nat_helper_unregister);
 
 static const struct nf_ct_ext_type helper_extend = {
-	.len	= sizeof(struct nf_conn_help),
 	.id	= NF_CT_EXT_HELPER,
 };
 
diff --git a/net/netfilter/nf_conntrack_labels.c b/net/netfilter/nf_conntrack_labels.c
index 6323358dbe73..0cd99535122b 100644
--- a/net/netfilter/nf_conntrack_labels.c
+++ b/net/netfilter/nf_conntrack_labels.c
@@ -80,7 +80,6 @@ void nf_connlabels_put(struct net *net)
 EXPORT_SYMBOL_GPL(nf_connlabels_put);
 
 static const struct nf_ct_ext_type labels_extend = {
-	.len    = sizeof(struct nf_conn_labels),
 	.id     = NF_CT_EXT_LABELS,
 };
 
diff --git a/net/netfilter/nf_conntrack_seqadj.c b/net/netfilter/nf_conntrack_seqadj.c
index b13b3a8a1082..b9629916e53d 100644
--- a/net/netfilter/nf_conntrack_seqadj.c
+++ b/net/netfilter/nf_conntrack_seqadj.c
@@ -234,7 +234,6 @@ s32 nf_ct_seq_offset(const struct nf_conn *ct,
 EXPORT_SYMBOL_GPL(nf_ct_seq_offset);
 
 static const struct nf_ct_ext_type nf_ct_seqadj_extend = {
-	.len	= sizeof(struct nf_conn_seqadj),
 	.id	= NF_CT_EXT_SEQADJ,
 };
 
diff --git a/net/netfilter/nf_conntrack_timeout.c b/net/netfilter/nf_conntrack_timeout.c
index 816fe680375d..ac99a0083156 100644
--- a/net/netfilter/nf_conntrack_timeout.c
+++ b/net/netfilter/nf_conntrack_timeout.c
@@ -136,7 +136,6 @@ void nf_ct_destroy_timeout(struct nf_conn *ct)
 EXPORT_SYMBOL_GPL(nf_ct_destroy_timeout);
 
 static const struct nf_ct_ext_type timeout_extend = {
-	.len	= sizeof(struct nf_conn_timeout),
 	.id	= NF_CT_EXT_TIMEOUT,
 };
 
diff --git a/net/netfilter/nf_conntrack_timestamp.c b/net/netfilter/nf_conntrack_timestamp.c
index 81878d9786ba..c696ca19dcb1 100644
--- a/net/netfilter/nf_conntrack_timestamp.c
+++ b/net/netfilter/nf_conntrack_timestamp.c
@@ -20,7 +20,6 @@ module_param_named(tstamp, nf_ct_tstamp, bool, 0644);
 MODULE_PARM_DESC(tstamp, "Enable connection tracking flow timestamping.");
 
 static const struct nf_ct_ext_type tstamp_extend = {
-	.len	= sizeof(struct nf_conn_tstamp),
 	.id	= NF_CT_EXT_TSTAMP,
 };
 
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index d0000f63b0af..2ff20d6a5afb 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -876,7 +876,6 @@ static void nf_nat_cleanup_conntrack(struct nf_conn *ct)
 }
 
 static struct nf_ct_ext_type nat_extend __read_mostly = {
-	.len		= sizeof(struct nf_conn_nat),
 	.destroy	= nf_nat_cleanup_conntrack,
 	.id		= NF_CT_EXT_NAT,
 };
diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index d5c1e93c4ba3..6d328f7bb323 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -237,7 +237,6 @@ synproxy_tstamp_adjust(struct sk_buff *skb, unsigned int protoff,
 }
 
 static struct nf_ct_ext_type nf_ct_synproxy_extend __read_mostly = {
-	.len		= sizeof(struct nf_conn_synproxy),
 	.id		= NF_CT_EXT_SYNPROXY,
 };
 
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 78ccd16be05e..774e32fab5cf 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -58,7 +58,6 @@ static const struct rhashtable_params zones_params = {
 };
 
 static struct nf_ct_ext_type act_ct_extend __read_mostly = {
-	.len		= sizeof(struct nf_conn_act_ct_ext),
 	.id		= NF_CT_EXT_ACT_CT,
 };
 
-- 
2.34.1

