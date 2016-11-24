From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/2 libnftnl] include: refresh nf_tables.h cache copy
Date: Thu, 24 Nov 2016 12:08:51 +0100
Message-ID: <1479985732-6104-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45374 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S938696AbcKXLJI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2016 06:09:08 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 04F6316B280
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 12:09:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E8D24DA7F6
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 12:09:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 21C1FDA851
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 12:08:56 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fetch what we have at 4.9-rc6.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_tables.h | 77 +++++++++++++++++++++++++++++++++++--
 1 file changed, 73 insertions(+), 4 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 30e3b21418c5..14e5f619167e 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -24,7 +24,7 @@ enum nft_registers {
 	__NFT_REG_MAX,
 
 	NFT_REG32_00	= 8,
-	MFT_REG32_01,
+	NFT_REG32_01,
 	NFT_REG32_02,
 	NFT_REG32_03,
 	NFT_REG32_04,
@@ -573,7 +573,7 @@ enum nft_range_attributes {
 	NFTA_RANGE_TO_DATA,
 	__NFTA_RANGE_MAX
 };
-#define NFTA_RANGE_MAX         (__NFTA_RANGE_MAX - 1)
+#define NFTA_RANGE_MAX		(__NFTA_RANGE_MAX - 1)
 
 enum nft_lookup_flags {
 	NFT_LOOKUP_F_INV = (1 << 0),
@@ -604,6 +604,10 @@ enum nft_dynset_ops {
 	NFT_DYNSET_OP_UPDATE,
 };
 
+enum nft_dynset_flags {
+	NFT_DYNSET_F_INV	= (1 << 0),
+};
+
 /**
  * enum nft_dynset_attributes - dynset expression attributes
  *
@@ -614,6 +618,7 @@ enum nft_dynset_ops {
  * @NFTA_DYNSET_SREG_DATA: source register of the data (NLA_U32)
  * @NFTA_DYNSET_TIMEOUT: timeout value for the new element (NLA_U64)
  * @NFTA_DYNSET_EXPR: expression (NLA_NESTED: nft_expr_attributes)
+ * @NFTA_DYNSET_FLAGS: flags (NLA_U32)
  */
 enum nft_dynset_attributes {
 	NFTA_DYNSET_UNSPEC,
@@ -625,6 +630,7 @@ enum nft_dynset_attributes {
 	NFTA_DYNSET_TIMEOUT,
 	NFTA_DYNSET_EXPR,
 	NFTA_DYNSET_PAD,
+	NFTA_DYNSET_FLAGS,
 	__NFTA_DYNSET_MAX,
 };
 #define NFTA_DYNSET_MAX		(__NFTA_DYNSET_MAX - 1)
@@ -753,6 +759,19 @@ enum nft_meta_keys {
 };
 
 /**
+ * enum nft_rt_keys - nf_tables routing expression keys
+ *
+ * @NFT_RT_CLASSID: realm value of packet's route (skb->dst->tclassid)
+ * @NFT_RT_NEXTHOP4: routing nexthop for IPv4
+ * @NFT_RT_NEXTHOP6: routing nexthop for IPv6
+ */
+enum nft_rt_keys {
+	NFT_RT_CLASSID,
+	NFT_RT_NEXTHOP4,
+	NFT_RT_NEXTHOP6,
+};
+
+/**
  * enum nft_hash_attributes - nf_tables hash expression netlink attributes
  *
  * @NFTA_HASH_SREG: source register (NLA_U32)
@@ -760,7 +779,7 @@ enum nft_meta_keys {
  * @NFTA_HASH_LEN: source data length (NLA_U32)
  * @NFTA_HASH_MODULUS: modulus value (NLA_U32)
  * @NFTA_HASH_SEED: seed value (NLA_U32)
- * @NFTA_HASH_OFFSET: offset value to be added (NLA_U32)
+ * @NFTA_HASH_OFFSET: add this offset value to hash result (NLA_U32)
  */
 enum nft_hash_attributes {
 	NFTA_HASH_UNSPEC,
@@ -791,6 +810,20 @@ enum nft_meta_attributes {
 #define NFTA_META_MAX		(__NFTA_META_MAX - 1)
 
 /**
+ * enum nft_rt_attributes - nf_tables routing expression netlink attributes
+ *
+ * @NFTA_RT_DREG: destination register (NLA_U32)
+ * @NFTA_RT_KEY: routing data item to load (NLA_U32: nft_rt_keys)
+ */
+enum nft_rt_attributes {
+	NFTA_RT_UNSPEC,
+	NFTA_RT_DREG,
+	NFTA_RT_KEY,
+	__NFTA_RT_MAX
+};
+#define NFTA_RT_MAX		(__NFTA_RT_MAX - 1)
+
+/**
  * enum nft_ct_keys - nf_tables ct expression keys
  *
  * @NFT_CT_STATE: conntrack state (bitmask of enum ip_conntrack_info)
@@ -1103,6 +1136,42 @@ enum nft_gen_attributes {
 };
 #define NFTA_GEN_MAX		(__NFTA_GEN_MAX - 1)
 
+/*
+ * enum nft_fib_attributes - nf_tables fib expression netlink attributes
+ *
+ * @NFTA_FIB_DREG: destination register (NLA_U32)
+ * @NFTA_FIB_RESULT: desired result (NLA_U32)
+ * @NFTA_FIB_FLAGS: flowi fields to initialize when querying the FIB (NLA_U32)
+ *
+ * The FIB expression performs a route lookup according
+ * to the packet data.
+ */
+enum nft_fib_attributes {
+	NFTA_FIB_UNSPEC,
+	NFTA_FIB_DREG,
+	NFTA_FIB_RESULT,
+	NFTA_FIB_FLAGS,
+	__NFTA_FIB_MAX
+};
+#define NFTA_FIB_MAX (__NFTA_FIB_MAX - 1)
+
+enum nft_fib_result {
+	NFT_FIB_RESULT_UNSPEC,
+	NFT_FIB_RESULT_OIF,
+	NFT_FIB_RESULT_OIFNAME,
+	NFT_FIB_RESULT_ADDRTYPE,
+	__NFT_FIB_RESULT_MAX
+};
+#define NFT_FIB_RESULT_MAX	(__NFT_FIB_RESULT_MAX - 1)
+
+enum nft_fib_flags {
+	NFTA_FIB_F_SADDR	= 1 << 0,	/* look up src */
+	NFTA_FIB_F_DADDR	= 1 << 1,	/* look up dst */
+	NFTA_FIB_F_MARK		= 1 << 2,	/* use skb->mark */
+	NFTA_FIB_F_IIF		= 1 << 3,	/* restrict to iif */
+	NFTA_FIB_F_OIF		= 1 << 4,	/* restrict to oif */
+};
+
 /**
  * enum nft_trace_attributes - nf_tables trace netlink attributes
  *
@@ -1159,7 +1228,7 @@ enum nft_trace_types {
  * enum nft_ng_attributes - nf_tables number generator expression netlink attributes
  *
  * @NFTA_NG_DREG: destination register (NLA_U32)
- * @NFTA_NG_MODULUS: maximum value to be returned (NLA_U32)
+ * @NFTA_NG_MODULUS: maximum counter value (NLA_U32)
  * @NFTA_NG_TYPE: operation type (NLA_U32)
  * @NFTA_NG_OFFSET: offset to be added to the counter (NLA_U32)
  */
-- 
2.1.4

