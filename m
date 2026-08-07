Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECAD471D17
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Aug 2026 12:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786104848; cv=none; b=G3PQyW0k+7pxwGDhJBDDanacN7WCDmtvw7snWz2MMQSEEmiL83jLGc0eQmEcTNzU1JswxghpLGVpdvkp5zXuRAMo9Ymej23JLXIsstG3LzA4KNMMbIykJG5xzh0VU9Z4nRBJyCxHiv4gCZ6B1gSRO+n/+I4s65rfSsH04u3RKt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786104848; c=relaxed/simple;
	bh=xD/U/aRKtdQYKWzoVZJRpp9PKxApJqwJ7pTKUr6Qu3E=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WNx07LuKHnlMQgV5Y4y5hCsmIwP4QJcxYJ32HYId/0+i9Bfrho6WrqaeXXr2TIEp8iM7JlB4OexySKJwa2VupOB8sbi/w+Yonrv4zaGL3ndJgqDwwNmin8CbvX665IfJFS69XhZO6mF7VuOXFlEvdT2Zv7BV7X+5eyrfW0BV4L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=mkdksxpT; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="mkdksxpT"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C69F8601A6
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Aug 2026 14:13:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786104814;
	bh=/pNR+RSEPZV1715TOscmGRsYOQoXRZLvTfSJ1Tf4gX4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=mkdksxpT7nFR+nqYeMNNDfD+sTdlxqRrqEbPAhc97LRXUbjFiqrdy+/BmgkjOR+tj
	 6Ef1cQ8H+QkjR7aYphhq8fblkmnMK/jWeWfHN5q5fuMhGYSpcKi35qPrIjByAzNgTj
	 9qGymz6MuXAA7dy0aFivSCI+9XXLb5FAaeA8z9O6rAfHK440Segzz+P5iPQAUnsaGO
	 fXUDZgcjyNSGImVUDqtu4+7QvJDzJq29ntlev7R9lErKfz1MfBYRfDYcibqR/e956j
	 peZNDbr4Ztjbb6sAxKZmIXYj5tvNmNomHBaogfGgteObcLxgN0X4XiCw3yNT7NK0sV
	 Pq6sf7pRom+1Q==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v3 2/2] netfilter: nft_ct: move custom expectation support to helper
