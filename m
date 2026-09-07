Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCBCA396560
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Sep 2026 18:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788807361; cv=none; b=FqYX9Fl+oMkgUFDTfLqdtSLCNjHWAe5LTVlChUsSy8tuIsvyNLXt+x1Au216n7BXz6U6sElda8rcnw2M++AzBGeb6n35BYzi6YkLnFIHoOgpOyQxXF0tRJP+PG82jSaJe6ayHXW1Nad8S+Mi0ilykQfzDzvNQ2ZUGgnXBJj3Dyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788807361; c=relaxed/simple;
	bh=ozOI8MvezhOqAd5UZgrfDU8WGUJMRPccjl/2Im4NlCU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=uBFNZetCs8oEFXpx5fKveCc900UiS4xeJFo0tfz2GtOh82LHdXiTDA4w3sR7r9axD1Ghl6Elrkg4p5NRHmBI1fUCLEAO0LKP3Wflm65I4v8GtnmqoJ5fKW7MzjsLHxoEduwugsp8KpQCH5lLNICVupZPeJQtL8vu1quGNEnLxBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=S8CDqIje; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="S8CDqIje"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788807356;
	bh=AV4o6mIQGfan+qTxneWrfwoWQfQ30W35kODmxshFH1E=;
	h=From:To:Subject:Date:From;
	b=S8CDqIjezDUysZ/s+1y/qd1K7wsTG1bxm198PwFMsX+b9kiQLprYmUITxI2zhS0y5
	 /uZFIQYHof2AKayZejBdcXmQXC9NWQnoT3WyIjVGT27Rovfo5gqu9c5BNLmCKE8/z2
	 0rbvG9rK4E7qltbdRcZnZJrHHn7lbLca5DPMfi2GQuiIEV5ah5IcxHB5CAsRzZXhHN
	 sxSKTcBToFB88+w83QjYnUZVxZg5t9XDvr1HrarEO0CJ4SdreSYgiuxWsh6cAfcOjY
	 j9w9k9d+gbgZ6sLVOyF1JC7SXcUwEGmLnuJ2iUEZH0cvqdPL4ZBboACNTOhAbVh28q
	 O0wR4ZN8CMqrg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4CB7560792
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Sep 2026 20:55:56 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v3 1/8] netfilter: x_tables: use GFP_KERNEL_ACCOUNT in match/target
Date: Mon,  7 Sep 2026 20:55:45 +0200
Message-ID: <20260907185552.1422008-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

GFP_KERNEL_ACCOUNT is preferred these days for memcg, replace GFP_KERNEL
by GFP_KERNEL_ACCOUNT.

Use GFP_KERNEL_ACCOUNT for objects that are allocated in the xtables
.check path. This includes template ct object with extensions such as
helper and timeout.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: no changes

 net/netfilter/nf_conntrack_ovs.c | 2 +-
 net/netfilter/xt_CT.c            | 6 +++---
 net/netfilter/xt_IDLETIMER.c     | 8 ++++----
 net/netfilter/xt_LED.c           | 5 +++--
 net/netfilter/xt_RATEEST.c       | 2 +-
 net/netfilter/xt_TEE.c           | 2 +-
 net/netfilter/xt_hashlimit.c     | 4 ++--
 net/netfilter/xt_limit.c         | 2 +-
 net/netfilter/xt_quota.c         | 2 +-
 net/netfilter/xt_recent.c        | 3 ++-
 net/netfilter/xt_statistic.c     | 2 +-
 net/netfilter/xt_string.c        | 2 +-
 12 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ovs.c b/net/netfilter/nf_conntrack_ovs.c
