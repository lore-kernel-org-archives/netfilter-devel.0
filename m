Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C3843B3EE
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Jul 2026 13:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785419374; cv=none; b=Q0ThGSHrfs44BCKdAVX01/7eBBxSHflWMyY6jY2RXjZFJaIdwFutmP58PiD+JgUIYX0QmzQ4eDj0sxfwxQecdpqf8n8Kjq7UlYtxOkm7q3l5iYWwGCXuz4/PhVUyIxpj5rKMZ4T5Gi0RPF5VfsmS486HRAJq9AqrEbpx/w0tZSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785419374; c=relaxed/simple;
	bh=mMQJDEXb8tkdNK0kULgvS7PBggHRv9Wjf7iw5RJodfk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DYJoaVatHTSNChbrtkl/BVjVEVHjEbKRg8+pTo/iUeAd8QUnRpP/QKj9th0kw2B+ml2rsaTjB0Bb13VNaVE2ftAzrJygQzrFOFfWoLlQIenVe0+nnNhWWmQ4yHtbHi88LiT0s6tbfImYYaVBKLrjs0Rzr22FrBeb8LSZvs9RAYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=JnjgWJQN; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="JnjgWJQN"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5850960194;
	Thu, 30 Jul 2026 15:49:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785419362;
	bh=E/iUWaptuiILwXpdpPAGyFvPMKh7spxe6QV4lNJucvM=;
	h=From:To:Cc:Subject:Date:From;
	b=JnjgWJQNsE97feYpr/SuKjtohENwrKJo1VK/Z0mWRs2nsRPvIHMdyMFtVBAO8FcZu
	 TGlWBDfwOSXPbHmGR01UyTLRVsVCpS2dk4ImY330+oKHEDWG4saS2PRNW626X8/awa
	 mg2zwD98ly93chVNtBFzgaaD6/x1NWXPIpZOuhK0ueb/mvk+ABDwhZFCoEHwwoC9Al
	 q1VtULiWElfd8KjzjlR8iBFr0Q0gF/yAUDDon7rNn15VSuSgdUdQbipqNwX7OFxPjR
	 lU8mB9eLQ/vwmNKWV/pZycJA2b/qgzCrou1NiYL5jLXzy5nul0kx79qVrhut1YscEI
	 cwyeo4qAUhspQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: iostreampy@proton.me
Subject: [PATCH nf] netfilter: nft_ct: move custom expectation support to helper
Date: Thu, 30 Jul 2026 15:49:18 +0200
Message-ID: <20260730134918.590167-1-pablo@netfilter.org>
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
confirmed conntrack") which restricted it to confirmed conntracks.

This is still not sufficient though. Early insertion of expectations
into the expectations list, which resides in the ct helper extension
area might lead to stale entries pointing to the wrong hlist_head
through .pprev due to ct extension reallocation.

Commit 7c9664351980 ("netfilter: move nat hlist_head to nf_conn") moved
the nat hlist_head to nf_conn for this reason:

     1. ...
     2. When reallocation of extension area occurs we need to fixup the
        bysource hash head via hlist_replace_rcu.

However, I'd rather not increase the size of the struct nf_conn for this
feature, which only supports for creating expectations in the reply
direction, which restricts its usecase. Note that ct expectation is also
broken with NAT, because the dnat mappings is not available until the
conntrack is confirmed.

To address this issue, add an internal ct helper and attach it to the
conntrack entry to streamline the custom ct expectation support with
existing ct helpers.

Expose a new nf_conntrack_helper_free() function to safely release the
internal helper that is allocated and attached to the conntrack entry to
create the custom expectations.

Fixes: 857b46027d6f ("netfilter: nft_ct: add ct expectations support")
Reported-by: Jaeyeong Lee <iostreampy@proton.me>
Link: https://patch.msgid.link/20260715144755.00ea7dfcd9f@proton.me
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v1: this replaces:
    [nf,v2] netfilter: nft_ct: postpone expectation creation to confirmed conntrack
    by following a different approach.

 include/net/netfilter/nf_conntrack_helper.h |   2 +
 net/netfilter/nf_conntrack_helper.c         |  18 ++-
 net/netfilter/nft_ct.c                      | 119 +++++++++++++++-----
 3 files changed, 106 insertions(+), 33 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index c761cd8158b2..4420846e41f2 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -114,6 +114,8 @@ int nf_conntrack_helpers_register(struct nf_conntrack_helper *, unsigned int,
 void nf_conntrack_helpers_unregister(struct nf_conntrack_helper **,
 				     unsigned int);
 
+void nf_conntrack_helper_free(struct nf_conntrack_helper *me);
+
 #define nf_conntrack_helper_deprecated(name) \
 	pr_warn("The %s conntrack helper is scheduled for removal.\n"	\
 		"Please contact the netfilter-devel mailing list if you still need this.\n", name)
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 500509b17663..1197e8793494 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -456,13 +456,8 @@ static bool expect_iter_me(struct nf_conntrack_expect *exp, void *data)
 	return this == me;
 }
 
