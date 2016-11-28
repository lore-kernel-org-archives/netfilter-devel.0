From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 2/2] netfilter: nf_tables: add numeric expression type definitions
Date: Mon, 28 Nov 2016 01:00:44 +0100
Message-ID: <1480291244-3666-2-git-send-email-pablo@netfilter.org>
References: <1480291244-3666-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40048 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752693AbcK1ABH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 27 Nov 2016 19:01:07 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4A6B3D1631
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2016 01:01:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3214EDA729
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2016 01:01:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 608CBDA729
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2016 01:00:59 +0100 (CET)
In-Reply-To: <1480291244-3666-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds numeric expression types, so we can refer to expressions
using these numeric type instead of their string name. A new netlink
attribute, NFTA_EXPR_TYPE, encapsulates the numeric expression type.
This patch doesn't use enum so stringify works for module aliases.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h        | 11 +++--
 include/uapi/linux/netfilter/nf_tables.h | 35 ++++++++++++++++
 net/bridge/netfilter/nft_meta_bridge.c   |  3 +-
 net/bridge/netfilter/nft_reject_bridge.c |  3 +-
 net/ipv4/netfilter/nft_dup_ipv4.c        |  3 +-
 net/ipv4/netfilter/nft_fib_ipv4.c        |  3 +-
 net/ipv4/netfilter/nft_masq_ipv4.c       |  3 +-
 net/ipv4/netfilter/nft_redir_ipv4.c      |  3 +-
 net/ipv4/netfilter/nft_reject_ipv4.c     |  3 +-
 net/ipv6/netfilter/nft_dup_ipv6.c        |  3 +-
 net/ipv6/netfilter/nft_fib_ipv6.c        |  3 +-
 net/ipv6/netfilter/nft_masq_ipv6.c       |  3 +-
 net/ipv6/netfilter/nft_redir_ipv6.c      |  3 +-
 net/ipv6/netfilter/nft_reject_ipv6.c     |  3 +-
 net/netfilter/nf_tables_api.c            | 70 ++++++++++++++++++++++----------
 net/netfilter/nft_bitwise.c              |  1 +
 net/netfilter/nft_byteorder.c            |  1 +
 net/netfilter/nft_cmp.c                  |  1 +
 net/netfilter/nft_compat.c               |  6 ++-
 net/netfilter/nft_counter.c              |  3 +-
 net/netfilter/nft_ct.c                   |  6 ++-
 net/netfilter/nft_dup_netdev.c           |  3 +-
 net/netfilter/nft_dynset.c               |  1 +
 net/netfilter/nft_exthdr.c               |  3 +-
 net/netfilter/nft_fib_inet.c             |  3 +-
 net/netfilter/nft_fwd_netdev.c           |  3 +-
 net/netfilter/nft_hash.c                 |  3 +-
 net/netfilter/nft_immediate.c            |  1 +
 net/netfilter/nft_limit.c                |  3 +-
 net/netfilter/nft_log.c                  |  3 +-
 net/netfilter/nft_lookup.c               |  1 +
 net/netfilter/nft_meta.c                 |  3 +-
 net/netfilter/nft_nat.c                  |  3 +-
 net/netfilter/nft_numgen.c               |  3 +-
 net/netfilter/nft_payload.c              |  1 +
 net/netfilter/nft_queue.c                |  3 +-
 net/netfilter/nft_quota.c                |  3 +-
 net/netfilter/nft_range.c                |  1 +
 net/netfilter/nft_reject_inet.c          |  3 +-
 net/netfilter/nft_rt.c                   |  3 +-
 40 files changed, 161 insertions(+), 56 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 7205c94fa0c8..0c12783f1008 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -649,6 +649,7 @@ struct nft_expr_type {
 	unsigned int			maxattr;
 	u8				family;
 	u8				flags;
+	u8				type;
 };
 
 #define NFT_EXPR_STATEFUL		0x1
@@ -979,11 +980,13 @@ void nft_trace_notify(struct nft_traceinfo *info);
 #define MODULE_ALIAS_NFT_CHAIN(family, name) \
 	MODULE_ALIAS("nft-chain-" __stringify(family) "-" name)
 
-#define MODULE_ALIAS_NFT_AF_EXPR(family, name) \
-	MODULE_ALIAS("nft-expr-" __stringify(family) "-" name)
+#define MODULE_ALIAS_NFT_AF_EXPR(family, name, type) \
+	MODULE_ALIAS("nft-expr-" __stringify(family) "-" name); \
+	MODULE_ALIAS("nft-expr-" __stringify(family) "-" __stringify(type)); \
 
-#define MODULE_ALIAS_NFT_EXPR(name) \
-	MODULE_ALIAS("nft-expr-" name)
+#define MODULE_ALIAS_NFT_EXPR(name, type) \
+	MODULE_ALIAS("nft-expr-" name);	\
+	MODULE_ALIAS("nft-expr-" __stringify(type))
 
 #define MODULE_ALIAS_NFT_SET() \
 	MODULE_ALIAS("nft-set")
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 14e5f619167e..d9f5d8ff11ea 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -420,16 +420,51 @@ enum nft_verdict_attributes {
 };
 #define NFTA_VERDICT_MAX	(__NFTA_VERDICT_MAX - 1)
 
