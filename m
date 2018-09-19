From: =?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>
Subject: [PATCH] netfilter: nf_tables: add SECMARK support
Date: Thu, 20 Sep 2018 01:14:02 +0200
Message-ID: <20180919231402.4482-1-cgzones@googlemail.com>
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
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Add the ability to set the security context of packets within the nf_tables framework.
Add a nft_object for holding security contexts in the kernel and manipulating packets on the wire.
The contexts are kept as strings and are evaluated to security identifiers at runtime (packet arrival),
so that the nft_objects do not need to be refreshed after security changes.
The maximum security context length is set to 256.

Based on v4.18.6

Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
---
 include/net/netfilter/nf_tables_core.h   |  4 +
 include/uapi/linux/netfilter/nf_tables.h | 18 ++++-
 net/netfilter/nf_tables_core.c           | 28 ++++++-
 net/netfilter/nft_meta.c                 | 95 ++++++++++++++++++++++++
 4 files changed, 140 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index a0513450..0d1f3b96 100644
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
index 89438e68..f1527962 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1169,6 +1169,21 @@ enum nft_quota_attributes {
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
@@ -1398,7 +1413,8 @@ enum nft_ct_helper_attributes {
 #define NFT_OBJECT_CT_HELPER	3
 #define NFT_OBJECT_LIMIT	4
 #define NFT_OBJECT_CONNLIMIT	5
-#define __NFT_OBJECT_MAX	6
+#define NFT_OBJECT_SECMARK	6
+#define __NFT_OBJECT_MAX	7
 #define NFT_OBJECT_MAX		(__NFT_OBJECT_MAX - 1)
 
 /**
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 8de912ca..d59ebba0 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -235,12 +235,24 @@ static struct nft_expr_type *nft_basic_types[] = {
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
@@ -248,8 +260,12 @@ int __init nf_tables_core_module_init(void)
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
 
@@ -260,4 +276,8 @@ void nf_tables_core_module_exit(void)
 	i = ARRAY_SIZE(nft_basic_types);
 	while (i-- > 0)
 		nft_unregister_expr(nft_basic_types[i]);
+
+	i = ARRAY_SIZE(nft_basic_objects);
+	while (i-- > 0)
+		nft_unregister_obj(nft_basic_objects[i]);
 }
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 1105a23b..26b79a3c 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -540,3 +540,98 @@ struct nft_expr_type nft_meta_type __read_mostly = {
 	.maxattr	= NFTA_META_MAX,
 	.owner		= THIS_MODULE,
 };
+
+#ifdef CONFIG_NETWORK_SECMARK
+
+struct nft_secmark {
+	char ctx[NFT_SECMARK_CTX_MAXLEN];
+	int len;
+};
+
+static const struct nla_policy nft_secmark_policy[NFTA_SECMARK_MAX + 1] = {
+	[NFTA_SECMARK_CTX]     = { .type = NLA_STRING, .len = NFT_SECMARK_CTX_MAXLEN },
+};
+
+
+static void nft_secmark_obj_eval(struct nft_object *obj, struct nft_regs *regs, const struct nft_pktinfo *pkt)
+{
+	const struct nft_secmark *priv = nft_obj_data(obj);
+	struct sk_buff *skb = pkt->skb;
+	int err;
+	u32 secid = 0;
+
+	/* skip if packet has already a secmark */
+	if (skb->secmark)
+		return;
+
+	err = security_secctx_to_secid(priv->ctx, priv->len, &secid);
+	if (err) {
+		if (err == -EINVAL)
+			pr_notice_ratelimited("invalid security context \'%s\'\n", priv->ctx);
+		else
+			pr_notice_ratelimited("unable to convert security context \'%s\': %d\n", priv->ctx, -err);
+		return;
+	}
+
+	if (!secid) {
+		pr_notice_ratelimited("unable to map security context \'%s\'\n", priv->ctx);
+		return;
+	}
+
+	err = security_secmark_relabel_packet(secid);
+	if (err) {
+		pr_notice_ratelimited("unable to obtain relabeling permission: %d\n", -err);
+		return;
+	}
+
+	skb->secmark = secid;
+}
+
+
+static int nft_secmark_obj_init(const struct nft_ctx *ctx, const struct nlattr * const tb[], struct nft_object *obj)
+{
+	struct nft_secmark *priv = nft_obj_data(obj);
+
+	if (tb[NFTA_SECMARK_CTX] == NULL)
+		return -EINVAL;
+
+	nla_strlcpy(priv->ctx, tb[NFTA_SECMARK_CTX], NFT_SECMARK_CTX_MAXLEN);
+	priv->len = strlen(priv->ctx);
+
+	security_secmark_refcount_inc();
+
+	return 0;
+}
+
+static int nft_secmark_obj_dump(struct sk_buff *skb, struct nft_object *obj, bool reset)
+{
+	const struct nft_secmark *priv = nft_obj_data(obj);
+
+	if (nla_put_string(skb, NFTA_SECMARK_CTX, priv->ctx))
+		return -1;
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