Date: Fri,  7 Aug 2026 14:13:27 +0200
Message-ID: <20260807121327.597152-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260807121327.597152-1-pablo@netfilter.org>
References: <20260807121327.597152-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Originally, the ct expectation support called nf_ct_helper_ext_add() for
confirmed conntracks, which is invalid, triggering a splat. This was
fixed by commit 1710eb913bdc ("netfilter: nft_ct: skip expectations for
confirmed conntrack") which restricted it to unconfirmed conntracks.

However, early insertion of expectations into the expectations list when
the conntrack is unconfirmed leads to stale entries pointing to the
wrong hlist_head through .pprev due to ct extension reallocation.

Commit 7c9664351980 ("netfilter: move nat hlist_head to nf_conn") moved
the nat hlist_head to nf_conn for this reason:

     1. ...
     2. When reallocation of extension area occurs we need to fixup the
        bysource hash head via hlist_replace_rcu.

I'd rather not increase the size of the struct nf_conn for this feature
has very limited scope: only one expectation can be created at a time
given expect_clash() will make nf_ct_expect_related() reports EBUSY.
For this reason, relax nf_ct_expect_related() not to drop packets in
case expectation creation fails, therefore, expectation creation becomes
best effort. Now the size determines the maximum number of expectations
that can be created for this connection, one after another, given the
expect_clash() limitations.

To address this issue, add an internal ct helper and attach it to the
conntrack entry to streamline the custom ct expectation support with
existing ct helpers.

Expose a new nf_conntrack_helper_free() function to release the internal
helper that is allocated and attached to the conntrack entry to create
the custom expectations.

This patch also restricts the creation of expectations to different
helpers other than this custom helper that is created for this type of
expectations.

Fixes: 857b46027d6f ("netfilter: nft_ct: add ct expectations support")
Reported-by: Jaeyeong Lee <iostreampy@proton.me>
Link: https://patch.msgid.link/20260715144755.00ea7dfcd9f@proton.me
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: - regard nf_ct_l3num() as reported by sashiko
    - do not drop packets if expectation creation fails
    - nullify helper pointer copied to expect_data
    - set a cap to priv->size (even though it is futile, because expectation will clash
      only one expectation can stay around)

 include/net/netfilter/nf_conntrack_helper.h |   2 +
 net/netfilter/nf_conntrack_helper.c         |  18 ++-
 net/netfilter/nft_ct.c                      | 140 +++++++++++++++-----
 3 files changed, 122 insertions(+), 38 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index bc5427d239f4..2cb66067a7c2 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -112,6 +112,8 @@ int nf_conntrack_helpers_register(struct nf_conntrack_helper *, unsigned int,
 void nf_conntrack_helpers_unregister(struct nf_conntrack_helper **,
 				     unsigned int);
 
+void nf_conntrack_helper_release(struct nf_conntrack_helper *me);
+
 #define nf_conntrack_helper_deprecated(name) \
 	pr_warn("The %s conntrack helper is scheduled for removal.\n"	\
 		"Please contact the netfilter-devel mailing list if you still need this.\n", name)
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 5cafb133ba0c..61ad3193d8be 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -448,13 +448,8 @@ static bool expect_iter_me(struct nf_conntrack_expect *exp, void *data)
 	return this == me;
 }
 
-void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
+void nf_conntrack_helper_release(struct nf_conntrack_helper *me)
 {
-	mutex_lock(&nf_ct_helper_mutex);
-	hlist_del_rcu(&me->hnode);
-	nf_ct_helper_count--;
-	mutex_unlock(&nf_ct_helper_mutex);
-
 	/* This helper is going away, disable it. */
 	rcu_assign_pointer(me->help, NULL);
 
@@ -466,6 +461,17 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
 	if (refcount_dec_and_test(&me->ct_refcnt))
 		kfree_rcu(me, rcu);
 }
+EXPORT_SYMBOL_GPL(nf_conntrack_helper_release);
+
+void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
+{
+	mutex_lock(&nf_ct_helper_mutex);
+	hlist_del_rcu(&me->hnode);
+	nf_ct_helper_count--;
+	mutex_unlock(&nf_ct_helper_mutex);
+
+	nf_conntrack_helper_release(me);
+}
 EXPORT_SYMBOL_GPL(nf_conntrack_helper_unregister);
 
 void nf_ct_helper_init(struct nf_conntrack_helper *helper,
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 358b9287e12e..95a270860d9c 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1213,6 +1213,8 @@ struct nft_ct_expect_obj {
 	u8		l4proto;
 	u8		size;
 	u32		timeout;
+
+	struct nf_conntrack_helper *helper;
 };
 
 static int nft_ct_expect_timeout_get(const struct nlattr *attr, u32 *val)
@@ -1226,6 +1228,80 @@ static int nft_ct_expect_timeout_get(const struct nlattr *attr, u32 *val)
 	return 0;
 }
 
+struct nft_ct_expect_data {
+	struct nft_ct_expect_obj	obj;
+	enum ip_conntrack_dir		dir;
+	atomic_t			num_expects;
+};
+
+static int ct_expect_help(struct sk_buff *skb, unsigned int protoff,
+			  struct nf_conn *ct, enum ip_conntrack_info ctinfo)
+{
+	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
+	struct nft_ct_expect_data *expect_data;
+	struct nf_conntrack_expect *exp;
+	int ret = NF_ACCEPT;
+	u16 l3num;
+
+	expect_data = nfct_help_data(ct);
+	if (!expect_data)
+		return NF_ACCEPT;
+
+	if (expect_data->dir != dir)
+		return NF_ACCEPT;
+
+	if (!atomic_add_unless(&expect_data->num_expects, 1, expect_data->obj.size))
+		return NF_ACCEPT;
+
+	exp = nf_ct_expect_alloc(ct);
+	if (!exp) {
+		atomic_dec(&expect_data->num_expects);
+		return NF_DROP;
+	}
+
+	if (expect_data->obj.l3num == NFPROTO_INET)
+		l3num = nf_ct_l3num(ct);
+	else
+		l3num = expect_data->obj.l3num;
+
+	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, nf_ct_l3num(ct),
+			  &ct->tuplehash[!dir].tuple.src.u3,
+			  &ct->tuplehash[!dir].tuple.dst.u3,
+			  expect_data->obj.l4proto, NULL, &expect_data->obj.dport);
+	exp->timeout += expect_data->obj.timeout;
+
+	if (nf_ct_expect_related(exp, 0) != 0) {
+		atomic_dec(&expect_data->num_expects);
+		ret = NF_ACCEPT;
+	}
+
+	nf_ct_expect_put(exp);
+
+	return ret;
+}
+
+static int nft_ct_expect_helper_alloc(struct nft_ct_expect_obj *priv)
+{
+	struct nf_conntrack_helper *ct_expect_helper;
+
+	ct_expect_helper = kzalloc_obj(struct nf_conntrack_helper,
+				       GFP_KERNEL_ACCOUNT);
+	if (!ct_expect_helper)
+		return -ENOMEM;
+
+	snprintf(ct_expect_helper->name, sizeof(ct_expect_helper->name), "%s",
+		 "nft_ct_expect");
+	ct_expect_helper->me = THIS_MODULE;
+	ct_expect_helper->expect_policy[NF_CT_EXPECT_CLASS_DEFAULT].max_expected = priv->size;
+	rcu_assign_pointer(ct_expect_helper->help, ct_expect_help);
+	refcount_set(&ct_expect_helper->ct_refcnt, 1);
+
+	/* No need to register this helper, this is internal. */
+	priv->helper = ct_expect_helper;
+
+	return 0;
+}
+
 static int nft_ct_expect_obj_init(const struct nft_ctx *ctx,
 				  const struct nlattr * const tb[],
 				  struct nft_object *obj)
