Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1627E39793C
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Aug 2026 07:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786345814; cv=none; b=RymAXiSZmtazL1vcyieQAvlnz3EjKugO0Z5UI9rnEYY3UOvf/DPqmFdS6+h/uDfjG1lmKl+lETn6tCn6tiV8BYXQ1kAZqK1BGBL6XCkwVmJ1LD31M0unyaPzDBZARWsdgUXBCQ+50P3nXchhAPDT+I9cGMjfUBDLx9P8pJc39JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786345814; c=relaxed/simple;
	bh=tzgqHUjcD8zi7O6PT8A8AfI3NjA43ZefBQPgpBA7LtM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=BsK6LNgIdt2H0ycD7CBUCE3XD6vFJXRG+V7hBoJflBLgb+1Xj4jymPrzzMgWEV+0Jy6wJIVQVOcG6BH4cHVu9UW0b1c1EzvWaitc7rRwzK6h5PTgn1oiHwM/7O7vkbSlWHz0C4EJ+ngjdIlk+uBbh3IiOniwc1pIpr7O132DnUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ipXnsMEW; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ipXnsMEW"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A3A4D60194
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Aug 2026 09:10:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786345800;
	bh=+GQJPCQqNv5+lNgyBZMqRoi7tZAtRc4kL8neyU9aOI8=;
	h=From:To:Subject:Date:From;
	b=ipXnsMEW8fpR+EOR34w7IVkhe//Ty+MWKDXBH2vq4qDHD8sRw0PGij3h2OxKma5Zw
	 pKzkjv1czSguQHP/fCMFIJPShZRIRLEf/3SlETIuv1AgZ2fEfqp4fxVBg/i3N2oHkV
	 TGgGIVW//Fv8x8WG2RQdL+NdoL0fOBMYvTI3SxW4CQ0O63mRcVuwCxT070H6YKUGDL
	 Kv11rYLdA+L80cj/A3qZarcppKhHTbBaGvlB+doTG4csfNyqb0zOPZoAlGly7RJi1a
	 gBQWTCH9+HOyMzKr4oRhOeymJoyd3v0/OIvdSWfT3HgaPqTLMdNUZq4pf9fsnDy9fC
	 PprJ7jm4LYf7w==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v4] netfilter: nft_ct: move custom expectation support to helper
Date: Mon, 10 Aug 2026 09:09:56 +0200
Message-ID: <20260810070956.689890-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
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
best effort.

To address this issue, add an internal ct helper and attach it to the
conntrack entry to streamline the custom ct expectation support with
existing ct helpers.

Expose a new nf_conntrack_helper_release() function to release the
internal helper that is allocated and attached to the conntrack entry to
create the custom expectations. The nft_ct module removal always waits
for rcu grace period, then the NULL helper callback is observed after
this.

This patch also restricts the creation of expectations to different
helpers other than this custom helper that is created for this type of
expectations.

Fixes: 857b46027d6f ("netfilter: nft_ct: add ct expectations support")
Reported-by: Jaeyeong Lee <iostreampy@proton.me>
Link: https://patch.msgid.link/20260715144755.00ea7dfcd9f@proton.me
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v4: - restore missing NAT code after rebase
    - honor l3num
    - remove num_expects as quota
    - no need to wait for rcu grace period when destroying helper

 include/net/netfilter/nf_conntrack_helper.h |   1 +
 net/netfilter/nf_conntrack_helper.c         |  14 +-
 net/netfilter/nft_ct.c                      | 167 +++++++++++++++-----
 3 files changed, 135 insertions(+), 47 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index bc5427d239f4..335b8c43694f 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -106,6 +106,7 @@ void nf_ct_helper_init(struct nf_conntrack_helper *helper,
 int nf_conntrack_helper_register(struct nf_conntrack_helper *, struct nf_conntrack_helper **);
 int __nf_conntrack_helper_register(struct nf_conntrack_helper *);
 void nf_conntrack_helper_unregister(struct nf_conntrack_helper *);
+void nf_conntrack_helper_release(struct nf_conntrack_helper *);
 
 int nf_conntrack_helpers_register(struct nf_conntrack_helper *, unsigned int,
 				  struct nf_conntrack_helper **);
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 506c58034761..c30ae3f203be 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -448,6 +448,15 @@ static bool expect_iter_me(struct nf_conntrack_expect *exp, void *data)
 	return this == me;
 }
 
