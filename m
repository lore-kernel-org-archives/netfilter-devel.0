Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47A02F9985
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2026 22:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777414253; cv=none; b=CTg8UVS9TphDtPF+H7d7iov0yjyeL3RpBsHtcjVQDn793LFZ9W9UABznWTTpFgDSFyFOCmwBFyI+ZrrInKP1i0DeQXVf8topbUOsNExmv6ts1c2bJnkbVfc2aV/najuNcWBqdnnjQwwELPxuyD/g+5la4ujlygsm/pLy/acklqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777414253; c=relaxed/simple;
	bh=eoj2UFUnZY7i5rA8NqBMw3nDpyN3TPjRbmY3my2XmfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ijlB0fhX+3F1brujyOmA5f6Quf6qm0G3u7yzqkrpyIoDCqQR9OnqKMnvngpqFTOCYsy5CeU+hikcMi731x2mRQO0zUTPoHSfx7RH/1zwuvXsx4W+d53B7yYBwYhbkVxiMNtnkSs2+NmtvHr7kTuG76yKb4xC9jPzo5CSg65TxFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=LSZ2Vilp; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="LSZ2Vilp"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id F12D960178;
	Wed, 29 Apr 2026 00:10:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777414242;
	bh=+Q17HSCRwRpFl98zN015DD2D8x7/VO59pfyj8U2TFJw=;
	h=From:To:Cc:Subject:Date:From;
	b=LSZ2Vilp73wzSdbo5AvvCUx31H/+UkKM51B3cJwr9YOJ9nK4Tuq0k8UAv6GzDtezP
	 suDUqYCAYXwrXLWPRBcfd+q2EVoZjU4MhKh8nQhxqBimWp864ZTZNT5tkxLt7smnj7
	 LH8yoRYDOVNoYZ6fnKSQK/J+DHXeP1mzgXsmGPR+m9G2Dx4OvcEHb5ae622eFwZxVJ
	 l7lEYsqCrYyiHQvGmnacQ9iMT5y2NLmobnUI5fD9zv6t0EbkXAqWo3ETNsJ2BmeW2f
	 RmSVLQ8Mm99M0jvEE9zzAeIgL3chAGlsODhq9cARk4xEqAtGbsyDcQiRE/RSxRtAGy
	 jjH4xDQDZ2sQw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf 1/2] netfilter: x_tables: add .check_hooks to matches and targets
Date: Wed, 29 Apr 2026 00:10:37 +0200
Message-ID: <20260428221038.96012-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new .check_hooks interface for checking if the match/target is
used from the validate hook according to its configuration.

Move existing conditional hook check based on the match/target
configuration from .checkentry to .check_hooks for the following
matches/targets:

- addrtype
- devgroup
- physdev
- policy
- set
- TCPMSS
- SET

This is a preparation patch to fix nft_compat, not functional changes
are intended.

