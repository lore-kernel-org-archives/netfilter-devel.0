From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/8] netfilter: xtables: slightly better error reporting (2/2)
Date: Sat, 20 Mar 2010 02:02:18 +0100
Message-ID: <1269046942-31719-6-git-send-email-jengelh@medozas.de>
References: <1269046942-31719-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:59723 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752660Ab0CTBCg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Mar 2010 21:02:36 -0400
In-Reply-To: <1269046942-31719-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When extended status codes are available, such as ENOMEM on failed
allocations, or subsequent functions (e.g. nf_ct_get_l3proto), passing
them up to userspace seems like a good idea compared to just always
EINVAL.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c |   11 ++++++-----
 net/ipv4/netfilter/ipt_LOG.c       |    2 +-
 net/netfilter/x_tables.c           |   22 ++++++++++++++++++----
 net/netfilter/xt_CONNSECMARK.c     |    8 +++++---
 net/netfilter/xt_CT.c              |   11 +++++++++--
 net/netfilter/xt_DSCP.c            |    2 +-
 net/netfilter/xt_HL.c              |    4 ++--
 net/netfilter/xt_LED.c             |   11 +++--------
 net/netfilter/xt_NFQUEUE.c         |    2 +-
 net/netfilter/xt_RATEEST.c         |    9 ++++++---
 net/netfilter/xt_SECMARK.c         |   16 +++++++++-------
 net/netfilter/xt_cluster.c         |    2 +-
 net/netfilter/xt_connbytes.c       |    6 ++++--
 net/netfilter/xt_connlimit.c       |    8 +++++---
 net/netfilter/xt_connmark.c        |   14 ++++++++++----
 net/netfilter/xt_conntrack.c       |    7 +++++--
 net/netfilter/xt_hashlimit.c       |   33 ++++++++++++++++++++-------------
 net/netfilter/xt_limit.c           |    4 ++--
 net/netfilter/xt_quota.c           |    2 +-
 net/netfilter/xt_rateest.c         |    2 ++
 net/netfilter/xt_recent.c          |    7 +++++--
 net/netfilter/xt_state.c           |    7 +++++--
 net/netfilter/xt_statistic.c       |    2 +-
 net/netfilter/xt_string.c          |    2 +-
 24 files changed, 123 insertions(+), 71 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index b8972ec..e29e8e5 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -352,8 +352,8 @@ static int clusterip_tg_check(const struct xt_tgchk_param *par)
 {
 	struct ipt_clusterip_tgt_info *cipinfo = par->targinfo;
 	const struct ipt_entry *e = par->entryinfo;
-
 	struct clusterip_config *config;
+	int ret;
 
 	if (cipinfo->hash_mode != CLUSTERIP_HASHMODE_SIP &&
 	    cipinfo->hash_mode != CLUSTERIP_HASHMODE_SIP_SPT &&
@@ -388,7 +388,7 @@ static int clusterip_tg_check(const struct xt_tgchk_param *par)
 			if (!dev) {
 				pr_info("no such interface %s\n",
 					e->ip.iniface);
-				return false;
+				return -ENOENT;
 			}
 
 			config = clusterip_config_init(cipinfo,
@@ -396,17 +396,18 @@ static int clusterip_tg_check(const struct xt_tgchk_param *par)
 			if (!config) {
 				pr_info("cannot allocate config\n");
 				dev_put(dev);
-				return false;
+				return -ENOMEM;
 			}
 			dev_mc_add(config->dev,config->clustermac, ETH_ALEN, 0);
 		}
 	}
 	cipinfo->config = config;
 
-	if (nf_ct_l3proto_try_module_get(par->family) < 0) {
+	ret = nf_ct_l3proto_try_module_get(par->family);
+	if (ret < 0) {
 		pr_info("cannot load conntrack support for proto=%u\n",
 			par->family);
-		return false;
+		return ret;
 	}
 
 	return true;
diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
index c9ee5c4..33213d6 100644
--- a/net/ipv4/netfilter/ipt_LOG.c
+++ b/net/ipv4/netfilter/ipt_LOG.c
@@ -445,7 +445,7 @@ static int log_tg_check(const struct xt_tgchk_param *par)
 
 	if (loginfo->level >= 8) {
 		pr_debug("level %u >= 8\n", loginfo->level);
-		return false;
+		return -EDOM;
 	}
 	if (loginfo->prefix[sizeof(loginfo->prefix)-1] != '\0') {
 		pr_debug("prefix is not null-terminated\n");
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 9a248d4..8c8dd20 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -354,6 +354,8 @@ static char *textify_hooks(char *buf, size_t size, unsigned int mask)
 int xt_check_match(struct xt_mtchk_param *par,
 		   unsigned int size, u_int8_t proto, bool inv_proto)
 {
+	int ret;
+
 	if (XT_ALIGN(par->match->matchsize) != size &&
 	    par->match->matchsize != -1) {
 		/*
@@ -390,8 +392,13 @@ int xt_check_match(struct xt_mtchk_param *par,
 		       par->match->proto);
 		return -EINVAL;
 	}
-	if (par->match->checkentry != NULL && !par->match->checkentry(par))
-		return -EINVAL;
+	if (par->match->checkentry != NULL) {
+		ret = par->match->checkentry(par);
+		if (ret < 0)
+			return ret;
+		else if (ret == 0)
+			return -EINVAL;
+	}
 	return 0;
 }
 EXPORT_SYMBOL_GPL(xt_check_match);
@@ -511,6 +518,8 @@ EXPORT_SYMBOL_GPL(xt_compat_match_to_user);
 int xt_check_target(struct xt_tgchk_param *par,
 		    unsigned int size, u_int8_t proto, bool inv_proto)
 {
+	int ret;
+
 	if (XT_ALIGN(par->target->targetsize) != size) {
 		pr_err("%s_tables: %s.%u target: invalid size "
 		       "%u (kernel) != (user) %u\n",
@@ -542,8 +551,13 @@ int xt_check_target(struct xt_tgchk_param *par,
 		       par->target->proto);
 		return -EINVAL;
 	}
-	if (par->target->checkentry != NULL && !par->target->checkentry(par))
-		return -EINVAL;
+	if (par->target->checkentry != NULL) {
+		ret = par->target->checkentry(par);
+		if (ret < 0)
+			return ret;
+		else if (ret == false)
+			return -EINVAL;
+	}
 	return 0;
 }
 EXPORT_SYMBOL_GPL(xt_check_target);
diff --git a/net/netfilter/xt_CONNSECMARK.c b/net/netfilter/xt_CONNSECMARK.c
index 3f9d0f4..d338d18 100644
--- a/net/netfilter/xt_CONNSECMARK.c
+++ b/net/netfilter/xt_CONNSECMARK.c
@@ -87,6 +87,7 @@ connsecmark_tg(struct sk_buff *skb, const struct xt_target_param *par)
 static int connsecmark_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct xt_connsecmark_target_info *info = par->targinfo;
+	int ret;
 
 	if (strcmp(par->table, "mangle") != 0 &&
 	    strcmp(par->table, "security") != 0) {
@@ -102,13 +103,14 @@ static int connsecmark_tg_check(const struct xt_tgchk_param *par)
 
 	default:
 		pr_info("invalid mode: %hu\n", info->mode);
-		return false;
+		return -EDOM;
 	}
 
-	if (nf_ct_l3proto_try_module_get(par->family) < 0) {
+	ret = nf_ct_l3proto_try_module_get(par->family);
+	if (ret < 0) {
 		pr_info("cannot load conntrack support for proto=%u\n",
 			par->family);
-		return false;
+		return ret;
 	}
 	return true;
 }
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index c1553bf..da5b951 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -59,6 +59,7 @@ static int xt_ct_tg_check(const struct xt_tgchk_param *par)
 	struct nf_conntrack_tuple t;
 	struct nf_conn_help *help;
 	struct nf_conn *ct;
+	int ret = 0;
 	u8 proto;
 
 	if (info->flags & ~XT_CT_NOTRACK)
@@ -75,28 +76,34 @@ static int xt_ct_tg_check(const struct xt_tgchk_param *par)
 		goto err1;
 #endif
 
-	if (nf_ct_l3proto_try_module_get(par->family) < 0)
+	ret = nf_ct_l3proto_try_module_get(par->family);
+	if (ret < 0)
 		goto err1;
 
 	memset(&t, 0, sizeof(t));
 	ct = nf_conntrack_alloc(par->net, info->zone, &t, &t, GFP_KERNEL);
+	ret = PTR_ERR(ct);
 	if (IS_ERR(ct))
 		goto err2;
 
+	ret = 0;
 	if ((info->ct_events || info->exp_events) &&
 	    !nf_ct_ecache_ext_add(ct, info->ct_events, info->exp_events,
 				  GFP_KERNEL))
 		goto err3;
 
 	if (info->helper[0]) {
+		ret = -ENOENT;
 		proto = xt_ct_find_proto(par);
 		if (!proto)
 			goto err3;
 
+		ret = -ENOMEM;
 		help = nf_ct_helper_ext_add(ct, GFP_KERNEL);
 		if (help == NULL)
 			goto err3;
 
+		ret = -ENOENT;
 		help->helper = nf_conntrack_helper_try_module_get(info->helper,
 								  par->family,
 								  proto);
@@ -115,7 +122,7 @@ err3:
 err2:
 	nf_ct_l3proto_module_put(par->family);
 err1:
-	return false;
+	return ret;
 }
 
 static void xt_ct_tg_destroy(const struct xt_tgdtor_param *par)
diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_DSCP.c
index 1fa7b67..0c9aae6 100644
--- a/net/netfilter/xt_DSCP.c
+++ b/net/netfilter/xt_DSCP.c
@@ -66,7 +66,7 @@ static int dscp_tg_check(const struct xt_tgchk_param *par)
 
 	if (info->dscp > XT_DSCP_MAX) {
 		pr_info("dscp %x out of range\n", info->dscp);
-		return false;
+		return -EDOM;
 	}
 	return true;
 }
diff --git a/net/netfilter/xt_HL.c b/net/netfilter/xt_HL.c
index 15ba161..22ed2dc 100644
--- a/net/netfilter/xt_HL.c
+++ b/net/netfilter/xt_HL.c
@@ -107,7 +107,7 @@ static int ttl_tg_check(const struct xt_tgchk_param *par)
 
 	if (info->mode > IPT_TTL_MAXMODE) {
 		pr_info("TTL: invalid or unknown mode %u\n", info->mode);
-		return false;
+		return -EDOM;
 	}
 	if (info->mode != IPT_TTL_SET && info->ttl == 0)
 		return false;
@@ -120,7 +120,7 @@ static int hl_tg6_check(const struct xt_tgchk_param *par)
 
 	if (info->mode > IP6T_HL_MAXMODE) {
 		pr_info("invalid or unknown mode %u\n", info->mode);
-		return false;
+		return -EDOM;
 	}
 	if (info->mode != IP6T_HL_SET && info->hop_limit == 0) {
 		pr_info("increment/decrement does not "
diff --git a/net/netfilter/xt_LED.c b/net/netfilter/xt_LED.c
index 1a3e3dd..899da12 100644
--- a/net/netfilter/xt_LED.c
+++ b/net/netfilter/xt_LED.c
@@ -93,7 +93,7 @@ static int led_tg_check(const struct xt_tgchk_param *par)
 
 	ledinternal = kzalloc(sizeof(struct xt_led_info_internal), GFP_KERNEL);
 	if (!ledinternal)
-		return false;
+		return -ENOMEM;
 
 	ledinternal->netfilter_led_trigger.name = ledinfo->id;
 
@@ -102,7 +102,8 @@ static int led_tg_check(const struct xt_tgchk_param *par)
 		pr_warning("led_trigger_register() failed\n");
 		if (err == -EEXIST)
 			pr_warning("Trigger name is already in use.\n");
-		goto exit_alloc;
+		kfree(ledinternal);
+		return err;
 	}
 
 	/* See if we need to set up a timer */
@@ -111,13 +112,7 @@ static int led_tg_check(const struct xt_tgchk_param *par)
 			    (unsigned long)ledinfo);
 
 	ledinfo->internal_data = ledinternal;
-
 	return true;
-
-exit_alloc:
-	kfree(ledinternal);
-
-	return false;
 }
 
 static void led_tg_destroy(const struct xt_tgdtor_param *par)
diff --git a/net/netfilter/xt_NFQUEUE.c b/net/netfilter/xt_NFQUEUE.c
index d435579..143f0e0 100644
--- a/net/netfilter/xt_NFQUEUE.c
+++ b/net/netfilter/xt_NFQUEUE.c
@@ -98,7 +98,7 @@ static int nfqueue_tg_v1_check(const struct xt_tgchk_param *par)
 	if (maxid > 0xffff) {
 		pr_err("NFQUEUE: number of queues (%u) out of range (got %u)\n",
 		       info->queues_total, maxid);
-		return false;
+		return -EDOM;
 	}
 	return true;
 }
diff --git a/net/netfilter/xt_RATEEST.c b/net/netfilter/xt_RATEEST.c
index 9743e50..3c5d1c9 100644
--- a/net/netfilter/xt_RATEEST.c
+++ b/net/netfilter/xt_RATEEST.c
@@ -93,6 +93,7 @@ static int xt_rateest_tg_checkentry(const struct xt_tgchk_param *par)
 		struct nlattr		opt;
 		struct gnet_estimator	est;
 	} cfg;
+	int ret;
 
 	if (unlikely(!rnd_inited)) {
 		get_random_bytes(&jhash_rnd, sizeof(jhash_rnd));
@@ -115,6 +116,7 @@ static int xt_rateest_tg_checkentry(const struct xt_tgchk_param *par)
 		return true;
 	}
 
+	ret = -ENOMEM;
 	est = kzalloc(sizeof(*est), GFP_KERNEL);
 	if (!est)
 		goto err1;
@@ -130,8 +132,9 @@ static int xt_rateest_tg_checkentry(const struct xt_tgchk_param *par)
 	cfg.est.interval	= info->interval;
 	cfg.est.ewma_log	= info->ewma_log;
 
-	if (gen_new_estimator(&est->bstats, &est->rstats, &est->lock,
-			      &cfg.opt) < 0)
+	ret = gen_new_estimator(&est->bstats, &est->rstats,
+				&est->lock, &cfg.opt);
+	if (ret < 0)
 		goto err2;
 
 	info->est = est;
@@ -142,7 +145,7 @@ static int xt_rateest_tg_checkentry(const struct xt_tgchk_param *par)
 err2:
 	kfree(est);
 err1:
-	return false;
+	return ret;
 }
 
 static void xt_rateest_tg_destroy(const struct xt_tgdtor_param *par)
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index 48f8e4f..6525eee 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -50,7 +50,7 @@ secmark_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool checkentry_selinux(struct xt_secmark_target_info *info)
+static int checkentry_selinux(struct xt_secmark_target_info *info)
 {
 	int err;
 	struct xt_secmark_target_selinux_info *sel = &info->u.sel;
@@ -62,18 +62,18 @@ static bool checkentry_selinux(struct xt_secmark_target_info *info)
 		if (err == -EINVAL)
 			pr_info("invalid SELinux context \'%s\'\n",
 				sel->selctx);
-		return false;
+		return err;
 	}
 
 	if (!sel->selsid) {
 		pr_info("unable to map SELinux context \'%s\'\n", sel->selctx);
-		return false;
+		return -ENOENT;
 	}
 
 	err = selinux_secmark_relabel_packet_permission(sel->selsid);
 	if (err) {
 		pr_info("unable to obtain relabeling permission\n");
-		return false;
+		return err;
 	}
 
 	selinux_secmark_refcount_inc();
