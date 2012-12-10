From: kaber@trash.net
Subject: =?UTF-8?q?=5BPATCH=205/5=5D=20netfilter=3A=20nf=5Ftables=3A=20add=20loop=20detection?=
Date: Mon, 10 Dec 2012 18:20:12 +0100
Message-ID: <1355160012-13952-6-git-send-email-kaber@trash.net>
References: <1355160012-13952-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36287 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab2LJRbm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Dec 2012 12:31:42 -0500
In-Reply-To: <1355160012-13952-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Patrick McHardy <kaber@trash.net>

Perform loop detection when adding new jump rules, new jump verdicts to
a verdict map or when binding a verdict map to a new chain.

The approach is pretty inefficient and probably can be improved by usin=
g
some caching. For now just the simple approach is used to perform loop
detection at all.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/net/netfilter/nf_tables.h |   1 +
 net/netfilter/nf_tables_api.c     | 113 ++++++++++++++++++++++++++++++=
+++++---
 net/netfilter/nft_immediate.c     |  11 ++++
 3 Dateien ge=C3=A4ndert, 118 Zeilen hinzugef=C3=BCgt(+), 7 Zeilen entf=
ernt(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/=
nf_tables.h
index 5e216de..99c500f 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -270,6 +270,7 @@ struct nft_expr_ops {
 	void				(*destroy)(const struct nft_expr *expr);
 	int				(*dump)(struct sk_buff *skb,
 						const struct nft_expr *expr);
+	const struct nft_data *		(*get_verdict)(const struct nft_expr *expr);
 	const struct nft_expr_type	*type;
 };
=20
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_ap=
i.c
index 22b14a5..2253593 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1972,12 +1972,21 @@ static int nf_tables_bind_check_setelem(const s=
truct nft_ctx *ctx,
 int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
 		       struct nft_set_binding *binding)
 {
+	struct nft_set_binding *i;
 	struct nft_set_iter iter;
=20
 	if (!list_empty(&set->bindings) && set->flags & NFT_SET_ANONYMOUS)
 		return -EBUSY;
=20
 	if (set->flags & NFT_SET_MAP) {
+		/* If the set is already bound to the same chain all
+		 * jumps are already validated for that chain.
+		 */
+		list_for_each_entry(i, &set->bindings, list) {
+			if (i->chain =3D=3D binding->chain)
+				goto bind;
+		}
+
 		iter.skip 	=3D 0;
 		iter.count	=3D 0;
 		iter.err	=3D 0;
@@ -1992,7 +2001,7 @@ int nf_tables_bind_set(const struct nft_ctx *ctx,=
 struct nft_set *set,
 			return iter.err;
 		}
 	}
-
+bind:
 	binding->chain =3D ctx->chain;
 	list_add_tail(&binding->list, &set->bindings);
 	return 0;
@@ -2457,6 +2466,90 @@ static const struct nfnetlink_subsystem nf_table=
s_subsys =3D {
 	.cb		=3D nf_tables_cb,
 };
=20
+/*
+ * Loop detection - walk through the ruleset beginning at the destinat=
ion chain
+ * of a new jump until either the source chain is reached (loop) or al=
l
+ * reachable chains have been traversed.
+ *
+ * The loop check is performed whenever a new jump verdict is added to=
 an
+ * expression or verdict map or a verdict map is bound to a new chain.
+ */
+
+static int nf_tables_check_loops(const struct nft_ctx *ctx,
+				 const struct nft_chain *chain);
+
+static int nf_tables_loop_check_setelem(const struct nft_ctx *ctx,
+					const struct nft_set *set,
+					const struct nft_set_iter *iter,
+					const struct nft_set_elem *elem)
+{
+	switch (elem->data.verdict) {
+	case NFT_JUMP:
+	case NFT_GOTO:
+		return nf_tables_check_loops(ctx, elem->data.chain);
+	default:
+		return 0;
+	}
+}
+
+static int nf_tables_check_loops(const struct nft_ctx *ctx,
+				 const struct nft_chain *chain)
+{
+	const struct nft_rule *rule;
+	const struct nft_expr *expr, *last;
+	const struct nft_data *data;
+	const struct nft_set *set;
+	struct nft_set_binding *binding;
+	struct nft_set_iter iter;
+	int err;
+
+	if (ctx->chain =3D=3D chain)
+		return -ELOOP;
+
+	list_for_each_entry(rule, &chain->rules, list) {
+		nft_rule_for_each_expr(expr, last, rule) {
+			if (!expr->ops->get_verdict)
+				continue;
+
+			data =3D expr->ops->get_verdict(expr);
+			if (data =3D=3D NULL)
+				break;
+
+			switch (data->verdict) {
+			case NFT_JUMP:
+			case NFT_GOTO:
+				err =3D nf_tables_check_loops(ctx, data->chain);
+				if (err < 0)
+					return err;
+			default:
+				break;
+			}
+		}
+	}
+
+	list_for_each_entry(set, &ctx->table->sets, list) {
+		if (!(set->flags & NFT_SET_MAP) ||
+		    set->dtype !=3D NFT_DATA_VERDICT)
+			continue;
+
+		list_for_each_entry(binding, &set->bindings, list) {
+			if (binding->chain !=3D chain)
+				continue;
+
+			iter.skip 	=3D 0;
+			iter.count	=3D 0;
+			iter.err	=3D 0;
+			iter.fn		=3D nf_tables_loop_check_setelem;
+
+			set->ops->walk(ctx, set, &iter);
+			if (iter.err < 0)
+				return iter.err;
+		}
+	}
+
+	return 0;
+}
+
 /**
  *	nft_validate_input_register - validate an expressions' input regist=
er
  *
@@ -2510,19 +2603,25 @@ int nft_validate_data_load(const struct nft_ctx=
 *ctx, enum nft_registers reg,
 			   const struct nft_data *data,
 			   enum nft_data_types type)
 {
+	int err;
+
 	switch (reg) {
 	case NFT_REG_VERDICT:
 		if (data =3D=3D NULL || type !=3D NFT_DATA_VERDICT)
 			return -EINVAL;
=20
-		if ((data->verdict =3D=3D NFT_GOTO || data->verdict =3D=3D NFT_JUMP)=
 &&
-		    ctx->chain->level + 1 > data->chain->level) {
-			if (ctx->chain->level + 1 =3D=3D NFT_JUMP_STACK_SIZE)
-				return -EMLINK;
-			data->chain->level =3D ctx->chain->level + 1;
+		if (data->verdict =3D=3D NFT_GOTO || data->verdict =3D=3D NFT_JUMP) =
{
+			err =3D nf_tables_check_loops(ctx, data->chain);
+			if (err < 0)
+				return err;
+
+			if (ctx->chain->level + 1 > data->chain->level) {
+				if (ctx->chain->level + 1 =3D=3D NFT_JUMP_STACK_SIZE)
+					return -EMLINK;
+				data->chain->level =3D ctx->chain->level + 1;
+			}
 		}
=20
-		// FIXME: do loop detection
 		return 0;
 	default:
 		if (data !=3D NULL && type !=3D NFT_DATA_VALUE)
diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediat=
e.c
index d1e901e..1bfeeaf 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -90,6 +90,16 @@ nla_put_failure:
 	return -1;
 }
=20
+static const struct nft_data *nft_immediate_get_verdict(const struct n=
ft_expr *expr)
+{
+	const struct nft_immediate_expr *priv =3D nft_expr_priv(expr);
+
+	if (priv->dreg =3D=3D NFT_REG_VERDICT)
+		return &priv->data;
+	else
+		return NULL;
+}
+
 static struct nft_expr_type nft_imm_type;
 static const struct nft_expr_ops nft_imm_ops =3D {
 	.type		=3D &nft_imm_type,
@@ -98,6 +108,7 @@ static const struct nft_expr_ops nft_imm_ops =3D {
 	.init		=3D nft_immediate_init,
 	.destroy	=3D nft_immediate_destroy,
 	.dump		=3D nft_immediate_dump,
+	.get_verdict	=3D nft_immediate_get_verdict,
 };
=20
 static struct nft_expr_type nft_imm_type __read_mostly =3D {
--=20
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
