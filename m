From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [PATCH] netfilter: nf_tables: Add meta expression key for bridge interface name
Date: Tue, 25 Mar 2014 18:39:47 +0200
Message-ID: <1395765587-5399-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:41593 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382AbaCYQue (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2014 12:50:34 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

NFT_META_IBRIFNAME to get packet input bridge interface name
NFT_META_OBRIFNAME to get packet output bridge interface name

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---

Hi Pablo,

Does that design sounds proper?
I added the nft type right away in nft_meta.c
to reuse as much as possible, only the evaluation is a bit specific.

I haven't tested yet, I will do the support of this meta key for nft to=
ol
accordingly.

Tomasz

 include/uapi/linux/netfilter/nf_tables.h |  4 ++
 net/netfilter/nft_meta.c                 | 79 ++++++++++++++++++++++++=
+++++++-
 2 files changed, 81 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/li=
nux/netfilter/nf_tables.h
index 83c985a..e3c98f9 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -533,6 +533,8 @@ enum nft_exthdr_attributes {
  * @NFT_META_SECMARK: packet secmark (skb->secmark)
  * @NFT_META_NFPROTO: netfilter protocol
  * @NFT_META_L4PROTO: layer 4 protocol number
+ * @NFT_META_IBRIFNAME: packet input bridge interface name
+ * @NFT_META_OBRIFNAME: packet output bridge interface name
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -552,6 +554,8 @@ enum nft_meta_keys {
 	NFT_META_SECMARK,
 	NFT_META_NFPROTO,
 	NFT_META_L4PROTO,
+	NFT_META_IBRIFNAME,
+	NFT_META_OBRIFNAME,
 };
=20
 /**
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index e8254ad..60a7d63 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -18,6 +18,9 @@
 #include <net/sock.h>
 #include <net/tcp_states.h> /* for TCP_TIME_WAIT */
 #include <net/netfilter/nf_tables.h>
+#ifdef CONFIG_NF_TABLES_BRIDGE
+#include "../br_private.h"
+#endif
=20
 struct nft_meta {
 	enum nft_meta_keys	key:8;
@@ -141,6 +144,40 @@ err:
 	data[NFT_REG_VERDICT].verdict =3D NFT_BREAK;
 }
=20
+#ifdef CONFIG_NF_TABLES_BRIDGE
+static void nft_meta_bridge_get_eval(const struct nft_expr *expr,
+				     struct nft_data data[NFT_REG_MAX + 1],
+				     const struct nft_pktinfo *pkt)
+{
+	const struct net_device *in =3D pkt->in, *out =3D pkt->out;
+	struct nft_data *dest =3D &data[priv->dreg];
+	const struct net_bridge_port *p;
+
+	if (pkt->ops->pf !=3D NFPROTO_BRIDGE)
+		goto out;
+
+	switch (priv->key) {
+	case NFT_META_IBRIFNAME:
+		if (in =3D=3D NULL ||=C2=A0(p =3D br_port_get_rcu(in)) =3D=3D NULL)
+			goto err;
+		break;
+	case NFT_META_OBRIFNAME:
+		if (out =3D=3D NULL ||=C2=A0(p =3D br_port_get_rcu(out)) =3D=3D NULL=
)
+			goto err;
+		break;
+	default:
+		goto out;
+	}
+
+	strncpy((char *)dest->data, p->br->dev->name, sizeof(dest->data));
+	return;
+out:
+	return nft_meta_get_eval(expr, data, pkt);
+err:
+	data[NFT_REG_VERDICT].verdict =3D NFT_BREAK;
+}
+#endif
+
 static void nft_meta_set_eval(const struct nft_expr *expr,
 			      struct nft_data data[NFT_REG_MAX + 1],
 			      const struct nft_pktinfo *pkt)
@@ -205,6 +242,10 @@ static int nft_meta_init_validate_get(uint32_t key=
)
 #ifdef CONFIG_NETWORK_SECMARK
 	case NFT_META_SECMARK:
 #endif
+#ifdef CONFIG_NF_TABLES_BRIDGE
+	case NFT_META_IBRIFNAME:
+	case NFT_META_OBRIFNAME:
+#endif
 		return 0;
 	default:
 		return -EOPNOTSUPP;
@@ -294,6 +335,17 @@ static const struct nft_expr_ops nft_meta_set_ops =
=3D {
 	.dump		=3D nft_meta_set_dump,
 };
=20
+#ifdef CONFIG_NF_TABLES_BRIDGE
+static struct nft_expr_type nft_meta_bridge_type;
+static const struct nft_expr_ops nft_meta_bridge_get_ops =3D {
+	.type		=3D &nft_meta_type,
+	.size		=3D NFT_EXPR_SIZE(sizeof(struct nft_meta)),
+	.eval		=3D nft_meta_bridge_get_eval,
+	.init		=3D nft_meta_init,
+	.dump		=3D nft_meta_get_dump,
+};
+#endif
+
 static const struct nft_expr_ops *
 nft_meta_select_ops(const struct nft_ctx *ctx,
 		    const struct nlattr * const tb[])
@@ -304,8 +356,13 @@ nft_meta_select_ops(const struct nft_ctx *ctx,
 	if (tb[NFTA_META_DREG] && tb[NFTA_META_SREG])
 		return ERR_PTR(-EINVAL);
=20
-	if (tb[NFTA_META_DREG])
+	if (tb[NFTA_META_DREG]) {
+#ifdef CONFIG_NF_TABLES_BRIDGE
+		if (ctx->aif->family =3D=3D NFPROTO_BRIDGE)
+			return &nft_meta_bridge_get_ops;
+#endif
 		return &nft_meta_get_ops;
+	}
=20
 	if (tb[NFTA_META_SREG])
 		return &nft_meta_set_ops;
@@ -321,9 +378,27 @@ static struct nft_expr_type nft_meta_type __read_m=
ostly =3D {
 	.owner		=3D THIS_MODULE,
 };
=20
+#ifdef CONFIG_NF_TABLES_BRIDGE
+static struct nft_expr_type nft_meta_bridge_type __read_mostly =3D {
+	.family		=3D NFPROTO_BRIDGE,
+	.name		=3D "meta",
+	.select_ops	=3D &nft_meta_select_ops,
+	.policy		=3D nft_meta_policy,
+	.maxattr	=3D NFTA_META_MAX,
+	.owner		=3D THIS_MODULE,
+};
+#endif
+
 static int __init nft_meta_module_init(void)
 {
-	return nft_register_expr(&nft_meta_type);
+	int ret;
+
+	ret =3D nft_register_expr(&nft_meta_type);
+#ifdef CONFIG_NF_TABLES_BRIDGE
+	if (ret =3D=3D 0)
+		ret =3D nft_register_expr(&nft_meta_bridge_type);
+#endif
+	return ret;
 }
=20
 static void __exit nft_meta_module_exit(void)
--=20
1.8.3.2

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