+void nf_conntrack_helper_release(struct nf_conntrack_helper *me)
+{
+	nf_ct_expect_iterate_destroy(expect_iter_me, me);
+
+	if (refcount_dec_and_test(&me->ct_refcnt))
+		kfree_rcu(me, rcu);
+}
+EXPORT_SYMBOL_GPL(nf_conntrack_helper_release);
+
 void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
 {
 	mutex_lock(&nf_ct_helper_mutex);
@@ -463,10 +472,7 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
 	 */
 	synchronize_rcu();
 
-	nf_ct_expect_iterate_destroy(expect_iter_me, me);
-
-	if (refcount_dec_and_test(&me->ct_refcnt))
-		kfree_rcu(me, rcu);
+	nf_conntrack_helper_release(me);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_helper_unregister);
 
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 358b9287e12e..9dbf127df9c8 100644
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
@@ -1226,6 +1228,93 @@ static int nft_ct_expect_timeout_get(const struct nlattr *attr, u32 *val)
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_NF_NAT)
+static void nft_ct_nat_follow_master(struct nf_conn *ct, struct nf_conntrack_expect *this)
+{
+	const struct nf_ct_helper_expectfn *expfn;
+
+	expfn = nf_ct_helper_expectfn_find_by_name("nat-follow-master");
+	if (expfn)
+		expfn->expectfn(ct, this);
+}
+#endif
+
+struct nft_ct_expect_data {
+	struct nft_ct_expect_obj	obj;
+	enum ip_conntrack_dir		dir;
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
+	if (nf_ct_is_confirmed(ct))
+		return NF_ACCEPT;
+
+	expect_data = nfct_help_data(ct);
+	if (!expect_data)
+		return NF_ACCEPT;
+
+	if (expect_data->dir != dir)
+		return NF_ACCEPT;
+
+	exp = nf_ct_expect_alloc(ct);
+	if (!exp)
+		return NF_DROP;
+
+	if (expect_data->obj.l3num == NFPROTO_INET)
+		l3num = nf_ct_l3num(ct);
+	else
+		l3num = expect_data->obj.l3num;
+
+	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, l3num,
+			  &ct->tuplehash[!dir].tuple.src.u3,
+			  &ct->tuplehash[!dir].tuple.dst.u3,
+			  expect_data->obj.l4proto, NULL, &expect_data->obj.dport);
+	exp->timeout += expect_data->obj.timeout;
+
+#if IS_ENABLED(CONFIG_NF_NAT)
+	if (ct->status & IPS_NAT_MASK) {
+		exp->saved_proto.tcp.port = expect_data->obj.dport;
+		exp->dir = !dir;
+		exp->expectfn = nft_ct_nat_follow_master;
+	}
+#endif
+	if (nf_ct_expect_related(exp, 0) != 0)
+		ret = NF_ACCEPT;
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
@@ -1233,6 +1322,8 @@ static int nft_ct_expect_obj_init(const struct nft_ctx *ctx,
 	struct nft_ct_expect_obj *priv = nft_obj_data(obj);
 	int err;
 
+	NF_CT_HELPER_BUILD_BUG_ON(sizeof(struct nft_ct_expect_data));
+
 	if (!tb[NFTA_CT_EXPECT_L4PROTO] ||
 	    !tb[NFTA_CT_EXPECT_DPORT] ||
 	    !tb[NFTA_CT_EXPECT_TIMEOUT] ||
@@ -1272,13 +1363,31 @@ static int nft_ct_expect_obj_init(const struct nft_ctx *ctx,
 
 	priv->dport = nla_get_be16(tb[NFTA_CT_EXPECT_DPORT]);
 	priv->size = nla_get_u8(tb[NFTA_CT_EXPECT_SIZE]);
+	if (!priv->size)
+		priv->size = NF_CT_EXPECT_MAX_CNT;
+
+	err = nf_ct_netns_get(ctx->net, ctx->family);
+	if (err < 0)
+		return err;
 
-	return nf_ct_netns_get(ctx->net, ctx->family);
+	err = nft_ct_expect_helper_alloc(priv);
+	if (err < 0) {
+		nf_ct_netns_put(ctx->net, ctx->family);
+		return err;
+	}
+
+	return err;
 }
 
 static void nft_ct_expect_obj_destroy(const struct nft_ctx *ctx,
-				       struct nft_object *obj)
+				      struct nft_object *obj)
 {
+	const struct nft_ct_expect_obj *priv = nft_obj_data(obj);
+	struct nf_conntrack_helper *me = priv->helper;
+
+	/* This helper is going away, disable it. */
+	rcu_assign_pointer(me->help, NULL);
+	nf_conntrack_helper_release(me);
 	nf_ct_netns_put(ctx->net, ctx->family);
 }
 
@@ -1297,27 +1406,14 @@ static int nft_ct_expect_obj_dump(struct sk_buff *skb,
 	return 0;
 }
 
-#if IS_ENABLED(CONFIG_NF_NAT)
-static void nft_ct_nat_follow_master(struct nf_conn *ct, struct nf_conntrack_expect *this)
-{
-	const struct nf_ct_helper_expectfn *expfn;
-
-	expfn = nf_ct_helper_expectfn_find_by_name("nat-follow-master");
-	if (expfn)
-		expfn->expectfn(ct, this);
-}
-#endif
-
 static void nft_ct_expect_obj_eval(struct nft_object *obj,
 				   struct nft_regs *regs,
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
@@ -1325,45 +1421,30 @@ static void nft_ct_expect_obj_eval(struct nft_object *obj,
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

