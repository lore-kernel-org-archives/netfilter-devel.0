From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next] netfilter: nf_tables: simplify the basic expressions' init routine
Date: Sun,  6 Nov 2016 21:15:51 +0800
Message-ID: <1478438151-30598-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-11.163.com ([220.181.12.11]:46457 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751577AbcKFNQ3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 6 Nov 2016 08:16:29 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

Some basic expressions are built into nf_tables.ko, such as nft_cmp,
nft_lookup, nft_range and so on. But these basic expressions' init
routine is a little ugly, too many goto errX labels, and we forget
to call nft_range_module_exit in the exit routine, although it is
harmless.

Acctually, the init and exit routines of these basic expressions
are same, i.e. do nft_register_expr in the init routine and do
nft_unregister_expr in the exit routine.

So it's better to arrange them into an array and deal with them
together.

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 include/net/netfilter/nf_tables_core.h | 33 ++++----------
 net/netfilter/nf_tables_core.c         | 80 +++++++++++-----------------------
 net/netfilter/nft_bitwise.c            | 13 +-----
 net/netfilter/nft_byteorder.c          | 13 +-----
 net/netfilter/nft_cmp.c                | 13 +-----
 net/netfilter/nft_dynset.c             | 13 +-----
 net/netfilter/nft_immediate.c          | 13 +-----
 net/netfilter/nft_lookup.c             | 13 +-----
 net/netfilter/nft_payload.c            | 13 +-----
 net/netfilter/nft_range.c              | 13 +-----
 10 files changed, 43 insertions(+), 174 deletions(-)

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index 00f4f6b..862373d 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -1,12 +1,18 @@
 #ifndef _NET_NF_TABLES_CORE_H
 #define _NET_NF_TABLES_CORE_H
 
+extern struct nft_expr_type nft_imm_type;
+extern struct nft_expr_type nft_cmp_type;
+extern struct nft_expr_type nft_lookup_type;
+extern struct nft_expr_type nft_bitwise_type;
+extern struct nft_expr_type nft_byteorder_type;
+extern struct nft_expr_type nft_payload_type;
+extern struct nft_expr_type nft_dynset_type;
+extern struct nft_expr_type nft_range_type;
+
 int nf_tables_core_module_init(void);
 void nf_tables_core_module_exit(void);
 
-int nft_immediate_module_init(void);
-void nft_immediate_module_exit(void);
-
 struct nft_cmp_fast_expr {
 	u32			data;
 	enum nft_registers	sreg:8;
@@ -25,24 +31,6 @@ static inline u32 nft_cmp_fast_mask(unsigned int len)
 
 extern const struct nft_expr_ops nft_cmp_fast_ops;
 
-int nft_cmp_module_init(void);
-void nft_cmp_module_exit(void);
-
-int nft_range_module_init(void);
-void nft_range_module_exit(void);
-
-int nft_lookup_module_init(void);
-void nft_lookup_module_exit(void);
-
-int nft_dynset_module_init(void);
-void nft_dynset_module_exit(void);
-
-int nft_bitwise_module_init(void);
-void nft_bitwise_module_exit(void);
-
-int nft_byteorder_module_init(void);
-void nft_byteorder_module_exit(void);
-
 struct nft_payload {
 	enum nft_payload_bases	base:8;
 	u8			offset;
@@ -62,7 +50,4 @@ struct nft_payload_set {
 extern const struct nft_expr_ops nft_payload_fast_ops;
 extern struct static_key_false nft_trace_enabled;
 
-int nft_payload_module_init(void);
-void nft_payload_module_exit(void);
-
 #endif /* _NET_NF_TABLES_CORE_H */
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index b63b1ed..65dbead 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -232,68 +232,40 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 }
 EXPORT_SYMBOL_GPL(nft_do_chain);
 
+static struct nft_expr_type *nft_basic_types[] = {
+	&nft_imm_type,
+	&nft_cmp_type,
+	&nft_lookup_type,
+	&nft_bitwise_type,
+	&nft_byteorder_type,
+	&nft_payload_type,
+	&nft_dynset_type,
+	&nft_range_type,
+};
+
 int __init nf_tables_core_module_init(void)
 {
-	int err;
-
-	err = nft_immediate_module_init();
-	if (err < 0)
-		goto err1;
-
-	err = nft_cmp_module_init();
-	if (err < 0)
-		goto err2;
-
-	err = nft_lookup_module_init();
-	if (err < 0)
-		goto err3;
-
-	err = nft_bitwise_module_init();
-	if (err < 0)
-		goto err4;
+	int err, i;
 
-	err = nft_byteorder_module_init();
-	if (err < 0)
-		goto err5;
-
-	err = nft_payload_module_init();
-	if (err < 0)
-		goto err6;
-
-	err = nft_dynset_module_init();
-	if (err < 0)
-		goto err7;
-
-	err = nft_range_module_init();
-	if (err < 0)
-		goto err8;
+	for (i = 0; i < ARRAY_SIZE(nft_basic_types); i++) {
+		err = nft_register_expr(nft_basic_types[i]);
+		if (err)
+			goto err;
+	}
 
 	return 0;
-err8:
-	nft_dynset_module_exit();
-err7:
-	nft_payload_module_exit();
-err6:
-	nft_byteorder_module_exit();
-err5:
-	nft_bitwise_module_exit();
-err4:
-	nft_lookup_module_exit();
-err3:
-	nft_cmp_module_exit();
-err2:
-	nft_immediate_module_exit();
-err1:
+
+err:
+	while (i-- > 0)
+		nft_unregister_expr(nft_basic_types[i]);
 	return err;
 }
 
 void nf_tables_core_module_exit(void)
 {
-	nft_dynset_module_exit();
-	nft_payload_module_exit();
-	nft_byteorder_module_exit();
-	nft_bitwise_module_exit();
-	nft_lookup_module_exit();
-	nft_cmp_module_exit();
-	nft_immediate_module_exit();
+	int i;
+
+	i = ARRAY_SIZE(nft_basic_types);
+	while (i-- > 0)
+		nft_unregister_expr(nft_basic_types[i]);
 }
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 31c15ed..877d9ac 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -121,7 +121,6 @@ static int nft_bitwise_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	return -1;
 }
 
-static struct nft_expr_type nft_bitwise_type;
 static const struct nft_expr_ops nft_bitwise_ops = {
 	.type		= &nft_bitwise_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_bitwise)),
@@ -130,20 +129,10 @@ static const struct nft_expr_ops nft_bitwise_ops = {
 	.dump		= nft_bitwise_dump,
 };
 
-static struct nft_expr_type nft_bitwise_type __read_mostly = {
+struct nft_expr_type nft_bitwise_type __read_mostly = {
 	.name		= "bitwise",
 	.ops		= &nft_bitwise_ops,
 	.policy		= nft_bitwise_policy,
 	.maxattr	= NFTA_BITWISE_MAX,
 	.owner		= THIS_MODULE,
 };
-
-int __init nft_bitwise_module_init(void)
-{
-	return nft_register_expr(&nft_bitwise_type);
-}
-
-void nft_bitwise_module_exit(void)
-{
-	nft_unregister_expr(&nft_bitwise_type);
-}
diff --git a/net/netfilter/nft_byteorder.c b/net/netfilter/nft_byteorder.c
index ee63d98..13d4e42 100644
--- a/net/netfilter/nft_byteorder.c
+++ b/net/netfilter/nft_byteorder.c
@@ -169,7 +169,6 @@ static int nft_byteorder_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	return -1;
 }
 
-static struct nft_expr_type nft_byteorder_type;
 static const struct nft_expr_ops nft_byteorder_ops = {
 	.type		= &nft_byteorder_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_byteorder)),
