Received: from smtp-out.freemail.hu (fmfe34.freemail.hu [46.107.16.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6F31F472F;
	Tue,  7 Jan 2025 18:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.107.16.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736275694; cv=none; b=I4V7LFsR16ywJU4AR6f1KCEdkJC2sGeno6fVPe2ofyk3jERCpYnascL56gSolhDl31uaZOZx5I7lU5Q6j+YolOhGU44GfqaheN46UkGAh1HJEb8ePHlSqEhmSTS0r4eOIUZv3sJ7r7+EKs0EjBG6eZCiQCiWGm83tLCBGuI34T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736275694; c=relaxed/simple;
	bh=+BVeyhg4zJidUQtnhsZ5V34Oa+zzzqnapUeOX+M6s24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dm0Q+4vh9L6BAvPf6TLhbPj/LjoEYos9kzlWHw4zTMi+EuGiZUioBy/OnpcB9J3GXs7EsKAQaNd83ml1AD7sw/0rm5v50np8K5EBa0XqExQdDcFxWbrUcFA9mN6icZWU9xlQgSbtbgCnyliN+c1ldpksQ8K3oRYbaoZXU2GAIn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu; spf=pass smtp.mailfrom=freemail.hu; dkim=fail (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b=f2xolSup reason="signature verification failed"; arc=none smtp.client-ip=46.107.16.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freemail.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b="f2xolSup"
Received: from fizweb.elte.hu (fizweb.elte.hu [157.181.183.248])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.freemail.hu (Postfix) with ESMTPSA id 4YSKn43Xr7z10V0;
	Tue, 07 Jan 2025 19:48:08 +0100 (CET)
From: egyszeregy@freemail.hu
To: fw@strlen.de,
	pablo@netfilter.org,
	lorenzo@kernel.org,
	daniel@iogearbox.net,
	leitao@debian.org,
	amiculas@cisco.com,
	kadlec@netfilter.org,
	davem@davemloft.net,
	dsahern@kernel.org,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Cc: =?UTF-8?q?Benjamin=20Sz=C5=91ke?= <egyszeregy@freemail.hu>
Subject: [PATCH 4/6] netfilter: x_tables: Merge xt_RATEEST.c to xt_rateest.c
Date: Tue,  7 Jan 2025 19:47:22 +0100
Message-ID: <20250107184724.56223-5-egyszeregy@freemail.hu>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250107184724.56223-1-egyszeregy@freemail.hu>
References: <20250107184724.56223-1-egyszeregy@freemail.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/relaxed; t=1736275689;
	s=20181004; d=freemail.hu;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	l=18209; bh=zvBk9tEFlJcU6YRcwwr7UH6SPiB9QwVsgVKuAbHki0c=;
	b=f2xolSup7rgxoyZdyXb5Jv4CvUuz68TYPzRcwIH5lGw4KcEJPp3fyywIhfNbzYxf
	vCWCRD+XrD5Ik+RV+3yNrmr5aTyefCBEUTxHKwXoDvVAoWq12m5jNyja1tCnuAymvUt
	qdtB/jEBLZaGMBdnfGNtd58W1e1q6n0e+JfyvlJ/Zk3nDnAJzIBq2BBAl65/3wkHOIi
	tAjxVWGRIH//h6bjDjczI9TCRJpjT0JvQGzNwNJIvkU8DMp0woIdB+CHDeasRNLwgkZ
	Gl0vEI6Eu2eMW9kU/WkCjN6XfJG+qwNjCgvuuQ6UTfFYfpzJxQ/YB+gmrZ9T9/YfQu7
	nI7iESLZew==

From: Benjamin Szőke <egyszeregy@freemail.hu>

Merge xt_RATEEST.c to xt_rateest.c file and remove xt_RATEEST.c.

Signed-off-by: Benjamin Szőke <egyszeregy@freemail.hu>
---
 net/netfilter/Kconfig      |  19 +++
 net/netfilter/Makefile     |   3 +-
 net/netfilter/xt_RATEEST.c | 249 ------------------------------------
 net/netfilter/xt_rateest.c | 253 +++++++++++++++++++++++++++++++++++--
 4 files changed, 263 insertions(+), 261 deletions(-)
 delete mode 100644 net/netfilter/xt_RATEEST.c

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index ca293f9a1db5..1aff3c7c4363 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -825,6 +825,16 @@ config NETFILTER_XT_HL
 	  The target allows you to change the hoplimit/time-to-live
 	  value of the IP header.
 
+config NETFILTER_XT_RATEEST
+	tristate '"RATEEST" target and match support'
+	depends on NETFILTER_ADVANCED
+	help
+	  This option adds the "RATEEST" target and "rateest" match.
+
+	  Netfilter rateest matching allows you to match on the rate
+	  estimated by the RATEEST target.
+	  The target allows you to measure rates similar to TC estimators.
+
 # alphabetically ordered list of targets
 
 comment "Xtables targets"
@@ -1062,11 +1072,16 @@ config NETFILTER_XT_TARGET_NOTRACK
 config NETFILTER_XT_TARGET_RATEEST
 	tristate '"RATEEST" target support'
 	depends on NETFILTER_ADVANCED
+	select NETFILTER_XT_RATEEST
 	help
 	  This option adds a `RATEEST' target, which allows to measure
 	  rates similar to TC estimators. The `rateest' match can be
 	  used to match on the measured rates.
 
+	  This is a backwards-compat option for the user's convenience
+	  (e.g. when running oldconfig). It selects
+	  CONFIG_NETFILTER_XT_RATEEST (combined rateest/RATEEST module).
+
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config NETFILTER_XT_TARGET_REDIRECT
@@ -1576,6 +1591,10 @@ config NETFILTER_XT_MATCH_RATEEST
 	  This option adds a `rateest' match, which allows to match on the
 	  rate estimated by the RATEEST target.
 
+	  This is a backwards-compat option for the user's convenience
+	  (e.g. when running oldconfig). It selects
+	  CONFIG_NETFILTER_XT_RATEEST (combined rateest/RATEEST module).
+
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config NETFILTER_XT_MATCH_REALM
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 381a18ce84d0..923112b0dc1e 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -162,6 +162,7 @@ obj-$(CONFIG_NETFILTER_XT_SET) += xt_set.o
 obj-$(CONFIG_NETFILTER_XT_NAT) += xt_nat.o
 obj-$(CONFIG_NETFILTER_XT_DSCP) += xt_dscp.o
 obj-$(CONFIG_NETFILTER_XT_HL) += xt_hl.o
+obj-$(CONFIG_NETFILTER_XT_RATEEST) += xt_rateest.o
 
 # targets
 obj-$(CONFIG_NETFILTER_XT_TARGET_AUDIT) += xt_AUDIT.o
@@ -175,7 +176,6 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_LOG) += xt_LOG.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NETMAP) += xt_NETMAP.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NFLOG) += xt_NFLOG.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NFQUEUE) += xt_NFQUEUE.o
-obj-$(CONFIG_NETFILTER_XT_TARGET_RATEEST) += xt_RATEEST.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_REDIRECT) += xt_REDIRECT.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_MASQUERADE) += xt_MASQUERADE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_SECMARK) += xt_SECMARK.o
@@ -218,7 +218,6 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_PHYSDEV) += xt_physdev.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_PKTTYPE) += xt_pkttype.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_POLICY) += xt_policy.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_QUOTA) += xt_quota.o
-obj-$(CONFIG_NETFILTER_XT_MATCH_RATEEST) += xt_rateest.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_REALM) += xt_realm.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_RECENT) += xt_recent.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_SCTP) += xt_sctp.o
diff --git a/net/netfilter/xt_RATEEST.c b/net/netfilter/xt_RATEEST.c
deleted file mode 100644
index d56276b965fa..000000000000
--- a/net/netfilter/xt_RATEEST.c
+++ /dev/null
@@ -1,249 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * (C) 2007 Patrick McHardy <kaber@trash.net>
- */
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/gen_stats.h>
-#include <linux/jhash.h>
-#include <linux/rtnetlink.h>
-#include <linux/random.h>
-#include <linux/slab.h>
-#include <net/gen_stats.h>
-#include <net/netlink.h>
-#include <net/netns/generic.h>
-
-#include <linux/netfilter/x_tables.h>
-#include <linux/netfilter/xt_rateest.h>
-#include <net/netfilter/xt_rateest.h>
-
-#define RATEEST_HSIZE	16
-
-struct xt_rateest_net {
-	/* To synchronize concurrent synchronous rate estimator operations. */
-	struct mutex hash_lock;
-	struct hlist_head hash[RATEEST_HSIZE];
-};
-
-static unsigned int xt_rateest_id;
-
-static unsigned int jhash_rnd __read_mostly;
-
-static unsigned int xt_rateest_hash(const char *name)
-{
-	return jhash(name, sizeof_field(struct xt_rateest, name), jhash_rnd) &
-	       (RATEEST_HSIZE - 1);
-}
-
-static void xt_rateest_hash_insert(struct xt_rateest_net *xn,
-				   struct xt_rateest *est)
-{
-	unsigned int h;
-
-	h = xt_rateest_hash(est->name);
-	hlist_add_head(&est->list, &xn->hash[h]);
-}
-
-static struct xt_rateest *__xt_rateest_lookup(struct xt_rateest_net *xn,
-					      const char *name)
-{
-	struct xt_rateest *est;
-	unsigned int h;
-
-	h = xt_rateest_hash(name);
-	hlist_for_each_entry(est, &xn->hash[h], list) {
-		if (strcmp(est->name, name) == 0) {
-			est->refcnt++;
-			return est;
-		}
-	}
-
-	return NULL;
-}
-
-struct xt_rateest *xt_rateest_lookup(struct net *net, const char *name)
-{
-	struct xt_rateest_net *xn = net_generic(net, xt_rateest_id);
-	struct xt_rateest *est;
-
-	mutex_lock(&xn->hash_lock);
-	est = __xt_rateest_lookup(xn, name);
-	mutex_unlock(&xn->hash_lock);
-	return est;
-}
-EXPORT_SYMBOL_GPL(xt_rateest_lookup);
-
-void xt_rateest_put(struct net *net, struct xt_rateest *est)
-{
-	struct xt_rateest_net *xn = net_generic(net, xt_rateest_id);
-
-	mutex_lock(&xn->hash_lock);
-	if (--est->refcnt == 0) {
-		hlist_del(&est->list);
-		gen_kill_estimator(&est->rate_est);
-		/*
-		 * gen_estimator est_timer() might access est->lock or bstats,
-		 * wait a RCU grace period before freeing 'est'
-		 */
-		kfree_rcu(est, rcu);
-	}
-	mutex_unlock(&xn->hash_lock);
-}
-EXPORT_SYMBOL_GPL(xt_rateest_put);
-
-static unsigned int
-xt_rateest_tg(struct sk_buff *skb, const struct xt_action_param *par)
-{
-	const struct xt_rateest_target_info *info = par->targinfo;
-	struct gnet_stats_basic_sync *stats = &info->est->bstats;
-
-	spin_lock_bh(&info->est->lock);
-	u64_stats_add(&stats->bytes, skb->len);
-	u64_stats_inc(&stats->packets);
-	spin_unlock_bh(&info->est->lock);
-
-	return XT_CONTINUE;
-}
-
-static int xt_rateest_tg_checkentry(const struct xt_tgchk_param *par)
-{
-	struct xt_rateest_net *xn = net_generic(par->net, xt_rateest_id);
-	struct xt_rateest_target_info *info = par->targinfo;
-	struct xt_rateest *est;
-	struct {
-		struct nlattr		opt;
-		struct gnet_estimator	est;
-	} cfg;
-	int ret;
-
-	if (strnlen(info->name, sizeof(est->name)) >= sizeof(est->name))
-		return -ENAMETOOLONG;
-
-	net_get_random_once(&jhash_rnd, sizeof(jhash_rnd));
-
-	mutex_lock(&xn->hash_lock);
-	est = __xt_rateest_lookup(xn, info->name);
-	if (est) {
-		mutex_unlock(&xn->hash_lock);
-		/*
-		 * If estimator parameters are specified, they must match the
-		 * existing estimator.
-		 */
-		if ((!info->interval && !info->ewma_log) ||
-		    (info->interval != est->params.interval ||
-		     info->ewma_log != est->params.ewma_log)) {
-			xt_rateest_put(par->net, est);
-			return -EINVAL;
-		}
-		info->est = est;
-		return 0;
-	}
-
-	ret = -ENOMEM;
-	est = kzalloc(sizeof(*est), GFP_KERNEL);
-	if (!est)
-		goto err1;
-
-	gnet_stats_basic_sync_init(&est->bstats);
-	strscpy(est->name, info->name, sizeof(est->name));
-	spin_lock_init(&est->lock);
-	est->refcnt		= 1;
-	est->params.interval	= info->interval;
-	est->params.ewma_log	= info->ewma_log;
-
-	cfg.opt.nla_len		= nla_attr_size(sizeof(cfg.est));
-	cfg.opt.nla_type	= TCA_STATS_RATE_EST;
-	cfg.est.interval	= info->interval;
-	cfg.est.ewma_log	= info->ewma_log;
-
-	ret = gen_new_estimator(&est->bstats, NULL, &est->rate_est,
-				&est->lock, NULL, &cfg.opt);
-	if (ret < 0)
-		goto err2;
-
-	info->est = est;
-	xt_rateest_hash_insert(xn, est);
-	mutex_unlock(&xn->hash_lock);
-	return 0;
-
-err2:
-	kfree(est);
-err1:
-	mutex_unlock(&xn->hash_lock);
-	return ret;
-}
-
-static void xt_rateest_tg_destroy(const struct xt_tgdtor_param *par)
-{
-	struct xt_rateest_target_info *info = par->targinfo;
-
-	xt_rateest_put(par->net, info->est);
-}
-
-static struct xt_target xt_rateest_tg_reg[] __read_mostly = {
-	{
-		.name       = "RATEEST",
-		.revision   = 0,
-		.family     = NFPROTO_IPV4,
-		.target     = xt_rateest_tg,
-		.checkentry = xt_rateest_tg_checkentry,
-		.destroy    = xt_rateest_tg_destroy,
-		.targetsize = sizeof(struct xt_rateest_target_info),
-		.usersize   = offsetof(struct xt_rateest_target_info, est),
-		.me         = THIS_MODULE,
-	},
-#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
-	{
-		.name       = "RATEEST",
-		.revision   = 0,
-		.family     = NFPROTO_IPV6,
-		.target     = xt_rateest_tg,
-		.checkentry = xt_rateest_tg_checkentry,
-		.destroy    = xt_rateest_tg_destroy,
-		.targetsize = sizeof(struct xt_rateest_target_info),
-		.usersize   = offsetof(struct xt_rateest_target_info, est),
-		.me         = THIS_MODULE,
-	},
-#endif
-};
-
-static __net_init int xt_rateest_net_init(struct net *net)
-{
-	struct xt_rateest_net *xn = net_generic(net, xt_rateest_id);
-	int i;
-
-	mutex_init(&xn->hash_lock);
-	for (i = 0; i < ARRAY_SIZE(xn->hash); i++)
-		INIT_HLIST_HEAD(&xn->hash[i]);
-	return 0;
-}
-
-static struct pernet_operations xt_rateest_net_ops = {
-	.init = xt_rateest_net_init,
-	.id   = &xt_rateest_id,
-	.size = sizeof(struct xt_rateest_net),
-};
-
-static int __init xt_rateest_tg_init(void)
-{
-	int err = register_pernet_subsys(&xt_rateest_net_ops);
-
-	if (err)
-		return err;
-	return xt_register_targets(xt_rateest_tg_reg, ARRAY_SIZE(xt_rateest_tg_reg));
-}
-
-static void __exit xt_rateest_tg_fini(void)
-{
-	xt_unregister_targets(xt_rateest_tg_reg, ARRAY_SIZE(xt_rateest_tg_reg));
-	unregister_pernet_subsys(&xt_rateest_net_ops);
-}
-
-
-MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Xtables: packet rate estimator");
-MODULE_ALIAS("ipt_RATEEST");
-MODULE_ALIAS("ip6t_RATEEST");
-module_init(xt_rateest_tg_init);
-module_exit(xt_rateest_tg_fini);
diff --git a/net/netfilter/xt_rateest.c b/net/netfilter/xt_rateest.c
index 72324bd976af..c0153b5b47a0 100644
--- a/net/netfilter/xt_rateest.c
+++ b/net/netfilter/xt_rateest.c
@@ -5,11 +5,28 @@
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/gen_stats.h>
+#include <linux/jhash.h>
+#include <linux/rtnetlink.h>
+#include <linux/random.h>
+#include <linux/slab.h>
+#include <net/gen_stats.h>
+#include <net/netlink.h>
+#include <net/netns/generic.h>
 
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_rateest.h>
 #include <net/netfilter/xt_rateest.h>
 
+#define RATEEST_HSIZE	16
+
+MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("xtables packet rate estimator");
+MODULE_ALIAS("ipt_rateest");
+MODULE_ALIAS("ip6t_rateest");
+MODULE_ALIAS("ipt_RATEEST");
+MODULE_ALIAS("ip6t_RATEEST");
+MODULE_ALIAS("xt_RATEEST");
 
 static bool
 xt_rateest_mt(const struct sk_buff *skb, struct xt_action_param *par)
@@ -134,20 +151,236 @@ static struct xt_match xt_rateest_mt_reg __read_mostly = {
 	.me         = THIS_MODULE,
 };
 
-static int __init xt_rateest_mt_init(void)
+struct xt_rateest_net {
+	/* To synchronize concurrent synchronous rate estimator operations. */
+	struct mutex hash_lock;
+	struct hlist_head hash[RATEEST_HSIZE];
+};
+
+static unsigned int xt_rateest_id;
+
+static unsigned int jhash_rnd __read_mostly;
+
+static unsigned int xt_rateest_hash(const char *name)
+{
+	return jhash(name, sizeof_field(struct xt_rateest, name), jhash_rnd) &
+	       (RATEEST_HSIZE - 1);
+}
+
+static void xt_rateest_hash_insert(struct xt_rateest_net *xn,
+				   struct xt_rateest *est)
+{
+	unsigned int h;
+
+	h = xt_rateest_hash(est->name);
+	hlist_add_head(&est->list, &xn->hash[h]);
+}
+
+static struct xt_rateest *__xt_rateest_lookup(struct xt_rateest_net *xn,
+					      const char *name)
 {
-	return xt_register_match(&xt_rateest_mt_reg);
+	struct xt_rateest *est;
+	unsigned int h;
+
+	h = xt_rateest_hash(name);
+	hlist_for_each_entry(est, &xn->hash[h], list) {
+		if (strcmp(est->name, name) == 0) {
+			est->refcnt++;
+			return est;
+		}
+	}
+
+	return NULL;
 }
 
-static void __exit xt_rateest_mt_fini(void)
+struct xt_rateest *xt_rateest_lookup(struct net *net, const char *name)
+{
+	struct xt_rateest_net *xn = net_generic(net, xt_rateest_id);
+	struct xt_rateest *est;
+
+	mutex_lock(&xn->hash_lock);
+	est = __xt_rateest_lookup(xn, name);
+	mutex_unlock(&xn->hash_lock);
+	return est;
+}
+EXPORT_SYMBOL_GPL(xt_rateest_lookup);
+
+void xt_rateest_put(struct net *net, struct xt_rateest *est)
+{
+	struct xt_rateest_net *xn = net_generic(net, xt_rateest_id);
+
+	mutex_lock(&xn->hash_lock);
+	if (--est->refcnt == 0) {
+		hlist_del(&est->list);
+		gen_kill_estimator(&est->rate_est);
+		/*
+		 * gen_estimator est_timer() might access est->lock or bstats,
+		 * wait a RCU grace period before freeing 'est'
+		 */
+		kfree_rcu(est, rcu);
+	}
+	mutex_unlock(&xn->hash_lock);
+}
+EXPORT_SYMBOL_GPL(xt_rateest_put);
+
+static unsigned int
+xt_rateest_tg(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	const struct xt_rateest_target_info *info = par->targinfo;
+	struct gnet_stats_basic_sync *stats = &info->est->bstats;
+
+	spin_lock_bh(&info->est->lock);
+	u64_stats_add(&stats->bytes, skb->len);
+	u64_stats_inc(&stats->packets);
+	spin_unlock_bh(&info->est->lock);
+
+	return XT_CONTINUE;
+}
+
+static int xt_rateest_tg_checkentry(const struct xt_tgchk_param *par)
+{
+	struct xt_rateest_net *xn = net_generic(par->net, xt_rateest_id);
+	struct xt_rateest_target_info *info = par->targinfo;
+	struct xt_rateest *est;
+	struct {
+		struct nlattr		opt;
+		struct gnet_estimator	est;
+	} cfg;
+	int ret;
+
+	if (strnlen(info->name, sizeof(est->name)) >= sizeof(est->name))
+		return -ENAMETOOLONG;
+
+	net_get_random_once(&jhash_rnd, sizeof(jhash_rnd));
+
+	mutex_lock(&xn->hash_lock);
+	est = __xt_rateest_lookup(xn, info->name);
+	if (est) {
+		mutex_unlock(&xn->hash_lock);
+		/*
+		 * If estimator parameters are specified, they must match the
+		 * existing estimator.
+		 */
+		if ((!info->interval && !info->ewma_log) ||
+		    (info->interval != est->params.interval ||
+		     info->ewma_log != est->params.ewma_log)) {
+			xt_rateest_put(par->net, est);
+			return -EINVAL;
+		}
+		info->est = est;
+		return 0;
+	}
+
+	ret = -ENOMEM;
+	est = kzalloc(sizeof(*est), GFP_KERNEL);
+	if (!est)
+		goto err1;
+
+	gnet_stats_basic_sync_init(&est->bstats);
+	strscpy(est->name, info->name, sizeof(est->name));
+	spin_lock_init(&est->lock);
+	est->refcnt		= 1;
+	est->params.interval	= info->interval;
+	est->params.ewma_log	= info->ewma_log;
+
+	cfg.opt.nla_len		= nla_attr_size(sizeof(cfg.est));
+	cfg.opt.nla_type	= TCA_STATS_RATE_EST;
+	cfg.est.interval	= info->interval;
+	cfg.est.ewma_log	= info->ewma_log;
+
+	ret = gen_new_estimator(&est->bstats, NULL, &est->rate_est,
+				&est->lock, NULL, &cfg.opt);
+	if (ret < 0)
+		goto err2;
+
+	info->est = est;
+	xt_rateest_hash_insert(xn, est);
+	mutex_unlock(&xn->hash_lock);
+	return 0;
+
+err2:
+	kfree(est);
+err1:
+	mutex_unlock(&xn->hash_lock);
+	return ret;
+}
+
+static void xt_rateest_tg_destroy(const struct xt_tgdtor_param *par)
+{
+	struct xt_rateest_target_info *info = par->targinfo;
+
+	xt_rateest_put(par->net, info->est);
+}
+
+static struct xt_target xt_rateest_tg_reg[] __read_mostly = {
+	{
+		.name       = "RATEEST",
+		.revision   = 0,
+		.family     = NFPROTO_IPV4,
+		.target     = xt_rateest_tg,
+		.checkentry = xt_rateest_tg_checkentry,
+		.destroy    = xt_rateest_tg_destroy,
+		.targetsize = sizeof(struct xt_rateest_target_info),
+		.usersize   = offsetof(struct xt_rateest_target_info, est),
+		.me         = THIS_MODULE,
+	},
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
+	{
+		.name       = "RATEEST",
+		.revision   = 0,
+		.family     = NFPROTO_IPV6,
+		.target     = xt_rateest_tg,
+		.checkentry = xt_rateest_tg_checkentry,
+		.destroy    = xt_rateest_tg_destroy,
+		.targetsize = sizeof(struct xt_rateest_target_info),
+		.usersize   = offsetof(struct xt_rateest_target_info, est),
+		.me         = THIS_MODULE,
+	},
+#endif
+};
+
+static __net_init int xt_rateest_net_init(struct net *net)
+{
+	struct xt_rateest_net *xn = net_generic(net, xt_rateest_id);
+	int i;
+
+	mutex_init(&xn->hash_lock);
+	for (i = 0; i < ARRAY_SIZE(xn->hash); i++)
+		INIT_HLIST_HEAD(&xn->hash[i]);
+	return 0;
+}
+
+static struct pernet_operations xt_rateest_net_ops = {
+	.init = xt_rateest_net_init,
+	.id   = &xt_rateest_id,
+	.size = sizeof(struct xt_rateest_net),
+};
+
+static int __init xt_rateest_init(void)
+{
+	int ret = register_pernet_subsys(&xt_rateest_net_ops);
+
+	if (ret)
+		return ret;
+
+	ret = xt_register_targets(xt_rateest_tg_reg, ARRAY_SIZE(xt_rateest_tg_reg));
+	if (ret < 0)
+		return ret;
+	ret = xt_register_match(&xt_rateest_mt_reg);
+	if (ret < 0) {
+		xt_unregister_targets(xt_rateest_tg_reg, ARRAY_SIZE(xt_rateest_tg_reg));
+		unregister_pernet_subsys(&xt_rateest_net_ops);
+		return ret;
+	}
+	return 0;
+}
+
+static void __exit xt_rateest_exit(void)
 {
 	xt_unregister_match(&xt_rateest_mt_reg);
+	xt_unregister_targets(xt_rateest_tg_reg, ARRAY_SIZE(xt_rateest_tg_reg));
+	unregister_pernet_subsys(&xt_rateest_net_ops);
 }
 
-MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("xtables rate estimator match");
-MODULE_ALIAS("ipt_rateest");
-MODULE_ALIAS("ip6t_rateest");
-module_init(xt_rateest_mt_init);
-module_exit(xt_rateest_mt_fini);
+module_init(xt_rateest_init);
+module_exit(xt_rateest_exit);
-- 
2.43.5