Based on patch from Florian Westphal.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/x_tables.h |  8 +++
 net/netfilter/x_tables.c           | 79 +++++++++++++++++++++++++++---
 net/netfilter/xt_TCPMSS.c          | 33 +++++++------
 net/netfilter/xt_addrtype.c        | 25 +++++++---
 net/netfilter/xt_devgroup.c        | 18 +++++--
 net/netfilter/xt_physdev.c         | 20 ++++++--
 net/netfilter/xt_policy.c          | 23 +++++++--
 net/netfilter/xt_set.c             | 39 +++++++++------
 8 files changed, 186 insertions(+), 59 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 77c778d84d4c..a81b46af5118 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -146,6 +146,9 @@ struct xt_match {
 	/* Called when user tries to insert an entry of this type. */
 	int (*checkentry)(const struct xt_mtchk_param *);
 
+	/* Called to validate hooks based on the match configuration. */
+	int (*check_hooks)(const struct xt_mtchk_param *);
+
 	/* Called when entry of this type deleted. */
 	void (*destroy)(const struct xt_mtdtor_param *);
 #ifdef CONFIG_NETFILTER_XTABLES_COMPAT
@@ -187,6 +190,9 @@ struct xt_target {
 	/* Should return 0 on success or an error code otherwise (-Exxxx). */
 	int (*checkentry)(const struct xt_tgchk_param *);
 
+	/* Called to validate hooks based on the target configuration. */
+	int (*check_hooks)(const struct xt_tgchk_param *);
+
 	/* Called when entry of this type deleted. */
 	void (*destroy)(const struct xt_tgdtor_param *);
 #ifdef CONFIG_NETFILTER_XTABLES_COMPAT
@@ -279,8 +285,10 @@ bool xt_find_jump_offset(const unsigned int *offsets,
 
 int xt_check_proc_name(const char *name, unsigned int size);
 
+int xt_check_hooks_match(struct xt_mtchk_param *par);
 int xt_check_match(struct xt_mtchk_param *, unsigned int size, u16 proto,
 		   bool inv_proto);
+int xt_check_hooks_target(struct xt_tgchk_param *par);
 int xt_check_target(struct xt_tgchk_param *, unsigned int size, u16 proto,
 		    bool inv_proto);
 
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 9f837fb5ceb4..2c67c2e6b132 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -477,11 +477,9 @@ int xt_check_proc_name(const char *name, unsigned int size)
 }
 EXPORT_SYMBOL(xt_check_proc_name);
 
-int xt_check_match(struct xt_mtchk_param *par,
-		   unsigned int size, u16 proto, bool inv_proto)
+static int xt_check_match_common(struct xt_mtchk_param *par,
+				 unsigned int size, u16 proto, bool inv_proto)
 {
-	int ret;
-
 	if (XT_ALIGN(par->match->matchsize) != size &&
 	    par->match->matchsize != -1) {
 		/*
@@ -530,6 +528,14 @@ int xt_check_match(struct xt_mtchk_param *par,
 				    par->match->proto);
 		return -EINVAL;
 	}
+
+	return 0;
+}
+
+static int xt_checkentry_match(struct xt_mtchk_param *par)
+{
+	int ret;
+
 	if (par->match->checkentry != NULL) {
 		ret = par->match->checkentry(par);
 		if (ret < 0)
@@ -538,8 +544,34 @@ int xt_check_match(struct xt_mtchk_param *par,
 			/* Flag up potential errors. */
 			return -EIO;
 	}
+
+	return 0;
+}
+
+int xt_check_hooks_match(struct xt_mtchk_param *par)
+{
+	if (par->match->check_hooks != NULL)
+		return par->match->check_hooks(par);
+
 	return 0;
 }
+EXPORT_SYMBOL_GPL(xt_check_hooks_match);
+
+int xt_check_match(struct xt_mtchk_param *par,
+		   unsigned int size, u16 proto, bool inv_proto)
+{
+	int ret;
+
+	ret = xt_check_match_common(par, size, proto, inv_proto);
+	if (ret < 0)
+		return ret;
+
+	ret = xt_check_hooks_match(par);
+	if (ret < 0)
+		return ret;
+
+	return xt_checkentry_match(par);
+}
 EXPORT_SYMBOL_GPL(xt_check_match);
 
 /** xt_check_entry_match - check that matches end before start of target
@@ -1012,11 +1044,9 @@ bool xt_find_jump_offset(const unsigned int *offsets,
 }
 EXPORT_SYMBOL(xt_find_jump_offset);
 
-int xt_check_target(struct xt_tgchk_param *par,
-		    unsigned int size, u16 proto, bool inv_proto)
+static int xt_check_target_common(struct xt_tgchk_param *par,
+				  unsigned int size, u16 proto, bool inv_proto)
 {
-	int ret;
-
 	if (XT_ALIGN(par->target->targetsize) != size) {
 		pr_err_ratelimited("%s_tables: %s.%u target: invalid size %u (kernel) != (user) %u\n",
 				   xt_prefix[par->family], par->target->name,
@@ -1061,6 +1091,23 @@ int xt_check_target(struct xt_tgchk_param *par,
 				    par->target->proto);
 		return -EINVAL;
 	}
+
+	return 0;
+}
+
+int xt_check_hooks_target(struct xt_tgchk_param *par)
+{
+	if (par->target->check_hooks != NULL)
+		return par->target->check_hooks(par);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xt_check_hooks_target);
+
+static int xt_checkentry_target(struct xt_tgchk_param *par)
+{
+	int ret;
+
 	if (par->target->checkentry != NULL) {
 		ret = par->target->checkentry(par);
 		if (ret < 0)
@@ -1071,6 +1118,22 @@ int xt_check_target(struct xt_tgchk_param *par,
 	}
 	return 0;
 }
+
+int xt_check_target(struct xt_tgchk_param *par,
+		    unsigned int size, u16 proto, bool inv_proto)
+{
+	int ret;
+
+	ret = xt_check_target_common(par, size, proto, inv_proto);
+	if (ret < 0)
+		return ret;
+
+	ret = xt_check_hooks_target(par);
+	if (ret < 0)
+		return ret;
+
+	return xt_checkentry_target(par);
+}
 EXPORT_SYMBOL_GPL(xt_check_target);
 
 /**
diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index 116a885adb3c..80e1634bc51f 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -247,6 +247,21 @@ tcpmss_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 }
 #endif
 
+static int tcpmss_tg4_check_hooks(const struct xt_tgchk_param *par)
+{
+	const struct xt_tcpmss_info *info = par->targinfo;
+
+	if (info->mss == XT_TCPMSS_CLAMP_PMTU &&
+	    (par->hook_mask & ~((1 << NF_INET_FORWARD) |
+			   (1 << NF_INET_LOCAL_OUT) |
+			   (1 << NF_INET_POST_ROUTING))) != 0) {
+		pr_info_ratelimited("path-MTU clamping only supported in FORWARD, OUTPUT and POSTROUTING hooks\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /* Must specify -p tcp --syn */
 static inline bool find_syn_match(const struct xt_entry_match *m)
 {
@@ -262,17 +277,9 @@ static inline bool find_syn_match(const struct xt_entry_match *m)
 
 static int tcpmss_tg4_check(const struct xt_tgchk_param *par)
 {
-	const struct xt_tcpmss_info *info = par->targinfo;
 	const struct ipt_entry *e = par->entryinfo;
 	const struct xt_entry_match *ematch;
 
-	if (info->mss == XT_TCPMSS_CLAMP_PMTU &&
-	    (par->hook_mask & ~((1 << NF_INET_FORWARD) |
-			   (1 << NF_INET_LOCAL_OUT) |
-			   (1 << NF_INET_POST_ROUTING))) != 0) {
-		pr_info_ratelimited("path-MTU clamping only supported in FORWARD, OUTPUT and POSTROUTING hooks\n");
-		return -EINVAL;
-	}
 	if (par->nft_compat)
 		return 0;
 
@@ -286,17 +293,9 @@ static int tcpmss_tg4_check(const struct xt_tgchk_param *par)
 #if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
 static int tcpmss_tg6_check(const struct xt_tgchk_param *par)
 {
-	const struct xt_tcpmss_info *info = par->targinfo;
 	const struct ip6t_entry *e = par->entryinfo;
 	const struct xt_entry_match *ematch;
 
-	if (info->mss == XT_TCPMSS_CLAMP_PMTU &&
-	    (par->hook_mask & ~((1 << NF_INET_FORWARD) |
-			   (1 << NF_INET_LOCAL_OUT) |
-			   (1 << NF_INET_POST_ROUTING))) != 0) {
-		pr_info_ratelimited("path-MTU clamping only supported in FORWARD, OUTPUT and POSTROUTING hooks\n");
-		return -EINVAL;
-	}
 	if (par->nft_compat)
 		return 0;
 
@@ -312,6 +311,7 @@ static struct xt_target tcpmss_tg_reg[] __read_mostly = {
 	{
 		.family		= NFPROTO_IPV4,
 		.name		= "TCPMSS",
+		.check_hooks	= tcpmss_tg4_check_hooks,
 		.checkentry	= tcpmss_tg4_check,
 		.target		= tcpmss_tg4,
 		.targetsize	= sizeof(struct xt_tcpmss_info),
@@ -322,6 +322,7 @@ static struct xt_target tcpmss_tg_reg[] __read_mostly = {
 	{
 		.family		= NFPROTO_IPV6,
 		.name		= "TCPMSS",
+		.check_hooks	= tcpmss_tg4_check_hooks,
 		.checkentry	= tcpmss_tg6_check,
 		.target		= tcpmss_tg6,
 		.targetsize	= sizeof(struct xt_tcpmss_info),
diff --git a/net/netfilter/xt_addrtype.c b/net/netfilter/xt_addrtype.c
index a77088943107..913dbe3aa5e2 100644
--- a/net/netfilter/xt_addrtype.c
+++ b/net/netfilter/xt_addrtype.c
@@ -153,14 +153,10 @@ addrtype_mt_v1(const struct sk_buff *skb, struct xt_action_param *par)
 	return ret;
 }
 
-static int addrtype_mt_checkentry_v1(const struct xt_mtchk_param *par)
+static int addrtype_mt_check_hooks(const struct xt_mtchk_param *par)
 {
-	const char *errmsg = "both incoming and outgoing interface limitation cannot be selected";
 	struct xt_addrtype_info_v1 *info = par->matchinfo;
-
-	if (info->flags & XT_ADDRTYPE_LIMIT_IFACE_IN &&
-	    info->flags & XT_ADDRTYPE_LIMIT_IFACE_OUT)
-		goto err;
+	const char *errmsg;
 
 	if (par->hook_mask & ((1 << NF_INET_PRE_ROUTING) |
 	    (1 << NF_INET_LOCAL_IN)) &&
@@ -176,6 +172,21 @@ static int addrtype_mt_checkentry_v1(const struct xt_mtchk_param *par)
 		goto err;
 	}
 
+	return 0;
+err:
+	pr_info_ratelimited("%s\n", errmsg);
+	return -EINVAL;
+}
+
+static int addrtype_mt_checkentry_v1(const struct xt_mtchk_param *par)
+{
+	const char *errmsg = "both incoming and outgoing interface limitation cannot be selected";
+	struct xt_addrtype_info_v1 *info = par->matchinfo;
+
+	if (info->flags & XT_ADDRTYPE_LIMIT_IFACE_IN &&
+	    info->flags & XT_ADDRTYPE_LIMIT_IFACE_OUT)
+		goto err;
+
 #if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
 	if (par->family == NFPROTO_IPV6) {
 		if ((info->source | info->dest) & XT_ADDRTYPE_BLACKHOLE) {
@@ -211,6 +222,7 @@ static struct xt_match addrtype_mt_reg[] __read_mostly = {
 		.family		= NFPROTO_IPV4,
 		.revision	= 1,
 		.match		= addrtype_mt_v1,
+		.check_hooks	= addrtype_mt_check_hooks,
 		.checkentry	= addrtype_mt_checkentry_v1,
 		.matchsize	= sizeof(struct xt_addrtype_info_v1),
 		.me		= THIS_MODULE
@@ -221,6 +233,7 @@ static struct xt_match addrtype_mt_reg[] __read_mostly = {
 		.family		= NFPROTO_IPV6,
 		.revision	= 1,
 		.match		= addrtype_mt_v1,
+		.check_hooks	= addrtype_mt_check_hooks,
 		.checkentry	= addrtype_mt_checkentry_v1,
 		.matchsize	= sizeof(struct xt_addrtype_info_v1),
 		.me		= THIS_MODULE
diff --git a/net/netfilter/xt_devgroup.c b/net/netfilter/xt_devgroup.c
index 9520dd00070b..6d1a44ab5eee 100644
--- a/net/netfilter/xt_devgroup.c
+++ b/net/netfilter/xt_devgroup.c
@@ -33,14 +33,10 @@ static bool devgroup_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	return true;
 }
 
-static int devgroup_mt_checkentry(const struct xt_mtchk_param *par)
+static int devgroup_mt_check_hooks(const struct xt_mtchk_param *par)
 {
 	const struct xt_devgroup_info *info = par->matchinfo;
 
-	if (info->flags & ~(XT_DEVGROUP_MATCH_SRC | XT_DEVGROUP_INVERT_SRC |
-			    XT_DEVGROUP_MATCH_DST | XT_DEVGROUP_INVERT_DST))
-		return -EINVAL;
-
 	if (info->flags & XT_DEVGROUP_MATCH_SRC &&
 	    par->hook_mask & ~((1 << NF_INET_PRE_ROUTING) |
 			       (1 << NF_INET_LOCAL_IN) |
@@ -56,9 +52,21 @@ static int devgroup_mt_checkentry(const struct xt_mtchk_param *par)
 	return 0;
 }
 
+static int devgroup_mt_checkentry(const struct xt_mtchk_param *par)
+{
+	const struct xt_devgroup_info *info = par->matchinfo;
+
+	if (info->flags & ~(XT_DEVGROUP_MATCH_SRC | XT_DEVGROUP_INVERT_SRC |
+			    XT_DEVGROUP_MATCH_DST | XT_DEVGROUP_INVERT_DST))
+		return -EINVAL;
+
+	return 0;
+}
+
 static struct xt_match devgroup_mt_reg __read_mostly = {
 	.name		= "devgroup",
 	.match		= devgroup_mt,
+	.check_hooks	= devgroup_mt_check_hooks,
 	.checkentry	= devgroup_mt_checkentry,
 	.matchsize	= sizeof(struct xt_devgroup_info),
 	.family		= NFPROTO_UNSPEC,
diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index d2b0b52434fa..dd98f758176c 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -91,14 +91,10 @@ physdev_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	return (!!ret ^ !(info->invert & XT_PHYSDEV_OP_OUT));
 }
 
-static int physdev_mt_check(const struct xt_mtchk_param *par)
+static int physdev_mt_check_hooks(const struct xt_mtchk_param *par)
 {
 	const struct xt_physdev_info *info = par->matchinfo;
-	static bool brnf_probed __read_mostly;
 
-	if (!(info->bitmask & XT_PHYSDEV_OP_MASK) ||
-	    info->bitmask & ~XT_PHYSDEV_OP_MASK)
-		return -EINVAL;
 	if (info->bitmask & (XT_PHYSDEV_OP_OUT | XT_PHYSDEV_OP_ISOUT) &&
 	    (!(info->bitmask & XT_PHYSDEV_OP_BRIDGED) ||
 	     info->invert & XT_PHYSDEV_OP_BRIDGED) &&
@@ -107,6 +103,18 @@ static int physdev_mt_check(const struct xt_mtchk_param *par)
 		return -EINVAL;
 	}
 
+	return 0;
+}
+
+static int physdev_mt_check(const struct xt_mtchk_param *par)
+{
+	const struct xt_physdev_info *info = par->matchinfo;
+	static bool brnf_probed __read_mostly;
+
+	if (!(info->bitmask & XT_PHYSDEV_OP_MASK) ||
+	    info->bitmask & ~XT_PHYSDEV_OP_MASK)
+		return -EINVAL;
+
 #define X(memb) strnlen(info->memb, sizeof(info->memb)) >= sizeof(info->memb)
 	if (info->bitmask & XT_PHYSDEV_OP_IN) {
 		if (info->physindev[0] == '\0')
@@ -141,6 +149,7 @@ static struct xt_match physdev_mt_reg[] __read_mostly = {
 	{
 		.name		= "physdev",
 		.family		= NFPROTO_IPV4,
+		.check_hooks	= physdev_mt_check_hooks,
 		.checkentry	= physdev_mt_check,
 		.match		= physdev_mt,
 		.matchsize	= sizeof(struct xt_physdev_info),
@@ -149,6 +158,7 @@ static struct xt_match physdev_mt_reg[] __read_mostly = {
 	{
 		.name		= "physdev",
 		.family		= NFPROTO_IPV6,
+		.check_hooks	= physdev_mt_check_hooks,
 		.checkentry	= physdev_mt_check,
 		.match		= physdev_mt,
 		.matchsize	= sizeof(struct xt_physdev_info),
diff --git a/net/netfilter/xt_policy.c b/net/netfilter/xt_policy.c
index b5fa65558318..b2014211d0b5 100644
--- a/net/netfilter/xt_policy.c
+++ b/net/netfilter/xt_policy.c
@@ -126,13 +126,10 @@ policy_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	return ret;
 }
 
-static int policy_mt_check(const struct xt_mtchk_param *par)
+static int policy_mt_check_hooks(const struct xt_mtchk_param *par)
 {
 	const struct xt_policy_info *info = par->matchinfo;
-	const char *errmsg = "neither incoming nor outgoing policy selected";
-
-	if (!(info->flags & (XT_POLICY_MATCH_IN|XT_POLICY_MATCH_OUT)))
-		goto err;
+	const char *errmsg;
 
 	if (par->hook_mask & ((1 << NF_INET_PRE_ROUTING) |
 	    (1 << NF_INET_LOCAL_IN)) && info->flags & XT_POLICY_MATCH_OUT) {
@@ -144,6 +141,21 @@ static int policy_mt_check(const struct xt_mtchk_param *par)
 		errmsg = "input policy not valid in POSTROUTING and OUTPUT";
 		goto err;
 	}
+
+	return 0;
+err:
+	pr_info_ratelimited("%s\n", errmsg);
+	return -EINVAL;
+}
+
+static int policy_mt_check(const struct xt_mtchk_param *par)
+{
+	const struct xt_policy_info *info = par->matchinfo;
+	const char *errmsg = "neither incoming nor outgoing policy selected";
+
+	if (!(info->flags & (XT_POLICY_MATCH_IN|XT_POLICY_MATCH_OUT)))
+		goto err;
+
 	if (info->len > XT_POLICY_MAX_ELEM) {
 		errmsg = "too many policy elements";
 		goto err;
@@ -158,6 +170,7 @@ static struct xt_match policy_mt_reg[] __read_mostly = {
 	{
 		.name		= "policy",
 		.family		= NFPROTO_IPV4,
+		.check_hooks	= policy_mt_check_hooks,
 		.checkentry 	= policy_mt_check,
 		.match		= policy_mt,
 		.matchsize	= sizeof(struct xt_policy_info),
diff --git a/net/netfilter/xt_set.c b/net/netfilter/xt_set.c
index 731bc2cafae4..4ae04bba9358 100644
--- a/net/netfilter/xt_set.c
+++ b/net/netfilter/xt_set.c
@@ -430,6 +430,29 @@ set_target_v3(struct sk_buff *skb, const struct xt_action_param *par)
 	return XT_CONTINUE;
 }
 
+static int
+set_target_v3_check_hooks(const struct xt_tgchk_param *par)
+{
+	const struct xt_set_info_target_v3 *info = par->targinfo;
+
+	if (info->map_set.index != IPSET_INVALID_ID) {
+		if (strncmp(par->table, "mangle", 7)) {
+			pr_info_ratelimited("--map-set only usable from mangle table\n");
+			return -EINVAL;
+		}
+		if (((info->flags & IPSET_FLAG_MAP_SKBPRIO) |
+		     (info->flags & IPSET_FLAG_MAP_SKBQUEUE)) &&
+		     (par->hook_mask & ~(1 << NF_INET_FORWARD |
+					 1 << NF_INET_LOCAL_OUT |
+					 1 << NF_INET_POST_ROUTING))) {
+			pr_info_ratelimited("mapping of prio or/and queue is allowed only from OUTPUT/FORWARD/POSTROUTING chains\n");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 static int
 set_target_v3_checkentry(const struct xt_tgchk_param *par)
 {
@@ -459,20 +482,6 @@ set_target_v3_checkentry(const struct xt_tgchk_param *par)
 	}
 
 	if (info->map_set.index != IPSET_INVALID_ID) {
-		if (strncmp(par->table, "mangle", 7)) {
-			pr_info_ratelimited("--map-set only usable from mangle table\n");
-			ret = -EINVAL;
-			goto cleanup_del;
-		}
-		if (((info->flags & IPSET_FLAG_MAP_SKBPRIO) |
-		     (info->flags & IPSET_FLAG_MAP_SKBQUEUE)) &&
-		     (par->hook_mask & ~(1 << NF_INET_FORWARD |
-					 1 << NF_INET_LOCAL_OUT |
-					 1 << NF_INET_POST_ROUTING))) {
-			pr_info_ratelimited("mapping of prio or/and queue is allowed only from OUTPUT/FORWARD/POSTROUTING chains\n");
-			ret = -EINVAL;
-			goto cleanup_del;
-		}
 		index = ip_set_nfnl_get_byindex(par->net,
 						info->map_set.index);
 		if (index == IPSET_INVALID_ID) {
@@ -672,6 +681,7 @@ static struct xt_target set_targets[] __read_mostly = {
 		.family		= NFPROTO_IPV4,
 		.target		= set_target_v3,
 		.targetsize	= sizeof(struct xt_set_info_target_v3),
+		.check_hooks	= set_target_v3_check_hooks,
 		.checkentry	= set_target_v3_checkentry,
 		.destroy	= set_target_v3_destroy,
 		.me		= THIS_MODULE
@@ -682,6 +692,7 @@ static struct xt_target set_targets[] __read_mostly = {
 		.family		= NFPROTO_IPV6,
 		.target		= set_target_v3,
 		.targetsize	= sizeof(struct xt_set_info_target_v3),
+		.check_hooks	= set_target_v3_check_hooks,
 		.checkentry	= set_target_v3_checkentry,
 		.destroy	= set_target_v3_destroy,
 		.me		= THIS_MODULE
-- 
2.47.3