index b4085af3ad1c..fe525b324af4 100644
--- a/net/netfilter/nf_conntrack_ovs.c
+++ b/net/netfilter/nf_conntrack_ovs.c
@@ -93,7 +93,7 @@ int nf_ct_add_helper(struct nf_conn *ct, const char *name, u8 family,
 	if (!helper)
 		return -EINVAL;
 
-	help = nf_ct_helper_ext_add(ct, GFP_KERNEL);
+	help = nf_ct_helper_ext_add(ct, GFP_KERNEL_ACCOUNT);
 	if (!help) {
 		nf_conntrack_helper_put(helper);
 		return -ENOMEM;
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index e78660dfdf4b..205bc6dd9812 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -91,7 +91,7 @@ xt_ct_set_helper(struct nf_conn *ct, const char *helper_name,
 		return -ENOENT;
 	}
 
-	help = nf_ct_helper_ext_add(ct, GFP_KERNEL);
+	help = nf_ct_helper_ext_add(ct, GFP_KERNEL_ACCOUNT);
 	if (help == NULL) {
 		nf_conntrack_helper_put(helper);
 		return -ENOMEM;
@@ -182,7 +182,7 @@ static int xt_ct_tg_check(const struct xt_tgchk_param *par,
 	if (info->flags & XT_CT_ZONE_MARK)
 		zone.flags |= NF_CT_FLAG_MARK;
 
-	ct = nf_ct_tmpl_alloc(par->net, &zone, GFP_KERNEL);
+	ct = nf_ct_tmpl_alloc(par->net, &zone, GFP_KERNEL_ACCOUNT);
 	if (!ct) {
 		ret = -ENOMEM;
 		goto err2;
@@ -190,7 +190,7 @@ static int xt_ct_tg_check(const struct xt_tgchk_param *par,
 
 	if ((info->ct_events || info->exp_events) &&
 	    !nf_ct_ecache_ext_add(ct, info->ct_events, info->exp_events,
-				  GFP_KERNEL)) {
+				  GFP_KERNEL_ACCOUNT)) {
 		ret = -EINVAL;
 		goto err3;
 	}
diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
index fe7d8d19629b..71b78b5da698 100644
--- a/net/netfilter/xt_IDLETIMER.c
+++ b/net/netfilter/xt_IDLETIMER.c
@@ -147,7 +147,7 @@ static int idletimer_tg_create(struct idletimer_tg_info *info)
 {
 	int ret;
 
-	info->timer = kzalloc_obj(*info->timer);
+	info->timer = kzalloc_obj(*info->timer, GFP_KERNEL_ACCOUNT);
 	if (!info->timer) {
 		ret = -ENOMEM;
 		goto out;
@@ -158,7 +158,7 @@ static int idletimer_tg_create(struct idletimer_tg_info *info)
 		goto out_free_timer;
 
 	sysfs_attr_init(&info->timer->attr.attr);
-	info->timer->attr.attr.name = kstrdup(info->label, GFP_KERNEL);
+	info->timer->attr.attr.name = kstrdup(info->label, GFP_KERNEL_ACCOUNT);
 	if (!info->timer->attr.attr.name) {
 		ret = -ENOMEM;
 		goto out_free_timer;
@@ -196,7 +196,7 @@ static int idletimer_tg_create_v1(struct idletimer_tg_info_v1 *info)
 {
 	int ret;
 
-	info->timer = kmalloc_obj(*info->timer);
+	info->timer = kmalloc_obj(*info->timer, GFP_KERNEL_ACCOUNT);
 	if (!info->timer) {
 		ret = -ENOMEM;
 		goto out;
@@ -207,7 +207,7 @@ static int idletimer_tg_create_v1(struct idletimer_tg_info_v1 *info)
 		goto out_free_timer;
 
 	sysfs_attr_init(&info->timer->attr.attr);
-	info->timer->attr.attr.name = kstrdup(info->label, GFP_KERNEL);
+	info->timer->attr.attr.name = kstrdup(info->label, GFP_KERNEL_ACCOUNT);
 	if (!info->timer->attr.attr.name) {
 		ret = -ENOMEM;
 		goto out_free_timer;
diff --git a/net/netfilter/xt_LED.c b/net/netfilter/xt_LED.c
index caaaf4d2c584..3cbb8d61d417 100644
--- a/net/netfilter/xt_LED.c
+++ b/net/netfilter/xt_LED.c
@@ -111,11 +111,12 @@ static int led_tg_check(const struct xt_tgchk_param *par)
 	}
 
 	err = -ENOMEM;
-	ledinternal = kzalloc_obj(struct xt_led_info_internal);
+	ledinternal = kzalloc_obj(struct xt_led_info_internal,
+				  GFP_KERNEL_ACCOUNT);
 	if (!ledinternal)
 		goto exit_mutex_only;
 
-	ledinternal->trigger_id = kstrdup(ledinfo->id, GFP_KERNEL);
+	ledinternal->trigger_id = kstrdup(ledinfo->id, GFP_KERNEL_ACCOUNT);
 	if (!ledinternal->trigger_id)
 		goto exit_internal_alloc;
 
diff --git a/net/netfilter/xt_RATEEST.c b/net/netfilter/xt_RATEEST.c
index 91270d467ffd..2f6b512b71e8 100644
--- a/net/netfilter/xt_RATEEST.c
+++ b/net/netfilter/xt_RATEEST.c
@@ -139,7 +139,7 @@ static int xt_rateest_tg_checkentry(const struct xt_tgchk_param *par)
 	}
 
 	ret = -ENOMEM;
-	est = kzalloc_obj(*est);
+	est = kzalloc_obj(*est, GFP_KERNEL_ACCOUNT);
 	if (!est)
 		goto err1;
 
diff --git a/net/netfilter/xt_TEE.c b/net/netfilter/xt_TEE.c
index 5d34ceb893ed..48b4104f0859 100644
--- a/net/netfilter/xt_TEE.c
+++ b/net/netfilter/xt_TEE.c
@@ -106,7 +106,7 @@ static int tee_tg_check(const struct xt_tgchk_param *par)
 		if (info->oif[sizeof(info->oif)-1] != '\0')
 			return -EINVAL;
 
-		priv = kzalloc_obj(*priv);
+		priv = kzalloc_obj(*priv, GFP_KERNEL_ACCOUNT);
 		if (priv == NULL)
 			return -ENOMEM;
 
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 9af0fa895f73..57ac455bc331 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -294,7 +294,7 @@ static int htable_create(struct net *net, struct hashlimit_cfg3 *cfg,
 		if (size < 16)
 			size = 16;
 	}
-	hinfo = kvmalloc_flex(*hinfo, hash, size);
+	hinfo = kvmalloc_flex(*hinfo, hash, size, GFP_KERNEL_ACCOUNT);
 	if (hinfo == NULL)
 		return -ENOMEM;
 	*out_hinfo = hinfo;
@@ -319,7 +319,7 @@ static int htable_create(struct net *net, struct hashlimit_cfg3 *cfg,
 	hinfo->count = 0;
 	hinfo->family = family;
 	hinfo->rnd_initialized = false;
-	hinfo->name = kstrdup(name, GFP_KERNEL);
+	hinfo->name = kstrdup(name, GFP_KERNEL_ACCOUNT);
 	if (!hinfo->name) {
 		kvfree(hinfo);
 		return -ENOMEM;
diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
index 87d74da14c0b..ad48b6879b13 100644
--- a/net/netfilter/xt_limit.c
+++ b/net/netfilter/xt_limit.c
@@ -115,7 +115,7 @@ static int limit_mt_check(const struct xt_mtchk_param *par)
 		return -ERANGE;
 	}
 
-	priv = kmalloc_obj(*priv);
+	priv = kmalloc_obj(*priv, GFP_KERNEL_ACCOUNT);
 	if (priv == NULL)
 		return -ENOMEM;
 
diff --git a/net/netfilter/xt_quota.c b/net/netfilter/xt_quota.c
index b05c5c8dac78..e21ec152d16a 100644
--- a/net/netfilter/xt_quota.c
+++ b/net/netfilter/xt_quota.c
@@ -50,7 +50,7 @@ static int quota_mt_check(const struct xt_mtchk_param *par)
 	if (q->flags & ~XT_QUOTA_MASK)
 		return -EINVAL;
 
-	q->master = kmalloc_obj(*q->master);
+	q->master = kmalloc_obj(*q->master, GFP_KERNEL_ACCOUNT);
 	if (q->master == NULL)
 		return -ENOMEM;
 
diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index d34831ce3adf..55f1f2d89952 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -391,7 +391,8 @@ static int recent_mt_check(const struct xt_mtchk_param *par,
 		goto out;
 	}
 
-	t = kvzalloc_flex(*t, iphash, ip_list_hash_size);
+	t = kvzalloc_flex(*t, iphash, ip_list_hash_size,
+			  GFP_KERNEL_ACCOUNT);
 	if (t == NULL) {
 		ret = -ENOMEM;
 		goto out;
diff --git a/net/netfilter/xt_statistic.c b/net/netfilter/xt_statistic.c
index 334e09771abf..1ffc59d90bb0 100644
--- a/net/netfilter/xt_statistic.c
+++ b/net/netfilter/xt_statistic.c
@@ -58,7 +58,7 @@ static int statistic_mt_check(const struct xt_mtchk_param *par)
 	    info->flags & ~XT_STATISTIC_MASK)
 		return -EINVAL;
 
-	info->master = kzalloc_obj(*info->master);
+	info->master = kzalloc_obj(*info->master, GFP_KERNEL_ACCOUNT);
 	if (info->master == NULL)
 		return -ENOMEM;
 	atomic_set(&info->master->count, info->u.nth.count);
diff --git a/net/netfilter/xt_string.c b/net/netfilter/xt_string.c
index 8ce25bc9b277..52c1deb02cdc 100644
--- a/net/netfilter/xt_string.c
+++ b/net/netfilter/xt_string.c
@@ -54,7 +54,7 @@ static int string_mt_check(const struct xt_mtchk_param *par)
 	if (conf->u.v1.flags & XT_STRING_FLAG_IGNORECASE)
 		flags |= TS_IGNORECASE;
 	ts_conf = textsearch_prepare(conf->algo, conf->pattern, conf->patlen,
-				     GFP_KERNEL, flags);
+				     GFP_KERNEL_ACCOUNT, flags);
 	if (IS_ERR(ts_conf))
 		return PTR_ERR(ts_conf);
 
-- 
2.47.3

