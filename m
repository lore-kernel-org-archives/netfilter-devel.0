From: kaber@trash.net
Subject: =?UTF-8?q?=5BPATCH=204/5=5D=20netfilter=3A=20nf=5Ftables=3A=20propagate=20context=20to=20set=20iter=20callback?=
Date: Mon, 10 Dec 2012 18:20:11 +0100
Message-ID: <1355160012-13952-5-git-send-email-kaber@trash.net>
References: <1355160012-13952-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36285 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab2LJRbl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Dec 2012 12:31:41 -0500
In-Reply-To: <1355160012-13952-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Patrick McHardy <kaber@trash.net>

Needed when adding new elements and for performing loop detection.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/net/netfilter/nf_tables.h |  6 ++++--
 net/netfilter/nf_tables_api.c     | 36 +++++++++++++++----------------=
-----
 net/netfilter/nft_hash.c          |  5 +++--
 net/netfilter/nft_rbtree.c        |  6 ++++--
 4 Dateien ge=C3=A4ndert, 26 Zeilen hinzugef=C3=BCgt(+), 27 Zeilen entf=
ernt(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/=
nf_tables.h
index a3defd8..5e216de 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -122,7 +122,8 @@ struct nft_set_iter {
 	unsigned int	count;
 	unsigned int	skip;
 	int		err;
-	int		(*fn)(const struct nft_set *set,
+	int		(*fn)(const struct nft_ctx *ctx,
+			      const struct nft_set *set,
 			      const struct nft_set_iter *iter,
 			      const struct nft_set_elem *elem);
 };
@@ -151,7 +152,8 @@ struct nft_set_ops {
 						  const struct nft_set_elem *elem);
 	void				(*remove)(const struct nft_set *set,
 						  const struct nft_set_elem *elem);
-	void				(*walk)(const struct nft_set *set,
+	void				(*walk)(const struct nft_ctx *ctx,
+						const struct nft_set *set,
 						struct nft_set_iter *iter);
=20
 	unsigned int			(*privsize)(const struct nlattr * const nla[]);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_ap=
i.c
index c0f0cf06e..22b14a5 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1958,45 +1958,38 @@ static int nf_tables_delset(struct sock *nlsk, =
struct sk_buff *skb,
 	return 0;
 }
=20
-struct nft_set_bind_check_args {
-	struct nft_set_iter		iter;
-	const struct nft_ctx		*ctx;
-};
-
-static int nf_tables_bind_check_setelem(const struct nft_set *set,
+static int nf_tables_bind_check_setelem(const struct nft_ctx *ctx,
+					const struct nft_set *set,
 					const struct nft_set_iter *iter,
 					const struct nft_set_elem *elem)
 {
-	struct nft_set_bind_check_args *args;
 	enum nft_registers dreg;
=20
-	args =3D container_of(iter, struct nft_set_bind_check_args, iter);
 	dreg =3D nft_type_to_reg(set->dtype);
-	return nft_validate_data_load(args->ctx, dreg, &elem->data, set->dtyp=
e);
+	return nft_validate_data_load(ctx, dreg, &elem->data, set->dtype);
 }
=20
 int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
 		       struct nft_set_binding *binding)
 {
-	struct nft_set_bind_check_args args;
+	struct nft_set_iter iter;
=20
 	if (!list_empty(&set->bindings) && set->flags & NFT_SET_ANONYMOUS)
 		return -EBUSY;
=20
 	if (set->flags & NFT_SET_MAP) {
-		args.iter.skip 	=3D 0;
-		args.iter.count	=3D 0;
-		args.iter.err   =3D 0;
-		args.iter.fn	=3D nf_tables_bind_check_setelem;
-		args.ctx	=3D ctx;
-
-		set->ops->walk(set, &args.iter);
-		if (args.iter.err < 0) {
+		iter.skip 	=3D 0;
+		iter.count	=3D 0;
+		iter.err	=3D 0;
+		iter.fn		=3D nf_tables_bind_check_setelem;
+
+		set->ops->walk(ctx, set, &iter);
+		if (iter.err < 0) {
 			/* Destroy anonymous sets if binding fails */
 			if (set->flags & NFT_SET_ANONYMOUS)
 				nf_tables_set_destroy(ctx, set);
=20
-			return args.iter.err;
+			return iter.err;
 		}
 	}
=20
@@ -2091,7 +2084,8 @@ struct nft_set_dump_args {
 	struct sk_buff			*skb;
 };
=20
-static int nf_tables_dump_setelem(const struct nft_set *set,
+static int nf_tables_dump_setelem(const struct nft_ctx *ctx,
+				  const struct nft_set *set,
 				  const struct nft_set_iter *iter,
 				  const struct nft_set_elem *elem)
 {
@@ -2157,7 +2151,7 @@ static int nf_tables_dump_set(struct sk_buff *skb=
, struct netlink_callback *cb)
 	args.iter.count	=3D 0;
 	args.iter.err   =3D 0;
 	args.iter.fn	=3D nf_tables_dump_setelem;
-	set->ops->walk(set, &args.iter);
+	set->ops->walk(&ctx, set, &args.iter);
=20
 	nla_nest_end(skb, nest);
 	nlmsg_end(skb, nlh);
diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index 6c6addb..e50e798 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -127,7 +127,8 @@ static int nft_hash_get(const struct nft_set *set, =
struct nft_set_elem *elem)
 	return -ENOENT;
 }
=20
-static void nft_hash_walk(const struct nft_set *set, struct nft_set_it=
er *iter)
+static void nft_hash_walk(const struct nft_ctx *ctx, const struct nft_=
set *set,
+			  struct nft_set_iter *iter)
 {
 	const struct nft_hash *priv =3D nft_set_priv(set);
 	const struct nft_hash_elem *he;
@@ -145,7 +146,7 @@ static void nft_hash_walk(const struct nft_set *set=
, struct nft_set_iter *iter)
 				memcpy(&elem.data, he->data, sizeof(elem.data));
 			elem.flags =3D 0;
=20
-			iter->err =3D iter->fn(set, iter, &elem);
+			iter->err =3D iter->fn(ctx, set, iter, &elem);
 			if (iter->err < 0)
 				return;
 cont:
diff --git a/net/netfilter/nft_rbtree.c b/net/netfilter/nft_rbtree.c
index c51e779..ca0c1b2 100644
--- a/net/netfilter/nft_rbtree.c
+++ b/net/netfilter/nft_rbtree.c
@@ -162,7 +162,9 @@ static int nft_rbtree_get(const struct nft_set *set=
, struct nft_set_elem *elem)
 	return -ENOENT;
 }
=20
-static void nft_rbtree_walk(const struct nft_set *set, struct nft_set_=
iter *iter)
+static void nft_rbtree_walk(const struct nft_ctx *ctx,
+			    const struct nft_set *set,
+			    struct nft_set_iter *iter)
 {
 	const struct nft_rbtree *priv =3D nft_set_priv(set);
 	const struct nft_rbtree_elem *rbe;
@@ -179,7 +181,7 @@ static void nft_rbtree_walk(const struct nft_set *s=
et, struct nft_set_iter *iter
 			nft_data_copy(&elem.data, rbe->data);
 		elem.flags =3D rbe->flags;
=20
-		iter->err =3D iter->fn(set, iter, &elem);
+		iter->err =3D iter->fn(ctx, set, iter, &elem);
 		if (iter->err < 0)
 			return;
 cont:
--=20
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