@@ -1233,6 +1309,8 @@ static int nft_ct_expect_obj_init(const struct nft_ctx *ctx,
 	struct nft_ct_expect_obj *priv = nft_obj_data(obj);
 	int err;
 
+	NF_CT_HELPER_BUILD_BUG_ON(sizeof(struct nft_ct_expect_data));
+
 	if (!tb[NFTA_CT_EXPECT_L4PROTO] ||
 	    !tb[NFTA_CT_EXPECT_DPORT] ||
 	    !tb[NFTA_CT_EXPECT_TIMEOUT] ||
@@ -1272,14 +1350,29 @@ static int nft_ct_expect_obj_init(const struct nft_ctx *ctx,
 
 	priv->dport = nla_get_be16(tb[NFTA_CT_EXPECT_DPORT]);
 	priv->size = nla_get_u8(tb[NFTA_CT_EXPECT_SIZE]);
+	if (!priv->size)
+		priv->size = NF_CT_EXPECT_MAX_CNT;
+
+	err = nf_ct_netns_get(ctx->net, ctx->family);
+	if (err < 0)
+		return err;
+
+	err = nft_ct_expect_helper_alloc(priv);
+	if (err < 0) {
+		nf_ct_netns_put(ctx->net, ctx->family);
+		return err;
+	}
 
-	return nf_ct_netns_get(ctx->net, ctx->family);
+	return err;
 }
 
 static void nft_ct_expect_obj_destroy(const struct nft_ctx *ctx,
-				       struct nft_object *obj)
+				      struct nft_object *obj)
 {
+	const struct nft_ct_expect_obj *priv = nft_obj_data(obj);
+
 	nf_ct_netns_put(ctx->net, ctx->family);
+	nf_conntrack_helper_release(priv->helper);
 }
 
 static int nft_ct_expect_obj_dump(struct sk_buff *skb,
@@ -1313,11 +1406,9 @@ static void nft_ct_expect_obj_eval(struct nft_object *obj,
 				   const struct nft_pktinfo *pkt)
 {
 	const struct nft_ct_expect_obj *priv = nft_obj_data(obj);
-	struct nf_conntrack_expect *exp;
+	struct nft_ct_expect_data *expect_data;
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn_help *help;
-	enum ip_conntrack_dir dir;
-	u16 l3num = priv->l3num;
 	struct nf_conn *ct;
 
 	ct = nf_ct_get(pkt->skb, &ctinfo);
@@ -1325,45 +1416,30 @@ static void nft_ct_expect_obj_eval(struct nft_object *obj,
 		regs->verdict.code = NFT_BREAK;
 		return;
 	}
-	dir = CTINFO2DIR(ctinfo);
 
 	help = nfct_help(ct);
-	if (!help)
-		help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
-	if (!help) {
-		regs->verdict.code = NF_DROP;
-		return;
-	}
-
-	if (help->expecting[NF_CT_EXPECT_CLASS_DEFAULT] >= priv->size) {
+	if (help) {
 		regs->verdict.code = NFT_BREAK;
 		return;
 	}
-	if (l3num == NFPROTO_INET)
-		l3num = nf_ct_l3num(ct);
 
-	exp = nf_ct_expect_alloc(ct);
-	if (exp == NULL) {
+	help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
+	if (!help) {
 		regs->verdict.code = NF_DROP;
 		return;
 	}
-	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, l3num,
-		          &ct->tuplehash[!dir].tuple.src.u3,
-		          &ct->tuplehash[!dir].tuple.dst.u3,
-		          priv->l4proto, NULL, &priv->dport);
-	exp->timeout += priv->timeout;
 
-#if IS_ENABLED(CONFIG_NF_NAT)
-	if (ct->status & IPS_NAT_MASK) {
-		exp->saved_proto.tcp.port = priv->dport;
-		exp->dir = !dir;
-		exp->expectfn = nft_ct_nat_follow_master;
+	expect_data = nfct_help_data(ct);
+	if (!expect_data) {
+		regs->verdict.code = NFT_BREAK;
+		return;
 	}
-#endif
-	if (nf_ct_expect_related(exp, 0) != 0)
-		regs->verdict.code = NF_DROP;
+	expect_data->obj = *priv;
+	expect_data->obj.helper = NULL;
+	expect_data->dir = CTINFO2DIR(ctinfo);
 
-	nf_ct_expect_put(exp);
+	if (help && refcount_inc_not_zero(&priv->helper->ct_refcnt))
+		rcu_assign_pointer(help->helper, priv->helper);
 }
 
 static const struct nla_policy nft_ct_expect_policy[NFTA_CT_EXPECT_MAX + 1] = {
-- 
2.47.3

