From: =?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>
Subject: [PATCH v2 1/2] netfilter: nf_tables: add SECMARK support
Date: Sun, 23 Sep 2018 11:16:10 +0200
Message-ID: <20180923091611.19815-1-cgzones@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        davem@davemloft.net, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, paul@paul-moore.com,
        sds@tycho.nsa.gov, eparis@parisplace.org, jmorris@namei.org,
        serge@hallyn.com, selinux@tycho.nsa.gov,
        linux-security-module@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Add the ability to set the security context of packets within the nf_tables framework.
Add a nft_object for holding security contexts in the kernel and manipulating packets on the wire.

Convert the security context strings at rule addition time to security identifiers.
This is the same behavior like in xt_SECMARK and offers better performance than computing it per packet.

Set the maximum security context length to 256.

Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
---

v2: convert security context strings to ids on rule addition time

Based on nf-next
Tested with v4.18.8

 include/net/netfilter/nf_tables_core.h   |   4 +
 include/uapi/linux/netfilter/nf_tables.h |  18 +++-
 net/netfilter/nf_tables_core.c           |  28 ++++++-
 net/netfilter/nft_meta.c                 | 101 +++++++++++++++++++++++
 4 files changed, 146 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index 8da837d2a..2046d104f 100644
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
index 702e4f0be..5444e7687 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1176,6 +1176,21 @@ enum nft_quota_attributes {
 };
 #define NFTA_QUOTA_MAX		(__NFTA_QUOTA_MAX - 1)
 
+/**
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
 /**
  * enum nft_reject_types - nf_tables reject expression reject types
  *
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
index ffd5c0f94..3fbce3b9c 100644
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
index 297fe7d97..ac5df9508 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -543,3 +543,104 @@ struct nft_expr_type nft_meta_type __read_mostly = {
 	.maxattr	= NFTA_META_MAX,
 	.owner		= THIS_MODULE,
 };
+
+#ifdef CONFIG_NETWORK_SECMARK
+
+struct nft_secmark {
+	char ctx[NFT_SECMARK_CTX_MAXLEN];
+	int len;
+	u32 secid;
+};
+
+static const struct nla_policy nft_secmark_policy[NFTA_SECMARK_MAX + 1] = {
+	[NFTA_SECMARK_CTX]     = { .type = NLA_STRING, .len = NFT_SECMARK_CTX_MAXLEN },
+};
+
+static int nft_secmark_secconversion(struct nft_secmark *priv)
+{
+	int err;
+	u32 tmp_secid = 0;
+
+	err = security_secctx_to_secid(priv->ctx, priv->len, &tmp_secid);
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
+static void nft_secmark_obj_eval(struct nft_object *obj, struct nft_regs *regs, const struct nft_pktinfo *pkt)
+{
+	const struct nft_secmark *priv = nft_obj_data(obj);
+	struct sk_buff *skb = pkt->skb;
+
+	skb->secmark = priv->secid;
+}
+
+
+static int nft_secmark_obj_init(const struct nft_ctx *ctx, const struct nlattr * const tb[], struct nft_object *obj)
+{
+	int err;
+	struct nft_secmark *priv = nft_obj_data(obj);
+
+	if (tb[NFTA_SECMARK_CTX] == NULL)
+		return -EINVAL;
+
+	nla_strlcpy(priv->ctx, tb[NFTA_SECMARK_CTX], NFT_SECMARK_CTX_MAXLEN);
+	priv->len = strlen(priv->ctx);
+
+	err = nft_secmark_secconversion(priv);
+	if (err)
+		return err;
+
+	security_secmark_refcount_inc();
+
+	return 0;
+}
+
+static int nft_secmark_obj_dump(struct sk_buff *skb, struct nft_object *obj, bool reset)
+{
+	int err;
+	struct nft_secmark *priv = nft_obj_data(obj);
+
+	if (nla_put_string(skb, NFTA_SECMARK_CTX, priv->ctx))
+		return -1;
+
+	if (reset) {
+		err = nft_secmark_secconversion(priv);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static void nft_secmark_obj_destroy(const struct nft_ctx *ctx, struct nft_object *obj)
+{
+	security_secmark_refcount_dec();
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
+
+#endif /* CONFIG_NETWORK_SECMARK */
-- 
2.19.0
