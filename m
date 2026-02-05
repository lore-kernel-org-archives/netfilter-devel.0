Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6FCC3A1D01;
	Thu,  5 Feb 2026 11:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770289800; cv=none; b=fj5EmQZ+tGRzbUbfmX6CO63rnmOJYoDoL6pVcUvQC0H65/T+YPbbk1iJzS84cVRnu4K9mgYOb78CUP3XKeen93TOqFlIC8qU5O67MqBOtLqaVtieZ4upizQtfPkwoqUclTpcfrtJLiIVam3M4wXY1+lAEESVBtouw/H7DDdyxiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770289800; c=relaxed/simple;
	bh=t+VA+1KnUsG3gTJL4iYud+IRmOMz9Kx/wdSQYDaA6Fg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UJGzL+GXRwKTSspTgbZmeTOpnuTeOW+iUmMF3Gn5FYL5XYBK36Vt+QUSkiN0Lky2zdg+Xwk2cRSQF/rfTJKoBeWiGeZQt1XYzJ9mmzPTFLU45MDzUTYLR/nD/u2EC+OYoJNtHHO+uHDGuhroYKfJsryKBolCNQX9Sn3KisYxX2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4095860915; Thu, 05 Feb 2026 12:09:58 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 10/11] netfilter: nft_set_rbtree: validate open interval overlap
Date: Thu,  5 Feb 2026 12:09:04 +0100
Message-ID: <20260205110905.26629-11-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260205110905.26629-1-fw@strlen.de>
References: <20260205110905.26629-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

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

For deletions, do not update the start cookie when deleting an open
interval, otherwise this can trigger spurious EEXIST when adding new
elements.

Unfortunately, there is no NFT_SET_ELEM_INTERVAL_OPEN flag which would
make easier to detect open interval overlaps.

Fixes: 7c84d41416d8 ("netfilter: nft_set_rbtree: Detect partial overlaps on insertion")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables.h |  4 ++
 net/netfilter/nf_tables_api.c     | 21 +++++++--
 net/netfilter/nft_set_rbtree.c    | 71 ++++++++++++++++++++++++++-----
 3 files changed, 82 insertions(+), 14 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 31906f90706e..e08f736ee97d 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -277,6 +277,8 @@ struct nft_userdata {
 	unsigned char		data[];
 };
 
+#define NFT_SET_ELEM_INTERNAL_LAST	0x1
+
 /* placeholder structure for opaque set element backend representation. */
 struct nft_elem_priv { };
 
@@ -286,6 +288,7 @@ struct nft_elem_priv { };
  *	@key: element key
  *	@key_end: closing element key
  *	@data: element data
+ *	@flags: flags
  *	@priv: element private data and extensions
  */
 struct nft_set_elem {
@@ -301,6 +304,7 @@ struct nft_set_elem {
 		u32		buf[NFT_DATA_VALUE_MAXLEN / sizeof(u32)];
 		struct nft_data val;
 	} data;
+	u32			flags;
 	struct nft_elem_priv	*priv;
 };
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8ced4964eade..9923387907e3 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7270,7 +7270,8 @@ static u32 nft_set_maxsize(const struct nft_set *set)
 }
 
 static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
