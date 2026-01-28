Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DFFB25783A
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Jan 2026 01:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769564585; cv=none; b=NVNMuE2f6mn0DNNjcw1a6CbrmHRR+imqRM66ETfRMECztBAqZP4xnFM3JQYUNKwb5OKYSurMld6yPH1qiFf+Xw3zp1R5ZQKVTHXTUvKnsOraebxJnOBjAKHXnq5k84WgbXvmjeOWKom1H9C7aoVLq2EncNsV516MaKJLQhMNu0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769564585; c=relaxed/simple;
	bh=V54W44WYUIYHugUhRyIFfFK75jiQqbN1iROESuZm1lA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OTGY3qW3tfkb/I0JQJrz2Sw0uW//VeS3ZROMfR01QL2wB6nYKqNlKv8PjL4KvhZZs3i05mHLs+gCtjySfRWFhMrZmIsM7J3qS+FDEZyq2thH5Y95wjpTDD6/8JB80GvQZvcoa/awRCRcWUqYUKAwxOxOiMIPIch+iySWSPr5Sj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=TDkPVqty; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="TDkPVqty"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4BEC160253
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Jan 2026 02:43:02 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1769564582;
	bh=6KVHVSIcHbFrxEix1stfunETMTvGKdHlKkdbXB8VTXI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=TDkPVqty0EmvwWuMJAU5AtN3B3XeOslJ39lBGqf5rnkCxL5RamQ6rR8dm6UI4gTvb
	 h2nFpgYCIrWvnLfA++1/bKzUIJjNq4DWfeKT4vr42xtGb+qJWe+q291Z8jB+i+W1k8
	 7WsVLQ7ZFTGLQ5OEvBuCGXlgp0XQZtDJiUcbXEswUtVVMv9uavVTnuWB4O4r6bzZUl
	 Jq1JvSutg5+WFV16wiXhEnOjKvI4c3eAOKb8zb4RfXjkSof0jPsU9uLJiGpKCz8f1k
	 1GIs4775z+LzvKRVyaanoADiCWEcZBM3QACO+i0K85joVpVNjUk+6Vmo312iK8FCxu
	 x4I5Y1o2L2eLQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 4/4] netfilter: nft_set_rbtree: validate open interval overlap
Date: Wed, 28 Jan 2026 02:42:51 +0100
Message-ID: <20260128014251.754512-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260128014251.754512-1-pablo@netfilter.org>
References: <20260128014251.754512-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Open intervals do not have an end element, in particular an open
interval at the end of the set is hard to validate because of it is
lacking the end element, and interval validation relies on such end
element to perform the checks.

This patch adds a new flag field to struct nft_set_elem, this is not an
issue because this is a temporary object that is allocated in the stack
from the insert/deactivate path. This flag field is used to specify that
this is the last element in this add/delete command.

The last flag is used, in combination with the start element cookie, to
check if there is a partial overlap, eg.

   Already exists:   255.255.255.0-255.255.255.254
   Add interval:     255.255.255.0-255.255.255.255
                     ~~~~~~~~~~~~~
             start element overlap

Basically, the idea is to check for an existing end element in the set
if there is an overlap with an existing start element.

However, the last open interval can come in any position in the add
command, the corner case can get a bit more complicated:

   Already exists:   255.255.255.0-255.255.255.254
   Add intervals:    255.255.255.0-255.255.255.255,255.255.255.0-255.255.255.254
                     ~~~~~~~~~~~~~
             start element overlap

To catch this overlap, annotate that the new start element is a possible
overlap, then report the overlap if the next element is another start
element that confirms that previous element in an open interval at the
end of the set.

For deletions, do not update the start cookie when deleting an open interval,
otherwise this can trigger spurious EEXIST when adding new elements.

Fixes: 7c84d41416d8 ("netfilter: nft_set_rbtree: Detect partial overlaps on insertion")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  4 ++
 net/netfilter/nf_tables_api.c     | 21 ++++++++--
 net/netfilter/nft_set_rbtree.c    | 70 +++++++++++++++++++++++++++----
 3 files changed, 82 insertions(+), 13 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index f1b67b40dd4d..05f57ba62244 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -278,6 +278,8 @@ struct nft_userdata {
 	unsigned char		data[];
 };
 
+#define NFT_SET_ELEM_INTERNAL_LAST	0x1
+
 /* placeholder structure for opaque set element backend representation. */
 struct nft_elem_priv { };
 
@@ -287,6 +289,7 @@ struct nft_elem_priv { };
  *	@key: element key
  *	@key_end: closing element key
  *	@data: element data
