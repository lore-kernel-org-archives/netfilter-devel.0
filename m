From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 07/12] include: resync nftables.h with kernel
Date: Wed,  8 Jan 2014 13:08:58 +0000
Message-ID: <1389186543-6919-8-git-send-email-kaber@trash.net>
References: <1389186543-6919-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40196 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755990AbaAHNJT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jan 2014 08:09:19 -0500
In-Reply-To: <1389186543-6919-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/linux/netfilter.h           |  22 +++++--
 include/linux/netfilter/nf_tables.h | 116 ++++++++++++++++++++++++++++++------
 2 files changed, 115 insertions(+), 23 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 2eb00b6..be0bc18 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -3,6 +3,8 @@
 
 #include <linux/types.h>
 
+#include <linux/sysctl.h>
+
 
 /* Responses from hook functions. */
 #define NF_DROP 0
@@ -14,14 +16,20 @@
 #define NF_MAX_VERDICT NF_STOP
 
 /* we overload the higher bits for encoding auxiliary data such as the queue
- * number. Not nice, but better than additional function arguments. */
-#define NF_VERDICT_MASK 0x0000ffff
-#define NF_VERDICT_BITS 16
+ * number or errno values. Not nice, but better than additional function
+ * arguments. */
+#define NF_VERDICT_MASK 0x000000ff
+
+/* extra verdict flags have mask 0x0000ff00 */
+#define NF_VERDICT_FLAG_QUEUE_BYPASS	0x00008000
 
+/* queue number (NF_QUEUE) or errno (NF_DROP) */
 #define NF_VERDICT_QMASK 0xffff0000
 #define NF_VERDICT_QBITS 16
 
