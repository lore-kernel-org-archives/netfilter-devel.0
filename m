Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6353CC7CE
	for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2026 16:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779813659; cv=none; b=Gidkgcogm4Wg2bmInWcgluxgPIsBjhc2nGwaUwYqKdh7AKL5w8fTJmkspH/jSQMWVs6QMMNQub2lSjLKnwK7HZFIk9hVK9Y3UrmGMQ1nvJXGXKfEa3OnnT0HIhifrI2xi7sQuX5pM8hAxBa4qx8AB+m488QbKTftQ6qi+to9Enk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779813659; c=relaxed/simple;
	bh=jcQDjlmGuxK23MXePeNHk1a0W+hw1kR284qs6eX0CY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=edyICjWwfYAzq6gJCQmF9Jm1YgV03GhWtgEa9Y7CF8SHCDyh9CP0yb6m2iFGQfg77CtB0mLXtyLo3lLc+Jxn/wAFcdZjHGXBGXJGx6opYjLgTfHVchNhIWZ+/1eCMzNoGphXllrtkzq6041h8fK9659EpTyWBJ+tWsojw/X3/K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Sk+arArj; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Sk+arArj"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 66C266055C;
	Tue, 26 May 2026 18:40:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1779813654;
	bh=9aDuVbQ5tzz9JgSkgFR5zCSgCK829JiUaW3Kyuumrgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sk+arArjEQ7R8bzIj8FgcAdFvktnBrXkUlzgDFBb1O6Fvd7QOq/mVJrj0Qmc6FGTb
	 Jh21caud/4zhTdntMl/ftzA6BZVVaFdBUbol8EmAVyBByKsVi7AU6Rpf3ly2smXkFe
	 hklIEHY9H3CJSNBPiT20LZvDDiwg60EM9kca03lZdGqBPIckI8WuI6Bwpl5UPgqblg
	 GyD+pdVS70h1i0husexy/uXc2HfO7Hsd7h/og24JdmV9FsBUZp1qTigB6NZr97QFmT
	 MeG2jaSUyJkMv7IplaA5jjVCjkzwu4kYJK4TssnYL3Z75e9bPpC6SXZc4vS88Tw3OW
	 AeuEd/ORtVNWA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf-next 2/6] netfilter: cttimeout: detach dataplane timeout policy and add refcount
Date: Tue, 26 May 2026 18:40:45 +0200
Message-ID: <20260526164049.148218-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260526164049.148218-1-pablo@netfilter.org>
References: <20260526164049.148218-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a refcount for struct nf_ct_timeout which is used by ct extension to
set the custom ct timeout policy, this tells us the ct timeout is being
used by a conntrack entry.

There is already a refcount for control plane which controls if the
ruleset refers to the timeout policy. This patch still allows users to
remove the ct timeout policy from control plane if it has no more users
in the ruleset, but the ct timeout object remains in memory if it has
conntrack entries that still use them. When the last conntrack entry
drops the refcount on the ct timeout, the ct timeout is released.

The inner nf_ct_timeout holds an initial reference on behalf of the
ctnl_timeout wrapper; per-conntrack references are taken on top of that via
nf_ct_timeout_ext_add().

Remove nf_queue_nf_hook_drop(): a packet sitting in nfqueue will just
hold a reference to the nf_ct_timeout object until packet is reinjected,
since this is part of the ct extension, this will be released by the
time the conntrack is freed.

nf_ct_untimeout() is still called to clean up in a best effort basis:
the ct timeout on existing entries gets remove when the ct timeout goes
away, but racing new unconfirmed conntrack entries could still attach
it, postponing release after that user of it is gone.