@@ -178,20 +177,10 @@ static const struct nft_expr_ops nft_byteorder_ops = {
 	.dump		= nft_byteorder_dump,
 };
 
-static struct nft_expr_type nft_byteorder_type __read_mostly = {
+struct nft_expr_type nft_byteorder_type __read_mostly = {
 	.name		= "byteorder",
 	.ops		= &nft_byteorder_ops,
 	.policy		= nft_byteorder_policy,
 	.maxattr	= NFTA_BYTEORDER_MAX,
 	.owner		= THIS_MODULE,
 };
-
-int __init nft_byteorder_module_init(void)
-{
-	return nft_register_expr(&nft_byteorder_type);
-}
-
-void nft_byteorder_module_exit(void)
-{
-	nft_unregister_expr(&nft_byteorder_type);
-}
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index e25b35d..2b96eff 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -107,7 +107,6 @@ static int nft_cmp_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	return -1;
 }
 
-static struct nft_expr_type nft_cmp_type;
 static const struct nft_expr_ops nft_cmp_ops = {
 	.type		= &nft_cmp_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_cmp_expr)),
@@ -208,20 +207,10 @@ nft_cmp_select_ops(const struct nft_ctx *ctx, const struct nlattr * const tb[])
 		return &nft_cmp_ops;
 }
 
-static struct nft_expr_type nft_cmp_type __read_mostly = {
+struct nft_expr_type nft_cmp_type __read_mostly = {
 	.name		= "cmp",
 	.select_ops	= nft_cmp_select_ops,
 	.policy		= nft_cmp_policy,
 	.maxattr	= NFTA_CMP_MAX,
 	.owner		= THIS_MODULE,
 };
-
-int __init nft_cmp_module_init(void)
-{
-	return nft_register_expr(&nft_cmp_type);
-}
-
-void nft_cmp_module_exit(void)
-{
-	nft_unregister_expr(&nft_cmp_type);
-}
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 517f087..4339e3f1 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -261,7 +261,6 @@ static int nft_dynset_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	return -1;
 }
 
-static struct nft_expr_type nft_dynset_type;
 static const struct nft_expr_ops nft_dynset_ops = {
 	.type		= &nft_dynset_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_dynset)),
@@ -271,20 +270,10 @@ static const struct nft_expr_ops nft_dynset_ops = {
 	.dump		= nft_dynset_dump,
 };
 