-			    const struct nlattr *attr, u32 nlmsg_flags)
+			    const struct nlattr *attr, u32 nlmsg_flags,
+			    bool last)
 {
 	struct nft_expr *expr_array[NFT_SET_EXPR_MAX] = {};
 	struct nlattr *nla[NFTA_SET_ELEM_MAX + 1];
@@ -7556,6 +7557,11 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	if (flags)
 		*nft_set_ext_flags(ext) = flags;
 
+	if (last)
+		elem.flags = NFT_SET_ELEM_INTERNAL_LAST;
+	else
+		elem.flags = 0;
+
 	if (obj)
 		*nft_set_ext_obj(ext) = obj;
 
@@ -7719,7 +7725,8 @@ static int nf_tables_newsetelem(struct sk_buff *skb,
 	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
 
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
-		err = nft_add_set_elem(&ctx, set, attr, info->nlh->nlmsg_flags);
+		err = nft_add_set_elem(&ctx, set, attr, info->nlh->nlmsg_flags,
+				       nla_is_last(attr, rem));
 		if (err < 0) {
 			NL_SET_BAD_ATTR(extack, attr);
 			return err;
@@ -7843,7 +7850,7 @@ static void nft_trans_elems_destroy_abort(const struct nft_ctx *ctx,
 }
 
 static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
-			   const struct nlattr *attr)
+			   const struct nlattr *attr, bool last)
 {
 	struct nlattr *nla[NFTA_SET_ELEM_MAX + 1];
 	struct nft_set_ext_tmpl tmpl;
@@ -7911,6 +7918,11 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
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
@@ -8058,7 +8070,8 @@ static int nf_tables_delsetelem(struct sk_buff *skb,
 		return nft_set_flush(&ctx, set, genmask);
 
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
-		err = nft_del_setelem(&ctx, set, attr);
+		err = nft_del_setelem(&ctx, set, attr,
+				      nla_is_last(attr, rem));
 		if (err == -ENOENT &&
 		    NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_DESTROYSETELEM)
 			continue;
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index fd4cd5d34b43..3ff52f2cbe5c 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -303,10 +303,19 @@ static void nft_rbtree_set_start_cookie(struct nft_rbtree *priv,
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
-	return priv->start_rbe_cookie == (unsigned long)rbe;
+	return (priv->start_rbe_cookie & ~NFT_RBTREE_OPEN_INTERVAL) == (unsigned long)rbe;
 }
 
 static bool nft_rbtree_insert_same_interval(const struct net *net,
@@ -336,13 +345,14 @@ static bool nft_rbtree_insert_same_interval(const struct net *net,
 
 static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			       struct nft_rbtree_elem *new,
-			       struct nft_elem_priv **elem_priv, u64 tstamp)
+			       struct nft_elem_priv **elem_priv, u64 tstamp, bool last)
 {
 	struct nft_rbtree_elem *rbe, *rbe_le = NULL, *rbe_ge = NULL, *rbe_prev;
 	struct rb_node *node, *next, *parent, **p, *first = NULL;
 	struct nft_rbtree *priv = nft_set_priv(set);
 	u8 cur_genmask = nft_genmask_cur(net);
 	u8 genmask = nft_genmask_next(net);
+	unsigned long open_interval = 0;
 	int d;
 
 	/* Descend the tree to search for an existing element greater than the
@@ -448,10 +458,18 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
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
@@ -459,7 +477,26 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
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
+				open_interval = NFT_RBTREE_OPEN_INTERVAL;
+			}
+		}
+		nft_rbtree_set_start_cookie_open(priv, rbe_ge, open_interval);
+
 		return -EEXIST;
 	}
 
@@ -514,6 +551,12 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
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
@@ -623,6 +666,7 @@ static int nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			     struct nft_elem_priv **elem_priv)
 {
 	struct nft_rbtree_elem *rbe = nft_elem_priv_cast(elem->priv);
+	bool last = !!(elem->flags & NFT_SET_ELEM_INTERNAL_LAST);
 	struct nft_rbtree *priv = nft_set_priv(set);
 	u64 tstamp = nft_net_tstamp(net);
 	int err;
@@ -639,8 +683,12 @@ static int nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 		cond_resched();
 
 		write_lock_bh(&priv->lock);
-		err = __nft_rbtree_insert(net, set, rbe, elem_priv, tstamp);
+		err = __nft_rbtree_insert(net, set, rbe, elem_priv, tstamp, last);
 		write_unlock_bh(&priv->lock);
+
+		if (nft_rbtree_interval_end(rbe))
+			priv->start_rbe_cookie = 0;
+
 	} while (err == -EAGAIN);
 
 	return err;
@@ -728,6 +776,7 @@ nft_rbtree_deactivate(const struct net *net, const struct nft_set *set,
 		      const struct nft_set_elem *elem)
 {
 	struct nft_rbtree_elem *rbe, *this = nft_elem_priv_cast(elem->priv);
+	bool last = !!(elem->flags & NFT_SET_ELEM_INTERNAL_LAST);
 	struct nft_rbtree *priv = nft_set_priv(set);
 	const struct rb_node *parent = priv->root.rb_node;
 	u8 genmask = nft_genmask_next(net);
@@ -768,10 +817,12 @@ nft_rbtree_deactivate(const struct net *net, const struct nft_set *set,
 				continue;
 			}
 
-			if (nft_rbtree_interval_start(rbe))
-				nft_rbtree_set_start_cookie(priv, rbe);
-			else if (!nft_rbtree_deactivate_same_interval(net, priv, rbe))
+			if (nft_rbtree_interval_start(rbe)) {
+				if (!last)
+					nft_rbtree_set_start_cookie(priv, rbe);
+			} else if (!nft_rbtree_deactivate_same_interval(net, priv, rbe)) {
 				return NULL;
+			}
 
 			nft_rbtree_flush(net, set, &rbe->priv);
 			return &rbe->priv;
-- 
2.52.0