+ * 	@flags: flags
  *	@priv: element private data and extensions
  */
 struct nft_set_elem {
@@ -302,6 +305,7 @@ struct nft_set_elem {
 		u32		buf[NFT_DATA_VALUE_MAXLEN / sizeof(u32)];
 		struct nft_data val;
 	} data;
+	u32			flags;
 	struct nft_elem_priv	*priv;
 };
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a3649d88ac64..4cdb3691f9f8 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7269,7 +7269,8 @@ static u32 nft_set_maxsize(const struct nft_set *set)
 }
 
 static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
-			    const struct nlattr *attr, u32 nlmsg_flags)
+			    const struct nlattr *attr, u32 nlmsg_flags,
+			    bool last)
 {
 	struct nft_expr *expr_array[NFT_SET_EXPR_MAX] = {};
 	struct nlattr *nla[NFTA_SET_ELEM_MAX + 1];
@@ -7555,6 +7556,11 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	if (flags)
 		*nft_set_ext_flags(ext) = flags;
 
+	if (last)
+		elem.flags = NFT_SET_ELEM_INTERNAL_LAST;
+	else
+		elem.flags = 0;
+
 	if (obj)
 		*nft_set_ext_obj(ext) = obj;
 
@@ -7718,7 +7724,8 @@ static int nf_tables_newsetelem(struct sk_buff *skb,
 	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
 
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
-		err = nft_add_set_elem(&ctx, set, attr, info->nlh->nlmsg_flags);
+		err = nft_add_set_elem(&ctx, set, attr, info->nlh->nlmsg_flags,
+				       nla_is_last(attr, rem));
 		if (err < 0) {
 			NL_SET_BAD_ATTR(extack, attr);
 			return err;
@@ -7842,7 +7849,7 @@ static void nft_trans_elems_destroy_abort(const struct nft_ctx *ctx,
 }
 
 static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
-			   const struct nlattr *attr)
+			   const struct nlattr *attr, bool last)
 {
 	struct nlattr *nla[NFTA_SET_ELEM_MAX + 1];
 	struct nft_set_ext_tmpl tmpl;
@@ -7910,6 +7917,11 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	if (flags)
 		*nft_set_ext_flags(ext) = flags;
 
+	if (last)
+		elem.flags = NFT_SET_ELEM_INTERNAL_LAST;
+	else
+		elem.flags = 0;
+
 	trans = nft_trans_elem_alloc(ctx, NFT_MSG_DELSETELEM, set);
 	if (trans == NULL)
 		goto fail_trans;
@@ -8057,7 +8069,8 @@ static int nf_tables_delsetelem(struct sk_buff *skb,
 		return nft_set_flush(&ctx, set, genmask);
 
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
-		err = nft_del_setelem(&ctx, set, attr);
+		err = nft_del_setelem(&ctx, set, attr,
+				      nla_is_last(attr, rem));
 		if (err == -ENOENT &&
 		    NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_DESTROYSETELEM)
 			continue;
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 6580b8e2ec25..fc9f1e12a43d 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -309,9 +309,20 @@ static void nft_rbtree_set_start_cookie(struct nft_rbtree *priv,
 	priv->start_rbe_cookie = (unsigned long)rbe;
 }
 
+static void nft_rbtree_set_start_cookie_open(struct nft_rbtree *priv,
+					     const struct nft_rbtree_elem *rbe,
+					     unsigned long open_interval)
+{
+	priv->start_rbe_cookie = (unsigned long)rbe | open_interval;
+}
+
+#define NFT_RBTREE_OPEN_INTERVAL	1UL
+
 static bool nft_rbtree_cmp_start_cookie(struct nft_rbtree *priv,
 					const struct nft_rbtree_elem *rbe)
 {
+	return (priv->start_rbe_cookie & ~NFT_RBTREE_OPEN_INTERVAL) == (unsigned long)rbe;
+
 	return priv->start_rbe_cookie == (unsigned long)rbe;
 }
 
@@ -342,7 +353,7 @@ static bool nft_rbtree_insert_same_interval(const struct net *net,
 
 static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			       struct nft_rbtree_elem *new,
-			       struct nft_elem_priv **elem_priv)
+			       struct nft_elem_priv **elem_priv, bool last)
 {
 	struct nft_rbtree_elem *rbe, *rbe_le = NULL, *rbe_ge = NULL, *rbe_prev;
 	struct rb_node *node, *next, *parent, **p, *first = NULL;
@@ -350,6 +361,7 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 	u8 cur_genmask = nft_genmask_cur(net);
 	u8 genmask = nft_genmask_next(net);
 	u64 tstamp = nft_net_tstamp(net);
+	unsigned long open_interval = 0;
 	int d;
 
 	/* Descend the tree to search for an existing element greater than the
@@ -455,10 +467,18 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 		}
 	}
 
-	if (nft_rbtree_interval_null(set, new))
-		priv->start_rbe_cookie = 0;
-	else if (nft_rbtree_interval_start(new) && priv->start_rbe_cookie)
+	if (nft_rbtree_interval_null(set, new)) {
 		priv->start_rbe_cookie = 0;
+	} else if (nft_rbtree_interval_start(new) && priv->start_rbe_cookie) {
+		if (nft_set_is_anonymous(set)) {
+			priv->start_rbe_cookie = 0;
+		} else if (priv->start_rbe_cookie & NFT_RBTREE_OPEN_INTERVAL) {
+			/* Previous element is an open interval that partially
+			 * overlaps with an existing non-open interval.
+			 */
+			return -ENOTEMPTY;
+		}
+	}
 
 	/* - new start element matching existing start element: full overlap
 	 *   reported as -EEXIST, cleared by caller if NLM_F_EXCL is not given.
@@ -466,7 +486,26 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 	if (rbe_ge && !nft_rbtree_cmp(set, new, rbe_ge) &&
 	    nft_rbtree_interval_start(rbe_ge) == nft_rbtree_interval_start(new)) {
 		*elem_priv = &rbe_ge->priv;
-		nft_rbtree_set_start_cookie(priv, rbe_ge);
+
+		/* - Corner case: new start element of open interval (which
+		 *   comes as last element in the batch) overlaps the start of
+		 *   an existing interval with an end element: partial overlap.
+		 */
+		node = rb_first(&priv->root);
+		rbe = __nft_rbtree_next_active(node, genmask);
+		if (nft_rbtree_interval_end(rbe)) {
+			rbe = nft_rbtree_next_active(rbe, genmask);
+			if (nft_rbtree_interval_start(rbe) &&
+			    !nft_rbtree_cmp(set, new, rbe)) {
+				if (last)
+					return -ENOTEMPTY;
+
+				/* Maybe open interval? */
+				open_interval = 1UL;
+			}
+		}
+		nft_rbtree_set_start_cookie_open(priv, rbe_ge, open_interval);
+
 		return -EEXIST;
 	}
 
