From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] include: refresh include/linux/nf_tables.h cached copy
Date: Thu, 11 Sep 2014 19:01:17 +0200
Message-ID: <1410454877-7236-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36431 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470AbaIKRAa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Sep 2014 13:00:30 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Keep in sync with nf_tables.h header file in net-next tree.

Rename NFT_CT_LABEL to NFT_CT_LABELS, this probably slipped through
when editing the header file by hand.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_tables.h |   61 +++++++++++++++++++++++++++++++++--
 src/ct.c                            |    2 +-
 src/parser.y                        |    2 +-
 3 files changed, 60 insertions(+), 5 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index e8b9d19..66d66dd 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
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
@@ -209,6 +212,29 @@ enum nft_set_flags {
 };
 
 /**
+ * enum nft_set_policies - set selection policy
+ *
+ * @NFT_SET_POL_PERFORMANCE: prefer high performance over low memory use
+ * @NFT_SET_POL_MEMORY: prefer low memory use over high performance
+ */
+enum nft_set_policies {
+	NFT_SET_POL_PERFORMANCE,
+	NFT_SET_POL_MEMORY,
+};
+
+/**
+ * enum nft_set_desc_attributes - set element description
+ *
+ * @NFTA_SET_DESC_SIZE: number of elements in set (NLA_U32)
+ */
+enum nft_set_desc_attributes {
+	NFTA_SET_DESC_UNSPEC,
+	NFTA_SET_DESC_SIZE,
+	__NFTA_SET_DESC_MAX
+};
+#define NFTA_SET_DESC_MAX	(__NFTA_SET_DESC_MAX - 1)
+
+/**
  * enum nft_set_attributes - nf_tables set netlink attributes
  *
  * @NFTA_SET_TABLE: table name (NLA_STRING)
@@ -218,6 +244,9 @@ enum nft_set_flags {
  * @NFTA_SET_KEY_LEN: key data length (NLA_U32)
  * @NFTA_SET_DATA_TYPE: mapping data type (NLA_U32)
  * @NFTA_SET_DATA_LEN: mapping data length (NLA_U32)
+ * @NFTA_SET_POLICY: selection policy (NLA_U32)
+ * @NFTA_SET_DESC: set description (NLA_NESTED)
+ * @NFTA_SET_ID: uniquely identifies a set in a transaction (NLA_U32)
  */
 enum nft_set_attributes {
 	NFTA_SET_UNSPEC,
@@ -228,6 +257,9 @@ enum nft_set_attributes {
 	NFTA_SET_KEY_LEN,
 	NFTA_SET_DATA_TYPE,
 	NFTA_SET_DATA_LEN,
+	NFTA_SET_POLICY,
+	NFTA_SET_DESC,
+	NFTA_SET_ID,
 	__NFTA_SET_MAX
 };
 #define NFTA_SET_MAX		(__NFTA_SET_MAX - 1)
@@ -263,12 +295,14 @@ enum nft_set_elem_attributes {
  * @NFTA_SET_ELEM_LIST_TABLE: table of the set to be changed (NLA_STRING)
  * @NFTA_SET_ELEM_LIST_SET: name of the set to be changed (NLA_STRING)
  * @NFTA_SET_ELEM_LIST_ELEMENTS: list of set elements (NLA_NESTED: nft_set_elem_attributes)
+ * @NFTA_SET_ELEM_LIST_SET_ID: uniquely identifies a set in a transaction (NLA_U32)
  */
 enum nft_set_elem_list_attributes {
 	NFTA_SET_ELEM_LIST_UNSPEC,
 	NFTA_SET_ELEM_LIST_TABLE,
 	NFTA_SET_ELEM_LIST_SET,
 	NFTA_SET_ELEM_LIST_ELEMENTS,
+	NFTA_SET_ELEM_LIST_SET_ID,
 	__NFTA_SET_ELEM_LIST_MAX
 };
 #define NFTA_SET_ELEM_LIST_MAX	(__NFTA_SET_ELEM_LIST_MAX - 1)
@@ -454,12 +488,14 @@ enum nft_cmp_attributes {
  * @NFTA_LOOKUP_SET: name of the set where to look for (NLA_STRING)
  * @NFTA_LOOKUP_SREG: source register of the data to look for (NLA_U32: nft_registers)
  * @NFTA_LOOKUP_DREG: destination register (NLA_U32: nft_registers)
+ * @NFTA_LOOKUP_SET_ID: uniquely identifies a set in a transaction (NLA_U32)
  */
 enum nft_lookup_attributes {
 	NFTA_LOOKUP_UNSPEC,
 	NFTA_LOOKUP_SET,
 	NFTA_LOOKUP_SREG,
 	NFTA_LOOKUP_DREG,
+	NFTA_LOOKUP_SET_ID,
 	__NFTA_LOOKUP_MAX
 };
 #define NFTA_LOOKUP_MAX		(__NFTA_LOOKUP_MAX - 1)
@@ -598,7 +634,6 @@ enum nft_meta_attributes {
  * @NFT_CT_PROTOCOL: conntrack layer 4 protocol
  * @NFT_CT_PROTO_SRC: conntrack layer 4 protocol source
  * @NFT_CT_PROTO_DST: conntrack layer 4 protocol destination
- * @NFT_CT_LABELS: conntrack label bitset (stored in conntrack extension)
  */
 enum nft_ct_keys {
 	NFT_CT_STATE,
@@ -614,7 +649,7 @@ enum nft_ct_keys {
 	NFT_CT_PROTOCOL,
 	NFT_CT_PROTO_SRC,
 	NFT_CT_PROTO_DST,
-	NFT_CT_LABEL,
+	NFT_CT_LABELS,
 };
 
 /**
@@ -623,12 +658,14 @@ enum nft_ct_keys {
  * @NFTA_CT_DREG: destination register (NLA_U32)
  * @NFTA_CT_KEY: conntrack data item to load (NLA_U32: nft_ct_keys)
  * @NFTA_CT_DIRECTION: direction in case of directional keys (NLA_U8)
+ * @NFTA_CT_SREG: source register (NLA_U32)
  */
 enum nft_ct_attributes {
 	NFTA_CT_UNSPEC,
 	NFTA_CT_DREG,
 	NFTA_CT_KEY,
 	NFTA_CT_DIRECTION,
+	NFTA_CT_SREG,
 	__NFTA_CT_MAX
 };
 #define NFTA_CT_MAX		(__NFTA_CT_MAX - 1)
@@ -668,6 +705,8 @@ enum nft_counter_attributes {
  * @NFTA_LOG_PREFIX: prefix to prepend to log messages (NLA_STRING)
  * @NFTA_LOG_SNAPLEN: length of payload to include in netlink message (NLA_U32)
  * @NFTA_LOG_QTHRESHOLD: queue threshold (NLA_U32)
+ * @NFTA_LOG_LEVEL: log level (NLA_U32)
+ * @NFTA_LOG_FLAGS: logging flags (NLA_U32)
  */
 enum nft_log_attributes {
 	NFTA_LOG_UNSPEC,
@@ -675,6 +714,8 @@ enum nft_log_attributes {
 	NFTA_LOG_PREFIX,
 	NFTA_LOG_SNAPLEN,
 	NFTA_LOG_QTHRESHOLD,
+	NFTA_LOG_LEVEL,
+	NFTA_LOG_FLAGS,
 	__NFTA_LOG_MAX
 };
 #define NFTA_LOG_MAX		(__NFTA_LOG_MAX - 1)
@@ -744,6 +785,7 @@ enum nft_nat_types {
  * @NFTA_NAT_REG_ADDR_MAX: source register of address range end (NLA_U32: nft_registers)
  * @NFTA_NAT_REG_PROTO_MIN: source register of proto range start (NLA_U32: nft_registers)
  * @NFTA_NAT_REG_PROTO_MAX: source register of proto range end (NLA_U32: nft_registers)
+ * @NFTA_NAT_FLAGS: NAT flags (see NF_NAT_RANGE_* in linux/netfilter/nf_nat.h) (NLA_U32)
  */
 enum nft_nat_attributes {
 	NFTA_NAT_UNSPEC,
@@ -753,8 +795,21 @@ enum nft_nat_attributes {
 	NFTA_NAT_REG_ADDR_MAX,
 	NFTA_NAT_REG_PROTO_MIN,
 	NFTA_NAT_REG_PROTO_MAX,
+	NFTA_NAT_FLAGS,
 	__NFTA_NAT_MAX
 };
 #define NFTA_NAT_MAX		(__NFTA_NAT_MAX - 1)
 
+/**
+ * enum nft_masq_attributes - nf_tables masquerade expression attributes
+ *
+ * @NFTA_MASQ_FLAGS: NAT flags (see NF_NAT_RANGE_* in linux/netfilter/nf_nat.h) (NLA_U32)
+ */
+enum nft_masq_attributes {
+	NFTA_MASQ_UNSPEC,
+	NFTA_MASQ_FLAGS,
+	__NFTA_MASQ_MAX
+};
+#define NFTA_MASQ_MAX		(__NFTA_MASQ_MAX - 1)
+
 #endif /* _LINUX_NF_TABLES_H */
diff --git a/src/ct.c b/src/ct.c
index 30639b2..2eb85ea 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -195,7 +195,7 @@ static const struct ct_template ct_templates[] = {
 	[NFT_CT_PROTO_DST]	= CT_TEMPLATE("proto-dst",  &invalid_type,
 					      BYTEORDER_BIG_ENDIAN,
 					      2 * BITS_PER_BYTE),
-	[NFT_CT_LABEL]		= CT_TEMPLATE("label", &ct_label_type,
+	[NFT_CT_LABELS]		= CT_TEMPLATE("label", &ct_label_type,
 					      BYTEORDER_HOST_ENDIAN,
 					      CT_LABEL_BIT_SIZE),
 };
diff --git a/src/parser.y b/src/parser.y
index aa40f90..6737aad 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -1896,7 +1896,7 @@ ct_key			:	STATE		{ $$ = NFT_CT_STATE; }
 			|	PROTOCOL	{ $$ = NFT_CT_PROTOCOL; }
 			|	PROTO_SRC	{ $$ = NFT_CT_PROTO_SRC; }
 			|	PROTO_DST	{ $$ = NFT_CT_PROTO_DST; }
-			|	LABEL		{ $$ = NFT_CT_LABEL; }
+			|	LABEL		{ $$ = NFT_CT_LABELS; }
 			;
 
 ct_stmt			:	CT	ct_key		SET	expr
-- 
1.7.10.4

