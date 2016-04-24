From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH nft 2/6] nft: resync kernel header files
Date: Sun, 24 Apr 2016 22:30:36 +0100
Message-ID: <1461533440-10605-3-git-send-email-kaber@trash.net>
References: <1461533440-10605-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org, fw@strlen.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52080 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227AbcDXVjW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Apr 2016 17:39:22 -0400
In-Reply-To: <1461533440-10605-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/linux/netfilter/nf_tables.h | 91 +++++++++++++++++++++++++++++++++++--
 include/linux/netfilter/nfnetlink.h |  4 ++
 2 files changed, 90 insertions(+), 5 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 310c785..eeffde1 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_NF_TABLES_H
 #define _LINUX_NF_TABLES_H
 
+#define NFT_TABLE_MAXNAMELEN	32
 #define NFT_CHAIN_MAXNAMELEN	32
 #define NFT_USERDATA_MAXLEN	256
 
@@ -82,6 +83,7 @@ enum nft_verdicts {
  * @NFT_MSG_DELSETELEM: delete a set element (enum nft_set_elem_attributes)
  * @NFT_MSG_NEWGEN: announce a new generation, only for events (enum nft_gen_attributes)
  * @NFT_MSG_GETGEN: get the rule-set generation (enum nft_gen_attributes)
+ * @NFT_MSG_TRACE: trace event (enum nft_trace_attributes)
  */
 enum nf_tables_msg_types {
 	NFT_MSG_NEWTABLE,
@@ -101,6 +103,7 @@ enum nf_tables_msg_types {
 	NFT_MSG_DELSETELEM,
 	NFT_MSG_NEWGEN,
 	NFT_MSG_GETGEN,
+	NFT_MSG_TRACE,
 	NFT_MSG_MAX,
 };
 
@@ -121,11 +124,13 @@ enum nft_list_attributes {
  *
  * @NFTA_HOOK_HOOKNUM: netfilter hook number (NLA_U32)
  * @NFTA_HOOK_PRIORITY: netfilter hook priority (NLA_U32)
+ * @NFTA_HOOK_DEV: netdevice name (NLA_STRING)
  */
 enum nft_hook_attributes {
 	NFTA_HOOK_UNSPEC,
 	NFTA_HOOK_HOOKNUM,
 	NFTA_HOOK_PRIORITY,
+	NFTA_HOOK_DEV,
 	__NFTA_HOOK_MAX
 };
 #define NFTA_HOOK_MAX		(__NFTA_HOOK_MAX - 1)
@@ -237,6 +242,7 @@ enum nft_rule_compat_attributes {
  * @NFT_SET_INTERVAL: set contains intervals
  * @NFT_SET_MAP: set is used as a dictionary
  * @NFT_SET_TIMEOUT: set uses timeouts
+ * @NFT_SET_EVAL: set contains expressions for evaluation
  */
 enum nft_set_flags {
 	NFT_SET_ANONYMOUS		= 0x1,
@@ -244,6 +250,7 @@ enum nft_set_flags {
 	NFT_SET_INTERVAL		= 0x4,
 	NFT_SET_MAP			= 0x8,
 	NFT_SET_TIMEOUT			= 0x10,
+	NFT_SET_EVAL			= 0x20,
 };
 
 /**
@@ -284,6 +291,7 @@ enum nft_set_desc_attributes {
  * @NFTA_SET_ID: uniquely identifies a set in a transaction (NLA_U32)
  * @NFTA_SET_TIMEOUT: default timeout value (NLA_U64)
  * @NFTA_SET_GC_INTERVAL: garbage collection interval (NLA_U32)
+ * @NFTA_SET_USERDATA: user data (NLA_BINARY)
  */
 enum nft_set_attributes {
 	NFTA_SET_UNSPEC,
@@ -299,6 +307,7 @@ enum nft_set_attributes {
 	NFTA_SET_ID,
 	NFTA_SET_TIMEOUT,
 	NFTA_SET_GC_INTERVAL,
+	NFTA_SET_USERDATA,
 	__NFTA_SET_MAX
 };
 #define NFTA_SET_MAX		(__NFTA_SET_MAX - 1)
@@ -321,6 +330,7 @@ enum nft_set_elem_flags {
  * @NFTA_SET_ELEM_TIMEOUT: timeout value (NLA_U64)
  * @NFTA_SET_ELEM_EXPIRATION: expiration time (NLA_U64)
  * @NFTA_SET_ELEM_USERDATA: user data (NLA_BINARY)
+ * @NFTA_SET_ELEM_EXPR: expression (NLA_NESTED: nft_expr_attributes)
  */
 enum nft_set_elem_attributes {
 	NFTA_SET_ELEM_UNSPEC,
@@ -330,6 +340,7 @@ enum nft_set_elem_attributes {
 	NFTA_SET_ELEM_TIMEOUT,
 	NFTA_SET_ELEM_EXPIRATION,
 	NFTA_SET_ELEM_USERDATA,
+	NFTA_SET_ELEM_EXPR,
 	__NFTA_SET_ELEM_MAX
 };
 #define NFTA_SET_ELEM_MAX	(__NFTA_SET_ELEM_MAX - 1)
@@ -562,6 +573,7 @@ enum nft_dynset_ops {
  * @NFTA_DYNSET_SREG_KEY: source register of the key (NLA_U32)
  * @NFTA_DYNSET_SREG_DATA: source register of the data (NLA_U32)
  * @NFTA_DYNSET_TIMEOUT: timeout value for the new element (NLA_U64)
+ * @NFTA_DYNSET_EXPR: expression (NLA_NESTED: nft_expr_attributes)
  */
 enum nft_dynset_attributes {
 	NFTA_DYNSET_UNSPEC,
@@ -571,6 +583,7 @@ enum nft_dynset_attributes {
 	NFTA_DYNSET_SREG_KEY,
 	NFTA_DYNSET_SREG_DATA,
 	NFTA_DYNSET_TIMEOUT,
+	NFTA_DYNSET_EXPR,
 	__NFTA_DYNSET_MAX,
 };
 #define NFTA_DYNSET_MAX		(__NFTA_DYNSET_MAX - 1)
@@ -668,6 +681,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_IIFGROUP: packet input interface group
  * @NFT_META_OIFGROUP: packet output interface group
  * @NFT_META_CGROUP: socket control group (skb->sk->sk_classid)
+ * @NFT_META_PRANDOM: a 32bit pseudo-random number
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -694,6 +708,7 @@ enum nft_meta_keys {
 	NFT_META_IIFGROUP,
 	NFT_META_OIFGROUP,
 	NFT_META_CGROUP,
+	NFT_META_PRANDOM,
 };
 
 /**
@@ -772,7 +787,7 @@ enum nft_limit_type {
 };
 
 enum nft_limit_flags {
-	NFT_LIMIT_F_INV = (1 << 0),
+	NFT_LIMIT_F_INV	= (1 << 0),
 };
 
 /**
@@ -936,10 +951,14 @@ enum nft_nat_attributes {
  * enum nft_masq_attributes - nf_tables masquerade expression attributes
  *
  * @NFTA_MASQ_FLAGS: NAT flags (see NF_NAT_RANGE_* in linux/netfilter/nf_nat.h) (NLA_U32)
+ * @NFTA_MASQ_REG_PROTO_MIN: source register of proto range start (NLA_U32: nft_registers)
+ * @NFTA_MASQ_REG_PROTO_MAX: source register of proto range end (NLA_U32: nft_registers)
  */
 enum nft_masq_attributes {
 	NFTA_MASQ_UNSPEC,
 	NFTA_MASQ_FLAGS,
+	NFTA_MASQ_REG_PROTO_MIN,
+	NFTA_MASQ_REG_PROTO_MAX,
 	__NFTA_MASQ_MAX
 };
 #define NFTA_MASQ_MAX		(__NFTA_MASQ_MAX - 1)
@@ -961,12 +980,12 @@ enum nft_redir_attributes {
 #define NFTA_REDIR_MAX		(__NFTA_REDIR_MAX - 1)
 
 /**
- * enum nft_tee_attributes - nf_tables tee expression netlink attributes
+ * enum nft_dup_attributes - nf_tables dup expression netlink attributes
  *
- * @NFTA_DUP_SREG_ADDR: source register of destination (NLA_U32: nft_registers)
- * @NFTA_DUP_SREG_DEV: output interface name (NLA_U32: nft_register)
+ * @NFTA_DUP_SREG_ADDR: source register of address (NLA_U32: nft_registers)
+ * @NFTA_DUP_SREG_DEV: source register of output interface (NLA_U32: nft_register)
  */
-enum nft_tee_attributes {
+enum nft_dup_attributes {
 	NFTA_DUP_UNSPEC,
 	NFTA_DUP_SREG_ADDR,
 	NFTA_DUP_SREG_DEV,
@@ -975,6 +994,18 @@ enum nft_tee_attributes {
 #define NFTA_DUP_MAX		(__NFTA_DUP_MAX - 1)
 
 /**
+ * enum nft_fwd_attributes - nf_tables fwd expression netlink attributes
+ *
+ * @NFTA_FWD_SREG_DEV: source register of output interface (NLA_U32: nft_register)
+ */
+enum nft_fwd_attributes {
+	NFTA_FWD_UNSPEC,
+	NFTA_FWD_SREG_DEV,
+	__NFTA_FWD_MAX
+};
+#define NFTA_FWD_MAX	(__NFTA_FWD_MAX - 1)
+
+/**
  * enum nft_gen_attributes - nf_tables ruleset generation attributes
  *
  * @NFTA_GEN_ID: Ruleset generation ID (NLA_U32)
@@ -986,4 +1017,54 @@ enum nft_gen_attributes {
 };
 #define NFTA_GEN_MAX		(__NFTA_GEN_MAX - 1)
 
+/**
+ * enum nft_trace_attributes - nf_tables trace netlink attributes
+ *
+ * @NFTA_TRACE_TABLE: name of the table (NLA_STRING)
+ * @NFTA_TRACE_CHAIN: name of the chain (NLA_STRING)
+ * @NFTA_TRACE_RULE_HANDLE: numeric handle of the rule (NLA_U64)
+ * @NFTA_TRACE_TYPE: type of the event (NLA_U32: nft_trace_types)
+ * @NFTA_TRACE_VERDICT: verdict returned by hook (NLA_NESTED: nft_verdicts)
+ * @NFTA_TRACE_ID: pseudo-id, same for each skb traced (NLA_U32)
+ * @NFTA_TRACE_LL_HEADER: linklayer header (NLA_BINARY)
+ * @NFTA_TRACE_NETWORK_HEADER: network header (NLA_BINARY)
+ * @NFTA_TRACE_TRANSPORT_HEADER: transport header (NLA_BINARY)
+ * @NFTA_TRACE_IIF: indev ifindex (NLA_U32)
+ * @NFTA_TRACE_IIFTYPE: netdev->type of indev (NLA_U16)
+ * @NFTA_TRACE_OIF: outdev ifindex (NLA_U32)
+ * @NFTA_TRACE_OIFTYPE: netdev->type of outdev (NLA_U16)
+ * @NFTA_TRACE_MARK: nfmark (NLA_U32)
+ * @NFTA_TRACE_NFPROTO: nf protocol processed (NLA_U32)
+ * @NFTA_TRACE_POLICY: policy that decided fate of packet (NLA_U32)
+ */
+enum nft_trace_attibutes {
+	NFTA_TRACE_UNSPEC,
+	NFTA_TRACE_TABLE,
+	NFTA_TRACE_CHAIN,
+	NFTA_TRACE_RULE_HANDLE,
+	NFTA_TRACE_TYPE,
+	NFTA_TRACE_VERDICT,
+	NFTA_TRACE_ID,
+	NFTA_TRACE_LL_HEADER,
+	NFTA_TRACE_NETWORK_HEADER,
+	NFTA_TRACE_TRANSPORT_HEADER,
+	NFTA_TRACE_IIF,
+	NFTA_TRACE_IIFTYPE,
+	NFTA_TRACE_OIF,
+	NFTA_TRACE_OIFTYPE,
+	NFTA_TRACE_MARK,
+	NFTA_TRACE_NFPROTO,
+	NFTA_TRACE_POLICY,
+	__NFTA_TRACE_MAX
+};
+#define NFTA_TRACE_MAX (__NFTA_TRACE_MAX - 1)
+
+enum nft_trace_types {
+	NFT_TRACETYPE_UNSPEC,
+	NFT_TRACETYPE_POLICY,
+	NFT_TRACETYPE_RETURN,
+	NFT_TRACETYPE_RULE,
+	__NFT_TRACETYPE_MAX
+};
+#define NFT_TRACETYPE_MAX (__NFT_TRACETYPE_MAX - 1)
 #endif /* _LINUX_NF_TABLES_H */
diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index 06eea26..454f78d 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -20,6 +20,10 @@ enum nfnetlink_groups {
 #define NFNLGRP_CONNTRACK_EXP_DESTROY	NFNLGRP_CONNTRACK_EXP_DESTROY
 	NFNLGRP_NFTABLES,
 #define NFNLGRP_NFTABLES		NFNLGRP_NFTABLES
+	NFNLGRP_ACCT_QUOTA,
+#define NFNLGRP_ACCT_QUOTA		NFNLGRP_ACCT_QUOTA
+	NFNLGRP_NFTRACE,
+#define NFNLGRP_NFTRACE			NFNLGRP_NFTRACE
 	__NFNLGRP_MAX,
 };
 #define NFNLGRP_MAX	(__NFNLGRP_MAX - 1)
-- 
2.5.5

