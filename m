From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: nf_tables: add optional user data area to rules
Date: Wed, 26 Feb 2014 02:53:12 +0100
Message-ID: <1393379592-16312-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40551 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbaBZBxW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Feb 2014 20:53:22 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This allows us to store user comment strings, but it could be also
used to store any kind of information that the user application needs
to link to the rule.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h        |   15 +++++++++++----
 include/uapi/linux/netfilter/nf_tables.h |    5 ++++-
 net/netfilter/nf_tables_api.c            |   17 +++++++++++++++--
 3 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index e7e14ff..a729298 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -323,15 +323,17 @@ static inline void *nft_expr_priv(const struct nft_expr *expr)
  *
  *	@list: used internally
  *	@handle: rule handle
- *	@genmask: generation mask
  *	@dlen: length of expression data
+ *	@genmask: generation mask
+ *	@ulen: length of user data (used for comments)
  *	@data: expression data
  */
 struct nft_rule {
 	struct list_head		list;
-	u64				handle:46,
-					genmask:2,
-					dlen:16;
+	u64				handle;
+	u32				dlen;
+	u32				genmask:2,
+					ulen:30;
 	unsigned char			data[]
 		__attribute__((aligned(__alignof__(struct nft_expr))));
 };
@@ -370,6 +372,11 @@ static inline struct nft_expr *nft_expr_last(const struct nft_rule *rule)
 	return (struct nft_expr *)&rule->data[rule->dlen];
 }
 
+static inline void *nft_userdata(const struct nft_rule *rule)
+{
+	return (void *)&rule->data[rule->dlen];
+}
+
 /*
  * The last pointer isn't really necessary, but the compiler isn't able to
  * determine that the result of nft_expr_last() is always the same since it
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 83c985a..2d72ec6 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1,7 +1,8 @@
 #ifndef _LINUX_NF_TABLES_H
 #define _LINUX_NF_TABLES_H
 
-#define NFT_CHAIN_MAXNAMELEN 32
+#define NFT_CHAIN_MAXNAMELEN	32
+#define NFT_USERDATA_MAXLEN	256
 
 enum nft_registers {
 	NFT_REG_VERDICT,
@@ -156,6 +157,7 @@ enum nft_chain_attributes {
  * @NFTA_RULE_EXPRESSIONS: list of expressions (NLA_NESTED: nft_expr_attributes)
  * @NFTA_RULE_COMPAT: compatibility specifications of the rule (NLA_NESTED: nft_rule_compat_attributes)
  * @NFTA_RULE_POSITION: numeric handle of the previous rule (NLA_U64)
+ * @NFTA_RULE_USERDATA: user data (NLA_BINARY, NFT_USERDATA_MAXLEN)
  */
 enum nft_rule_attributes {
 	NFTA_RULE_UNSPEC,
@@ -165,6 +167,7 @@ enum nft_rule_attributes {
 	NFTA_RULE_EXPRESSIONS,
 	NFTA_RULE_COMPAT,
 	NFTA_RULE_POSITION,
+	NFTA_RULE_USERDATA,
 	__NFTA_RULE_MAX
 };
 #define NFTA_RULE_MAX		(__NFTA_RULE_MAX - 1)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index adce01e..b68364b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1296,6 +1296,8 @@ static const struct nla_policy nft_rule_policy[NFTA_RULE_MAX + 1] = {
 	[NFTA_RULE_EXPRESSIONS]	= { .type = NLA_NESTED },
 	[NFTA_RULE_COMPAT]	= { .type = NLA_NESTED },
 	[NFTA_RULE_POSITION]	= { .type = NLA_U64 },
+	[NFTA_RULE_USERDATA]	= { .type = NLA_BINARY,
+				    .len = NFT_USERDATA_MAXLEN },
 };
 
 static int nf_tables_fill_rule_info(struct sk_buff *skb, u32 portid, u32 seq,
@@ -1348,6 +1350,10 @@ static int nf_tables_fill_rule_info(struct sk_buff *skb, u32 portid, u32 seq,
 	}
 	nla_nest_end(skb, list);
 
+	if (rule->ulen &&
+	    nla_put(skb, NFTA_RULE_USERDATA, rule->ulen, nft_userdata(rule)))
+		goto nla_put_failure;
+
 	return nlmsg_end(skb, nlh);
 
 nla_put_failure:
@@ -1584,7 +1590,7 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 	struct nft_expr *expr;
 	struct nft_ctx ctx;
 	struct nlattr *tmp;
-	unsigned int size, i, n;
+	unsigned int size, i, n, ulen = 0;
 	int err, rem;
 	bool create;
 	u64 handle, pos_handle;
@@ -1650,8 +1656,11 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 		}
 	}
 
+	if (nla[NFTA_RULE_USERDATA])
+		ulen = nla_len(nla[NFTA_RULE_USERDATA]);
+
 	err = -ENOMEM;
-	rule = kzalloc(sizeof(*rule) + size, GFP_KERNEL);
+	rule = kzalloc(sizeof(*rule) + size + ulen, GFP_KERNEL);
 	if (rule == NULL)
 		goto err1;
 
@@ -1659,6 +1668,10 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
 
 	rule->handle = handle;
 	rule->dlen   = size;
+	rule->ulen   = ulen;
+
+	if (ulen)
+		nla_memcpy(nft_userdata(rule), nla[NFTA_RULE_USERDATA], ulen);
 
 	expr = nft_expr_first(rule);
 	for (i = 0; i < n; i++) {
-- 
1.7.10.4

