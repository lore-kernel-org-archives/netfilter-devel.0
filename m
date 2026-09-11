Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0F046D0A6;
	Fri, 11 Sep 2026 08:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789116300; cv=none; b=jE6udDZS5KIHuWdhWFgxZIrPzN9ex6XitX/zkk/XlTi8fBW//vXo3Ynn5rMJHnFaMEr0be/KYiUQIVM0zwDD1ML4PnZuLTiGEmZq7jqgWpZLTm2HiXW0K3uqtL2eldXXp60/jDG5hJNAKJbnVVdaUdOCBJifk9y97S+1L5IujEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789116300; c=relaxed/simple;
	bh=AUpzQ2+U+rUcKOMx9H8S7/jmqSOtBdfqlJ24GKAJSdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K47eXREXj9j8ymka2e4ZXL2Vimc2ELQ2oCLZKsEAtMi5cX2lBbNN0utPNOJVw6yF4ZW6fwpvtFRycR9l77toRLyTvi32BQ/j7ClVmehUbIAf6hjVUF12FlVmmhHWtYvsrgLXUR9tdYzC/U6uWjGzAGBh2kc+s/vYQNoXlAsCARQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=BqkxLd8v; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="BqkxLd8v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789116287;
	bh=HKAyJe5FrQS8hXv6EwgpPtnJKO7gW3iJKulQtlAleMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BqkxLd8v8gCJZkhyEI7K6AiN/M3KTqRN2sg+evWILj159KUzE3YEj9Dr2bMA0zwLY
	 dCvRQtgmGwY3+e5HXawH44BSPMyMUwd2gnHmG9Ob/QVGYxe6LK1nZ3O73+ixubk5ox
	 XVXNNUAYHvv7A7HgidPuEJhU9uFr7vFGXVbT4+SqB/kL51QH3FZR3gK6X1V0aXRnT5
	 C3e6NDJIiXbJ1xO+k+5zKm/1Mpfgk2/mZ8lH9/yJ8h36Tkt/+OcuiiQb/TU0GypKxr
	 dAkvPeM3eMZ+Euc5+oOQWXbEJJAbDaeDFNJnzrmjarAunNqMDkH5gjLbN5z6HQSx60
	 YAz1MRibEovXQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C17A9603DF;
	Fri, 11 Sep 2026 10:44:46 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 2/8] netfilter: x_tables: use GFP_KERNEL_ACCOUNT in match/target
Date: Fri, 11 Sep 2026 10:44:31 +0200
Message-ID: <20260911084437.1838161-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260911084437.1838161-1-pablo@netfilter.org>
References: <20260911084437.1838161-1-pablo@netfilter.org>
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