Fixes: 50978462300f ("netfilter: add cttimeout infrastructure for fine timeout tuning")
Fixes: 7e0b2b57f01d ("netfilter: nft_ct: add ct timeout support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack.h         |  2 +
 include/net/netfilter/nf_conntrack_timeout.h | 21 ++++++
 net/netfilter/nf_conntrack_core.c            | 11 +--
 net/netfilter/nf_conntrack_timeout.c         | 20 +++++-
 net/netfilter/nfnetlink_cttimeout.c          | 74 ++++++++++++--------
 net/netfilter/nft_ct.c                       |  5 +-
 net/netfilter/xt_CT.c                        |  2 +-
 7 files changed, 94 insertions(+), 41 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index bc42dd0e10e6..f75af8eb1cae 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -239,6 +239,8 @@ struct nf_ct_iter_data {
 };
 
 /* Iterate over all conntracks: if iter returns true, it's deleted. */
+void nf_ct_iterate_cleanup(int (*iter)(struct nf_conn *i, void *data),
+			   const struct nf_ct_iter_data *iter_data);
 void nf_ct_iterate_cleanup_net(int (*iter)(struct nf_conn *i, void *data),
 			       const struct nf_ct_iter_data *iter_data);
 
diff --git a/include/net/netfilter/nf_conntrack_timeout.h b/include/net/netfilter/nf_conntrack_timeout.h
index 3a66d4abb6d6..7659e8a1abd9 100644
--- a/include/net/netfilter/nf_conntrack_timeout.h
+++ b/include/net/netfilter/nf_conntrack_timeout.h
@@ -12,6 +12,8 @@
 #define CTNL_TIMEOUT_NAME_MAX	32
 
 struct nf_ct_timeout {
+	refcount_t		refcnt;
+	struct ctnl_timeout	*ctnl;	/* for nfnetlink_cttimeout. */
 	__u16			l3num;
 	const struct nf_conntrack_l4proto *l4proto;
 	struct rcu_head		rcu;
@@ -22,6 +24,22 @@ struct nf_conn_timeout {
 	struct nf_ct_timeout __rcu *timeout;
 };
 
+static inline void nf_ct_timeout_put(const struct nf_conn *ct)
+{
+#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
+	struct nf_conn_timeout *timeout_ext;
+	struct nf_ct_timeout *timeout;
+
+	timeout_ext = nf_ct_ext_find(ct, NF_CT_EXT_TIMEOUT);
+	if (!timeout_ext)
+		return;
+
+	timeout = rcu_dereference(timeout_ext->timeout);
+	if (likely(timeout) && refcount_dec_and_test(&timeout->refcnt))
+		kfree_rcu(timeout, rcu);
+#endif
+}
+
 static inline unsigned int *
 nf_ct_timeout_data(const struct nf_conn_timeout *t)
 {
@@ -60,6 +78,9 @@ struct nf_conn_timeout *nf_ct_timeout_ext_add(struct nf_conn *ct,
 	if (timeout_ext == NULL)
 		return NULL;
 
+	if (!refcount_inc_not_zero(&timeout->refcnt))
+		return NULL;
+
 	rcu_assign_pointer(timeout_ext->timeout, timeout);
 
 	return timeout_ext;
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 60973ba58820..63159c070c3a 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1730,16 +1730,18 @@ void nf_conntrack_free(struct nf_conn *ct)
 	 */
 	WARN_ON(refcount_read(&ct->ct_general.use) != 0);
 
+	rcu_read_lock();
 	if (ct->status & IPS_SRC_NAT_DONE) {
 		const struct nf_nat_hook *nat_hook;
 
-		rcu_read_lock();
 		nat_hook = rcu_dereference(nf_nat_hook);
 		if (nat_hook)
 			nat_hook->remove_nat_bysrc(ct);
-		rcu_read_unlock();
 	}
 
+	nf_ct_timeout_put(ct);
+	rcu_read_unlock();
+
 	kfree(ct->ext);
 	kmem_cache_free(nf_conntrack_cachep, ct);
 	cnet = nf_ct_pernet(net);
@@ -2356,8 +2358,8 @@ get_next_corpse(int (*iter)(struct nf_conn *i, void *data),
 	return ct;
 }
 
-static void nf_ct_iterate_cleanup(int (*iter)(struct nf_conn *i, void *data),
-				  const struct nf_ct_iter_data *iter_data)
+void nf_ct_iterate_cleanup(int (*iter)(struct nf_conn *i, void *data),
+			   const struct nf_ct_iter_data *iter_data)
 {
 	unsigned int bucket = 0;
 	struct nf_conn *ct;
@@ -2374,6 +2376,7 @@ static void nf_ct_iterate_cleanup(int (*iter)(struct nf_conn *i, void *data),
 	}
 	mutex_unlock(&nf_conntrack_mutex);
 }
+EXPORT_SYMBOL_GPL(nf_ct_iterate_cleanup);
 
 void nf_ct_iterate_cleanup_net(int (*iter)(struct nf_conn *i, void *data),
 			       const struct nf_ct_iter_data *iter_data)
diff --git a/net/netfilter/nf_conntrack_timeout.c b/net/netfilter/nf_conntrack_timeout.c
index 0cc584d3dbb1..00281db8e410 100644
--- a/net/netfilter/nf_conntrack_timeout.c
+++ b/net/netfilter/nf_conntrack_timeout.c
@@ -25,17 +25,28 @@
 const struct nf_ct_timeout_hooks __rcu *nf_ct_timeout_hook __read_mostly;
 EXPORT_SYMBOL_GPL(nf_ct_timeout_hook);
 
+/* nf_ct_iterate_cleanup() holds refcount on this conntrack. */
 static int untimeout(struct nf_conn *ct, void *timeout)
 {
 	struct nf_conn_timeout *timeout_ext = nf_ct_timeout_find(ct);
 
 	if (timeout_ext) {
-		const struct nf_ct_timeout *t;
+		struct nf_ct_timeout *t;
 
 		t = rcu_access_pointer(timeout_ext->timeout);
+		if (!t)
+			return 0;
 
-		if (!timeout || t == timeout)
+		if (!timeout || t == timeout) {
 			RCU_INIT_POINTER(timeout_ext->timeout, NULL);
+
+			/* No race with nf_conntrack_free() which is called
+			 * only after the conntrack has been removed from
+			 * the hashes.
+			 */
+			if (refcount_dec_and_test(&t->refcnt))
+				kfree_rcu(t, rcu);
+		}
 	}
 
 	/* We are not intended to delete this conntrack. */
@@ -49,7 +60,10 @@ void nf_ct_untimeout(struct net *net, struct nf_ct_timeout *timeout)
 		.data	= timeout,
 	};
 
-	nf_ct_iterate_cleanup_net(untimeout, &iter_data);
+	if (net)
+		nf_ct_iterate_cleanup_net(untimeout, &iter_data);
+	else
+		nf_ct_iterate_cleanup(untimeout, &iter_data);
 }
 EXPORT_SYMBOL_GPL(nf_ct_untimeout);
 
diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index dca6826af7de..8efda53f94eb 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -39,9 +39,7 @@ struct ctnl_timeout {
 	struct rcu_head		rcu_head;
 	refcount_t		refcnt;
 	char			name[CTNL_TIMEOUT_NAME_MAX];
-
-	/* must be at the end */
-	struct nf_ct_timeout	timeout;
+	struct nf_ct_timeout	*timeout;
 };
 
 struct nfct_timeout_pernet {
@@ -132,12 +130,12 @@ static int cttimeout_new_timeout(struct sk_buff *skb,
 			/* You cannot replace one timeout policy by another of
 			 * different kind, sorry.
 			 */
-			if (matching->timeout.l3num != l3num ||
-			    matching->timeout.l4proto->l4proto != l4num)
+			if (matching->timeout->l3num != l3num ||
+			    matching->timeout->l4proto->l4proto != l4num)
 				return -EINVAL;
 
-			return ctnl_timeout_parse_policy(&matching->timeout.data,
-							 matching->timeout.l4proto,
+			return ctnl_timeout_parse_policy(&matching->timeout->data,
+							 matching->timeout->l4proto,
 							 info->net,
 							 cda[CTA_TIMEOUT_DATA]);
 		}
@@ -153,26 +151,37 @@ static int cttimeout_new_timeout(struct sk_buff *skb,
 		goto err_proto_put;
 	}
 
-	timeout = kzalloc(sizeof(struct ctnl_timeout) +
-			  l4proto->ctnl_timeout.obj_size, GFP_KERNEL);
+	timeout = kzalloc(sizeof(*timeout), GFP_KERNEL);
 	if (timeout == NULL) {
 		ret = -ENOMEM;
 		goto err_proto_put;
 	}
 
-	ret = ctnl_timeout_parse_policy(&timeout->timeout.data, l4proto,
+	timeout->timeout = kzalloc(sizeof(*timeout->timeout) +
+				   l4proto->ctnl_timeout.obj_size, GFP_KERNEL);
+	if (!timeout->timeout) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	ret = ctnl_timeout_parse_policy(&timeout->timeout->data, l4proto,
 					info->net, cda[CTA_TIMEOUT_DATA]);
 	if (ret < 0)
-		goto err;
+		goto err_parse_timeout_policy;
 
 	strcpy(timeout->name, nla_data(cda[CTA_TIMEOUT_NAME]));
-	timeout->timeout.l3num = l3num;
-	timeout->timeout.l4proto = l4proto;
 	refcount_set(&timeout->refcnt, 1);
+	timeout->timeout->ctnl = timeout;
+	timeout->timeout->l3num = l3num;
+	timeout->timeout->l4proto = l4proto;
+	refcount_set(&timeout->timeout->refcnt, 1);
 	__module_get(THIS_MODULE);
 	list_add_tail_rcu(&timeout->head, &pernet->nfct_timeout_list);
 
 	return 0;
+
+err_parse_timeout_policy:
+	kfree(timeout->timeout);
 err:
 	kfree(timeout);
 err_proto_put:
@@ -185,7 +194,7 @@ ctnl_timeout_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 {
 	struct nlmsghdr *nlh;
 	unsigned int flags = portid ? NLM_F_MULTI : 0;
-	const struct nf_conntrack_l4proto *l4proto = timeout->timeout.l4proto;
+	const struct nf_conntrack_l4proto *l4proto = timeout->timeout->l4proto;
 	struct nlattr *nest_parms;
 	int ret;
 
@@ -197,7 +206,7 @@ ctnl_timeout_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 
 	if (nla_put_string(skb, CTA_TIMEOUT_NAME, timeout->name) ||
 	    nla_put_be16(skb, CTA_TIMEOUT_L3PROTO,
-			 htons(timeout->timeout.l3num)) ||
+			 htons(timeout->timeout->l3num)) ||
 	    nla_put_u8(skb, CTA_TIMEOUT_L4PROTO, l4proto->l4proto) ||
 	    nla_put_be32(skb, CTA_TIMEOUT_USE,
 			 htonl(refcount_read(&timeout->refcnt))))
@@ -207,7 +216,7 @@ ctnl_timeout_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 	if (!nest_parms)
 		goto nla_put_failure;
 
-	ret = l4proto->ctnl_timeout.obj_to_nlattr(skb, &timeout->timeout.data);
+	ret = l4proto->ctnl_timeout.obj_to_nlattr(skb, &timeout->timeout->data);
 	if (ret < 0)
 		goto nla_put_failure;
 
@@ -316,9 +325,20 @@ static int ctnl_timeout_try_del(struct net *net, struct ctnl_timeout *timeout)
 	 * current refcnt is 1, we decrease it to 0.
 	 */
 	if (refcount_dec_if_one(&timeout->refcnt)) {
+		/* ->timeout_put is called by template conntrack in xt_CT and
+		 * OVS to drop the reference on this timeout policy. This can
+		 * only be 1 if this timeout policy unused. It is safe to
+		 * reset this ->ctnl indirection here because it has no users.
+		 */
+		WRITE_ONCE(timeout->timeout->ctnl, NULL);
+
 		/* We are protected by nfnl mutex. */
 		list_del_rcu(&timeout->head);
-		nf_ct_untimeout(net, &timeout->timeout);
+		nf_ct_untimeout(net, timeout->timeout);
+
+		if (refcount_dec_and_test(&timeout->timeout->refcnt))
+			kfree_rcu(timeout->timeout, rcu);
+
 		kfree_rcu(timeout, rcu_head);
 	} else {
 		ret = -EBUSY;
@@ -517,13 +537,15 @@ static struct nf_ct_timeout *ctnl_timeout_find_get(struct net *net,
 		break;
 	}
 err:
-	return matching ? &matching->timeout : NULL;
+	return matching ? matching->timeout : NULL;
 }
 
 static void ctnl_timeout_put(struct nf_ct_timeout *t)
 {
-	struct ctnl_timeout *timeout =
-		container_of(t, struct ctnl_timeout, timeout);
+	struct ctnl_timeout *timeout = READ_ONCE(t->ctnl);
+
+	if (!timeout)
+		return;
 
 	if (refcount_dec_and_test(&timeout->refcnt)) {
 		kfree_rcu(timeout, rcu_head);
@@ -649,16 +671,6 @@ static int __init cttimeout_init(void)
 	return ret;
 }
 
-static int untimeout(struct nf_conn *ct, void *timeout)
-{
-	struct nf_conn_timeout *timeout_ext = nf_ct_timeout_find(ct);
-
-	if (timeout_ext)
-		RCU_INIT_POINTER(timeout_ext->timeout, NULL);
-
-	return 0;
-}
-
 static void __exit cttimeout_exit(void)
 {
 	nfnetlink_subsys_unregister(&cttimeout_subsys);
@@ -666,7 +678,7 @@ static void __exit cttimeout_exit(void)
 	unregister_pernet_subsys(&cttimeout_ops);
 	RCU_INIT_POINTER(nf_ct_timeout_hook, NULL);
 
-	nf_ct_iterate_destroy(untimeout, NULL);
+	nf_ct_untimeout(NULL, NULL);
 }
 
 module_init(cttimeout_init);
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index fa2cc556331c..85e3d68dfb59 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -951,6 +951,7 @@ static int nft_ct_timeout_obj_init(const struct nft_ctx *ctx,
 
 	timeout->l3num = l3num;
 	timeout->l4proto = l4proto;
+	refcount_set(&timeout->refcnt, 1);
 
 	ret = nf_ct_netns_get(ctx->net, ctx->family);
 	if (ret < 0)
@@ -971,10 +972,10 @@ static void nft_ct_timeout_obj_destroy(const struct nft_ctx *ctx,
 	struct nft_ct_timeout_obj *priv = nft_obj_data(obj);
 	struct nf_ct_timeout *timeout = priv->timeout;
 
-	nf_queue_nf_hook_drop(ctx->net);
 	nf_ct_untimeout(ctx->net, timeout);
 	nf_ct_netns_put(ctx->net, ctx->family);
-	kfree_rcu(priv->timeout, rcu);
+	if (refcount_dec_and_test(&timeout->refcnt))
+		kfree_rcu(priv->timeout, rcu);
 }
 
 static int nft_ct_timeout_obj_dump(struct sk_buff *skb,
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index d2aeacf94230..b94f004d5f5c 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -284,7 +284,7 @@ static void xt_ct_tg_destroy(const struct xt_tgdtor_param *par,
 	struct nf_conn_help *help;
 
 	if (ct) {
-		if (info->helper[0] || info->timeout[0])
+		if (info->helper[0])
 			nf_queue_nf_hook_drop(par->net);
 
 		help = nfct_help(ct);
-- 
2.47.3