-static struct nft_expr_type nft_dynset_type __read_mostly = {
+struct nft_expr_type nft_dynset_type __read_mostly = {
 	.name		= "dynset",
 	.ops		= &nft_dynset_ops,
 	.policy		= nft_dynset_policy,
 	.maxattr	= NFTA_DYNSET_MAX,
 	.owner		= THIS_MODULE,
 };
-
-int __init nft_dynset_module_init(void)
-{
-	return nft_register_expr(&nft_dynset_type);
-}
-
-void nft_dynset_module_exit(void)
-{
-	nft_unregister_expr(&nft_dynset_type);
-}
diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index 4528ade..728baf8 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -102,7 +102,6 @@ static int nft_immediate_validate(const struct nft_ctx *ctx,
 	return 0;
 }
 
-static struct nft_expr_type nft_imm_type;
 static const struct nft_expr_ops nft_imm_ops = {
 	.type		= &nft_imm_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_immediate_expr)),
@@ -113,20 +112,10 @@ static const struct nft_expr_ops nft_imm_ops = {
 	.validate	= nft_immediate_validate,
 };
 
-static struct nft_expr_type nft_imm_type __read_mostly = {
+struct nft_expr_type nft_imm_type __read_mostly = {
 	.name		= "immediate",
 	.ops		= &nft_imm_ops,
 	.policy		= nft_immediate_policy,
 	.maxattr	= NFTA_IMMEDIATE_MAX,
 	.owner		= THIS_MODULE,
 };
-
-int __init nft_immediate_module_init(void)
-{
-	return nft_register_expr(&nft_imm_type);
-}
-
-void nft_immediate_module_exit(void)
-{
-	nft_unregister_expr(&nft_imm_type);
-}
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index a8ce49b..d4f97fa 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -154,7 +154,6 @@ static int nft_lookup_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	return -1;
 }
 
-static struct nft_expr_type nft_lookup_type;
 static const struct nft_expr_ops nft_lookup_ops = {
 	.type		= &nft_lookup_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_lookup)),
@@ -164,20 +163,10 @@ static const struct nft_expr_ops nft_lookup_ops = {
 	.dump		= nft_lookup_dump,
 };
 
-static struct nft_expr_type nft_lookup_type __read_mostly = {
+struct nft_expr_type nft_lookup_type __read_mostly = {
 	.name		= "lookup",
 	.ops		= &nft_lookup_ops,
 	.policy		= nft_lookup_policy,
 	.maxattr	= NFTA_LOOKUP_MAX,
 	.owner		= THIS_MODULE,
 };
-
-int __init nft_lookup_module_init(void)
-{
-	return nft_register_expr(&nft_lookup_type);
-}
-
-void nft_lookup_module_exit(void)
-{
-	nft_unregister_expr(&nft_lookup_type);
-}
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index b2f8861..98fb5d7 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -148,7 +148,6 @@ static int nft_payload_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	return -1;
 }
 
-static struct nft_expr_type nft_payload_type;
 static const struct nft_expr_ops nft_payload_ops = {
 	.type		= &nft_payload_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_payload)),
@@ -320,20 +319,10 @@ nft_payload_select_ops(const struct nft_ctx *ctx,
 		return &nft_payload_ops;
 }
 
-static struct nft_expr_type nft_payload_type __read_mostly = {
+struct nft_expr_type nft_payload_type __read_mostly = {
 	.name		= "payload",
 	.select_ops	= nft_payload_select_ops,
 	.policy		= nft_payload_policy,
 	.maxattr	= NFTA_PAYLOAD_MAX,
 	.owner		= THIS_MODULE,
 };
-
-int __init nft_payload_module_init(void)
-{
-	return nft_register_expr(&nft_payload_type);
-}
-
-void nft_payload_module_exit(void)
-{
-	nft_unregister_expr(&nft_payload_type);
-}
diff --git a/net/netfilter/nft_range.c b/net/netfilter/nft_range.c
index fbc8800..0090626 100644
--- a/net/netfilter/nft_range.c
+++ b/net/netfilter/nft_range.c
@@ -122,7 +122,6 @@ static int nft_range_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	return -1;
 }
 
-static struct nft_expr_type nft_range_type;
 static const struct nft_expr_ops nft_range_ops = {
 	.type		= &nft_range_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_range_expr)),
@@ -131,20 +130,10 @@ static const struct nft_expr_ops nft_range_ops = {
 	.dump		= nft_range_dump,
 };
 
-static struct nft_expr_type nft_range_type __read_mostly = {
+struct nft_expr_type nft_range_type __read_mostly = {
 	.name		= "range",
 	.ops		= &nft_range_ops,
 	.policy		= nft_range_policy,
 	.maxattr	= NFTA_RANGE_MAX,
 	.owner		= THIS_MODULE,
 };
-
-int __init nft_range_module_init(void)
-{
-	return nft_register_expr(&nft_range_type);
-}
-
-void nft_range_module_exit(void)
-{
-	nft_unregister_expr(&nft_range_type);
-}
-- 
2.5.5


