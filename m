Received: from wilbur.contactoffice.com (wilbur.contactoffice.com [212.3.242.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412FB34D4F9
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Feb 2026 05:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.3.242.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770095281; cv=none; b=eYBzHDFeY36DGY9W+D9OK5teTE3tigdwKlAkXUfVgB+FxGwFSDI2Lh21El0N7YEvDS2GCmKOsRFSzZI2dt83kUW1sB8oZNhnQpA/wTpgsaqqdD09ZVDt9jjY7f98xSGZbuPQrOhr7cMWX4/O/i+8q905qAdjL+ardpnJ5D288/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770095281; c=relaxed/simple;
	bh=59X9IdfYMiM8f9d1De+a57dKcYRtWDWdYeSK3+2F1Jc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mT226TI6IQO8Psu97XqMl7E/RY35dYwDD8ea4+3mpCWClPhnSimX7nEGR23bnFoF2w9zkX7z94nsdcnO91wllqgPNADE8Xn9CUz1eOr/RZJZcoCe4Gw8MQ9FJRTpP1t074C6nUmBD+KCk3PXF7YiWHqUDnePb6qC0XzlcpimBBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailfence.com; spf=pass smtp.mailfrom=mailfence.com; dkim=pass (2048-bit key) header.d=mailfence.com header.i=brianwitte@mailfence.com header.b=MynSNqjK; arc=none smtp.client-ip=212.3.242.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailfence.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailfence.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailfence.com header.i=brianwitte@mailfence.com header.b="MynSNqjK"
Received: from smtpauth2.co-bxl (smtpauth2.co-bxl [10.2.0.24])
	by wilbur.contactoffice.com (Postfix) with ESMTP id 3C7E987AD;
	Tue,  3 Feb 2026 06:07:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1770095277;
	s=20240605-akrp; d=mailfence.com; i=brianwitte@mailfence.com;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=eGMM5I0BcWHiwWrUyNl+QY0J5VpQCRVwtAlhiWRe19Y=;
	b=MynSNqjK4LJaz+nnnRiUCHhFwKpinyUorekiEsQ1tMpOkvPo7Z93smxoKdW4+isl
	S8X8jxfEA/Bv6io2z8yEi6/k0ETHOMHJOCpaGuC6YpInujcVey8NXRR4z1mhLEVCaEO
	4BFFbdYIhtg2tKp+qOVIfpRSk6BJIowDMejkxBYJJrFl57nDVIdPhM2xKanaRa30oZB
	bqoUo0qpG8Xy23B+BcRU2OUvo3UIavNaXb/7Mw82jcEiEwF3SJ6Ar1p0GGw1QUMAz5d
	4e/srmccnyNqFoodQSeXHaCD2bjzNPtHKNNdtBZSOcL6wKQzYrX5JPuB3ZbzlwVA58W
	pHvq7xA96Q==
Received: by smtp.mailfence.com with ESMTPSA ; Tue, 3 Feb 2026 06:07:53 +0100 (CET)
From: Brian Witte <brianwitte@mailfence.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	kadlec@netfilter.org,
	syzbot+ff16b505ec9152e5f448@syzkaller.appspotmail.com,
	Brian Witte <brianwitte@mailfence.com>
Subject: [PATCH v4 nf-next 2/2] netfilter: nf_tables: serialize reset with spinlock and atomic
Date: Mon,  2 Feb 2026 23:07:23 -0600
Message-ID: <20260203050723.263515-3-brianwitte@mailfence.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260203050723.263515-1-brianwitte@mailfence.com>
References: <20260203050723.263515-1-brianwitte@mailfence.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ContactOffice-Account: com:441463380

Add a dedicated spinlock to serialize counter reset operations,
preventing concurrent dump-and-reset from underrunning values.

Store struct net in counter priv to access the per-net spinlock during
reset. This avoids dereferencing skb->sk which is NULL in single-element
GET paths such as nft_get_set_elem.

For quota, use atomic64_xchg() to atomically read and zero the consumed
value, which is simpler and doesn't require spinlock protection.

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Brian Witte <brianwitte@mailfence.com>
---
 include/net/netfilter/nf_tables.h |  1 +
 net/netfilter/nf_tables_api.c     |  3 +--
 net/netfilter/nft_counter.c       | 17 ++++++++++++-----
 net/netfilter/nft_quota.c         | 12 +++++++-----
 4 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 426534a711b0..c4b6b8cadf09 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1935,6 +1935,7 @@ struct nftables_pernet {
 	struct list_head	module_list;
 	struct list_head	notify_list;
 	struct mutex		commit_mutex;
+	spinlock_t		reset_lock;
 	u64			table_handle;
 	u64			tstamp;
 	unsigned int		gc_seq;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 9969d8488de4..146f29be834a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3986,7 +3986,6 @@ nf_tables_getrule_single(u32 portid, const struct nfnl_info *info,
 static int nf_tables_getrule(struct sk_buff *skb, const struct nfnl_info *info,
 			     const struct nlattr * const nla[])
 {
-	struct nftables_pernet *nft_net = nft_pernet(info->net);
 	u32 portid = NETLINK_CB(skb).portid;
 	struct net *net = info->net;
 	struct sk_buff *skb2;
@@ -8529,7 +8528,6 @@ nf_tables_getobj_single(u32 portid, const struct nfnl_info *info,
 static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
 			    const struct nlattr * const nla[])
 {
-	struct nftables_pernet *nft_net = nft_pernet(info->net);
 	u32 portid = NETLINK_CB(skb).portid;
 	struct net *net = info->net;
 	struct sk_buff *skb2;
@@ -12050,6 +12048,7 @@ static int __net_init nf_tables_init_net(struct net *net)
 	INIT_LIST_HEAD(&nft_net->module_list);
 	INIT_LIST_HEAD(&nft_net->notify_list);
 	mutex_init(&nft_net->commit_mutex);
+	spin_lock_init(&nft_net->reset_lock);
 	net->nft.base_seq = 1;
 	nft_net->gc_seq = 0;
 	nft_net->validate_state = NFT_VALIDATE_SKIP;
diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index cc7325329496..54bcbf33e2b9 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -28,6 +28,7 @@ struct nft_counter_tot {
 
 struct nft_counter_percpu_priv {
 	struct nft_counter __percpu *counter;
+	struct net *net;
 };
 
 static DEFINE_PER_CPU(struct u64_stats_sync, nft_counter_sync);
@@ -61,7 +62,8 @@ static inline void nft_counter_obj_eval(struct nft_object *obj,
 }
 
 static int nft_counter_do_init(const struct nlattr * const tb[],
-			       struct nft_counter_percpu_priv *priv)
+			       struct nft_counter_percpu_priv *priv,
+			       struct net *net)
 {
 	struct nft_counter __percpu *cpu_stats;
 	struct nft_counter *this_cpu;
@@ -81,6 +83,7 @@ static int nft_counter_do_init(const struct nlattr * const tb[],
 	}
 
 	priv->counter = cpu_stats;
+	priv->net = net;
 	return 0;
 }
 
@@ -90,7 +93,7 @@ static int nft_counter_obj_init(const struct nft_ctx *ctx,
 {
 	struct nft_counter_percpu_priv *priv = nft_obj_data(obj);
 
-	return nft_counter_do_init(tb, priv);
+	return nft_counter_do_init(tb, priv, ctx->net);
 }
 
 static void nft_counter_do_destroy(struct nft_counter_percpu_priv *priv)
@@ -106,13 +109,15 @@ static void nft_counter_obj_destroy(const struct nft_ctx *ctx,
 	nft_counter_do_destroy(priv);
 }
 
-static void nft_counter_reset(struct nft_counter_percpu_priv *priv,
+static void nft_counter_reset(struct nftables_pernet *nft_net,
+			      struct nft_counter_percpu_priv *priv,
 			      struct nft_counter_tot *total)
 {
 	struct u64_stats_sync *nft_sync;
 	struct nft_counter *this_cpu;
 
 	local_bh_disable();
+	spin_lock(&nft_net->reset_lock);
 	this_cpu = this_cpu_ptr(priv->counter);
 	nft_sync = this_cpu_ptr(&nft_counter_sync);
 
@@ -121,6 +126,7 @@ static void nft_counter_reset(struct nft_counter_percpu_priv *priv,
 	u64_stats_add(&this_cpu->bytes, -total->bytes);
 	u64_stats_update_end(nft_sync);
 
+	spin_unlock(&nft_net->reset_lock);
 	local_bh_enable();
 }
 
@@ -163,7 +169,7 @@ static int nft_counter_do_dump(struct sk_buff *skb,
 		goto nla_put_failure;
 
 	if (reset)
-		nft_counter_reset(priv, &total);
+		nft_counter_reset(nft_pernet(priv->net), priv, &total);
 
 	return 0;
 
@@ -224,7 +230,7 @@ static int nft_counter_init(const struct nft_ctx *ctx,
 {
 	struct nft_counter_percpu_priv *priv = nft_expr_priv(expr);
 
-	return nft_counter_do_init(tb, priv);
+	return nft_counter_do_init(tb, priv, ctx->net);
 }
 
 static void nft_counter_destroy(const struct nft_ctx *ctx,
@@ -254,6 +260,7 @@ static int nft_counter_clone(struct nft_expr *dst, const struct nft_expr *src, g
 	u64_stats_set(&this_cpu->bytes, total.bytes);
 
 	priv_clone->counter = cpu_stats;
+	priv_clone->net = priv->net;
 	return 0;
 }
 
diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index df0798da2329..34c77c872f79 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -140,11 +140,14 @@ static int nft_quota_do_dump(struct sk_buff *skb, struct nft_quota *priv,
 	u64 consumed, consumed_cap, quota;
 	u32 flags = priv->flags;
 
-	/* Since we inconditionally increment consumed quota for each packet
+	/* Since we unconditionally increment consumed quota for each packet
 	 * that we see, don't go over the quota boundary in what we send to
 	 * userspace.
 	 */
-	consumed = atomic64_read(priv->consumed);
+	if (reset)
+		consumed = atomic64_xchg(priv->consumed, 0);
+	else
+		consumed = atomic64_read(priv->consumed);
 	quota = atomic64_read(&priv->quota);
 	if (consumed >= quota) {
 		consumed_cap = quota;
@@ -160,10 +163,9 @@ static int nft_quota_do_dump(struct sk_buff *skb, struct nft_quota *priv,
 	    nla_put_be32(skb, NFTA_QUOTA_FLAGS, htonl(flags)))
 		goto nla_put_failure;
 
-	if (reset) {
-		atomic64_sub(consumed, priv->consumed);
+	if (reset)
 		clear_bit(NFT_QUOTA_DEPLETED_BIT, &priv->flags);
-	}
+
 	return 0;
 
 nla_put_failure:
-- 
2.47.3

