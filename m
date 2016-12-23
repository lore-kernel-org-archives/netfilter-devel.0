From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 01/10] include: fetch nf_tables.h updates
Date: Fri, 23 Dec 2016 15:26:46 +0100
Message-ID: <1482503215-25422-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40164 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941098AbcLWO1O (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Dec 2016 09:27:14 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 595FB2519A1
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Dec 2016 15:27:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4AA388E661
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Dec 2016 15:27:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AA4AC8E675
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Dec 2016 15:27:06 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Get header in sync with recent updates.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_tables.h | 64 +++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index f030e59aa2ec..881d49e94569 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -4,6 +4,7 @@
 #define NFT_TABLE_MAXNAMELEN	32
 #define NFT_CHAIN_MAXNAMELEN	32
 #define NFT_SET_MAXNAMELEN	32
+#define NFT_OBJ_MAXNAMELEN	32
 #define NFT_USERDATA_MAXLEN	256
 
 /**
@@ -85,6 +86,10 @@ enum nft_verdicts {
  * @NFT_MSG_NEWGEN: announce a new generation, only for events (enum nft_gen_attributes)
  * @NFT_MSG_GETGEN: get the rule-set generation (enum nft_gen_attributes)
  * @NFT_MSG_TRACE: trace event (enum nft_trace_attributes)
+ * @NFT_MSG_NEWOBJ: create a stateful object (enum nft_obj_attributes)
+ * @NFT_MSG_GETOBJ: get a stateful object (enum nft_obj_attributes)
+ * @NFT_MSG_DELOBJ: delete a stateful object (enum nft_obj_attributes)
+ * @NFT_MSG_GETOBJ_RESET: get and reset a stateful object (enum nft_obj_attributes)
  */
 enum nf_tables_msg_types {
 	NFT_MSG_NEWTABLE,
@@ -105,6 +110,10 @@ enum nf_tables_msg_types {
 	NFT_MSG_NEWGEN,
 	NFT_MSG_GETGEN,
 	NFT_MSG_TRACE,
+	NFT_MSG_NEWOBJ,
+	NFT_MSG_GETOBJ,
+	NFT_MSG_DELOBJ,
+	NFT_MSG_GETOBJ_RESET,
 	NFT_MSG_MAX,
 };
 
@@ -246,6 +255,7 @@ enum nft_rule_compat_attributes {
  * @NFT_SET_MAP: set is used as a dictionary
  * @NFT_SET_TIMEOUT: set uses timeouts
  * @NFT_SET_EVAL: set contains expressions for evaluation
+ * @NFT_SET_OBJECT: set contains stateful objects
  */
 enum nft_set_flags {
 	NFT_SET_ANONYMOUS		= 0x1,
@@ -254,6 +264,7 @@ enum nft_set_flags {
 	NFT_SET_MAP			= 0x8,
 	NFT_SET_TIMEOUT			= 0x10,
 	NFT_SET_EVAL			= 0x20,
+	NFT_SET_OBJECT			= 0x40,
 };
 
 /**
@@ -295,6 +306,7 @@ enum nft_set_desc_attributes {
  * @NFTA_SET_TIMEOUT: default timeout value (NLA_U64)
  * @NFTA_SET_GC_INTERVAL: garbage collection interval (NLA_U32)
  * @NFTA_SET_USERDATA: user data (NLA_BINARY)
+ * @NFTA_SET_OBJ_TYPE: stateful object type (NLA_U32: NFT_OBJECT_*)
  */
 enum nft_set_attributes {
 	NFTA_SET_UNSPEC,
@@ -312,6 +324,7 @@ enum nft_set_attributes {
 	NFTA_SET_GC_INTERVAL,
 	NFTA_SET_USERDATA,
 	NFTA_SET_PAD,
+	NFTA_SET_OBJ_TYPE,
 	__NFTA_SET_MAX
 };
 #define NFTA_SET_MAX		(__NFTA_SET_MAX - 1)
@@ -335,6 +348,7 @@ enum nft_set_elem_flags {
  * @NFTA_SET_ELEM_EXPIRATION: expiration time (NLA_U64)
  * @NFTA_SET_ELEM_USERDATA: user data (NLA_BINARY)
  * @NFTA_SET_ELEM_EXPR: expression (NLA_NESTED: nft_expr_attributes)
+ * @NFTA_SET_ELEM_OBJREF: stateful object reference (NLA_STRING)
  */
 enum nft_set_elem_attributes {
 	NFTA_SET_ELEM_UNSPEC,
@@ -346,6 +360,7 @@ enum nft_set_elem_attributes {
 	NFTA_SET_ELEM_USERDATA,
 	NFTA_SET_ELEM_EXPR,
 	NFTA_SET_ELEM_PAD,
+	NFTA_SET_ELEM_OBJREF,
 	__NFTA_SET_ELEM_MAX
 };
 #define NFTA_SET_ELEM_MAX	(__NFTA_SET_ELEM_MAX - 1)
@@ -974,6 +989,7 @@ enum nft_queue_attributes {
 
 enum nft_quota_flags {
 	NFT_QUOTA_F_INV		= (1 << 0),
+	NFT_QUOTA_F_DEPLETED	= (1 << 1),
 };
 
 /**
@@ -981,12 +997,14 @@ enum nft_quota_flags {
  *
  * @NFTA_QUOTA_BYTES: quota in bytes (NLA_U16)
  * @NFTA_QUOTA_FLAGS: flags (NLA_U32)
+ * @NFTA_QUOTA_CONSUMED: quota already consumed in bytes (NLA_U64)
  */
 enum nft_quota_attributes {
 	NFTA_QUOTA_UNSPEC,
 	NFTA_QUOTA_BYTES,
 	NFTA_QUOTA_FLAGS,
 	NFTA_QUOTA_PAD,
+	NFTA_QUOTA_CONSUMED,
 	__NFTA_QUOTA_MAX
 };
 #define NFTA_QUOTA_MAX		(__NFTA_QUOTA_MAX - 1)
@@ -1131,6 +1149,26 @@ enum nft_fwd_attributes {
 #define NFTA_FWD_MAX	(__NFTA_FWD_MAX - 1)
 
 /**
+ * enum nft_objref_attributes - nf_tables stateful object expression netlink attributes
+ *
+ * @NFTA_OBJREF_IMM_TYPE: object type for immediate reference (NLA_U32: nft_register)
+ * @NFTA_OBJREF_IMM_NAME: object name for immediate reference (NLA_STRING)
+ * @NFTA_OBJREF_SET_SREG: source register of the data to look for (NLA_U32: nft_registers)
+ * @NFTA_OBJREF_SET_NAME: name of the set where to look for (NLA_STRING)
+ * @NFTA_OBJREF_SET_ID: id of the set where to look for in this transaction (NLA_U32)
+ */
+enum nft_objref_attributes {
+	NFTA_OBJREF_UNSPEC,
+	NFTA_OBJREF_IMM_TYPE,
+	NFTA_OBJREF_IMM_NAME,
+	NFTA_OBJREF_SET_SREG,
+	NFTA_OBJREF_SET_NAME,
+	NFTA_OBJREF_SET_ID,
+	__NFTA_OBJREF_MAX
+};
+#define NFTA_OBJREF_MAX	(__NFTA_OBJREF_MAX - 1)
+
+/**
  * enum nft_gen_attributes - nf_tables ruleset generation attributes
  *
  * @NFTA_GEN_ID: Ruleset generation ID (NLA_U32)
@@ -1178,6 +1216,32 @@ enum nft_fib_flags {
 	NFTA_FIB_F_OIF		= 1 << 4,	/* restrict to oif */
 };
 
+#define NFT_OBJECT_UNSPEC	0
+#define NFT_OBJECT_COUNTER	1
+#define NFT_OBJECT_QUOTA	2
+#define __NFT_OBJECT_MAX	3
+#define NFT_OBJECT_MAX		(__NFT_OBJECT_MAX - 1)
+
+/**
+ * enum nft_object_attributes - nf_tables stateful object netlink attributes
+ *
+ * @NFTA_OBJ_TABLE: name of the table containing the expression (NLA_STRING)
+ * @NFTA_OBJ_NAME: name of this expression type (NLA_STRING)
+ * @NFTA_OBJ_TYPE: stateful object type (NLA_U32)
+ * @NFTA_OBJ_DATA: stateful object data (NLA_NESTED)
+ * @NFTA_OBJ_USE: number of references to this expression (NLA_U32)
+ */
+enum nft_object_attributes {
+	NFTA_OBJ_UNSPEC,
+	NFTA_OBJ_TABLE,
+	NFTA_OBJ_NAME,
+	NFTA_OBJ_TYPE,
+	NFTA_OBJ_DATA,
+	NFTA_OBJ_USE,
+	__NFTA_OBJ_MAX
+};
+#define NFTA_OBJ_MAX		(__NFTA_OBJ_MAX - 1)
+
 /**
  * enum nft_trace_attributes - nf_tables trace netlink attributes
  *
-- 
2.1.4

