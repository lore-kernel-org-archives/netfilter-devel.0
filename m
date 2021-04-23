Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACD4FC433B4
	for <netfilter-devel@archiver.kernel.org>; Fri, 23 Apr 2021 21:42:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B81A61168
	for <netfilter-devel@archiver.kernel.org>; Fri, 23 Apr 2021 21:42:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232283AbhDWVm5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 23 Apr 2021 17:42:57 -0400
Received: from mail.netfilter.org ([217.70.188.207]:47686 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231881AbhDWVm4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Apr 2021 17:42:56 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 4F487630C2
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Apr 2021 23:41:44 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: nftables: add catch-all set element support
Date:   Fri, 23 Apr 2021 23:42:14 +0200
Message-Id: <20210423214214.6071-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch extends the set infrastructure to add a special catch-all set
element. If the lookup fails to find an element (or range) in the set,
then the catch-all element is selected. Users can specify a mapping,
expression(s) and timeout to be attached to the catch-all element.

This adds the catchall_list list to the set, this list might contain up
to two catch-all elements (in case that catch-all element is removed and
a new one is added in the same transaction). Most of the time, there
will be either one element or no elements at all in this list.

The catch-all element is identified via NFT_SET_ELEM_CATCHALL flag and
such special element has no NFTA_SET_ELEM_KEY attribute.

The set size does not apply to the catch-all element, users can define a
catch-all element even if the set if full.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h        |   5 +
 include/uapi/linux/netfilter/nf_tables.h |   2 +
 net/netfilter/nf_tables_api.c            | 309 ++++++++++++++++++++---
 net/netfilter/nft_lookup.c               |  12 +-
 net/netfilter/nft_objref.c               |  11 +-
 net/netfilter/nft_set_hash.c             |   5 +
 net/netfilter/nft_set_pipapo.c           |   6 +-
 net/netfilter/nft_set_rbtree.c           |   6 +
 8 files changed, 306 insertions(+), 50 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index eb708b77c4a5..27eeb613bb4e 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -497,6 +497,7 @@ struct nft_set {
 	u8				dlen;
 	u8				num_exprs;
 	struct nft_expr			*exprs[NFT_SET_EXPR_MAX];
+	struct list_head		catchall_list;
 	unsigned char			data[]
 		__attribute__((aligned(__alignof__(u64))));
 };
@@ -522,6 +523,10 @@ struct nft_set *nft_set_lookup_global(const struct net *net,
 				      const struct nlattr *nla_set_id,
 				      u8 genmask);
 
+struct nft_set_ext *nft_set_catchall_lookup(const struct net *net,
+					    const struct nft_set *set);
+void *nft_set_catchall_gc(const struct nft_set *set);
+
 static inline unsigned long nft_set_gc_interval(const struct nft_set *set)
 {
 	return set->gc_int ? msecs_to_jiffies(set->gc_int) : HZ;
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 467365ed59a7..1fb4ca18ffbb 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -398,9 +398,11 @@ enum nft_set_attributes {
  * enum nft_set_elem_flags - nf_tables set element flags
  *
  * @NFT_SET_ELEM_INTERVAL_END: element ends the previous interval
+ * @NFT_SET_ELEM_CATCHALL: special catch-all element
  */
 enum nft_set_elem_flags {
 	NFT_SET_ELEM_INTERVAL_END	= 0x1,
+	NFT_SET_ELEM_CATCHALL		= 0x2,
 };
 
 /**
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1050f23c0d29..c634e531adfc 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4389,6 +4389,7 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 	}
 
 	INIT_LIST_HEAD(&set->bindings);
+	INIT_LIST_HEAD(&set->catchall_list);
 	set->table = table;
 	write_pnet(&set->net, net);
 	set->ops   = ops;
@@ -4729,7 +4730,8 @@ static int nf_tables_fill_setelem(struct sk_buff *skb,
 	if (nest == NULL)
 		goto nla_put_failure;
 
-	if (nft_data_dump(skb, NFTA_SET_ELEM_KEY, nft_set_ext_key(ext),
+	if (nft_set_ext_exists(ext, NFT_SET_EXT_KEY) &&
+	    nft_data_dump(skb, NFTA_SET_ELEM_KEY, nft_set_ext_key(ext),
 			  NFT_DATA_VALUE, set->klen) < 0)
 		goto nla_put_failure;
 
@@ -4818,6 +4820,35 @@ struct nft_set_dump_ctx {
 	struct nft_ctx		ctx;
 };
 
+struct nft_set_elem_catchall {
+	struct list_head	list;
+	struct rcu_head		rcu;
+	void			*elem;
+};
+
+static int nft_set_catchall_walk(struct net *net, struct sk_buff *skb,
+				 const struct nft_set *set)
+{
+	struct nft_set_elem_catchall *catchall;
+	u8 genmask = nft_genmask_cur(net);
+	struct nft_set_elem elem;
+	struct nft_set_ext *ext;
+	int ret = 0;
+
+	list_for_each_entry_rcu(catchall, &set->catchall_list, list) {
+		ext = nft_set_elem_ext(set, catchall->elem);
+		if (!nft_set_elem_active(ext, genmask) ||
+		    nft_set_elem_expired(ext))
+			continue;
+
+		elem.priv = catchall->elem;
+		ret = nf_tables_fill_setelem(skb, set, &elem);
+		break;
+	}
+
+	return ret;
+}
+
 static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct nft_set_dump_ctx *dump_ctx = cb->data;
@@ -4882,6 +4913,9 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	args.iter.err		= 0;
 	args.iter.fn		= nf_tables_dump_setelem;
 	set->ops->walk(&dump_ctx->ctx, set, &args.iter);
+
+	if (args.iter.err && args.iter.err != -EMSGSIZE)
+		args.iter.err = nft_set_catchall_walk(net, skb, set);
 	rcu_read_unlock();
 
 	nla_nest_end(skb, nest);
@@ -4961,7 +4995,7 @@ static int nft_setelem_parse_flags(const struct nft_set *set,
 		return 0;
 
 	*flags = ntohl(nla_get_be32(attr));
-	if (*flags & ~NFT_SET_ELEM_INTERVAL_END)
+	if (*flags & ~(NFT_SET_ELEM_INTERVAL_END | NFT_SET_ELEM_CATCHALL))
 		return -EINVAL;
 	if (!(set->flags & NFT_SET_INTERVAL) &&
 	    *flags & NFT_SET_ELEM_INTERVAL_END)
@@ -5007,6 +5041,35 @@ static int nft_setelem_parse_data(struct nft_ctx *ctx, struct nft_set *set,
 	return 0;
 }
 
+static int nft_setelem_get(struct nft_ctx *ctx, struct nft_set *set,
+			   struct nft_set_elem *elem, u32 flags)
+{
+	void *priv;
+
+	if (!(flags & NFT_SET_ELEM_CATCHALL)) {
+		priv = set->ops->get(ctx->net, set, elem, flags);
+		if (IS_ERR(priv))
+			return PTR_ERR(priv);
+
+		elem->priv = priv;
+	} else {
+		struct nft_set_elem_catchall *catchall;
+		u8 genmask = nft_genmask_cur(ctx->net);
+		struct nft_set_ext *ext;
+
+		list_for_each_entry_rcu(catchall, &set->catchall_list, list) {
+			ext = nft_set_elem_ext(set, catchall->elem);
+			if (!nft_set_elem_active(ext, genmask) ||
+			    nft_set_elem_expired(ext))
+				continue;
+
+			elem->priv = catchall->elem;
+		}
+	}
+
+	return 0;
+}
+
 static int nft_get_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			    const struct nlattr *attr)
 {
@@ -5014,7 +5077,6 @@ static int nft_get_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	struct nft_set_elem elem;
 	struct sk_buff *skb;
 	uint32_t flags = 0;
-	void *priv;
 	int err;
 
 	err = nla_parse_nested_deprecated(nla, NFTA_SET_ELEM_MAX, attr,
@@ -5022,17 +5084,19 @@ static int nft_get_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	if (err < 0)
 		return err;
 
-	if (!nla[NFTA_SET_ELEM_KEY])
-		return -EINVAL;
-
 	err = nft_setelem_parse_flags(set, nla[NFTA_SET_ELEM_FLAGS], &flags);
 	if (err < 0)
 		return err;
 
-	err = nft_setelem_parse_key(ctx, set, &elem.key.val,
-				    nla[NFTA_SET_ELEM_KEY]);
-	if (err < 0)
-		return err;
+	if (!nla[NFTA_SET_ELEM_KEY] && !(flags & NFT_SET_ELEM_CATCHALL))
+		return -EINVAL;
+
+	if (nla[NFTA_SET_ELEM_KEY]) {
+		err = nft_setelem_parse_key(ctx, set, &elem.key.val,
+					    nla[NFTA_SET_ELEM_KEY]);
+		if (err < 0)
+			return err;
+	}
 
 	if (nla[NFTA_SET_ELEM_KEY_END]) {
 		err = nft_setelem_parse_key(ctx, set, &elem.key_end.val,
@@ -5041,11 +5105,9 @@ static int nft_get_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			return err;
 	}
 
-	priv = set->ops->get(ctx->net, set, &elem, flags);
-	if (IS_ERR(priv))
-		return PTR_ERR(priv);
-
-	elem.priv = priv;
+	err = nft_setelem_get(ctx, set, &elem, flags);
+	if (err < 0)
+		return err;
 
 	err = -ENOMEM;
 	skb = nlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
@@ -5205,7 +5267,8 @@ void *nft_set_elem_init(const struct nft_set *set,
 	ext = nft_set_elem_ext(set, elem);
 	nft_set_ext_init(ext, tmpl);
 
-	memcpy(nft_set_ext_key(ext), key, set->klen);
+	if (nft_set_ext_exists(ext, NFT_SET_EXT_KEY))
+		memcpy(nft_set_ext_key(ext), key, set->klen);
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_KEY_END))
 		memcpy(nft_set_ext_key_end(ext), key_end, set->klen);
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA))
@@ -5336,6 +5399,169 @@ static int nft_set_elem_expr_setup(struct nft_ctx *ctx,
 	return -ENOMEM;
 }
 
+struct nft_set_ext *nft_set_catchall_lookup(const struct net *net,
+					    const struct nft_set *set)
+{
+	struct nft_set_elem_catchall *catchall;
+	u8 genmask = nft_genmask_cur(net);
+	struct nft_set_ext *ext;
+
+	list_for_each_entry_rcu(catchall, &set->catchall_list, list) {
+		ext = nft_set_elem_ext(set, catchall->elem);
+		if (nft_set_elem_active(ext, genmask) &&
+		    !nft_set_elem_expired(ext))
+			return ext;
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(nft_set_catchall_lookup);
+
+void *nft_set_catchall_gc(const struct nft_set *set)
+{
+	struct nft_set_elem_catchall *catchall, *next;
+	struct nft_set_ext *ext;
+	void *elem = NULL;
+
+	list_for_each_entry_safe(catchall, next, &set->catchall_list, list) {
+		ext = nft_set_elem_ext(set, catchall->elem);
+
+		if (!nft_set_elem_expired(ext) ||
+		    nft_set_elem_mark_busy(ext))
+			continue;
+
+		elem = catchall->elem;
+		list_del_rcu(&catchall->list);
+		kfree_rcu(catchall, rcu);
+		break;
+	}
+
+	return elem;
+}
+EXPORT_SYMBOL_GPL(nft_set_catchall_gc);
+
+static int nft_setelem_catchall_insert(const struct net *net,
+				       struct nft_set *set,
+				       const struct nft_set_elem *elem,
+				       struct nft_set_ext **pext)
+{
+	struct nft_set_elem_catchall *catchall;
+	u8 genmask = nft_genmask_next(net);
+	struct nft_set_ext *ext;
+
+	list_for_each_entry(catchall, &set->catchall_list, list) {
+		ext = nft_set_elem_ext(set, catchall->elem);
+		if (nft_set_elem_active(ext, genmask)) {
+			*pext = ext;
+			return -EEXIST;
+		}
+	}
+
+	catchall = kmalloc(sizeof(*catchall), GFP_KERNEL);
+	if (!catchall)
+		return -ENOMEM;
+
+	catchall->elem = elem->priv;
+	list_add_tail_rcu(&catchall->list, &set->catchall_list);
+
+	return 0;
+}
+
+static int nft_setelem_catchall_deactivate(const struct net *net,
+					   struct nft_set *set,
+					   const struct nft_set_elem *elem)
+{
+	struct nft_set_elem_catchall *catchall;
+	struct nft_set_ext *ext;
+
+	list_for_each_entry(catchall, &set->catchall_list, list) {
+		if (catchall->elem != elem->priv)
+			continue;
+
+		ext = nft_set_elem_ext(set, catchall->elem);
+		if (nft_is_active(net, ext) &&
+		    !nft_set_elem_mark_busy(ext)) {
+			nft_set_elem_change_active(net, set, ext);
+			return 0;
+		}
+	}
+
+	return -ENOENT;
+}
+
+static void nft_setelem_catchall_remove(const struct nft_set *set,
+					const struct nft_set_elem *elem)
+{
+	struct nft_set_elem_catchall *catchall, *next;
+
+	list_for_each_entry_safe(catchall, next, &set->catchall_list, list) {
+		if (catchall->elem == elem) {
+			list_del_rcu(&catchall->list);
+			nft_set_elem_destroy(set, catchall->elem, true);
+			kfree_rcu(catchall);
+		}
+	}
+}
+
+static int nft_setelem_insert(const struct net *net,
+			      struct nft_set *set,
+			      const struct nft_set_elem *elem,
+			      struct nft_set_ext **ext, unsigned int flags)
+{
+	int ret;
+
+	if (flags & NFT_SET_ELEM_CATCHALL)
+		ret = nft_setelem_catchall_insert(net, set, elem, ext);
+	else
+		ret = set->ops->insert(net, set, elem, ext);
+
+	return ret;
+}
+
+static int __nft_setelem_deactivate(const struct net *net,
+				    struct nft_set *set,
+				    struct nft_set_elem *elem)
+{
+	void *priv;
+
+	priv = set->ops->deactivate(net, set, elem);
+	if (!priv)
+		return -ENOENT;
+
+	kfree(elem->priv);
+	elem->priv = priv;
+
+	return 0;
+}
+
+static int nft_setelem_deactivate(const struct net *net,
+				  struct nft_set *set,
+				  struct nft_set_elem *elem, u32 flags)
+{
+	int ret;
+
+	if (flags & NFT_SET_ELEM_CATCHALL)
+		ret = nft_setelem_catchall_deactivate(net, set, elem);
+	else
+		ret = __nft_setelem_deactivate(net, set, elem);
+
+	return ret;
+}
+
+static void nft_setelem_remove(const struct net *net,
+			       const struct nft_set *set,
+			       const struct nft_set_elem *elem)
+{
+	struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
+
+	if (nft_set_ext_exists(ext, NFT_SET_EXT_FLAGS) &&
+	    *nft_set_ext_flags(ext) & NFT_SET_ELEM_CATCHALL) {
+		nft_setelem_catchall_remove(set, elem);
+	} else {
+		set->ops->remove(net, set, elem);
+	}
+}
+
 static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			    const struct nlattr *attr, u32 nlmsg_flags)
 {
@@ -5362,14 +5588,15 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	if (err < 0)
 		return err;
 
-	if (nla[NFTA_SET_ELEM_KEY] == NULL)
-		return -EINVAL;
-
 	nft_set_ext_prepare(&tmpl);
 
 	err = nft_setelem_parse_flags(set, nla[NFTA_SET_ELEM_FLAGS], &flags);
 	if (err < 0)
 		return err;
+
+	if (!nla[NFTA_SET_ELEM_KEY] && !(flags & NFT_SET_ELEM_CATCHALL))
+		return -EINVAL;
+
 	if (flags != 0)
 		nft_set_ext_add(&tmpl, NFT_SET_EXT_FLAGS);
 
@@ -5474,12 +5701,14 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		num_exprs = set->num_exprs;
 	}
 
-	err = nft_setelem_parse_key(ctx, set, &elem.key.val,
-				    nla[NFTA_SET_ELEM_KEY]);
-	if (err < 0)
-		goto err_set_elem_expr;
+	if (nla[NFTA_SET_ELEM_KEY]) {
+		err = nft_setelem_parse_key(ctx, set, &elem.key.val,
+					    nla[NFTA_SET_ELEM_KEY]);
+		if (err < 0)
+			goto err_set_elem_expr;
 
-	nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, set->klen);
+		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, set->klen);
+	}
 
 	if (nla[NFTA_SET_ELEM_KEY_END]) {
 		err = nft_setelem_parse_key(ctx, set, &elem.key_end.val,
@@ -5596,7 +5825,8 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	}
 
 	ext->genmask = nft_genmask_cur(ctx->net) | NFT_SET_ELEM_BUSY_MASK;
-	err = set->ops->insert(ctx->net, set, &elem, &ext2);
+
+	err = nft_setelem_insert(ctx->net, set, &elem, &ext2, flags);
 	if (err) {
 		if (err == -EEXIST) {
 			if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA) ^
@@ -5634,7 +5864,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	return 0;
 
 err_set_full:
-	set->ops->remove(ctx->net, set, &elem);
+	nft_setelem_remove(ctx->net, set, &elem);
 err_element_clash:
 	kfree(trans);
 err_elem_expr:
@@ -5766,7 +5996,6 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	struct nft_set_ext *ext;
 	struct nft_trans *trans;
 	u32 flags = 0;
-	void *priv;
 	int err;
 
 	err = nla_parse_nested_deprecated(nla, NFTA_SET_ELEM_MAX, attr,
@@ -5774,7 +6003,7 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	if (err < 0)
 		return err;
 
-	if (nla[NFTA_SET_ELEM_KEY] == NULL)
+	if (!nla[NFTA_SET_ELEM_KEY] && !(flags & NFT_SET_ELEM_CATCHALL))
 		return -EINVAL;
 
 	nft_set_ext_prepare(&tmpl);
@@ -5785,12 +6014,14 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	if (flags != 0)
 		nft_set_ext_add(&tmpl, NFT_SET_EXT_FLAGS);
 
-	err = nft_setelem_parse_key(ctx, set, &elem.key.val,
-				    nla[NFTA_SET_ELEM_KEY]);
-	if (err < 0)
-		return err;
+	if (nla[NFTA_SET_ELEM_KEY]) {
+		err = nft_setelem_parse_key(ctx, set, &elem.key.val,
+					    nla[NFTA_SET_ELEM_KEY]);
+		if (err < 0)
+			return err;
 
-	nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, set->klen);
+		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, set->klen);
+	}
 
 	if (nla[NFTA_SET_ELEM_KEY_END]) {
 		err = nft_setelem_parse_key(ctx, set, &elem.key_end.val,
@@ -5816,13 +6047,9 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	if (trans == NULL)
 		goto fail_trans;
 
-	priv = set->ops->deactivate(ctx->net, set, &elem);
-	if (priv == NULL) {
-		err = -ENOENT;
+	err = nft_setelem_deactivate(ctx->net, set, &elem, flags);
+	if (err < 0)
 		goto fail_ops;
-	}
-	kfree(elem.priv);
-	elem.priv = priv;
 
 	nft_set_elem_deactivate(ctx->net, set, &elem);
 
@@ -8270,7 +8497,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			nf_tables_setelem_notify(&trans->ctx, te->set,
 						 &te->elem,
 						 NFT_MSG_DELSETELEM, 0);
-			te->set->ops->remove(net, te->set, &te->elem);
+			nft_setelem_remove(net, te->set, &te->elem);
 			atomic_dec(&te->set->nelems);
 			te->set->ndeact--;
 			break;
@@ -8473,7 +8700,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 				break;
 			}
 			te = (struct nft_trans_elem *)trans->data;
-			te->set->ops->remove(net, te->set, &te->elem);
+			nft_setelem_remove(net, te->set, &te->elem);
 			atomic_dec(&te->set->nelems);
 			break;
 		case NFT_MSG_DELSETELEM:
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index b0f558b4fea5..a479f8a1270c 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -30,13 +30,17 @@ void nft_lookup_eval(const struct nft_expr *expr,
 	const struct nft_lookup *priv = nft_expr_priv(expr);
 	const struct nft_set *set = priv->set;
 	const struct nft_set_ext *ext = NULL;
+	const struct net *net = nft_net(pkt);
 	bool found;
 
-	found = set->ops->lookup(nft_net(pkt), set, &regs->data[priv->sreg],
-				 &ext) ^ priv->invert;
+	found = set->ops->lookup(net, set, &regs->data[priv->sreg], &ext) ^
+				 priv->invert;
 	if (!found) {
-		regs->verdict.code = NFT_BREAK;
-		return;
+		ext = nft_set_catchall_lookup(net, set);
+		if (!ext) {
+			regs->verdict.code = NFT_BREAK;
+			return;
+		}
 	}
 
 	if (ext) {
diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index bc104d36d3bb..7e47edee88ee 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -105,15 +105,18 @@ static void nft_objref_map_eval(const struct nft_expr *expr,
 {
 	struct nft_objref_map *priv = nft_expr_priv(expr);
 	const struct nft_set *set = priv->set;
+	struct net *net = nft_net(pkt);
 	const struct nft_set_ext *ext;
 	struct nft_object *obj;
 	bool found;
 
-	found = set->ops->lookup(nft_net(pkt), set, &regs->data[priv->sreg],
-				 &ext);
+	found = set->ops->lookup(net, set, &regs->data[priv->sreg], &ext);
 	if (!found) {
-		regs->verdict.code = NFT_BREAK;
-		return;
+		ext = nft_set_catchall_lookup(net, set);
+		if (!ext) {
+			regs->verdict.code = NFT_BREAK;
+			return;
+		}
 	}
 	obj = *nft_set_ext_obj(ext);
 	obj->ops->eval(obj, regs, pkt);
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index bf618b7ec1ae..d67fcc6aae6a 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -350,6 +350,11 @@ static void nft_rhash_gc(struct work_struct *work)
 	rhashtable_walk_stop(&hti);
 	rhashtable_walk_exit(&hti);
 
+	he = nft_set_catchall_gc(set);
+	gcb = nft_set_gc_batch_check(set, gcb, GFP_ATOMIC);
+	if (gcb)
+		nft_set_gc_batch_add(gcb, he);
+
 	nft_set_gc_batch_complete(gcb);
 	queue_delayed_work(system_power_efficient_wq, &priv->gc_work,
 			   nft_set_gc_interval(set));
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 9944523f5c2c..528a2d7ca991 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1529,11 +1529,11 @@ static void pipapo_gc(const struct nft_set *set, struct nft_pipapo_match *m)
 {
 	struct nft_pipapo *priv = nft_set_priv(set);
 	int rules_f0, first_rule = 0;
+	struct nft_pipapo_elem *e;
 
 	while ((rules_f0 = pipapo_rules_same_key(m->f, first_rule))) {
 		union nft_pipapo_map_bucket rulemap[NFT_PIPAPO_MAX_FIELDS];
 		struct nft_pipapo_field *f;
-		struct nft_pipapo_elem *e;
 		int i, start, rules_fx;
 
 		start = first_rule;
@@ -1569,6 +1569,10 @@ static void pipapo_gc(const struct nft_set *set, struct nft_pipapo_match *m)
 		}
 	}
 
+	e = nft_set_catchall_gc(set);
+	if (e)
+		nft_set_elem_destroy(set, e, true);
+
 	priv->last_gc = jiffies;
 }
 
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 217ab3644c25..3b5c0dda357f 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -541,6 +541,12 @@ static void nft_rbtree_gc(struct work_struct *work)
 	write_seqcount_end(&priv->count);
 	write_unlock_bh(&priv->lock);
 
+	rbe = nft_set_catchall_gc(set);
+	if (rbe) {
+		gcb = nft_set_gc_batch_check(set, gcb, GFP_ATOMIC);
+		nft_set_gc_batch_add(gcb, rbe);
+	}
+
 	nft_set_gc_batch_complete(gcb);
 
 	queue_delayed_work(system_power_efficient_wq, &priv->gc_work,
-- 
2.30.2