-void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
+void nf_conntrack_helper_free(struct nf_conntrack_helper *me)
 {
-	mutex_lock(&nf_ct_helper_mutex);
-	hlist_del_rcu(&me->hnode);
-	nf_ct_helper_count--;
-	mutex_unlock(&nf_ct_helper_mutex);
-
 	/* This helper is going away, disable it. */
 	rcu_assign_pointer(me->help, NULL);
 
@@ -476,6 +471,17 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
 	if (refcount_dec_and_test(&me->ct_refcnt))
 		kfree_rcu(me, rcu);
 }
+EXPORT_SYMBOL_GPL(nf_conntrack_helper_free);
+
+void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
+{
+	mutex_lock(&nf_ct_helper_mutex);
+	hlist_del_rcu(&me->hnode);
+	nf_ct_helper_count--;
+	mutex_unlock(&nf_ct_helper_mutex);
+
+	nf_conntrack_helper_free(me);
+}
 EXPORT_SYMBOL_GPL(nf_conntrack_helper_unregister);
 
 void nf_ct_helper_init(struct nf_conntrack_helper *helper,
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 03a88c77e0f0..ff7c27579cfb 100644
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
@@ -1226,6 +1228,66 @@ static int nft_ct_expect_timeout_get(const struct nlattr *attr, u32 *val)
 	return 0;
 }
 
+struct nft_ct_expect_data {
+	struct nft_ct_expect_obj	obj;
+	atomic_t			num_expects;
+};
+
+static int ct_expect_help(struct sk_buff *skb, unsigned int protoff,
+			  struct nf_conn *ct, enum ip_conntrack_info ctinfo)
+{
+	struct nft_ct_expect_data *expect_data;
+	struct nf_conntrack_expect *exp;
+	enum ip_conntrack_dir dir;
+	int ret;
+
+	expect_data = nfct_help_data(ct);
+	if (!expect_data)
+		return NF_ACCEPT;
+
+	if (!atomic_add_unless(&expect_data->num_expects, 1, expect_data->obj.size))
+		return NF_ACCEPT;
+
+	exp = nf_ct_expect_alloc(ct);
+	if (!exp)
+		return NF_DROP;
+
+	dir = CTINFO2DIR(ctinfo);
+	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, nf_ct_l3num(ct),
+			  &ct->tuplehash[!dir].tuple.src.u3,
+			  &ct->tuplehash[!dir].tuple.dst.u3,
+			  expect_data->obj.l4proto, NULL, &expect_data->obj.dport);
+	exp->timeout += expect_data->obj.timeout;
+
+	if (nf_ct_expect_related(exp, 0) != 0)
+		ret = NF_DROP;
+
+	nf_ct_expect_put(exp);
+
+	return NF_ACCEPT;
+}
+
+static int nft_ct_expect_helper_alloc(struct nft_ct_expect_obj *priv)
+{
+	struct nf_conntrack_helper *ct_expect_helper;
+
+	ct_expect_helper = kzalloc_obj(struct nf_conntrack_helper);
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
@@ -1233,6 +1295,8 @@ static int nft_ct_expect_obj_init(const struct nft_ctx *ctx,
 	struct nft_ct_expect_obj *priv = nft_obj_data(obj);
 	int err;
 
+	NF_CT_HELPER_BUILD_BUG_ON(sizeof(struct nft_ct_expect_data));
+
 	if (!tb[NFTA_CT_EXPECT_L4PROTO] ||
 	    !tb[NFTA_CT_EXPECT_DPORT] ||
 	    !tb[NFTA_CT_EXPECT_TIMEOUT] ||
@@ -1273,13 +1337,26 @@ static int nft_ct_expect_obj_init(const struct nft_ctx *ctx,
 	priv->dport = nla_get_be16(tb[NFTA_CT_EXPECT_DPORT]);
 	priv->size = nla_get_u8(tb[NFTA_CT_EXPECT_SIZE]);
 
-	return nf_ct_netns_get(ctx->net, ctx->family);
+	err = nf_ct_netns_get(ctx->net, ctx->family);
+	if (err < 0)
+		return err;
+
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
+
 	nf_ct_netns_put(ctx->net, ctx->family);
+	nf_conntrack_helper_free(priv->helper);
 }
 
 static int nft_ct_expect_obj_dump(struct sk_buff *skb,
@@ -1302,50 +1379,38 @@ static void nft_ct_expect_obj_eval(struct nft_object *obj,
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
-	if (!ct || nf_ct_is_confirmed(ct) || nf_ct_is_template(ct)) {
+	if (!ct || nf_ct_is_template(ct) || nf_ct_is_confirmed(ct)) {
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
 
-	if (nf_ct_expect_related(exp, 0) != 0)
-		regs->verdict.code = NF_DROP;
+	expect_data = nfct_help_data(ct);
+	if (!expect_data) {
+		regs->verdict.code = NFT_BREAK;
+		return;
+	}
+	expect_data->obj = *priv;
 
-	nf_ct_expect_put(exp);
+	if (help && refcount_inc_not_zero(&priv->helper->ct_refcnt))
+		rcu_assign_pointer(help->helper, priv->helper);
 }
 
 static const struct nla_policy nft_ct_expect_policy[NFTA_CT_EXPECT_MAX + 1] = {
-- 
2.47.3

