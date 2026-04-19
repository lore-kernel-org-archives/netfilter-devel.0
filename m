Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98BDA19D092
	for <netfilter-devel@vger.kernel.org>; Sun, 19 Apr 2026 10:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776595521; cv=none; b=s2Y/VO2FEijEa6MxyePfpeK0fl+ZX3CA1CmjjJ7Ecl2EmqgJwTNw+JCzQqJjz+WugGtp5rhOY4r//HaSdI4pBFsx7iZmRl4JQaP2oZwLJiBkVnaDKyHudPIabB29DdUPiBIwsnFhp9J+/UtQ7XRARUAHpKfGLovDT9cSrwIHqjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776595521; c=relaxed/simple;
	bh=8Yav3RGYSVs/mUmrmMQX4wgtTX1tVzGIvih/7MzIb3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KqsfQmYsOQSz5X1wszn7wJjgrCnP65NLBxTFGkVXl8VLc56MJbLa7d71FgSRk/q2QMtuD646YSO29GgkdF0txfCyGCxO3Yfh41UJZzldt4zXR/O5MzSy68RsvTGxeT1DehoODLCMXbtGVKoJS5KV53Zqz4zYdfVl9B5FG9a4oOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 122A160640; Sun, 19 Apr 2026 12:45:16 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>
Subject: [PATCH nf] netfilter: x_tables: add late validate callback for nft_compat sake
Date: Sun, 19 Apr 2026 12:45:05 +0200
Message-ID: <20260419104509.42196-1-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

x_tables and nftables are fundamentally different.
In x_tables, one gets the full ruleset graph via setsockopt().
->checkentry() gets called at ruleset validation time.

In nf_tables, you get a transactional request (rule add in this case)
in netlink format.  At this time, it is not yet knowm from which
basechain(s) the new expression is reachable.

In nf_tables, there is one final hook validation pass right before the
point-of-no-return when the new state is fully known.

However, nft_compat calls the x_tables checkentry functions way too
early, at expression instantiation time, when we have the netlink
info available but not the base chain info (not yet known).

At final validation time we lack the additional compat information
userspace provided to us.  So we need compat_info + base chain info,
but we never have both.

Add a new .nft_validate_chain callback to x_tables.
It is not allowed to have side effects and only performs addititonal
hook_mask validiation at last possible moment.
It is called from nft_compat .validate callbacks.

