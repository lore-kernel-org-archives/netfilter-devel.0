From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 26/31] netfilter: nf_tables: add SECMARK support
Date: Tue,  9 Oct 2018 01:01:20 +0200
Message-ID: <20181008230125.2330-27-pablo@netfilter.org>
References: <20181008230125.2330-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181008230125.2330-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Christian Göttsche <cgzones@googlemail.com>

Add the ability to set the security context of packets within the nf_tables framework.
Add a nft_object for holding security contexts in the kernel and manipulating packets on the wire.

Convert the security context strings at rule addition time to security identifiers.
This is the same behavior like in xt_SECMARK and offers better performance than computing it per packet.

Set the maximum security context length to 256.

Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables_core.h   |   4 ++
 include/uapi/linux/netfilter/nf_tables.h |  18 +++++-
 net/netfilter/nf_tables_core.c           |  28 ++++++--
 net/netfilter/nft_meta.c                 | 108 +++++++++++++++++++++++++++++++
 4 files changed, 153 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index 8da837d2aaf9..2046d104f323 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -16,6 +16,10 @@ extern struct nft_expr_type nft_meta_type;
 extern struct nft_expr_type nft_rt_type;
 extern struct nft_expr_type nft_exthdr_type;
 
+#ifdef CONFIG_NETWORK_SECMARK
+extern struct nft_object_type nft_secmark_obj_type;
+#endif
+
 int nf_tables_core_module_init(void);
 void nf_tables_core_module_exit(void);
 
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 702e4f0bec56..5444e76870bb 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1177,6 +1177,21 @@ enum nft_quota_attributes {
 #define NFTA_QUOTA_MAX		(__NFTA_QUOTA_MAX - 1)
 
 /**
+ * enum nft_secmark_attributes - nf_tables secmark object netlink attributes
+ *
+ * @NFTA_SECMARK_CTX: security context (NLA_STRING)
+ */
+enum nft_secmark_attributes {
+	NFTA_SECMARK_UNSPEC,
+	NFTA_SECMARK_CTX,
+	__NFTA_SECMARK_MAX,
+};
+#define NFTA_SECMARK_MAX	(__NFTA_SECMARK_MAX - 1)
+
+/* Max security context length */
+#define NFT_SECMARK_CTX_MAXLEN		256
+
+/**
  * enum nft_reject_types - nf_tables reject expression reject types
  *
  * @NFT_REJECT_ICMP_UNREACH: reject using ICMP unreachable
@@ -1432,7 +1447,8 @@ enum nft_ct_timeout_timeout_attributes {
 #define NFT_OBJECT_CONNLIMIT	5
 #define NFT_OBJECT_TUNNEL	6
 #define NFT_OBJECT_CT_TIMEOUT	7
-#define __NFT_OBJECT_MAX	8
+#define NFT_OBJECT_SECMARK	8
+#define __NFT_OBJECT_MAX	9
 #define NFT_OBJECT_MAX		(__NFT_OBJECT_MAX - 1)
 
 /**
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index ffd5c0f9412b..3fbce3b9c5ec 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -249,12 +249,24 @@ static struct nft_expr_type *nft_basic_types[] = {
 	&nft_exthdr_type,
 };
 
+static struct nft_object_type *nft_basic_objects[] = {
+#ifdef CONFIG_NETWORK_SECMARK
+	&nft_secmark_obj_type,
+#endif
+};
+
 int __init nf_tables_core_module_init(void)
 {
-	int err, i;
+	int err, i, j = 0;
+
+	for (i = 0; i < ARRAY_SIZE(nft_basic_objects); i++) {
+		err = nft_register_obj(nft_basic_objects[i]);
+		if (err)
+			goto err;
+	}
 
-	for (i = 0; i < ARRAY_SIZE(nft_basic_types); i++) {
-		err = nft_register_expr(nft_basic_types[i]);
+	for (j = 0; j < ARRAY_SIZE(nft_basic_types); j++) {
+		err = nft_register_expr(nft_basic_types[j]);
 		if (err)
 			goto err;
 	}
@@ -262,8 +274,12 @@ int __init nf_tables_core_module_init(void)
 	return 0;
 
 err:
+	while (j-- > 0)
+		nft_unregister_expr(nft_basic_types[j]);
+
 	while (i-- > 0)
-		nft_unregister_expr(nft_basic_types[i]);
+		nft_unregister_obj(nft_basic_objects[i]);
+
 	return err;
 }
 
@@ -274,4 +290,8 @@ void nf_tables_core_module_exit(void)
 	i = ARRAY_SIZE(nft_basic_types);
 	while (i-- > 0)
 		nft_unregister_expr(nft_basic_types[i]);
+
+	i = ARRAY_SIZE(nft_basic_objects);
+	while (i-- > 0)
+		nft_unregister_obj(nft_basic_objects[i]);
 }
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 297fe7d97c18..91fd6e677ad7 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -543,3 +543,111 @@ struct nft_expr_type nft_meta_type __read_mostly = {
 	.maxattr	= NFTA_META_MAX,
 	.owner		= THIS_MODULE,
 };
+
+#ifdef CONFIG_NETWORK_SECMARK
+struct nft_secmark {
+	u32 secid;
+	char *ctx;
+};
+
+static const struct nla_policy nft_secmark_policy[NFTA_SECMARK_MAX + 1] = {
+	[NFTA_SECMARK_CTX]     = { .type = NLA_STRING, .len = NFT_SECMARK_CTX_MAXLEN },
+};
+
+static int nft_secmark_compute_secid(struct nft_secmark *priv)
+{
+	u32 tmp_secid = 0;
+	int err;
+
+	err = security_secctx_to_secid(priv->ctx, strlen(priv->ctx), &tmp_secid);
+	if (err)
+		return err;
+
+	if (!tmp_secid)
+		return -ENOENT;
+
+	err = security_secmark_relabel_packet(tmp_secid);
+	if (err)
+		return err;
+
+	priv->secid = tmp_secid;
+	return 0;
+}
+
+static void nft_secmark_obj_eval(struct nft_object *obj, struct nft_regs *regs,
+				 const struct nft_pktinfo *pkt)
+{
+	const struct nft_secmark *priv = nft_obj_data(obj);
+	struct sk_buff *skb = pkt->skb;
+
+	skb->secmark = priv->secid;
+}
+
+static int nft_secmark_obj_init(const struct nft_ctx *ctx,
+				const struct nlattr * const tb[],
+				struct nft_object *obj)
+{
+	struct nft_secmark *priv = nft_obj_data(obj);
+	int err;
+
+	if (tb[NFTA_SECMARK_CTX] == NULL)
+		return -EINVAL;
+
+	priv->ctx = nla_strdup(tb[NFTA_SECMARK_CTX], GFP_KERNEL);
+	if (!priv->ctx)
+		return -ENOMEM;
+
+	err = nft_secmark_compute_secid(priv);
+	if (err) {
+		kfree(priv->ctx);
+		return err;
+	}
+
+	security_secmark_refcount_inc();
+
+	return 0;
+}
+
+static int nft_secmark_obj_dump(struct sk_buff *skb, struct nft_object *obj,
+				bool reset)
+{
+	struct nft_secmark *priv = nft_obj_data(obj);
+	int err;
+
+	if (nla_put_string(skb, NFTA_SECMARK_CTX, priv->ctx))
+		return -1;
+
+	if (reset) {
+		err = nft_secmark_compute_secid(priv);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static void nft_secmark_obj_destroy(const struct nft_ctx *ctx, struct nft_object *obj)
+{
+	struct nft_secmark *priv = nft_obj_data(obj);
+
+	security_secmark_refcount_dec();
+
+	kfree(priv->ctx);
+}
+
+static const struct nft_object_ops nft_secmark_obj_ops = {
+	.type		= &nft_secmark_obj_type,
+	.size		= sizeof(struct nft_secmark),
+	.init		= nft_secmark_obj_init,
+	.eval		= nft_secmark_obj_eval,
+	.dump		= nft_secmark_obj_dump,
+	.destroy	= nft_secmark_obj_destroy,
+};
+struct nft_object_type nft_secmark_obj_type __read_mostly = {
+	.type		= NFT_OBJECT_SECMARK,
+	.ops		= &nft_secmark_obj_ops,
+	.maxattr	= NFTA_SECMARK_MAX,
+	.policy		= nft_secmark_policy,
+	.owner		= THIS_MODULE,
+};
+#endif /* CONFIG_NETWORK_SECMARK */
-- 
2.11.0
