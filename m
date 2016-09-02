From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl] include: resync nf_tables.h cache copy
Date: Fri,  2 Sep 2016 12:02:54 +0200
Message-ID: <1472810574-5759-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47620 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752432AbcIBKDU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Sep 2016 06:03:20 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E534011E599
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Sep 2016 12:03:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D524C6DB34
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Sep 2016 12:03:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 410DF100A7E
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Sep 2016 12:02:58 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sync this with the kernel header file we currently have in tree.

This patch addresses the compilation warning and breakage as result of
this header update, specifically the "attibute" typo in trace and
missing default case in expr/numgen.c.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_tables.h | 84 ++++++++++++++++++-------------------
 src/expr/numgen.c                   |  4 +-
 src/trace.c                         |  2 +-
 3 files changed, 44 insertions(+), 46 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 0b11abf..8a63f22 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -667,33 +667,6 @@ enum nft_exthdr_attributes {
 #define NFTA_EXTHDR_MAX		(__NFTA_EXTHDR_MAX - 1)
 
 /**
- * enum nft_ng_attributes - nf_tables number generator expression attributes
- *
- * @NFTA_NG_DREG: destination register (NLA_U32)
- * @NFTA_NG_UNTIL: limit value (NLA_U32)
- * @NFTA_NG_TYPE: type of operation (NLA_U32)
- */
-enum nft_ng_attributes {
-	NFTA_NG_UNSPEC,
-	NFTA_NG_DREG,
-	NFTA_NG_UNTIL,
-	NFTA_NG_TYPE,
-	__NFTA_NG_MAX
-};
-#define NFTA_NG_MAX		(__NFTA_NG_MAX - 1)
-
-/**
- * enum nft_ng_type - nf_tables number generator expression reject types
- *
- * @NFT_NG_INCREMENTAL: Incremental number generator
- * @NFT_NG_RANDOM: Random number generator
- */
-enum nft_ng_type {
-	NFT_NG_INCREMENTAL,
-	NFT_NG_RANDOM
-};
-
-/**
  * enum nft_meta_keys - nf_tables meta expression keys
  *
  * @NFT_META_LEN: packet length (skb->len)
@@ -751,6 +724,26 @@ enum nft_meta_keys {
 };
 
 /**
+ * enum nft_hash_attributes - nf_tables hash expression netlink attributes
+ *
+ * @NFTA_HASH_SREG: source register (NLA_U32)
+ * @NFTA_HASH_DREG: destination register (NLA_U32)
+ * @NFTA_HASH_LEN: source data length (NLA_U32)
+ * @NFTA_HASH_MODULUS: modulus value (NLA_U32)
+ * @NFTA_HASH_SEED: seed value (NLA_U32)
+ */
+enum nft_hash_attributes {
+	NFTA_HASH_UNSPEC,
+	NFTA_HASH_SREG,
+	NFTA_HASH_DREG,
+	NFTA_HASH_LEN,
+	NFTA_HASH_MODULUS,
+	NFTA_HASH_SEED,
+	__NFTA_HASH_MAX,
+};
+#define NFTA_HASH_MAX	(__NFTA_HASH_MAX - 1)
+
+/**
  * enum nft_meta_attributes - nf_tables meta expression netlink attributes
  *
  * @NFTA_META_DREG: destination register (NLA_U32)
@@ -908,7 +901,7 @@ enum nft_queue_attributes {
 #define NFT_QUEUE_FLAG_MASK		0x03
 
 enum nft_quota_flags {
-	NFT_QUOTA_F_INV	= (1 << 0),
+	NFT_QUOTA_F_INV		= (1 << 0),
 };
 
 /**
@@ -1097,7 +1090,7 @@ enum nft_gen_attributes {
  * @NFTA_TRACE_NFPROTO: nf protocol processed (NLA_U32)
  * @NFTA_TRACE_POLICY: policy that decided fate of packet (NLA_U32)
  */
-enum nft_trace_attibutes {
+enum nft_trace_attributes {
 	NFTA_TRACE_UNSPEC,
 	NFTA_TRACE_TABLE,
 	NFTA_TRACE_CHAIN,
@@ -1130,23 +1123,26 @@ enum nft_trace_types {
 #define NFT_TRACETYPE_MAX (__NFT_TRACETYPE_MAX - 1)
 
 /**
- * enum nft_hash_attributes - nf_tables hash expression attributes
+ * enum nft_ng_attributes - nf_tables number generator expression netlink attributes
  *
- * @NFTA_HASH_SREG: source register (NLA_U32)
- * @NFTA_HASH_DREG: destination register (NLA_U32)
- * @NFTA_HASH_LEN: data length (NLA_U32)
- * @NFTA_HASH_MODULUS: Modulus value (NLA_U32)
- * @NFTA_HASH_SEED: hash initial value (NLA_U32)
+ * @NFTA_NG_DREG: destination register (NLA_U32)
+ * @NFTA_NG_UNTIL: source value to increment the counter until reset (NLA_U32)
+ * @NFTA_NG_TYPE: operation type (NLA_U32)
  */
-enum nft_hash_attributes {
-	NFTA_HASH_UNSPEC,
-	NFTA_HASH_SREG,
-	NFTA_HASH_DREG,
-	NFTA_HASH_LEN,
-	NFTA_HASH_MODULUS,
-	NFTA_HASH_SEED,
-	__NFTA_HASH_MAX
+enum nft_ng_attributes {
+	NFTA_NG_UNSPEC,
+	NFTA_NG_DREG,
+	NFTA_NG_UNTIL,
+	NFTA_NG_TYPE,
+	__NFTA_NG_MAX
+};
+#define NFTA_NG_MAX	(__NFTA_NG_MAX - 1)
+
+enum nft_ng_types {
+	NFT_NG_INCREMENTAL,
+	NFT_NG_RANDOM,
+	__NFT_NG_MAX
 };
-#define NFTA_HASH_MAX		(__NFTA_HASH_MAX - 1)
+#define NFT_NG_MAX	(__NFT_NG_MAX - 1)
 
 #endif /* _LINUX_NF_TABLES_H */
diff --git a/src/expr/numgen.c b/src/expr/numgen.c
index 0669eda..7f2b425 100644
--- a/src/expr/numgen.c
+++ b/src/expr/numgen.c
@@ -23,7 +23,7 @@
 struct nftnl_expr_ng {
 	enum nft_registers	dreg;
 	unsigned int		until;
-	enum nft_ng_type	type;
+	enum nft_ng_types	type;
 };
 
 static int
@@ -200,6 +200,8 @@ nftnl_expr_ng_snprintf_default(char *buf, size_t size,
 			       ng->until);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 		break;
+	default:
+		break;
 	}
 
 	return offset;
diff --git a/src/trace.c b/src/trace.c
index 1a50390..2b3388d 100644
--- a/src/trace.c
+++ b/src/trace.c
@@ -79,7 +79,7 @@ bool nftnl_trace_is_set(const struct nftnl_trace *t, uint16_t attr)
 static int nftnl_trace_parse_attr_cb(const struct nlattr *attr, void *data)
 {
 	const struct nlattr **tb = data;
-	enum nft_trace_attibutes type = mnl_attr_get_type(attr);
+	enum nft_trace_attributes type = mnl_attr_get_type(attr);
 
 	if (mnl_attr_type_valid(attr, NFTA_TRACE_MAX) < 0)
 		return MNL_CB_OK;
-- 
2.1.4