@@ -521,6 +560,12 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 	    nft_rbtree_interval_end(rbe_ge) && nft_rbtree_interval_end(new))
 		return -ENOTEMPTY;
 
+	/* - start element overlaps an open interval but end element is new:
+	 *   partial overlap, reported as -ENOEMPTY.
+	 */
+	if (!rbe_ge && priv->start_rbe_cookie && nft_rbtree_interval_end(new))
+		return -ENOTEMPTY;
+
 	/* Accepted element: pick insertion point depending on key value */
 	parent = NULL;
 	p = &priv->root.rb_node;
@@ -630,6 +675,7 @@ static int nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			     struct nft_elem_priv **elem_priv)
 {
 	struct nft_rbtree_elem *rbe = nft_elem_priv_cast(elem->priv);
+	bool last = !!(elem->flags & NFT_SET_ELEM_INTERNAL_LAST);
 	struct nft_rbtree *priv = nft_set_priv(set);
 	int err;
 
@@ -643,8 +689,12 @@ static int nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 		cond_resched();
 
 		write_lock_bh(&priv->lock);
-		err = __nft_rbtree_insert(net, set, rbe, elem_priv);
+		err = __nft_rbtree_insert(net, set, rbe, elem_priv, last);
 		write_unlock_bh(&priv->lock);
+
+		if (nft_rbtree_interval_end(rbe))
+			priv->start_rbe_cookie = 0;
+
 	} while (err == -EAGAIN);
 
 	return err;
@@ -732,6 +782,7 @@ nft_rbtree_deactivate(const struct net *net, const struct nft_set *set,
 		      const struct nft_set_elem *elem)
 {
 	struct nft_rbtree_elem *rbe, *this = nft_elem_priv_cast(elem->priv);
+	bool last = !!(elem->flags & NFT_SET_ELEM_INTERNAL_LAST);
 	struct nft_rbtree *priv = nft_set_priv(set);
 	const struct rb_node *parent = priv->root.rb_node;
 	u8 genmask = nft_genmask_next(net);
@@ -770,9 +821,10 @@ nft_rbtree_deactivate(const struct net *net, const struct nft_set *set,
 				continue;
 			}
 
-			if (nft_rbtree_interval_start(rbe))
-				nft_rbtree_set_start_cookie(priv, rbe);
-			else if (!nft_rbtree_deactivate_same_interval(net, priv, rbe))
+			if (nft_rbtree_interval_start(rbe)) {
+				if (!last)
+					nft_rbtree_set_start_cookie(priv, rbe);
+			} else if (!nft_rbtree_deactivate_same_interval(net, priv, rbe))
 				return NULL;
 
 			nft_rbtree_flush(net, set, &rbe->priv);
-- 
2.47.3