-#define NF_QUEUE_NR(x) ((((x) << NF_VERDICT_BITS) & NF_VERDICT_QMASK) | NF_QUEUE)
+#define NF_QUEUE_NR(x) ((((x) << 16) & NF_VERDICT_QMASK) | NF_QUEUE)
+
+#define NF_DROP_ERR(x) (((-x) << 16) | NF_DROP)
 
 /* only for userspace compatibility */
 /* Generic cache responses from hook functions.
@@ -29,6 +37,9 @@
 #define NFC_UNKNOWN 0x4000
 #define NFC_ALTERED 0x8000
 
+/* NF_VERDICT_BITS should be 8 now, but userspace might break if this changes */
+#define NF_VERDICT_BITS 16
+
 enum nf_inet_hooks {
 	NF_INET_PRE_ROUTING,
 	NF_INET_LOCAL_IN,
@@ -40,6 +51,7 @@ enum nf_inet_hooks {
 
 enum {
 	NFPROTO_UNSPEC =  0,
+	NFPROTO_INET   =  1,
 	NFPROTO_IPV4   =  2,
 	NFPROTO_ARP    =  3,
 	NFPROTO_BRIDGE =  7,
@@ -56,4 +68,4 @@ union nf_inet_addr {
 	struct in6_addr	in6;
 };
 
-#endif /*__LINUX_NETFILTER_H*/
+#endif /* __LINUX_NETFILTER_H */
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 1d5a925..448593c 100644
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
@@ -48,8 +67,6 @@ enum nf_tables_msg_types {
 	NFT_MSG_NEWSETELEM,
 	NFT_MSG_GETSETELEM,
 	NFT_MSG_DELSETELEM,
-	NFT_MSG_COMMIT,
-	NFT_MSG_ABORT,
 	NFT_MSG_MAX,
 };
 
@@ -92,11 +109,14 @@ enum nft_table_flags {
  * enum nft_table_attributes - nf_tables table netlink attributes
  *
  * @NFTA_TABLE_NAME: name of the table (NLA_STRING)
+ * @NFTA_TABLE_FLAGS: bitmask of enum nft_table_flags (NLA_U32)
+ * @NFTA_TABLE_USE: number of chains in this table (NLA_U32)
  */
 enum nft_table_attributes {
 	NFTA_TABLE_UNSPEC,
 	NFTA_TABLE_NAME,
 	NFTA_TABLE_FLAGS,
+	NFTA_TABLE_USE,
 	__NFTA_TABLE_MAX
 };
 #define NFTA_TABLE_MAX		(__NFTA_TABLE_MAX - 1)
@@ -105,8 +125,13 @@ enum nft_table_attributes {
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
@@ -122,18 +147,15 @@ enum nft_chain_attributes {
 };
 #define NFTA_CHAIN_MAX		(__NFTA_CHAIN_MAX - 1)
 
-enum {
-	NFT_RULE_F_COMMIT	= (1 << 0),
-	NFT_RULE_F_MASK		= NFT_RULE_F_COMMIT,
-};
-
 /**
  * enum nft_rule_attributes - nf_tables rule netlink attributes
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
@@ -141,17 +163,28 @@ enum nft_rule_attributes {
 	NFTA_RULE_CHAIN,
 	NFTA_RULE_HANDLE,
 	NFTA_RULE_EXPRESSIONS,
-	NFTA_RULE_FLAGS,
 	NFTA_RULE_COMPAT,
+	NFTA_RULE_POSITION,
 	__NFTA_RULE_MAX
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
@@ -349,11 +382,26 @@ enum nft_bitwise_attributes {
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
@@ -365,6 +413,16 @@ enum nft_byteorder_attributes {
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
@@ -390,6 +448,13 @@ enum nft_cmp_attributes {
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
@@ -430,6 +495,14 @@ enum nft_payload_attributes {
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
@@ -458,6 +531,8 @@ enum nft_exthdr_attributes {
  * @NFT_META_NFTRACE: packet nftrace bit
  * @NFT_META_RTCLASSID: realm value of packet's route (skb->dst->tclassid)
  * @NFT_META_SECMARK: packet secmark (skb->secmark)
+ * @NFT_META_NFPROTO: netfilter protocol
+ * @NFT_META_L4PROTO: layer 4 protocol number
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -475,6 +550,8 @@ enum nft_meta_keys {
 	NFT_META_NFTRACE,
 	NFT_META_RTCLASSID,
 	NFT_META_SECMARK,
+	NFT_META_NFPROTO,
+	NFT_META_L4PROTO,
 };
 
 /**
@@ -482,11 +559,13 @@ enum nft_meta_keys {
  *
  * @NFTA_META_DREG: destination register (NLA_U32)
  * @NFTA_META_KEY: meta data item to load (NLA_U32: nft_meta_keys)
+ * @NFTA_META_SREG: source register (NLA_U32)
  */
 enum nft_meta_attributes {
 	NFTA_META_UNSPEC,
 	NFTA_META_DREG,
 	NFTA_META_KEY,
+	NFTA_META_SREG,
 	__NFTA_META_MAX
 };
 #define NFTA_META_MAX		(__NFTA_META_MAX - 1)
@@ -544,12 +623,12 @@ enum nft_ct_attributes {
  * enum nft_limit_attributes - nf_tables limit expression netlink attributes
  *
  * @NFTA_LIMIT_RATE: refill rate (NLA_U64)
- * @NFTA_LIMIT_DEPTH: bucket depth (NLA_U64)
+ * @NFTA_LIMIT_UNIT: refill unit (NLA_U64)
  */
 enum nft_limit_attributes {
 	NFTA_LIMIT_UNSPEC,
 	NFTA_LIMIT_RATE,
-	NFTA_LIMIT_DEPTH,
+	NFTA_LIMIT_UNIT,
 	__NFTA_LIMIT_MAX
 };
 #define NFTA_LIMIT_MAX		(__NFTA_LIMIT_MAX - 1)
@@ -589,9 +668,9 @@ enum nft_log_attributes {
 /**
  * enum nft_queue_attributes - nf_tables queue expression netlink attributes
  *
- * @NFTA_QUEUE_NUM: netlink group to send messages to (NLA_U32)
- * @NFTA_QUEUE_TOTAL: prefix to prepend to log messages (NLA_STRING)
- * @NFTA_QUEUE_FLAGS: length of payload to include in netlink message (NLA_U32)
+ * @NFTA_QUEUE_NUM: netlink queue to send messages to (NLA_U16)
+ * @NFTA_QUEUE_TOTAL: number of queues to load balance packets on (NLA_U16)
+ * @NFTA_QUEUE_FLAGS: various flags (NLA_U16)
  */
 enum nft_queue_attributes {
 	NFTA_QUEUE_UNSPEC,
@@ -646,10 +725,11 @@ enum nft_nat_types {
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
1.8.4.2

