Received: from wilbur.contactoffice.com (wilbur.contactoffice.com [212.3.242.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07491E2614
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Jan 2026 01:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.3.242.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769738185; cv=none; b=LVme9TPIdVY1EXln9/cSlBtAyUjmbmuu9bvhwnriMUzDYmsBdJWGQATeTOIyHR37wreTdMmXKFYcV3mjo8SGCmKcV5JMQw/D6I4B74cLJt3VHfoNGb7n/KgvFZWs+SfYkfc24B4HONwx5x7c84/EkpTtDVvxWlZZff3FWdXPIvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769738185; c=relaxed/simple;
	bh=YN/oEn1B7daHwvFaaKiihJisoXy1lWbJmIj82w4TXWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ln0HUvIEea7I3qeAMp1IhImvekKs+A5jJg7e4GHNX6jBDtFM94s6iqN8BP2W2weLWcU5d19ZgxneKO8bOt7+mCMHVISqmdrp9zFyd/SGJoMdccqtdOU9SLQeky/c6tXjiDPON29G8iz/fPyxeKuwSeX8Ow32eIJ9T6gkp5QpS5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailfence.com; spf=pass smtp.mailfrom=mailfence.com; dkim=pass (2048-bit key) header.d=mailfence.com header.i=brianwitte@mailfence.com header.b=Y//Ewm6w; arc=none smtp.client-ip=212.3.242.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailfence.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailfence.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailfence.com header.i=brianwitte@mailfence.com header.b="Y//Ewm6w"
Received: from smtpauth2.co-bxl (smtpauth2.co-bxl [10.2.0.24])
	by wilbur.contactoffice.com (Postfix) with ESMTP id DFD7F2907;
	Fri, 30 Jan 2026 02:56:21 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1769738181;
	s=20240605-akrp; d=mailfence.com; i=brianwitte@mailfence.com;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=OSBZyxb7hLWqCtiJmhOlwCkr5tGRv0AeADqSwMS1s8M=;
	b=Y//Ewm6w8R59v3MRwlBWSwzAw0ZN62JSOQmjRlJ8JrSBrrnj75dOW8vJuut5ryqN
	D0dzHDsFCPHTgmmMm0xEWtCpFNLDgZi1BBi/PYM3yhnuXYMUrABuaOA6vabCGH1vK8r
	FqEKsV35CfWgC8OEPVZbZGOJAmwGLHzt17f9QDAt8TVsvTg7n2hxCPKkezHAoZTB8Ae
	WXBG7yB+mkwdgb++D5cKTpGUmD/bpObSPzJRs7t+rFQQ8ZcoE13Mkaws98tmm+QYb+I
	NYhOa6siTL1ytn14NNCcUo60fbz8KFXuk323vk/fZKmKAsIIcXFsmt3U3VJPe9qe5jP
	4n+oRF7+IQ==
Received: by smtp.mailfence.com with ESMTPSA ; Fri, 30 Jan 2026 02:56:20 +0100 (CET)
From: Brian Witte <brianwitte@mailfence.com>
To: fw@strlen.de
Cc: kadlec@blackhole.kfki.hu,
	netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
Subject: Re: [PATCH nf-next] netfilter: nf_tables: use dedicated mutex for reset operations
Date: Thu, 29 Jan 2026 19:56:17 -0600
Message-ID: <20260130015617.42025-1-brianwitte@mailfence.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <aXlTpuk0Z1CeoYwT@strlen.de>
References: <aXlTpuk0Z1CeoYwT@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ContactOffice-Account: com:441463380

Florian Westphal <fw@strlen.de> wrote:
> Maybe its worth investigating if we should instead protect
> only the reset action itself, i.e. add private reset spinlocks
> in nft_quota_do_dump() et al?

Thanks for the suggestion. Implemented per-object spinlocks as proposed.
Sending inline rather than v2 since I'm not certain about the approach.

Ran tests/shell/run-tests.sh with PROVE_LOCKING, PROVE_RCU, and
PROVE_RCU_LIST enabled - no warnings.

Uses static lock class keys to avoid lockdep exhaustion with many objects.

Two questions:

1. Should this be spin_lock_bh()? I think plain spin_lock() is fine
   since the packet path doesn't take this lock.

2. The nf_tables_api.c changes also remove the try_module_get/module_put
   and rcu_read_unlock/rcu_read_lock dance - that was only needed because
   mutex_lock can sleep and we couldn't hold RCU across it. Since
   spin_lock doesn't sleep, we stay under RCU the entire time. Please
   confirm this is correct.

---
 net/netfilter/nf_tables_api.c | 60 ++---------------------------------
 net/netfilter/nft_counter.c   | 18 ++++++++++-
 net/netfilter/nft_quota.c     | 29 ++++++++++++++---
 3 files changed, 45 insertions(+), 62 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index be4924aeaf0e..11f2e467081e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3904,18 +3904,7 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
 static int nf_tables_dumpreset_rules(struct sk_buff *skb,
 				    struct netlink_callback *cb)
 {
-	struct nftables_pernet *nft_net = nft_pernet(sock_net(skb->sk));
-	int ret;
-
-	/* Mutex is held is to prevent that two concurrent dump-and-reset calls
-	* do not underrun counters and quotas. The commit_mutex is used for
-	* the lack a better lock, this is not transaction path.
-	*/
-	mutex_lock(&nft_net->commit_mutex);
-	ret = nf_tables_dump_rules(skb, cb);
-	mutex_unlock(&nft_net->commit_mutex);
-
-	return ret;
+	return nf_tables_dump_rules(skb, cb);
 }

 static int nf_tables_dump_rules_start(struct netlink_callback *cb)
@@ -4036,7 +4025,6 @@ static int nf_tables_getrule_reset(struct sk_buff *skb,
 				  const struct nfnl_info *info,
 				  const struct nlattr * const nla[])
 {
-	struct nftables_pernet *nft_net = nft_pernet(info->net);
 	u32 portid = NETLINK_CB(skb).portid;
 	struct net *net = info->net;
 	struct sk_buff *skb2;
@@ -4054,15 +4042,7 @@ static int nf_tables_getrule_reset(struct sk_buff *skb,
 		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
 	}

-	if (!try_module_get(THIS_MODULE))
-		return -EINVAL;
-	rcu_read_unlock();
-	mutex_lock(&nft_net->commit_mutex);
 	skb2 = nf_tables_getrule_single(portid, info, nla, true);
-	mutex_unlock(&nft_net->commit_mutex);
-	rcu_read_lock();
-	module_put(THIS_MODULE);
-
 	if (IS_ERR(skb2))
 		return PTR_ERR(skb2);

@@ -6342,20 +6322,15 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 static int nf_tables_dumpreset_set(struct sk_buff *skb,
 				  struct netlink_callback *cb)
 {
-	struct nftables_pernet *nft_net = nft_pernet(sock_net(skb->sk));
 	struct nft_set_dump_ctx *dump_ctx = cb->data;
 	int ret, skip = cb->args[0];

-	mutex_lock(&nft_net->commit_mutex);
-
 	ret = nf_tables_dump_set(skb, cb);

 	if (cb->args[0] > skip)
 		audit_log_nft_set_reset(dump_ctx->ctx.table, cb->seq,
 					cb->args[0] - skip);

-	mutex_unlock(&nft_net->commit_mutex);
-
 	return ret;
 }

@@ -6643,7 +6618,6 @@ static int nf_tables_getsetelem_reset(struct sk_buff *skb,
 				     const struct nfnl_info *info,
 				     const struct nlattr * const nla[])
 {
-	struct nftables_pernet *nft_net = nft_pernet(info->net);
 	struct netlink_ext_ack *extack = info->extack;
 	struct nft_set_dump_ctx dump_ctx;
 	int rem, err = 0, nelems = 0;
@@ -6668,15 +6642,9 @@ static int nf_tables_getsetelem_reset(struct sk_buff *skb,
 	if (!nla[NFTA_SET_ELEM_LIST_ELEMENTS])
 		return -EINVAL;

-	if (!try_module_get(THIS_MODULE))
-		return -EINVAL;
-	rcu_read_unlock();
-	mutex_lock(&nft_net->commit_mutex);
-	rcu_read_lock();
-
 	err = nft_set_dump_ctx_init(&dump_ctx, skb, info, nla, true);
 	if (err)
-		goto out_unlock;
+		return err;

 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
 		err = nft_get_set_elem(&dump_ctx.ctx, dump_ctx.set, attr, true);
@@ -6688,12 +6656,6 @@ static int nf_tables_getsetelem_reset(struct sk_buff *skb,
 	}
 	audit_log_nft_set_reset(dump_ctx.ctx.table, nft_base_seq(info->net), nelems);

-out_unlock:
-	rcu_read_unlock();
-	mutex_unlock(&nft_net->commit_mutex);
-	rcu_read_lock();
-	module_put(THIS_MODULE);
-
 	return err;
 }

@@ -8549,14 +8511,7 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 static int nf_tables_dumpreset_obj(struct sk_buff *skb,
 				  struct netlink_callback *cb)
 {
-	struct nftables_pernet *nft_net = nft_pernet(sock_net(skb->sk));
-	int ret;
-
-	mutex_lock(&nft_net->commit_mutex);
-	ret = nf_tables_dump_obj(skb, cb);
-	mutex_unlock(&nft_net->commit_mutex);
-
-	return ret;
+	return nf_tables_dump_obj(skb, cb);
 }

 static int nf_tables_dump_obj_start(struct netlink_callback *cb)
@@ -8672,7 +8627,6 @@ static int nf_tables_getobj_reset(struct sk_buff *skb,
 				 const struct nfnl_info *info,
 				 const struct nlattr * const nla[])
 {
-	struct nftables_pernet *nft_net = nft_pernet(info->net);
 	u32 portid = NETLINK_CB(skb).portid;
 	struct net *net = info->net;
 	struct sk_buff *skb2;
@@ -8690,15 +8644,7 @@ static int nf_tables_getobj_reset(struct sk_buff *skb,
 		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
 	}

-	if (!try_module_get(THIS_MODULE))
-		return -EINVAL;
-	rcu_read_unlock();
-	mutex_lock(&nft_net->commit_mutex);
 	skb2 = nf_tables_getobj_single(portid, info, nla, true);
-	mutex_unlock(&nft_net->commit_mutex);
-	rcu_read_lock();
-	module_put(THIS_MODULE);
-
 	if (IS_ERR(skb2))
 		return PTR_ERR(skb2);

diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index cc7325329496..ae3c339cbcee 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -28,10 +28,13 @@ struct nft_counter_tot {

 struct nft_counter_percpu_priv {
 	struct nft_counter __percpu *counter;
+	spinlock_t	reset_lock;	/* protects concurrent reset */
 };

 static DEFINE_PER_CPU(struct u64_stats_sync, nft_counter_sync);

+static struct lock_class_key nft_counter_reset_key;
+
 static inline void nft_counter_do_eval(struct nft_counter_percpu_priv *priv,
 				      struct nft_regs *regs,
 				      const struct nft_pktinfo *pkt)
@@ -81,6 +84,9 @@ static int nft_counter_do_init(const struct nlattr * const tb[],
 	}

 	priv->counter = cpu_stats;
+	spin_lock_init(&priv->reset_lock);
+	lockdep_set_class(&priv->reset_lock, &nft_counter_reset_key);
+
 	return 0;
 }

@@ -154,6 +160,9 @@ static int nft_counter_do_dump(struct sk_buff *skb,
 {
 	struct nft_counter_tot total;

+	if (reset)
+		spin_lock(&priv->reset_lock);
+
 	nft_counter_fetch(priv, &total);

 	if (nla_put_be64(skb, NFTA_COUNTER_BYTES, cpu_to_be64(total.bytes),
@@ -162,12 +171,16 @@ static int nft_counter_do_dump(struct sk_buff *skb,
 			NFTA_COUNTER_PAD))
 		goto nla_put_failure;

-	if (reset)
+	if (reset) {
 		nft_counter_reset(priv, &total);
+		spin_unlock(&priv->reset_lock);
+	}

 	return 0;

 nla_put_failure:
+	if (reset)
+		spin_unlock(&priv->reset_lock);
 	return -1;
 }

@@ -254,6 +267,9 @@ static int nft_counter_clone(struct nft_expr *dst, const struct nft_expr *src, g
 	u64_stats_set(&this_cpu->bytes, total.bytes);

 	priv_clone->counter = cpu_stats;
+	spin_lock_init(&priv_clone->reset_lock);
+	lockdep_set_class(&priv_clone->reset_lock, &nft_counter_reset_key);
+
 	return 0;
 }

diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index df0798da2329..a66e06cdb3a9 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -16,8 +16,11 @@ struct nft_quota {
 	atomic64_t	quota;
 	unsigned long	flags;
 	atomic64_t	*consumed;
+	spinlock_t	reset_lock;	/* protects concurrent reset */
 };

+static struct lock_class_key nft_quota_reset_key;
+
 static inline bool nft_overquota(struct nft_quota *priv,
 				const struct sk_buff *skb,
 				bool *report)
@@ -103,6 +106,8 @@ static int nft_quota_do_init(const struct nlattr * const tb[],
 	atomic64_set(&priv->quota, quota);
 	priv->flags = flags;
 	atomic64_set(priv->consumed, consumed);
+	spin_lock_init(&priv->reset_lock);
+	lockdep_set_class(&priv->reset_lock, &nft_quota_reset_key);

 	return 0;
 }
@@ -134,13 +139,24 @@ static void nft_quota_obj_update(struct nft_object *obj,
 	priv->flags = newpriv->flags;
 }

+static void nft_quota_reset(struct nft_quota *priv, u64 consumed)
+{
+	atomic64_sub(consumed, priv->consumed);
+	clear_bit(NFT_QUOTA_DEPLETED_BIT, &priv->flags);
+}
+
 static int nft_quota_do_dump(struct sk_buff *skb, struct nft_quota *priv,
 			    bool reset)
 {
 	u64 consumed, consumed_cap, quota;
-	u32 flags = priv->flags;
+	u32 flags;
+
+	if (reset)
+		spin_lock(&priv->reset_lock);
+
+	flags = priv->flags;

-	/* Since we inconditionally increment consumed quota for each packet
+	/* Since we unconditionally increment consumed quota for each packet
 	* that we see, don't go over the quota boundary in what we send to
 	* userspace.
 	*/
@@ -161,12 +177,15 @@ static int nft_quota_do_dump(struct sk_buff *skb, struct nft_quota *priv,
 		goto nla_put_failure;

 	if (reset) {
-		atomic64_sub(consumed, priv->consumed);
-		clear_bit(NFT_QUOTA_DEPLETED_BIT, &priv->flags);
+		nft_quota_reset(priv, consumed);
+		spin_unlock(&priv->reset_lock);
 	}
+
 	return 0;

 nla_put_failure:
+	if (reset)
+		spin_unlock(&priv->reset_lock);
 	return -1;
 }

@@ -252,6 +271,8 @@ static int nft_quota_clone(struct nft_expr *dst, const struct nft_expr *src, gfp
 		return -ENOMEM;

 	*priv_dst->consumed = *priv_src->consumed;
+	spin_lock_init(&priv_dst->reset_lock);
+	lockdep_set_class(&priv_dst->reset_lock, &nft_quota_reset_key);

 	return 0;
 }
--
2.47.3
