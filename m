From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [libnftables PATCH 1/2] include: Update API documentation in sync with kernel's one
Date: Thu, 12 Dec 2013 15:00:43 +0200
Message-ID: <1386853244-16783-3-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1386853244-16783-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:31068 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568Ab3LLNAy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Dec 2013 08:00:54 -0500
In-Reply-To: <1386853244-16783-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Adding or modifying API's documentation on nf_tables.h.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 include/linux/netfilter/nf_tables.h | 89 ++++++++++++++++++++++++++++++++++---
 1 file changed, 84 insertions(+), 5 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index b58990e..256d36b 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -32,6 +32,25 @@ enum nft_verdicts {
 	NFT_RETURN	= -5,
 };
 
+/**
+ * enum nf_tables_msg_types - nf_tables netlink message types
+ *
+ * @NFT_MSG_NEWTABLE: create a new table (enum nft_table_attributes)
+ * @NFT_MSG_GETTABLE: get a table (enum nft_table_attributes)
+ * @NFT_MSG_DELTABLE: delete a table (enum nft_table_attributes)
+ * @NFT_MSG_NEWCHAIN: create a new chain (enum nft_chain_attributes)
+ * @NFT_MSG_GETCHAIN: get a chain (enum nft_chain_attributes)
+ * @NFT_MSG_DELCHAIN: delete a chain (enum nft_chain_attributes)
+ * @NFT_MSG_NEWRULE: create a new rule (enum nft_rule_attributes)
+ * @NFT_MSG_GETRULE: get a rule (enum nft_rule_attributes)
+ * @NFT_MSG_DELRULE: delete a rule (enum nft_rule_attributes)
+ * @NFT_MSG_NEWSET: create a new set (enum nft_set_attributes)
+ * @NFT_MSG_GETSET: get a set (enum nft_set_attributes)
+ * @NFT_MSG_DELSET: delete a set (enum nft_set_attributes)
+ * @NFT_MSG_NEWSETELEM: create a new set element (enum nft_set_elem_attributes)
+ * @NFT_MSG_GETSETELEM: get a set element (enum nft_set_elem_attributes)
+ * @NFT_MSG_DELSETELEM: delete a set element (enum nft_set_elem_attributes)
+ */
 enum nf_tables_msg_types {
 	NFT_MSG_NEWTABLE,
 	NFT_MSG_GETTABLE,
@@ -90,6 +109,7 @@ enum nft_table_flags {
  * enum nft_table_attributes - nf_tables table netlink attributes
  *
  * @NFTA_TABLE_NAME: name of the table (NLA_STRING)
+ * @NFTA_TABLE_FLAGS: bitmask of enum nft_table_flags (NLA_U32)
  */
 enum nft_table_attributes {
 	NFTA_TABLE_UNSPEC,
@@ -103,8 +123,13 @@ enum nft_table_attributes {
  * enum nft_chain_attributes - nf_tables chain netlink attributes
  *
  * @NFTA_CHAIN_TABLE: name of the table containing the chain (NLA_STRING)
+ * @NFTA_CHAIN_HANDLE: numeric handle of the chain (NLA_U64)
  * @NFTA_CHAIN_NAME: name of the chain (NLA_STRING)
  * @NFTA_CHAIN_HOOK: hook specification for basechains (NLA_NESTED: nft_hook_attributes)
+ * @NFTA_CHAIN_POLICY: numeric policy of the chain (NLA_U32)
+ * @NFTA_CHAIN_USE: number of references to this chain (NLA_U32)
+ * @NFTA_CHAIN_TYPE: type name of the string (NLA_NUL_STRING)
+ * @NFTA_CHAIN_COUNTERS: counter specification of the chain (NLA_NESTED: nft_counter_attributes)
  */
 enum nft_chain_attributes {
 	NFTA_CHAIN_UNSPEC,
@@ -125,8 +150,10 @@ enum nft_chain_attributes {
  *
  * @NFTA_RULE_TABLE: name of the table containing the rule (NLA_STRING)
  * @NFTA_RULE_CHAIN: name of the chain containing the rule (NLA_STRING)
- * @NFTA_RULE_HANDLE: numeric handle of the rule (NLA_U16)
+ * @NFTA_RULE_HANDLE: numeric handle of the rule (NLA_U64)
  * @NFTA_RULE_EXPRESSIONS: list of expressions (NLA_NESTED: nft_expr_attributes)
+ * @NFTA_RULE_COMPAT: compatibility specifications of the rule (NLA_NESTED: nft_rule_compat_attributes)
+ * @NFTA_RULE_POSITION: numeric handle of the previous rule (NLA_U64)
  */
 enum nft_rule_attributes {
 	NFTA_RULE_UNSPEC,
@@ -140,11 +167,22 @@ enum nft_rule_attributes {
 };
 #define NFTA_RULE_MAX		(__NFTA_RULE_MAX - 1)
 
+/**
+ * enum nft_rule_compat_flags - nf_tables rule compat flags
+ *
+ * @NFT_RULE_COMPAT_F_INV: invert the check result
+ */
 enum nft_rule_compat_flags {
 	NFT_RULE_COMPAT_F_INV	= (1 << 1),
 	NFT_RULE_COMPAT_F_MASK	= NFT_RULE_COMPAT_F_INV,
 };
 
+/**
+ * enum nft_rule_compat_attributes - nf_tables rule compat attributes
+ *
+ * @NFTA_RULE_COMPAT_PROTO: numerice value of handled protocol (NLA_U32)
+ * @NFTA_RULE_COMPAT_FLAGS: bitmask of enum nft_rule_compat_flags (NLA_U32)
+ */
 enum nft_rule_compat_attributes {
 	NFTA_RULE_COMPAT_UNSPEC,
 	NFTA_RULE_COMPAT_PROTO,
@@ -342,11 +380,26 @@ enum nft_bitwise_attributes {
 };
 #define NFTA_BITWISE_MAX	(__NFTA_BITWISE_MAX - 1)
 
+/**
+ * enum nft_byteorder_ops - nf_tables byteorder operators
+ *
+ * @NFT_BYTEORDER_NTOH: network to host operator
+ * @NFT_BYTEORDER_HTON: host to network opertaor
+ */
 enum nft_byteorder_ops {
 	NFT_BYTEORDER_NTOH,
 	NFT_BYTEORDER_HTON,
 };
 
+/**
+ * enum nft_byteorder_attributes - nf_tables byteorder expression netlink attributes
+ *
+ * @NFTA_BYTEORDER_SREG: source register (NLA_U32: nft_registers)
+ * @NFTA_BYTEORDER_DREG: destination register (NLA_U32: nft_registers)
+ * @NFTA_BYTEORDER_OP: operator (NLA_U32: enum nft_byteorder_ops)
+ * @NFTA_BYTEORDER_LEN: length of the data (NLA_U32)
+ * @NFTA_BYTEORDER_SIZE: data size in bytes (NLA_U32: 2 or 4)
+ */
 enum nft_byteorder_attributes {
 	NFTA_BYTEORDER_UNSPEC,
 	NFTA_BYTEORDER_SREG,
@@ -358,6 +411,16 @@ enum nft_byteorder_attributes {
 };
 #define NFTA_BYTEORDER_MAX	(__NFTA_BYTEORDER_MAX - 1)
 
+/**
+ * enum nft_cmp_ops - nf_tables relational operator
+ *
+ * @NFT_CMP_EQ: equal
+ * @NFT_CMP_NEQ: not equal
+ * @NFT_CMP_LT: less than
+ * @NFT_CMP_LTE: less than or equal to
+ * @NFT_CMP_GT: greater than
+ * @NFT_CMP_GTE: greater than or equal to
+ */
 enum nft_cmp_ops {
 	NFT_CMP_EQ,
 	NFT_CMP_NEQ,
@@ -383,6 +446,13 @@ enum nft_cmp_attributes {
 };
 #define NFTA_CMP_MAX		(__NFTA_CMP_MAX - 1)
 
+/**
+ * enum nft_lookup_attributes - nf_tables set lookup expression netlink attributes
+ *
+ * @NFTA_LOOKUP_SET: name of the set where to look for (NLA_STRING)
+ * @NFTA_LOOKUP_SREG: source register of the data to look for (NLA_U32: nft_registers)
+ * @NFTA_LOOKUP_DREG: destination register (NLA_U32: nft_registers)
+ */
 enum nft_lookup_attributes {
 	NFTA_LOOKUP_UNSPEC,
 	NFTA_LOOKUP_SET,
@@ -423,6 +493,14 @@ enum nft_payload_attributes {
 };
 #define NFTA_PAYLOAD_MAX	(__NFTA_PAYLOAD_MAX - 1)
 
+/**
+ * enum nft_exthdr_attributes - nf_tables IPv6 extension header expression netlink attributes
+ *
+ * @NFTA_EXTHDR_DREG: destination register (NLA_U32: nft_registers)
+ * @NFTA_EXTHDR_TYPE: extension header type (NLA_U8)
+ * @NFTA_EXTHDR_OFFSET: extension header offset (NLA_U32)
+ * @NFTA_EXTHDR_LEN: extension header length (NLA_U32)
+ */
 enum nft_exthdr_attributes {
 	NFTA_EXTHDR_UNSPEC,
 	NFTA_EXTHDR_DREG,
@@ -639,10 +717,11 @@ enum nft_nat_types {
  * enum nft_nat_attributes - nf_tables nat expression netlink attributes
  *
  * @NFTA_NAT_TYPE: NAT type (NLA_U32: nft_nat_types)
- * @NFTA_NAT_ADDR_MIN: source register of address range start (NLA_U32: nft_registers)
- * @NFTA_NAT_ADDR_MAX: source register of address range end (NLA_U32: nft_registers)
- * @NFTA_NAT_PROTO_MIN: source register of proto range start (NLA_U32: nft_registers)
- * @NFTA_NAT_PROTO_MAX: source register of proto range end (NLA_U32: nft_registers)
+ * @NFTA_NAT_FAMILY: NAT family (NLA_U32)
+ * @NFTA_NAT_REG_ADDR_MIN: source register of address range start (NLA_U32: nft_registers)
+ * @NFTA_NAT_REG_ADDR_MAX: source register of address range end (NLA_U32: nft_registers)
+ * @NFTA_NAT_REG_PROTO_MIN: source register of proto range start (NLA_U32: nft_registers)
+ * @NFTA_NAT_REG_PROTO_MAX: source register of proto range end (NLA_U32: nft_registers)
  */
 enum nft_nat_attributes {
 	NFTA_NAT_UNSPEC,
-- 
1.8.4.4