Fixes: 0ca743a55991 ("netfilter: nf_tables: add compatibility layer for x_tables")
Reported-by: Xiang Mei <xmei5@asu.edu>
Cc: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Tentative hack to resolve this bug where it originates.

 include/linux/netfilter/x_tables.h | 15 ++++++++++++++
 net/netfilter/nft_compat.c         | 32 +++++++++++++++++++++++++++---
 net/netfilter/xt_TCPMSS.c          | 25 ++++++++++++++++-------
 net/netfilter/xt_addrtype.c        | 27 +++++++++++++++++++------
 net/netfilter/xt_devgroup.c        | 31 +++++++++++++++++++----------
 net/netfilter/xt_physdev.c         | 21 ++++++++++++++++----
 net/netfilter/xt_policy.c          | 24 ++++++++++++++++++----
 net/netfilter/xt_set.c             | 22 +++++++++++++++-----
 8 files changed, 158 insertions(+), 39 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 77c778d84d4c..d1dcef359e61 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -146,6 +146,10 @@ struct xt_match {
 	/* Called when user tries to insert an entry of this type. */
 	int (*checkentry)(const struct xt_mtchk_param *);
 
+#if IS_ENABLED(CONFIG_NFT_COMPAT)
+	/* only used by nft_compat, must be pure: no side effects allowed */
+	bool (*nft_validate_chain)(const void *matchinfo, unsigned int hook_mask);
+#endif
 	/* Called when entry of this type deleted. */
 	void (*destroy)(const struct xt_mtdtor_param *);
 #ifdef CONFIG_NETFILTER_XTABLES_COMPAT
@@ -187,6 +191,10 @@ struct xt_target {
 	/* Should return 0 on success or an error code otherwise (-Exxxx). */
 	int (*checkentry)(const struct xt_tgchk_param *);
 
+#if IS_ENABLED(CONFIG_NFT_COMPAT)
+	/* only used by nft_compat, must be pure: no side effects allowed */
+	bool (*nft_validate_chain)(const void *targinfo, unsigned int hook_mask);
+#endif
 	/* Called when entry of this type deleted. */
 	void (*destroy)(const struct xt_tgdtor_param *);
 #ifdef CONFIG_NETFILTER_XTABLES_COMPAT
@@ -524,4 +532,11 @@ int xt_compat_check_entry_offsets(const void *base, const char *elems,
 				  unsigned int next_offset);
 
 #endif /* CONFIG_NETFILTER_XTABLES_COMPAT */
+
+#if IS_ENABLED(CONFIG_NFT_COMPAT)
+#define NFT_COMPAT_VALIDATE(fname) .nft_validate_chain = fname,
+#else
+#define NFT_COMPAT_VALIDATE(fname)
+#endif
+
 #endif /* _X_TABLES_H */
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 27cc983a7cdf..cc4041b1f1d0 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -382,6 +382,10 @@ static int nft_target_validate(const struct nft_ctx *ctx,
 		if (target->hooks && !(hook_mask & target->hooks))
 			return -EINVAL;
 
+		if (target->nft_validate_chain &&
+		    !target->nft_validate_chain(nft_expr_priv(expr), hook_mask))
+			return -EINVAL;
+
 		ret = nft_compat_chain_validate_dependency(ctx, target->table);
 		if (ret < 0)
 			return ret;
@@ -611,10 +615,11 @@ static int nft_match_large_dump(struct sk_buff *skb,
 	return __nft_match_dump(skb, e, priv->info);
 }
 
-static int nft_match_validate(const struct nft_ctx *ctx,
-			      const struct nft_expr *expr)
+static int __nft_match_validate(const struct nft_ctx *ctx,
+				const struct nft_expr *expr,
+				const void *info)
 {
-	struct xt_match *match = expr->ops->data;
+	const struct xt_match *match = expr->ops->data;
 	unsigned int hook_mask = 0;
 	int ret;
 
@@ -643,6 +648,10 @@ static int nft_match_validate(const struct nft_ctx *ctx,
 		if (match->hooks && !(hook_mask & match->hooks))
 			return -EINVAL;
 
+		if (match->nft_validate_chain &&
+		    !match->nft_validate_chain(info, hook_mask))
+			return -EINVAL;
+
 		ret = nft_compat_chain_validate_dependency(ctx, match->table);
 		if (ret < 0)
 			return ret;
@@ -650,6 +659,22 @@ static int nft_match_validate(const struct nft_ctx *ctx,
 	return 0;
 }
 
+static int nft_match_validate(const struct nft_ctx *ctx,
+			      const struct nft_expr *expr)
+{
+	const void *info = nft_expr_priv(expr);
+
+	return __nft_match_validate(ctx, expr, info);
+}
+
+static int nft_match_large_validate(const struct nft_ctx *ctx,
+			            const struct nft_expr *expr)
+{
+	struct nft_xt_match_priv *priv = nft_expr_priv(expr);
+
+	return __nft_match_validate(ctx, expr, priv->info);
+}
+
 static int
 nfnl_compat_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 		      int event, u16 family, const char *name,
@@ -838,6 +863,7 @@ nft_match_select_ops(const struct nft_ctx *ctx,
 		ops->init = nft_match_large_init;
 		ops->destroy = nft_match_large_destroy;
 		ops->dump = nft_match_large_dump;
+		ops->validate = nft_match_large_validate;
 	}
 
 	ops->size = matchsize;
diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index 116a885adb3c..261115ad4242 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -260,16 +260,26 @@ static inline bool find_syn_match(const struct xt_entry_match *m)
 	return false;
 }
 
+static bool tcpmss_validate_chain(const void *tginfo, unsigned int hook_mask)
+{
+	const struct xt_tcpmss_info *info = tginfo;
+
+	if ((info->mss == XT_TCPMSS_CLAMP_PMTU) &&
+	   (hook_mask & ~((1 << NF_INET_FORWARD) |
+			  (1 << NF_INET_LOCAL_OUT) |
+			  (1 << NF_INET_POST_ROUTING))) != 0)
+		return false;
+
+	return true;
+}
+
 static int tcpmss_tg4_check(const struct xt_tgchk_param *par)
 {
 	const struct xt_tcpmss_info *info = par->targinfo;
 	const struct ipt_entry *e = par->entryinfo;
 	const struct xt_entry_match *ematch;
 
-	if (info->mss == XT_TCPMSS_CLAMP_PMTU &&
-	    (par->hook_mask & ~((1 << NF_INET_FORWARD) |
-			   (1 << NF_INET_LOCAL_OUT) |
-			   (1 << NF_INET_POST_ROUTING))) != 0) {
+	if (!tcpmss_validate_chain(info, par->hook_mask)) {
 		pr_info_ratelimited("path-MTU clamping only supported in FORWARD, OUTPUT and POSTROUTING hooks\n");
 		return -EINVAL;
 	}
@@ -291,12 +301,11 @@ static int tcpmss_tg6_check(const struct xt_tgchk_param *par)
 	const struct xt_entry_match *ematch;
 
 	if (info->mss == XT_TCPMSS_CLAMP_PMTU &&
-	    (par->hook_mask & ~((1 << NF_INET_FORWARD) |
-			   (1 << NF_INET_LOCAL_OUT) |
-			   (1 << NF_INET_POST_ROUTING))) != 0) {
+	    !tcpmss_validate_chain(info, par->hook_mask)) {
 		pr_info_ratelimited("path-MTU clamping only supported in FORWARD, OUTPUT and POSTROUTING hooks\n");
 		return -EINVAL;
 	}
+
 	if (par->nft_compat)
 		return 0;
 
@@ -313,6 +322,7 @@ static struct xt_target tcpmss_tg_reg[] __read_mostly = {
 		.family		= NFPROTO_IPV4,
 		.name		= "TCPMSS",
 		.checkentry	= tcpmss_tg4_check,
+		NFT_COMPAT_VALIDATE(tcpmss_validate_chain)
 		.target		= tcpmss_tg4,
 		.targetsize	= sizeof(struct xt_tcpmss_info),
 		.proto		= IPPROTO_TCP,
@@ -323,6 +333,7 @@ static struct xt_target tcpmss_tg_reg[] __read_mostly = {
 		.family		= NFPROTO_IPV6,
 		.name		= "TCPMSS",
 		.checkentry	= tcpmss_tg6_check,
+		NFT_COMPAT_VALIDATE(tcpmss_validate_chain)
 		.target		= tcpmss_tg6,
 		.targetsize	= sizeof(struct xt_tcpmss_info),
 		.proto		= IPPROTO_TCP,
diff --git a/net/netfilter/xt_addrtype.c b/net/netfilter/xt_addrtype.c
index a77088943107..bd1391bb0853 100644
--- a/net/netfilter/xt_addrtype.c
+++ b/net/netfilter/xt_addrtype.c
@@ -153,6 +153,21 @@ addrtype_mt_v1(const struct sk_buff *skb, struct xt_action_param *par)
 	return ret;
 }
 
+static bool addrtype_mt_validate(const void *matchinfo, unsigned int hook_mask)
+{
+	const struct xt_addrtype_info_v1 *info = matchinfo;
+
+	if (hook_mask & ((1 << NF_INET_PRE_ROUTING) | (1 << NF_INET_LOCAL_IN)) &&
+	    info->flags & XT_ADDRTYPE_LIMIT_IFACE_OUT)
+		return false;
+
+	if (hook_mask & ((1 << NF_INET_POST_ROUTING) | (1 << NF_INET_LOCAL_OUT)) &&
+	    info->flags & XT_ADDRTYPE_LIMIT_IFACE_IN)
+		return false;
+
+	return true;
+}
+
 static int addrtype_mt_checkentry_v1(const struct xt_mtchk_param *par)
 {
 	const char *errmsg = "both incoming and outgoing interface limitation cannot be selected";
@@ -162,16 +177,14 @@ static int addrtype_mt_checkentry_v1(const struct xt_mtchk_param *par)
 	    info->flags & XT_ADDRTYPE_LIMIT_IFACE_OUT)
 		goto err;
 
-	if (par->hook_mask & ((1 << NF_INET_PRE_ROUTING) |
-	    (1 << NF_INET_LOCAL_IN)) &&
-	    info->flags & XT_ADDRTYPE_LIMIT_IFACE_OUT) {
+	if ((info->flags & XT_ADDRTYPE_LIMIT_IFACE_OUT) &&
+	    !addrtype_mt_validate(info, par->hook_mask)) {
 		errmsg = "output interface limitation not valid in PREROUTING and INPUT";
 		goto err;
 	}
 
-	if (par->hook_mask & ((1 << NF_INET_POST_ROUTING) |
-	    (1 << NF_INET_LOCAL_OUT)) &&
-	    info->flags & XT_ADDRTYPE_LIMIT_IFACE_IN) {
+	if ((info->flags & XT_ADDRTYPE_LIMIT_IFACE_IN) &&
+	    !addrtype_mt_validate(info, par->hook_mask)) {
 		errmsg = "input interface limitation not valid in POSTROUTING and OUTPUT";
 		goto err;
 	}
@@ -212,6 +225,7 @@ static struct xt_match addrtype_mt_reg[] __read_mostly = {
 		.revision	= 1,
 		.match		= addrtype_mt_v1,
 		.checkentry	= addrtype_mt_checkentry_v1,
+		NFT_COMPAT_VALIDATE(addrtype_mt_validate)
 		.matchsize	= sizeof(struct xt_addrtype_info_v1),
 		.me		= THIS_MODULE
 	},
@@ -222,6 +236,7 @@ static struct xt_match addrtype_mt_reg[] __read_mostly = {
 		.revision	= 1,
 		.match		= addrtype_mt_v1,
 		.checkentry	= addrtype_mt_checkentry_v1,
+		NFT_COMPAT_VALIDATE(addrtype_mt_validate)
 		.matchsize	= sizeof(struct xt_addrtype_info_v1),
 		.me		= THIS_MODULE
 	},
diff --git a/net/netfilter/xt_devgroup.c b/net/netfilter/xt_devgroup.c
index 9520dd00070b..d6ee83554845 100644
--- a/net/netfilter/xt_devgroup.c
+++ b/net/netfilter/xt_devgroup.c
@@ -33,6 +33,25 @@ static bool devgroup_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	return true;
 }
 
+static bool devgroup_mt_validate(const void *matchinfo, unsigned int hook_mask)
+{
+	const struct xt_devgroup_info *info = matchinfo;
+
+	if (info->flags & XT_DEVGROUP_MATCH_SRC &&
+	    hook_mask & ~((1 << NF_INET_PRE_ROUTING) |
+			  (1 << NF_INET_LOCAL_IN) |
+			  (1 << NF_INET_FORWARD)))
+		return false;
+
+	if (info->flags & XT_DEVGROUP_MATCH_DST &&
+	    hook_mask & ~((1 << NF_INET_FORWARD) |
+			  (1 << NF_INET_LOCAL_OUT) |
+			  (1 << NF_INET_POST_ROUTING)))
+		return false;
+
+	return true;
+}
+
 static int devgroup_mt_checkentry(const struct xt_mtchk_param *par)
 {
 	const struct xt_devgroup_info *info = par->matchinfo;
@@ -41,16 +60,7 @@ static int devgroup_mt_checkentry(const struct xt_mtchk_param *par)
 			    XT_DEVGROUP_MATCH_DST | XT_DEVGROUP_INVERT_DST))
 		return -EINVAL;
 
-	if (info->flags & XT_DEVGROUP_MATCH_SRC &&
-	    par->hook_mask & ~((1 << NF_INET_PRE_ROUTING) |
-			       (1 << NF_INET_LOCAL_IN) |
-			       (1 << NF_INET_FORWARD)))
-		return -EINVAL;
-
-	if (info->flags & XT_DEVGROUP_MATCH_DST &&
-	    par->hook_mask & ~((1 << NF_INET_FORWARD) |
-			       (1 << NF_INET_LOCAL_OUT) |
-			       (1 << NF_INET_POST_ROUTING)))
+	if (!devgroup_mt_validate(info, par->hook_mask))
 		return -EINVAL;
 
 	return 0;
@@ -60,6 +70,7 @@ static struct xt_match devgroup_mt_reg __read_mostly = {
 	.name		= "devgroup",
 	.match		= devgroup_mt,
 	.checkentry	= devgroup_mt_checkentry,
+	NFT_COMPAT_VALIDATE(devgroup_mt_validate)
 	.matchsize	= sizeof(struct xt_devgroup_info),
 	.family		= NFPROTO_UNSPEC,
 	.me		= THIS_MODULE
diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index 343e65f377d4..27dcd7fc7427 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -91,6 +91,20 @@ physdev_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	return (!!ret ^ !(info->invert & XT_PHYSDEV_OP_OUT));
 }
 
+static bool physdev_mt_validate(const void *matchinfo, unsigned int hook_mask)
+{
+	const struct xt_physdev_info *info = matchinfo;
+
+	if (info->bitmask & (XT_PHYSDEV_OP_OUT | XT_PHYSDEV_OP_ISOUT) &&
+	    (!(info->bitmask & XT_PHYSDEV_OP_BRIDGED) ||
+	     info->invert & XT_PHYSDEV_OP_BRIDGED) &&
+	     hook_mask & (1 << NF_INET_LOCAL_OUT)) {
+		return false;
+	}
+
+	return true;
+}
+
 static int physdev_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct xt_physdev_info *info = par->matchinfo;
@@ -99,10 +113,8 @@ static int physdev_mt_check(const struct xt_mtchk_param *par)
 	if (!(info->bitmask & XT_PHYSDEV_OP_MASK) ||
 	    info->bitmask & ~XT_PHYSDEV_OP_MASK)
 		return -EINVAL;
-	if (info->bitmask & (XT_PHYSDEV_OP_OUT | XT_PHYSDEV_OP_ISOUT) &&
-	    (!(info->bitmask & XT_PHYSDEV_OP_BRIDGED) ||
-	     info->invert & XT_PHYSDEV_OP_BRIDGED) &&
-	    par->hook_mask & (1 << NF_INET_LOCAL_OUT)) {
+
+	if (!physdev_mt_validate(info, par->hook_mask)) {
 		pr_info_ratelimited("--physdev-out and --physdev-is-out only supported in the FORWARD and POSTROUTING chains with bridged traffic\n");
 		return -EINVAL;
 	}
@@ -120,6 +132,7 @@ static struct xt_match physdev_mt_reg __read_mostly = {
 	.revision   = 0,
 	.family     = NFPROTO_UNSPEC,
 	.checkentry = physdev_mt_check,
+	NFT_COMPAT_VALIDATE(physdev_mt_validate)
 	.match      = physdev_mt,
 	.matchsize  = sizeof(struct xt_physdev_info),
 	.me         = THIS_MODULE,
diff --git a/net/netfilter/xt_policy.c b/net/netfilter/xt_policy.c
index cb6e8279010a..826727ca843c 100644
--- a/net/netfilter/xt_policy.c
+++ b/net/netfilter/xt_policy.c
@@ -126,6 +126,20 @@ policy_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	return ret;
 }
 
+static bool policy_mt_validate(const void *matchinfo, unsigned int hook_mask)
+{
+	const struct xt_policy_info *info = matchinfo;
+
+	if (hook_mask & ((1 << NF_INET_PRE_ROUTING) |
+	    (1 << NF_INET_LOCAL_IN)) && info->flags & XT_POLICY_MATCH_OUT)
+		return false;
+	if (hook_mask & ((1 << NF_INET_POST_ROUTING) |
+	    (1 << NF_INET_LOCAL_OUT)) && info->flags & XT_POLICY_MATCH_IN)
+		return false;
+
+	return true;
+}
+
 static int policy_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct xt_policy_info *info = par->matchinfo;
@@ -134,13 +148,13 @@ static int policy_mt_check(const struct xt_mtchk_param *par)
 	if (!(info->flags & (XT_POLICY_MATCH_IN|XT_POLICY_MATCH_OUT)))
 		goto err;
 
-	if (par->hook_mask & ((1 << NF_INET_PRE_ROUTING) |
-	    (1 << NF_INET_LOCAL_IN)) && info->flags & XT_POLICY_MATCH_OUT) {
+	if ((info->flags & XT_POLICY_MATCH_OUT) &&
+	    !policy_mt_validate(info, par->hook_mask)) {
 		errmsg = "output policy not valid in PREROUTING and INPUT";
 		goto err;
 	}
-	if (par->hook_mask & ((1 << NF_INET_POST_ROUTING) |
-	    (1 << NF_INET_LOCAL_OUT)) && info->flags & XT_POLICY_MATCH_IN) {
+	if ((info->flags & XT_POLICY_MATCH_IN) &&
+	    !policy_mt_validate(info, par->hook_mask)) {
 		errmsg = "input policy not valid in POSTROUTING and OUTPUT";
 		goto err;
 	}
@@ -159,6 +173,7 @@ static struct xt_match policy_mt_reg[] __read_mostly = {
 		.name		= "policy",
 		.family		= NFPROTO_IPV4,
 		.checkentry 	= policy_mt_check,
+		NFT_COMPAT_VALIDATE(policy_mt_validate)
 		.match		= policy_mt,
 		.matchsize	= sizeof(struct xt_policy_info),
 		.me		= THIS_MODULE,
@@ -167,6 +182,7 @@ static struct xt_match policy_mt_reg[] __read_mostly = {
 		.name		= "policy",
 		.family		= NFPROTO_IPV6,
 		.checkentry	= policy_mt_check,
+		NFT_COMPAT_VALIDATE(policy_mt_validate)
 		.match		= policy_mt,
 		.matchsize	= sizeof(struct xt_policy_info),
 		.me		= THIS_MODULE,
diff --git a/net/netfilter/xt_set.c b/net/netfilter/xt_set.c
index 731bc2cafae4..a4ff80fd0223 100644
--- a/net/netfilter/xt_set.c
+++ b/net/netfilter/xt_set.c
@@ -430,6 +430,20 @@ set_target_v3(struct sk_buff *skb, const struct xt_action_param *par)
 	return XT_CONTINUE;
 }
 
+static bool set_target_v3_validate(const void *targinfo, unsigned int hook_mask)
+{
+	const struct xt_set_info_target_v3 *info = targinfo;
+
+	if (((info->flags & IPSET_FLAG_MAP_SKBPRIO) |
+	     (info->flags & IPSET_FLAG_MAP_SKBQUEUE)) &&
+	     (hook_mask & ~(1 << NF_INET_FORWARD |
+			    1 << NF_INET_LOCAL_OUT |
+			    1 << NF_INET_POST_ROUTING)))
+		return false;
+
+	return true;
+}
+
 static int
 set_target_v3_checkentry(const struct xt_tgchk_param *par)
 {
@@ -464,11 +478,7 @@ set_target_v3_checkentry(const struct xt_tgchk_param *par)
 			ret = -EINVAL;
 			goto cleanup_del;
 		}
-		if (((info->flags & IPSET_FLAG_MAP_SKBPRIO) |
-		     (info->flags & IPSET_FLAG_MAP_SKBQUEUE)) &&
-		     (par->hook_mask & ~(1 << NF_INET_FORWARD |
-					 1 << NF_INET_LOCAL_OUT |
-					 1 << NF_INET_POST_ROUTING))) {
+		if (!set_target_v3_validate(info, par->hook_mask)) {
 			pr_info_ratelimited("mapping of prio or/and queue is allowed only from OUTPUT/FORWARD/POSTROUTING chains\n");
 			ret = -EINVAL;
 			goto cleanup_del;
@@ -673,6 +683,7 @@ static struct xt_target set_targets[] __read_mostly = {
 		.target		= set_target_v3,
 		.targetsize	= sizeof(struct xt_set_info_target_v3),
 		.checkentry	= set_target_v3_checkentry,
+		NFT_COMPAT_VALIDATE(set_target_v3_validate)
 		.destroy	= set_target_v3_destroy,
 		.me		= THIS_MODULE
 	},
@@ -683,6 +694,7 @@ static struct xt_target set_targets[] __read_mostly = {
 		.target		= set_target_v3,
 		.targetsize	= sizeof(struct xt_set_info_target_v3),
 		.checkentry	= set_target_v3_checkentry,
+		NFT_COMPAT_VALIDATE(set_target_v3_validate)
 		.destroy	= set_target_v3_destroy,
 		.me		= THIS_MODULE
 	},
-- 
2.53.0