@@ -83,6 +83,7 @@ static bool checkentry_selinux(struct xt_secmark_target_info *info)
 static int secmark_tg_check(const struct xt_tgchk_param *par)
 {
 	struct xt_secmark_target_info *info = par->targinfo;
+	int err;
 
 	if (strcmp(par->table, "mangle") != 0 &&
 	    strcmp(par->table, "security") != 0) {
@@ -99,13 +100,14 @@ static int secmark_tg_check(const struct xt_tgchk_param *par)
 
 	switch (info->mode) {
 	case SECMARK_MODE_SEL:
-		if (!checkentry_selinux(info))
-			return false;
+		err = checkentry_selinux(info);
+		if (err <= 0)
+			return err;
 		break;
 
 	default:
 		pr_info("invalid mode: %hu\n", info->mode);
-		return false;
+		return -EDOM;
 	}
 
 	if (!mode)
diff --git a/net/netfilter/xt_cluster.c b/net/netfilter/xt_cluster.c
index 1f2c35e..0c8a653 100644
--- a/net/netfilter/xt_cluster.c
+++ b/net/netfilter/xt_cluster.c
@@ -145,7 +145,7 @@ static int xt_cluster_mt_checkentry(const struct xt_mtchk_param *par)
 	if (info->node_mask >= (1ULL << info->total_nodes)) {
 		pr_info("this node mask cannot be "
 			"higher than the total number of nodes\n");
-		return false;
+		return -EDOM;
 	}
 	return true;
 }
diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
index 136ef4c..d50a53e 100644
--- a/net/netfilter/xt_connbytes.c
+++ b/net/netfilter/xt_connbytes.c
@@ -96,6 +96,7 @@ connbytes_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 static int connbytes_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct xt_connbytes_info *sinfo = par->matchinfo;
+	int ret;
 
 	if (sinfo->what != XT_CONNBYTES_PKTS &&
 	    sinfo->what != XT_CONNBYTES_BYTES &&
@@ -107,10 +108,11 @@ static int connbytes_mt_check(const struct xt_mtchk_param *par)
 	    sinfo->direction != XT_CONNBYTES_DIR_BOTH)
 		return false;
 
-	if (nf_ct_l3proto_try_module_get(par->family) < 0) {
+	ret = nf_ct_l3proto_try_module_get(par->family);
+	if (ret < 0) {
 		pr_info("cannot load conntrack support for proto=%u\n",
 			par->family);
-		return false;
+		return ret;
 	}
 
 	return true;
diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index a9fec38..f8d92aa 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -220,22 +220,24 @@ static int connlimit_mt_check(const struct xt_mtchk_param *par)
 {
 	struct xt_connlimit_info *info = par->matchinfo;
 	unsigned int i;
+	int ret;
 
 	if (unlikely(!connlimit_rnd_inited)) {
 		get_random_bytes(&connlimit_rnd, sizeof(connlimit_rnd));
 		connlimit_rnd_inited = true;
 	}
-	if (nf_ct_l3proto_try_module_get(par->family) < 0) {
+	ret = nf_ct_l3proto_try_module_get(par->family);
+	if (ret < 0) {
 		pr_info("cannot load conntrack support for "
 			"address family %u\n", par->family);
-		return false;
+		return ret;
 	}
 
 	/* init private data */
 	info->data = kmalloc(sizeof(struct xt_connlimit_data), GFP_KERNEL);
 	if (info->data == NULL) {
 		nf_ct_l3proto_module_put(par->family);
-		return false;
+		return -ENOMEM;
 	}
 
 	spin_lock_init(&info->data->lock);
diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index 0e69427..1ffbafb 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -76,10 +76,13 @@ connmark_tg(struct sk_buff *skb, const struct xt_target_param *par)
 
 static int connmark_tg_check(const struct xt_tgchk_param *par)
 {
-	if (nf_ct_l3proto_try_module_get(par->family) < 0) {
+	int ret;
+
+	ret = nf_ct_l3proto_try_module_get(par->family);
+	if (ret < 0) {
 		pr_info("cannot load conntrack support for proto=%u\n",
 			par->family);
-		return false;
+		return ret;
 	}
 	return true;
 }
@@ -105,10 +108,13 @@ connmark_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 
 static int connmark_mt_check(const struct xt_mtchk_param *par)
 {
-	if (nf_ct_l3proto_try_module_get(par->family) < 0) {
+	int ret;
+
+	ret = nf_ct_l3proto_try_module_get(par->family);
+	if (ret < 0) {
 		pr_info("cannot load conntrack support for proto=%u\n",
 			par->family);
-		return false;
+		return ret;
 	}
 	return true;
 }
diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index 500e033..59d2589 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -208,10 +208,13 @@ conntrack_mt_v2(const struct sk_buff *skb, const struct xt_match_param *par)
 
 static int conntrack_mt_check(const struct xt_mtchk_param *par)
 {
-	if (nf_ct_l3proto_try_module_get(par->family) < 0) {
+	int ret;
+
+	ret = nf_ct_l3proto_try_module_get(par->family);
+	if (ret < 0) {
 		pr_info("cannot load conntrack support for proto=%u\n",
 			par->family);
-		return false;
+		return ret;
 	}
 	return true;
 }
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index d13800c..e769fc6 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -214,7 +214,7 @@ static int htable_create_v0(struct net *net, struct xt_hashlimit_info *minfo, u_
 	hinfo = vmalloc(sizeof(struct xt_hashlimit_htable) +
 			sizeof(struct list_head) * size);
 	if (!hinfo)
-		return -1;
+		return -ENOMEM;
 	minfo->hinfo = hinfo;
 
 	/* copy match config into hashtable config */
@@ -250,7 +250,7 @@ static int htable_create_v0(struct net *net, struct xt_hashlimit_info *minfo, u_
 		&dl_file_ops, hinfo);
 	if (!hinfo->pde) {
 		vfree(hinfo);
-		return -1;
+		return -ENOMEM;
 	}
 	hinfo->net = net;
 
@@ -285,7 +285,7 @@ static int htable_create(struct net *net, struct xt_hashlimit_mtinfo1 *minfo,
 	hinfo = vmalloc(sizeof(struct xt_hashlimit_htable) +
 	                sizeof(struct list_head) * size);
 	if (hinfo == NULL)
-		return -1;
+		return -ENOMEM;
 	minfo->hinfo = hinfo;
 
 	/* copy match config into hashtable config */
@@ -311,7 +311,7 @@ static int htable_create(struct net *net, struct xt_hashlimit_mtinfo1 *minfo,
 		&dl_file_ops, hinfo);
 	if (hinfo->pde == NULL) {
 		vfree(hinfo);
-		return -1;
+		return -ENOMEM;
 	}
 	hinfo->net = net;
 
@@ -675,13 +675,14 @@ static int hashlimit_mt_check_v0(const struct xt_mtchk_param *par)
 {
 	struct net *net = par->net;
 	struct xt_hashlimit_info *r = par->matchinfo;
+	int ret;
 
 	/* Check for overflow. */
 	if (r->cfg.burst == 0 ||
 	    user2credits(r->cfg.avg * r->cfg.burst) < user2credits(r->cfg.avg)) {
 		pr_info("overflow, try lower: %u/%u\n",
 			r->cfg.avg, r->cfg.burst);
-		return false;
+		return -ERANGE;
 	}
 	if (r->cfg.mode == 0 ||
 	    r->cfg.mode > (XT_HASHLIMIT_HASH_DPT |
@@ -698,12 +699,14 @@ static int hashlimit_mt_check_v0(const struct xt_mtchk_param *par)
 
 	mutex_lock(&hashlimit_mutex);
 	r->hinfo = htable_find_get(net, r->name, par->family);
-	if (!r->hinfo && htable_create_v0(net, r, par->family) != 0) {
-		mutex_unlock(&hashlimit_mutex);
-		return false;
+	if (r->hinfo == NULL) {
+		ret = htable_create_v0(net, r, par->family);
+		if (ret < 0) {
+			mutex_unlock(&hashlimit_mutex);
+			return ret;
+		}
 	}
 	mutex_unlock(&hashlimit_mutex);
-
 	return true;
 }
 
@@ -711,6 +714,7 @@ static int hashlimit_mt_check(const struct xt_mtchk_param *par)
 {
 	struct net *net = par->net;
 	struct xt_hashlimit_mtinfo1 *info = par->matchinfo;
+	int ret;
 
 	/* Check for overflow. */
 	if (info->cfg.burst == 0 ||
@@ -718,7 +722,7 @@ static int hashlimit_mt_check(const struct xt_mtchk_param *par)
 	    user2credits(info->cfg.avg)) {
 		pr_info("overflow, try lower: %u/%u\n",
 			info->cfg.avg, info->cfg.burst);
-		return false;
+		return -ERANGE;
 	}
 	if (info->cfg.gc_interval == 0 || info->cfg.expire == 0)
 		return false;
@@ -734,9 +738,12 @@ static int hashlimit_mt_check(const struct xt_mtchk_param *par)
 
 	mutex_lock(&hashlimit_mutex);
 	info->hinfo = htable_find_get(net, info->name, par->family);
-	if (!info->hinfo && htable_create(net, info, par->family) != 0) {
-		mutex_unlock(&hashlimit_mutex);
-		return false;
+	if (info->hinfo == NULL) {
+		ret = htable_create(net, info, par->family);
+		if (ret < 0) {
+			mutex_unlock(&hashlimit_mutex);
+			return ret;
+		}
 	}
 	mutex_unlock(&hashlimit_mutex);
 	return true;
diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
index 138a324..de99e08 100644
--- a/net/netfilter/xt_limit.c
+++ b/net/netfilter/xt_limit.c
@@ -107,12 +107,12 @@ static int limit_mt_check(const struct xt_mtchk_param *par)
 	    || user2credits(r->avg * r->burst) < user2credits(r->avg)) {
 		pr_info("Overflow, try lower: %u/%u\n",
 			r->avg, r->burst);
-		return false;
+		return -ERANGE;
 	}
 
 	priv = kmalloc(sizeof(*priv), GFP_KERNEL);
 	if (priv == NULL)
-		return false;
+		return -ENOMEM;
 
 	/* For SMP, we only want to use one set of state. */
 	r->master = priv;
diff --git a/net/netfilter/xt_quota.c b/net/netfilter/xt_quota.c
index 2861fac..d61f05d 100644
--- a/net/netfilter/xt_quota.c
+++ b/net/netfilter/xt_quota.c
@@ -52,7 +52,7 @@ static int quota_mt_check(const struct xt_mtchk_param *par)
 
 	q->master = kmalloc(sizeof(*q->master), GFP_KERNEL);
 	if (q->master == NULL)
-		return false;
+		return -ENOMEM;
 
 	q->master->quota = q->quota;
 	return true;
diff --git a/net/netfilter/xt_rateest.c b/net/netfilter/xt_rateest.c
index 3b5e3d6..9badfa6 100644
--- a/net/netfilter/xt_rateest.c
+++ b/net/netfilter/xt_rateest.c
@@ -78,6 +78,7 @@ static int xt_rateest_mt_checkentry(const struct xt_mtchk_param *par)
 {
 	struct xt_rateest_match_info *info = par->matchinfo;
 	struct xt_rateest *est1, *est2;
+	int ret = false;
 
 	if (hweight32(info->flags & (XT_RATEEST_MATCH_ABS |
 				     XT_RATEEST_MATCH_REL)) != 1)
@@ -95,6 +96,7 @@ static int xt_rateest_mt_checkentry(const struct xt_mtchk_param *par)
 		goto err1;
 	}
 
+	ret  = -ENOENT;
 	est1 = xt_rateest_lookup(info->name1);
 	if (!est1)
 		goto err1;
diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 52042c8..99eb6b2 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -314,7 +314,7 @@ static int recent_mt_check(const struct xt_mtchk_param *par)
 	struct proc_dir_entry *pde;
 #endif
 	unsigned i;
-	bool ret = false;
+	int ret = false;
 
 	if (unlikely(!hash_rnd_inited)) {
 		get_random_bytes(&hash_rnd, sizeof(hash_rnd));
@@ -355,8 +355,10 @@ static int recent_mt_check(const struct xt_mtchk_param *par)
 
 	t = kzalloc(sizeof(*t) + sizeof(t->iphash[0]) * ip_list_hash_size,
 		    GFP_KERNEL);
-	if (t == NULL)
+	if (t == NULL) {
+		ret = -ENOMEM;
 		goto out;
+	}
 	t->refcnt = 1;
 	strcpy(t->name, info->name);
 	INIT_LIST_HEAD(&t->lru_list);
@@ -367,6 +369,7 @@ static int recent_mt_check(const struct xt_mtchk_param *par)
 		  &recent_mt_fops, t);
 	if (pde == NULL) {
 		kfree(t);
+		ret = -ENOMEM;
 		goto out;
 	}
 	pde->uid = ip_list_uid;
diff --git a/net/netfilter/xt_state.c b/net/netfilter/xt_state.c
index 8b15b13..e69375e 100644
--- a/net/netfilter/xt_state.c
+++ b/net/netfilter/xt_state.c
@@ -39,10 +39,13 @@ state_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 
 static int state_mt_check(const struct xt_mtchk_param *par)
 {
-	if (nf_ct_l3proto_try_module_get(par->family) < 0) {
+	int ret;
+
+	ret = nf_ct_l3proto_try_module_get(par->family);
+	if (ret < 0) {
 		pr_info("cannot load conntrack support for proto=%u\n",
 			par->family);
-		return false;
+		return ret;
 	}
 	return true;
 }
diff --git a/net/netfilter/xt_statistic.c b/net/netfilter/xt_statistic.c
index a577ab0..c07e450 100644
--- a/net/netfilter/xt_statistic.c
+++ b/net/netfilter/xt_statistic.c
@@ -62,7 +62,7 @@ static int statistic_mt_check(const struct xt_mtchk_param *par)
 
 	info->master = kzalloc(sizeof(*info->master), GFP_KERNEL);
 	if (info->master == NULL)
-		return false;
+		return -ENOMEM;
 	info->master->count = info->u.nth.count;
 
 	return true;
diff --git a/net/netfilter/xt_string.c b/net/netfilter/xt_string.c
index 7d14121..fa7d066 100644
--- a/net/netfilter/xt_string.c
+++ b/net/netfilter/xt_string.c
@@ -63,7 +63,7 @@ static int string_mt_check(const struct xt_mtchk_param *par)
 	ts_conf = textsearch_prepare(conf->algo, conf->pattern, conf->patlen,
 				     GFP_KERNEL, flags);
 	if (IS_ERR(ts_conf))
-		return false;
+		return PTR_ERR(ts_conf);
 
 	conf->config = ts_conf;
 
-- 
1.7.0.2