+/* Expression types. */
+#define NFT_EXPR_UNSPEC		0
+#define NFT_EXPR_BITWISE	1
+#define NFT_EXPR_BYTEORDER	2
+#define NFT_EXPR_CMP		3
+#define NFT_EXPR_COMPAT_MATCH	4
+#define NFT_EXPR_COMPAT_TARGET	5
+#define NFT_EXPR_COUNTER	6
+#define NFT_EXPR_CT		7
+#define NFT_EXPR_DUP		8
+#define NFT_EXPR_DYNSET		9
+#define NFT_EXPR_EXTHDR		10
+#define NFT_EXPR_FIB		11
+#define NFT_EXPR_FWD		12
+#define NFT_EXPR_HASH		13
+#define NFT_EXPR_IMMEDIATE	14
+#define NFT_EXPR_LIMIT		15
+#define NFT_EXPR_LOG		16
+#define NFT_EXPR_LOOKUP		17
+#define NFT_EXPR_MASQ		18
+#define NFT_EXPR_META		19
+#define NFT_EXPR_NAT		20
+#define NFT_EXPR_NOTRACK	21
+#define NFT_EXPR_NUMGEN		22
+#define NFT_EXPR_PAYLOAD	23
+#define NFT_EXPR_QUEUE		24
+#define NFT_EXPR_QUOTA		25
+#define NFT_EXPR_RANGE		26
+#define NFT_EXPR_REDIR		27
+#define NFT_EXPR_REJECT		28
+#define NFT_EXPR_RT		29
+#define NFT_EXPR_MAX		30
+
 /**
  * enum nft_expr_attributes - nf_tables expression netlink attributes
  *
  * @NFTA_EXPR_NAME: name of the expression type (NLA_STRING)
  * @NFTA_EXPR_DATA: type specific data (NLA_NESTED)
+ * @NFTA_EXPR_TYPE: expression type (NLA_U32)
  */
 enum nft_expr_attributes {
 	NFTA_EXPR_UNSPEC,
 	NFTA_EXPR_NAME,
 	NFTA_EXPR_DATA,
+	NFTA_EXPR_TYPE,
 	__NFTA_EXPR_MAX
 };
 #define NFTA_EXPR_MAX		(__NFTA_EXPR_MAX - 1)
diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index 5974dbc1ea24..c9b5292b060a 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -111,6 +111,7 @@ nft_meta_bridge_select_ops(const struct nft_ctx *ctx,
 static struct nft_expr_type nft_meta_bridge_type __read_mostly = {
 	.family         = NFPROTO_BRIDGE,
 	.name           = "meta",
+	.type		= NFT_EXPR_META,
 	.select_ops     = &nft_meta_bridge_select_ops,
 	.policy         = nft_meta_policy,
 	.maxattr        = NFTA_META_MAX,
@@ -132,4 +133,4 @@ module_exit(nft_meta_bridge_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>");
-MODULE_ALIAS_NFT_AF_EXPR(AF_BRIDGE, "meta");
+MODULE_ALIAS_NFT_AF_EXPR(AF_BRIDGE, "meta", NFT_EXPR_META);
diff --git a/net/bridge/netfilter/nft_reject_bridge.c b/net/bridge/netfilter/nft_reject_bridge.c
index 206dc266ecd2..d5eab228543d 100644
--- a/net/bridge/netfilter/nft_reject_bridge.c
+++ b/net/bridge/netfilter/nft_reject_bridge.c
@@ -443,6 +443,7 @@ static const struct nft_expr_ops nft_reject_bridge_ops = {
 static struct nft_expr_type nft_reject_bridge_type __read_mostly = {
 	.family		= NFPROTO_BRIDGE,
 	.name		= "reject",
+	.type		= NFT_EXPR_REJECT,
 	.ops		= &nft_reject_bridge_ops,
 	.policy		= nft_reject_policy,
 	.maxattr	= NFTA_REJECT_MAX,
@@ -464,4 +465,4 @@ module_exit(nft_reject_bridge_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
-MODULE_ALIAS_NFT_AF_EXPR(AF_BRIDGE, "reject");
+MODULE_ALIAS_NFT_AF_EXPR(AF_BRIDGE, "reject", NFT_EXPR_REJECT);
diff --git a/net/ipv4/netfilter/nft_dup_ipv4.c b/net/ipv4/netfilter/nft_dup_ipv4.c
index 7ab544fbc382..9b83e2e4d4c9 100644
--- a/net/ipv4/netfilter/nft_dup_ipv4.c
+++ b/net/ipv4/netfilter/nft_dup_ipv4.c
@@ -86,6 +86,7 @@ static const struct nla_policy nft_dup_ipv4_policy[NFTA_DUP_MAX + 1] = {
 static struct nft_expr_type nft_dup_ipv4_type __read_mostly = {
 	.family		= NFPROTO_IPV4,
 	.name		= "dup",
+	.type		= NFT_EXPR_DUP,
 	.ops		= &nft_dup_ipv4_ops,
 	.policy		= nft_dup_ipv4_policy,
 	.maxattr	= NFTA_DUP_MAX,
@@ -107,4 +108,4 @@ module_exit(nft_dup_ipv4_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
-MODULE_ALIAS_NFT_AF_EXPR(AF_INET, "dup");
+MODULE_ALIAS_NFT_AF_EXPR(AF_INET, "dup", NFT_EXPR_DUP);
diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
index 1b49966484b3..add99a9d6f2f 100644
--- a/net/ipv4/netfilter/nft_fib_ipv4.c
+++ b/net/ipv4/netfilter/nft_fib_ipv4.c
@@ -214,6 +214,7 @@ nft_fib4_select_ops(const struct nft_ctx *ctx,
 
 static struct nft_expr_type nft_fib4_type __read_mostly = {
 	.name		= "fib",
+	.type		= NFT_EXPR_FIB,
 	.select_ops	= &nft_fib4_select_ops,
 	.policy		= nft_fib_policy,
 	.maxattr	= NFTA_FIB_MAX,
@@ -235,4 +236,4 @@ module_init(nft_fib4_module_init);
 module_exit(nft_fib4_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Florian Westphal <fw@strlen.de>");
-MODULE_ALIAS_NFT_AF_EXPR(2, "fib");
+MODULE_ALIAS_NFT_AF_EXPR(2, "fib", NFT_EXPR_FIB);
diff --git a/net/ipv4/netfilter/nft_masq_ipv4.c b/net/ipv4/netfilter/nft_masq_ipv4.c
index 4f697e431811..61c99e46c704 100644
--- a/net/ipv4/netfilter/nft_masq_ipv4.c
+++ b/net/ipv4/netfilter/nft_masq_ipv4.c
@@ -48,6 +48,7 @@ static const struct nft_expr_ops nft_masq_ipv4_ops = {
 static struct nft_expr_type nft_masq_ipv4_type __read_mostly = {
 	.family		= NFPROTO_IPV4,
 	.name		= "masq",
+	.type		= NFT_EXPR_MASQ,
 	.ops		= &nft_masq_ipv4_ops,
 	.policy		= nft_masq_policy,
 	.maxattr	= NFTA_MASQ_MAX,
@@ -78,4 +79,4 @@ module_exit(nft_masq_ipv4_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>");
-MODULE_ALIAS_NFT_AF_EXPR(AF_INET, "masq");
+MODULE_ALIAS_NFT_AF_EXPR(AF_INET, "masq", NFT_EXPR_MASQ);
diff --git a/net/ipv4/netfilter/nft_redir_ipv4.c b/net/ipv4/netfilter/nft_redir_ipv4.c
index 16df0493c5ce..c91360195449 100644
--- a/net/ipv4/netfilter/nft_redir_ipv4.c
+++ b/net/ipv4/netfilter/nft_redir_ipv4.c
@@ -51,6 +51,7 @@ static const struct nft_expr_ops nft_redir_ipv4_ops = {
 static struct nft_expr_type nft_redir_ipv4_type __read_mostly = {
 	.family		= NFPROTO_IPV4,
 	.name		= "redir",
+	.type		= NFT_EXPR_REDIR,
 	.ops		= &nft_redir_ipv4_ops,
 	.policy		= nft_redir_policy,
 	.maxattr	= NFTA_REDIR_MAX,
@@ -72,4 +73,4 @@ module_exit(nft_redir_ipv4_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>");
-MODULE_ALIAS_NFT_AF_EXPR(AF_INET, "redir");
+MODULE_ALIAS_NFT_AF_EXPR(AF_INET, "redir", NFT_EXPR_REDIR);
diff --git a/net/ipv4/netfilter/nft_reject_ipv4.c b/net/ipv4/netfilter/nft_reject_ipv4.c
index 517ce93699de..28c28559cbf9 100644
--- a/net/ipv4/netfilter/nft_reject_ipv4.c
+++ b/net/ipv4/netfilter/nft_reject_ipv4.c
@@ -52,6 +52,7 @@ static const struct nft_expr_ops nft_reject_ipv4_ops = {
 static struct nft_expr_type nft_reject_ipv4_type __read_mostly = {
 	.family		= NFPROTO_IPV4,
 	.name		= "reject",
+	.type		= NFT_EXPR_REJECT,
 	.ops		= &nft_reject_ipv4_ops,
 	.policy		= nft_reject_policy,
 	.maxattr	= NFTA_REJECT_MAX,
@@ -73,4 +74,4 @@ module_exit(nft_reject_ipv4_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_ALIAS_NFT_AF_EXPR(AF_INET, "reject");
+MODULE_ALIAS_NFT_AF_EXPR(AF_INET, "reject", NFT_EXPR_REJECT);
diff --git a/net/ipv6/netfilter/nft_dup_ipv6.c b/net/ipv6/netfilter/nft_dup_ipv6.c
index 26074a8bada7..f2d0bdaa3641 100644
--- a/net/ipv6/netfilter/nft_dup_ipv6.c
+++ b/net/ipv6/netfilter/nft_dup_ipv6.c
@@ -84,6 +84,7 @@ static const struct nla_policy nft_dup_ipv6_policy[NFTA_DUP_MAX + 1] = {
 static struct nft_expr_type nft_dup_ipv6_type __read_mostly = {
 	.family		= NFPROTO_IPV6,
 	.name		= "dup",
+	.type		= NFT_EXPR_DUP,
 	.ops		= &nft_dup_ipv6_ops,
 	.policy		= nft_dup_ipv6_policy,
 	.maxattr	= NFTA_DUP_MAX,
@@ -105,4 +106,4 @@ module_exit(nft_dup_ipv6_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
-MODULE_ALIAS_NFT_AF_EXPR(AF_INET6, "dup");
+MODULE_ALIAS_NFT_AF_EXPR(AF_INET6, "dup", NFT_EXPR_DUP);
diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
index d526bb594956..553b26dff2f0 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -251,6 +251,7 @@ nft_fib6_select_ops(const struct nft_ctx *ctx,
 
 static struct nft_expr_type nft_fib6_type __read_mostly = {
 	.name		= "fib",
+	.type		= NFT_EXPR_FIB,
 	.select_ops	= &nft_fib6_select_ops,
 	.policy		= nft_fib_policy,
 	.maxattr	= NFTA_FIB_MAX,
@@ -272,4 +273,4 @@ module_exit(nft_fib6_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Florian Westphal <fw@strlen.de>");
-MODULE_ALIAS_NFT_AF_EXPR(10, "fib");
+MODULE_ALIAS_NFT_AF_EXPR(10, "fib", NFT_EXPR_FIB);
diff --git a/net/ipv6/netfilter/nft_masq_ipv6.c b/net/ipv6/netfilter/nft_masq_ipv6.c
index a2aff1277b40..fd6d0a6b2052 100644
--- a/net/ipv6/netfilter/nft_masq_ipv6.c
+++ b/net/ipv6/netfilter/nft_masq_ipv6.c
@@ -49,6 +49,7 @@ static const struct nft_expr_ops nft_masq_ipv6_ops = {
 static struct nft_expr_type nft_masq_ipv6_type __read_mostly = {
 	.family		= NFPROTO_IPV6,
 	.name		= "masq",
+	.type		= NFT_EXPR_MASQ,
 	.ops		= &nft_masq_ipv6_ops,
 	.policy		= nft_masq_policy,
 	.maxattr	= NFTA_MASQ_MAX,
@@ -79,4 +80,4 @@ module_exit(nft_masq_ipv6_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>");
-MODULE_ALIAS_NFT_AF_EXPR(AF_INET6, "masq");
+MODULE_ALIAS_NFT_AF_EXPR(AF_INET6, "masq", NFT_EXPR_MASQ);
diff --git a/net/ipv6/netfilter/nft_redir_ipv6.c b/net/ipv6/netfilter/nft_redir_ipv6.c
index bfcd5af6bc15..f6747df0462d 100644
--- a/net/ipv6/netfilter/nft_redir_ipv6.c
+++ b/net/ipv6/netfilter/nft_redir_ipv6.c
@@ -51,6 +51,7 @@ static const struct nft_expr_ops nft_redir_ipv6_ops = {
 
 static struct nft_expr_type nft_redir_ipv6_type __read_mostly = {
 	.family		= NFPROTO_IPV6,
+	.type		= NFT_EXPR_REDIR,
 	.name		= "redir",
 	.ops		= &nft_redir_ipv6_ops,
 	.policy		= nft_redir_policy,
@@ -73,4 +74,4 @@ module_exit(nft_redir_ipv6_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>");
-MODULE_ALIAS_NFT_AF_EXPR(AF_INET6, "redir");
+MODULE_ALIAS_NFT_AF_EXPR(AF_INET6, "redir", NFT_EXPR_REDIR);
diff --git a/net/ipv6/netfilter/nft_reject_ipv6.c b/net/ipv6/netfilter/nft_reject_ipv6.c
index 057deeaff1cb..58e4aba21615 100644
--- a/net/ipv6/netfilter/nft_reject_ipv6.c
+++ b/net/ipv6/netfilter/nft_reject_ipv6.c
@@ -53,6 +53,7 @@ static const struct nft_expr_ops nft_reject_ipv6_ops = {
 static struct nft_expr_type nft_reject_ipv6_type __read_mostly = {
 	.family		= NFPROTO_IPV6,
 	.name		= "reject",
+	.type		= NFT_EXPR_REJECT,
 	.ops		= &nft_reject_ipv6_ops,
 	.policy		= nft_reject_policy,
 	.maxattr	= NFTA_REJECT_MAX,
@@ -74,4 +75,4 @@ module_exit(nft_reject_ipv6_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_ALIAS_NFT_AF_EXPR(AF_INET6, "reject");
+MODULE_ALIAS_NFT_AF_EXPR(AF_INET6, "reject", NFT_EXPR_REJECT);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 24db22257586..f72533be6c6c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1555,6 +1555,9 @@ static int nf_tables_delchain(struct net *net, struct sock *nlsk,
  */
 int nft_register_expr(struct nft_expr_type *type)
 {
+	if (type->type == NFT_EXPR_UNSPEC)
+		return -EINVAL;
+
 	nfnl_lock(NFNL_SUBSYS_NFTABLES);
 	if (type->family == NFPROTO_UNSPEC)
 		list_add_tail_rcu(&type->list, &nf_tables_expressions);
@@ -1580,45 +1583,62 @@ void nft_unregister_expr(struct nft_expr_type *type)
 EXPORT_SYMBOL_GPL(nft_unregister_expr);
 
 static const struct nft_expr_type *__nft_expr_type_get(u8 family,
-						       struct nlattr *nla)
+						       struct nlattr *nla,
+						       u16 attr)
 {
 	const struct nft_expr_type *type;
 
 	list_for_each_entry(type, &nf_tables_expressions, list) {
-		if (!nla_strcmp(nla, type->name) &&
-		    (!type->family || type->family == family))
+		if (attr == NFTA_EXPR_NAME &&
+		    !nla_strcmp(nla, type->name))
+			return type;
+		else if (attr == NFTA_EXPR_TYPE &&
+			 ntohl(nla_get_be32(nla)) == type->type)
 			return type;
 	}
 	return NULL;
 }
 
 static const struct nft_expr_type *nft_expr_type_get(u8 family,
-						     struct nlattr *nla)
+						     struct nlattr *nla,
+						     u16 attr)
 {
 	const struct nft_expr_type *type;
 
-	if (nla == NULL)
-		return ERR_PTR(-EINVAL);
-
-	type = __nft_expr_type_get(family, nla);
+	type = __nft_expr_type_get(family, nla, attr);
 	if (type != NULL && try_module_get(type->owner))
 		return type;
 
 #ifdef CONFIG_MODULES
 	if (type == NULL) {
 		nfnl_unlock(NFNL_SUBSYS_NFTABLES);
-		request_module("nft-expr-%u-%.*s", family,
-			       nla_len(nla), (char *)nla_data(nla));
-		nfnl_lock(NFNL_SUBSYS_NFTABLES);
-		if (__nft_expr_type_get(family, nla))
-			return ERR_PTR(-EAGAIN);
-
-		nfnl_unlock(NFNL_SUBSYS_NFTABLES);
-		request_module("nft-expr-%.*s",
-			       nla_len(nla), (char *)nla_data(nla));
-		nfnl_lock(NFNL_SUBSYS_NFTABLES);
-		if (__nft_expr_type_get(family, nla))
-			return ERR_PTR(-EAGAIN);
+		if (attr == NFTA_EXPR_NAME) {
+			request_module("nft-expr-%u-%.*s", family,
+				       nla_len(nla), (char *)nla_data(nla));
+			nfnl_lock(NFNL_SUBSYS_NFTABLES);
+			if (__nft_expr_type_get(family, nla, attr))
+				return ERR_PTR(-EAGAIN);
+
+			nfnl_unlock(NFNL_SUBSYS_NFTABLES);
+			request_module("nft-expr-%.*s",
+				       nla_len(nla), (char *)nla_data(nla));
+			nfnl_lock(NFNL_SUBSYS_NFTABLES);
+			if (__nft_expr_type_get(family, nla, attr))
+				return ERR_PTR(-EAGAIN);
+		} else if (attr == NFTA_EXPR_TYPE) {
+			u32 expr_type = ntohl(nla_get_be32(nla));
+
+			request_module("nft-expr-%u-%u", family, expr_type);
+			nfnl_lock(NFNL_SUBSYS_NFTABLES);
+			if (__nft_expr_type_get(family, nla, attr))
+				return ERR_PTR(-EAGAIN);
+
+			nfnl_unlock(NFNL_SUBSYS_NFTABLES);
+			request_module("nft-expr-%u", expr_type);
+			nfnl_lock(NFNL_SUBSYS_NFTABLES);
+			if (__nft_expr_type_get(family, nla, attr))
+				return ERR_PTR(-EAGAIN);
+		}
 	}
 #endif
 	return ERR_PTR(-ENOENT);
@@ -1627,6 +1647,7 @@ static const struct nft_expr_type *nft_expr_type_get(u8 family,
 static const struct nla_policy nft_expr_policy[NFTA_EXPR_MAX + 1] = {
 	[NFTA_EXPR_NAME]	= { .type = NLA_STRING },
 	[NFTA_EXPR_DATA]	= { .type = NLA_NESTED },
+	[NFTA_EXPR_TYPE]	= { .type = NLA_U32 },
 };
 
 static int nf_tables_fill_expr_info(struct sk_buff *skb,
@@ -1634,6 +1655,8 @@ static int nf_tables_fill_expr_info(struct sk_buff *skb,
 {
 	if (nla_put_string(skb, NFTA_EXPR_NAME, expr->ops->type->name))
 		goto nla_put_failure;
+	if (nla_put_be32(skb, NFTA_EXPR_TYPE, htonl(expr->ops->type->type)))
+		goto nla_put_failure;
 
 	if (expr->ops->dump) {
 		struct nlattr *data = nla_nest_start(skb, NFTA_EXPR_DATA);
@@ -1685,7 +1708,12 @@ static int nf_tables_expr_parse(const struct nft_ctx *ctx,
 	if (err < 0)
 		return err;
 
-	type = nft_expr_type_get(ctx->afi->family, tb[NFTA_EXPR_NAME]);
+	if (tb[NFTA_EXPR_TYPE])
+		type = nft_expr_type_get(ctx->afi->family, tb[NFTA_EXPR_TYPE],
+					 NFTA_EXPR_TYPE);
+	else
+		type = nft_expr_type_get(ctx->afi->family, tb[NFTA_EXPR_NAME],
+					 NFTA_EXPR_NAME);
 	if (IS_ERR(type))
 		return PTR_ERR(type);
 
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 877d9acd91ef..f6c1dc766837 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -131,6 +131,7 @@ static const struct nft_expr_ops nft_bitwise_ops = {
 
 struct nft_expr_type nft_bitwise_type __read_mostly = {
 	.name		= "bitwise",
+	.type		= NFT_EXPR_BITWISE,
 	.ops		= &nft_bitwise_ops,
 	.policy		= nft_bitwise_policy,
 	.maxattr	= NFTA_BITWISE_MAX,
diff --git a/net/netfilter/nft_byteorder.c b/net/netfilter/nft_byteorder.c
index 13d4e421a6b3..5d86ffe688b5 100644
--- a/net/netfilter/nft_byteorder.c
+++ b/net/netfilter/nft_byteorder.c
@@ -179,6 +179,7 @@ static const struct nft_expr_ops nft_byteorder_ops = {
 
 struct nft_expr_type nft_byteorder_type __read_mostly = {
 	.name		= "byteorder",
+	.type		= NFT_EXPR_BYTEORDER,
 	.ops		= &nft_byteorder_ops,
 	.policy		= nft_byteorder_policy,
 	.maxattr	= NFTA_BYTEORDER_MAX,
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index 2b96effeadc1..6f6e0942a13d 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -209,6 +209,7 @@ nft_cmp_select_ops(const struct nft_ctx *ctx, const struct nlattr * const tb[])
 
 struct nft_expr_type nft_cmp_type __read_mostly = {
 	.name		= "cmp",
+	.type		= NFT_EXPR_CMP,
 	.select_ops	= nft_cmp_select_ops,
 	.policy		= nft_cmp_policy,
 	.maxattr	= NFTA_CMP_MAX,
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index c21e7eb8dce0..a7e4d05e66da 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -705,6 +705,7 @@ nft_match_select_ops(const struct nft_ctx *ctx,
 
 static struct nft_expr_type nft_match_type __read_mostly = {
 	.name		= "match",
+	.type		= NFT_EXPR_COMPAT_MATCH,
 	.select_ops	= nft_match_select_ops,
 	.policy		= nft_match_policy,
 	.maxattr	= NFTA_MATCH_MAX,
@@ -794,6 +795,7 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 
 static struct nft_expr_type nft_target_type __read_mostly = {
 	.name		= "target",
+	.type		= NFT_EXPR_COMPAT_TARGET,
 	.select_ops	= nft_target_select_ops,
 	.policy		= nft_target_policy,
 	.maxattr	= NFTA_TARGET_MAX,
@@ -843,5 +845,5 @@ module_exit(nft_compat_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
-MODULE_ALIAS_NFT_EXPR("match");
-MODULE_ALIAS_NFT_EXPR("target");
+MODULE_ALIAS_NFT_EXPR("match", NFT_EXPR_MATCH);
+MODULE_ALIAS_NFT_EXPR("target", NFT_EXPR_TARGET);
diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index 77db8358ab14..6a13a5866862 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -165,6 +165,7 @@ static const struct nft_expr_ops nft_counter_ops = {
 
 static struct nft_expr_type nft_counter_type __read_mostly = {
 	.name		= "counter",
+	.type		= NFT_EXPR_COUNTER,
 	.ops		= &nft_counter_ops,
 	.policy		= nft_counter_policy,
 	.maxattr	= NFTA_COUNTER_MAX,
@@ -187,4 +188,4 @@ module_exit(nft_counter_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_ALIAS_NFT_EXPR("counter");
+MODULE_ALIAS_NFT_EXPR("counter", NFT_EXPR_COUNTER);
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 6837348c8993..1e802fcdd2ad 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -513,6 +513,7 @@ nft_ct_select_ops(const struct nft_ctx *ctx,
 
 static struct nft_expr_type nft_ct_type __read_mostly = {
 	.name		= "ct",
+	.type		= NFT_EXPR_CT,
 	.select_ops	= &nft_ct_select_ops,
 	.policy		= nft_ct_policy,
 	.maxattr	= NFTA_CT_MAX,
@@ -547,6 +548,7 @@ static const struct nft_expr_ops nft_notrack_ops = {
 
 static struct nft_expr_type nft_notrack_type __read_mostly = {
 	.name		= "notrack",
+	.type		= NFT_EXPR_NOTRACK,
 	.ops		= &nft_notrack_ops,
 	.owner		= THIS_MODULE,
 };
@@ -582,5 +584,5 @@ module_exit(nft_ct_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_ALIAS_NFT_EXPR("ct");
-MODULE_ALIAS_NFT_EXPR("notrack");
+MODULE_ALIAS_NFT_EXPR("ct", NFT_EXPR_CT);
+MODULE_ALIAS_NFT_EXPR("notrack", NFT_EXPR_NOTRACK);
diff --git a/net/netfilter/nft_dup_netdev.c b/net/netfilter/nft_dup_netdev.c
index 2cc1e0ef56e8..50051830acc2 100644
--- a/net/netfilter/nft_dup_netdev.c
+++ b/net/netfilter/nft_dup_netdev.c
@@ -72,6 +72,7 @@ static const struct nft_expr_ops nft_dup_netdev_ops = {
 
 static struct nft_expr_type nft_dup_netdev_type __read_mostly = {
 	.family		= NFPROTO_NETDEV,
+	.type		= NFT_EXPR_DUP,
 	.name		= "dup",
 	.ops		= &nft_dup_netdev_ops,
 	.policy		= nft_dup_netdev_policy,
@@ -94,4 +95,4 @@ module_exit(nft_dup_netdev_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
-MODULE_ALIAS_NFT_AF_EXPR(5, "dup");
+MODULE_ALIAS_NFT_AF_EXPR(5, "dup", NFT_EXPR_DUP);
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 4339e3f1c4b1..37877b4579d8 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -272,6 +272,7 @@ static const struct nft_expr_ops nft_dynset_ops = {
 
 struct nft_expr_type nft_dynset_type __read_mostly = {
 	.name		= "dynset",
+	.type		= NFT_EXPR_DYNSET,
 	.ops		= &nft_dynset_ops,
 	.policy		= nft_dynset_policy,
 	.maxattr	= NFTA_DYNSET_MAX,
diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 47beb3abcc9d..14a8fb45abfd 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -114,6 +114,7 @@ static const struct nft_expr_ops nft_exthdr_ops = {
 
 static struct nft_expr_type nft_exthdr_type __read_mostly = {
 	.name		= "exthdr",
+	.type		= NFT_EXPR_EXTHDR,
 	.ops		= &nft_exthdr_ops,
 	.policy		= nft_exthdr_policy,
 	.maxattr	= NFTA_EXTHDR_MAX,
@@ -135,4 +136,4 @@ module_exit(nft_exthdr_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_ALIAS_NFT_EXPR("exthdr");
+MODULE_ALIAS_NFT_EXPR("exthdr", NFT_EXPR_EXTHDR);
diff --git a/net/netfilter/nft_fib_inet.c b/net/netfilter/nft_fib_inet.c
index 9120fc7228f4..feed452ae956 100644
--- a/net/netfilter/nft_fib_inet.c
+++ b/net/netfilter/nft_fib_inet.c
@@ -58,6 +58,7 @@ static const struct nft_expr_ops nft_fib_inet_ops = {
 static struct nft_expr_type nft_fib_inet_type __read_mostly = {
 	.family		= NFPROTO_INET,
 	.name		= "fib",
+	.type		= NFT_EXPR_FIB,
 	.ops		= &nft_fib_inet_ops,
 	.policy		= nft_fib_policy,
 	.maxattr	= NFTA_FIB_MAX,
@@ -79,4 +80,4 @@ module_exit(nft_fib_inet_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Florian Westphal <fw@strlen.de>");
-MODULE_ALIAS_NFT_AF_EXPR(1, "fib");
+MODULE_ALIAS_NFT_AF_EXPR(1, "fib", NFT_EXPR_FIB);
diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index 763ebc3e0b2b..60c8fbd35e1a 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -74,6 +74,7 @@ static const struct nft_expr_ops nft_fwd_netdev_ops = {
 static struct nft_expr_type nft_fwd_netdev_type __read_mostly = {
 	.family		= NFPROTO_NETDEV,
 	.name		= "fwd",
+	.type		= NFT_EXPR_FWD,
 	.ops		= &nft_fwd_netdev_ops,
 	.policy		= nft_fwd_netdev_policy,
 	.maxattr	= NFTA_FWD_MAX,
@@ -95,4 +96,4 @@ module_exit(nft_fwd_netdev_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
-MODULE_ALIAS_NFT_AF_EXPR(5, "fwd");
+MODULE_ALIAS_NFT_AF_EXPR(5, "fwd", NFT_EXPR_FWD);
diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index 97ad8e30e4b4..8037cfe307ab 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -124,6 +124,7 @@ static const struct nft_expr_ops nft_hash_ops = {
 
 static struct nft_expr_type nft_hash_type __read_mostly = {
 	.name		= "hash",
+	.type		= NFT_EXPR_HASH,
 	.ops		= &nft_hash_ops,
 	.policy		= nft_hash_policy,
 	.maxattr	= NFTA_HASH_MAX,
@@ -145,4 +146,4 @@ module_exit(nft_hash_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Laura Garcia <nevola@gmail.com>");
-MODULE_ALIAS_NFT_EXPR("hash");
+MODULE_ALIAS_NFT_EXPR("hash", NFT_EXPR_HASH);
diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index 728baf88295a..988097554967 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -114,6 +114,7 @@ static const struct nft_expr_ops nft_imm_ops = {
 
 struct nft_expr_type nft_imm_type __read_mostly = {
 	.name		= "immediate",
+	.type		= NFT_EXPR_IMMEDIATE,
 	.ops		= &nft_imm_ops,
 	.policy		= nft_immediate_policy,
 	.maxattr	= NFTA_IMMEDIATE_MAX,
diff --git a/net/netfilter/nft_limit.c b/net/netfilter/nft_limit.c
index c6baf412236d..c8f337b3a204 100644
--- a/net/netfilter/nft_limit.c
+++ b/net/netfilter/nft_limit.c
@@ -219,6 +219,7 @@ nft_limit_select_ops(const struct nft_ctx *ctx,
 
 static struct nft_expr_type nft_limit_type __read_mostly = {
 	.name		= "limit",
+	.type		= NFT_EXPR_LIMIT,
 	.select_ops	= nft_limit_select_ops,
 	.policy		= nft_limit_policy,
 	.maxattr	= NFTA_LIMIT_MAX,
@@ -241,4 +242,4 @@ module_exit(nft_limit_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_ALIAS_NFT_EXPR("limit");
+MODULE_ALIAS_NFT_EXPR("limit", NFT_EXPR_LIMIT);
diff --git a/net/netfilter/nft_log.c b/net/netfilter/nft_log.c
index 6271e40a3dd6..5f3eb066c715 100644
--- a/net/netfilter/nft_log.c
+++ b/net/netfilter/nft_log.c
@@ -188,6 +188,7 @@ static const struct nft_expr_ops nft_log_ops = {
 
 static struct nft_expr_type nft_log_type __read_mostly = {
 	.name		= "log",
+	.type		= NFT_EXPR_LOG,
 	.ops		= &nft_log_ops,
 	.policy		= nft_log_policy,
 	.maxattr	= NFTA_LOG_MAX,
@@ -209,4 +210,4 @@ module_exit(nft_log_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_ALIAS_NFT_EXPR("log");
+MODULE_ALIAS_NFT_EXPR("log", NFT_EXPR_LOG);
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index d4f97fa7e21d..2e7df753fd24 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -165,6 +165,7 @@ static const struct nft_expr_ops nft_lookup_ops = {
 
 struct nft_expr_type nft_lookup_type __read_mostly = {
 	.name		= "lookup",
+	.type		= NFT_EXPR_LOOKUP,
 	.ops		= &nft_lookup_ops,
 	.policy		= nft_lookup_policy,
 	.maxattr	= NFTA_LOOKUP_MAX,
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 66c7f4b4c49b..5f19286715bb 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -446,6 +446,7 @@ nft_meta_select_ops(const struct nft_ctx *ctx,
 
 static struct nft_expr_type nft_meta_type __read_mostly = {
 	.name		= "meta",
+	.type		= NFT_EXPR_META,
 	.select_ops	= &nft_meta_select_ops,
 	.policy		= nft_meta_policy,
 	.maxattr	= NFTA_META_MAX,
@@ -467,4 +468,4 @@ module_exit(nft_meta_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_ALIAS_NFT_EXPR("meta");
+MODULE_ALIAS_NFT_EXPR("meta", NFT_EXPR_META);
diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index ee2d71753746..b69e3e5fdccd 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -269,6 +269,7 @@ static const struct nft_expr_ops nft_nat_ops = {
 
 static struct nft_expr_type nft_nat_type __read_mostly = {
 	.name           = "nat",
+	.type		= NFT_EXPR_NAT,
 	.ops            = &nft_nat_ops,
 	.policy         = nft_nat_policy,
 	.maxattr        = NFTA_NAT_MAX,
@@ -290,4 +291,4 @@ module_exit(nft_nat_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>");
-MODULE_ALIAS_NFT_EXPR("nat");
+MODULE_ALIAS_NFT_EXPR("nat", NFT_EXPR_NAT);
diff --git a/net/netfilter/nft_numgen.c b/net/netfilter/nft_numgen.c
index a66b36097b8f..21f551a83e45 100644
--- a/net/netfilter/nft_numgen.c
+++ b/net/netfilter/nft_numgen.c
@@ -188,6 +188,7 @@ nft_ng_select_ops(const struct nft_ctx *ctx, const struct nlattr * const tb[])
 
 static struct nft_expr_type nft_ng_type __read_mostly = {
 	.name		= "numgen",
+	.type		= NFT_EXPR_NUMGEN,
 	.select_ops	= &nft_ng_select_ops,
 	.policy		= nft_ng_policy,
 	.maxattr	= NFTA_NG_MAX,
@@ -209,4 +210,4 @@ module_exit(nft_ng_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Laura Garcia <nevola@gmail.com>");
-MODULE_ALIAS_NFT_EXPR("numgen");
+MODULE_ALIAS_NFT_EXPR("numgen", NFT_EXPR_NUMGEN);
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 98fb5d7b8087..259f99d875f7 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -321,6 +321,7 @@ nft_payload_select_ops(const struct nft_ctx *ctx,
 
 struct nft_expr_type nft_payload_type __read_mostly = {
 	.name		= "payload",
+	.type		= NFT_EXPR_PAYLOAD,
 	.select_ops	= nft_payload_select_ops,
 	.policy		= nft_payload_policy,
 	.maxattr	= NFTA_PAYLOAD_MAX,
diff --git a/net/netfilter/nft_queue.c b/net/netfilter/nft_queue.c
index 3e19fa1230dc..9b54d0cd3048 100644
--- a/net/netfilter/nft_queue.c
+++ b/net/netfilter/nft_queue.c
@@ -197,6 +197,7 @@ nft_queue_select_ops(const struct nft_ctx *ctx,
 
 static struct nft_expr_type nft_queue_type __read_mostly = {
 	.name		= "queue",
+	.type		= NFT_EXPR_QUEUE,
 	.select_ops	= &nft_queue_select_ops,
 	.policy		= nft_queue_policy,
 	.maxattr	= NFTA_QUEUE_MAX,
@@ -218,4 +219,4 @@ module_exit(nft_queue_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Eric Leblond <eric@regit.org>");
-MODULE_ALIAS_NFT_EXPR("queue");
+MODULE_ALIAS_NFT_EXPR("queue", NFT_EXPR_QUEUE);
diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index c00104c07095..dd2d86ebe486 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -96,6 +96,7 @@ static const struct nft_expr_ops nft_quota_ops = {
 
 static struct nft_expr_type nft_quota_type __read_mostly = {
 	.name		= "quota",
+	.type		= NFT_EXPR_QUOTA,
 	.ops		= &nft_quota_ops,
 	.policy		= nft_quota_policy,
 	.maxattr	= NFTA_QUOTA_MAX,
@@ -118,4 +119,4 @@ module_exit(nft_quota_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
-MODULE_ALIAS_NFT_EXPR("quota");
+MODULE_ALIAS_NFT_EXPR("quota", NFT_EXPR_QUOTA);
diff --git a/net/netfilter/nft_range.c b/net/netfilter/nft_range.c
index 009062606697..acab54632e40 100644
--- a/net/netfilter/nft_range.c
+++ b/net/netfilter/nft_range.c
@@ -132,6 +132,7 @@ static const struct nft_expr_ops nft_range_ops = {
 
 struct nft_expr_type nft_range_type __read_mostly = {
 	.name		= "range",
+	.type		= NFT_EXPR_RANGE,
 	.ops		= &nft_range_ops,
 	.policy		= nft_range_policy,
 	.maxattr	= NFTA_RANGE_MAX,
diff --git a/net/netfilter/nft_reject_inet.c b/net/netfilter/nft_reject_inet.c
index 9e90a02cb104..5865a97ac547 100644
--- a/net/netfilter/nft_reject_inet.c
+++ b/net/netfilter/nft_reject_inet.c
@@ -134,6 +134,7 @@ static const struct nft_expr_ops nft_reject_inet_ops = {
 static struct nft_expr_type nft_reject_inet_type __read_mostly = {
 	.family		= NFPROTO_INET,
 	.name		= "reject",
+	.type		= NFT_EXPR_REJECT,
 	.ops		= &nft_reject_inet_ops,
 	.policy		= nft_reject_policy,
 	.maxattr	= NFTA_REJECT_MAX,
@@ -155,4 +156,4 @@ module_exit(nft_reject_inet_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_ALIAS_NFT_AF_EXPR(1, "reject");
+MODULE_ALIAS_NFT_AF_EXPR(1, "reject", NFT_EXPR_REJECT);
diff --git a/net/netfilter/nft_rt.c b/net/netfilter/nft_rt.c
index d3eb640bc784..5bfeb3858ac0 100644
--- a/net/netfilter/nft_rt.c
+++ b/net/netfilter/nft_rt.c
@@ -129,6 +129,7 @@ static const struct nft_expr_ops nft_rt_get_ops = {
 
 static struct nft_expr_type nft_rt_type __read_mostly = {
 	.name		= "rt",
+	.type		= NFT_EXPR_RT,
 	.ops		= &nft_rt_get_ops,
 	.policy		= nft_rt_policy,
 	.maxattr	= NFTA_RT_MAX,
@@ -150,4 +151,4 @@ module_exit(nft_rt_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Anders K. Pedersen <akp@cohaesio.com>");
-MODULE_ALIAS_NFT_EXPR("rt");
+MODULE_ALIAS_NFT_EXPR("rt", NFT_EXPR_RT);
-- 
2.1.4

