Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D1081C6F76
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Oct 2024 12:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728565153; cv=none; b=n/bb44PE9wKWfvmW6FuCqCSAFNq5ZrPoGOaufQNWxBiHF74FVMYM5Qw8eaUiXJXha/feMGIuxHe2tkNa0Yi0tpIgbfh204Y+7Y6BmO/UWmrabUWoNyxj2J+rOshNjrz7is9Fs6nWN4moDeK9liEHDtVn5jdaWfShWjh3QNHnW5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728565153; c=relaxed/simple;
	bh=sj8TFk+3kTLEdBPRQmmzR1BgYoNy2VFLsoyCLElRUwI=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=hLhvQvthHlLgjed4G3TDGxg6xaJu/OYQT5cRr2OkBSOK/hi6NLE4cYTe8rlw3f0BeyCwGnV3AjejVx5VLjvj1tRgvy0TH0A4oWh8GdstbFHQw+4dhLLsjNUx+m1VQYubZ9ECWBWTXWFnXd0GUmmbMOIAUewkBsQPo4UwpSnW1AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl] include: refresh nf_tables.h copy
Date: Thu, 10 Oct 2024 14:58:58 +0200
Message-Id: <20241010125858.1540-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fetch what we have in the kernel tree.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_tables.h | 46 +++++++++++++++++++++++------
 1 file changed, 37 insertions(+), 9 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index c48b19333630..9e9079321380 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -97,6 +97,15 @@ enum nft_verdicts {
  * @NFT_MSG_NEWFLOWTABLE: add new flow table (enum nft_flowtable_attributes)
  * @NFT_MSG_GETFLOWTABLE: get flow table (enum nft_flowtable_attributes)
  * @NFT_MSG_DELFLOWTABLE: delete flow table (enum nft_flowtable_attributes)
+ * @NFT_MSG_GETRULE_RESET: get rules and reset stateful expressions (enum nft_obj_attributes)
+ * @NFT_MSG_DESTROYTABLE: destroy a table (enum nft_table_attributes)
+ * @NFT_MSG_DESTROYCHAIN: destroy a chain (enum nft_chain_attributes)
+ * @NFT_MSG_DESTROYRULE: destroy a rule (enum nft_rule_attributes)
+ * @NFT_MSG_DESTROYSET: destroy a set (enum nft_set_attributes)
+ * @NFT_MSG_DESTROYSETELEM: destroy a set element (enum nft_set_elem_attributes)
+ * @NFT_MSG_DESTROYOBJ: destroy a stateful object (enum nft_object_attributes)
+ * @NFT_MSG_DESTROYFLOWTABLE: destroy flow table (enum nft_flowtable_attributes)
+ * @NFT_MSG_GETSETELEM_RESET: get set elements and reset attached stateful expressions (enum nft_set_elem_attributes)
  */
 enum nf_tables_msg_types {
 	NFT_MSG_NEWTABLE,
@@ -124,6 +133,15 @@ enum nf_tables_msg_types {
 	NFT_MSG_NEWFLOWTABLE,
 	NFT_MSG_GETFLOWTABLE,
 	NFT_MSG_DELFLOWTABLE,
+	NFT_MSG_GETRULE_RESET,
+	NFT_MSG_DESTROYTABLE,
+	NFT_MSG_DESTROYCHAIN,
+	NFT_MSG_DESTROYRULE,
+	NFT_MSG_DESTROYSET,
+	NFT_MSG_DESTROYSETELEM,
+	NFT_MSG_DESTROYOBJ,
+	NFT_MSG_DESTROYFLOWTABLE,
+	NFT_MSG_GETSETELEM_RESET,
 	NFT_MSG_MAX,
 };
 
@@ -161,13 +179,17 @@ enum nft_hook_attributes {
  * enum nft_table_flags - nf_tables table flags
  *
  * @NFT_TABLE_F_DORMANT: this table is not active
+ * @NFT_TABLE_F_OWNER:   this table is owned by a process
+ * @NFT_TABLE_F_PERSIST: this table shall outlive its owner
  */
 enum nft_table_flags {
 	NFT_TABLE_F_DORMANT	= 0x1,
 	NFT_TABLE_F_OWNER	= 0x2,
+	NFT_TABLE_F_PERSIST	= 0x4,
 };
 #define NFT_TABLE_F_MASK	(NFT_TABLE_F_DORMANT | \
-				 NFT_TABLE_F_OWNER)
+				 NFT_TABLE_F_OWNER | \
+				 NFT_TABLE_F_PERSIST)
 
 /**
  * enum nft_table_attributes - nf_tables table netlink attributes
@@ -245,6 +267,7 @@ enum nft_chain_attributes {
  * @NFTA_RULE_USERDATA: user data (NLA_BINARY, NFT_USERDATA_MAXLEN)
  * @NFTA_RULE_ID: uniquely identifies a rule in a transaction (NLA_U32)
  * @NFTA_RULE_POSITION_ID: transaction unique identifier of the previous rule (NLA_U32)
+ * @NFTA_RULE_CHAIN_ID: add the rule to chain by ID, alternative to @NFTA_RULE_CHAIN (NLA_U32)
  */
 enum nft_rule_attributes {
 	NFTA_RULE_UNSPEC,
@@ -266,9 +289,11 @@ enum nft_rule_attributes {
 /**
  * enum nft_rule_compat_flags - nf_tables rule compat flags
  *
+ * @NFT_RULE_COMPAT_F_UNUSED: unused
  * @NFT_RULE_COMPAT_F_INV: invert the check result
  */
 enum nft_rule_compat_flags {
+	NFT_RULE_COMPAT_F_UNUSED = (1 << 0),
 	NFT_RULE_COMPAT_F_INV	= (1 << 1),
 	NFT_RULE_COMPAT_F_MASK	= NFT_RULE_COMPAT_F_INV,
 };
@@ -411,7 +436,7 @@ enum nft_set_elem_flags {
  * @NFTA_SET_ELEM_KEY: key value (NLA_NESTED: nft_data)
  * @NFTA_SET_ELEM_DATA: data value of mapping (NLA_NESTED: nft_data_attributes)
  * @NFTA_SET_ELEM_FLAGS: bitmask of nft_set_elem_flags (NLA_U32)
- * @NFTA_SET_ELEM_TIMEOUT: timeout value (NLA_U64)
+ * @NFTA_SET_ELEM_TIMEOUT: timeout value, zero means never times out (NLA_U64)
  * @NFTA_SET_ELEM_EXPIRATION: expiration time (NLA_U64)
  * @NFTA_SET_ELEM_USERDATA: user data (NLA_BINARY)
  * @NFTA_SET_ELEM_EXPR: expression (NLA_NESTED: nft_expr_attributes)
@@ -669,7 +694,7 @@ enum nft_range_ops {
  * enum nft_range_attributes - nf_tables range expression netlink attributes
  *
  * @NFTA_RANGE_SREG: source register of data to compare (NLA_U32: nft_registers)
- * @NFTA_RANGE_OP: cmp operation (NLA_U32: nft_cmp_ops)
+ * @NFTA_RANGE_OP: cmp operation (NLA_U32: nft_range_ops)
  * @NFTA_RANGE_FROM_DATA: data range from (NLA_NESTED: nft_data_attributes)
  * @NFTA_RANGE_TO_DATA: data range to (NLA_NESTED: nft_data_attributes)
  */
@@ -783,6 +808,7 @@ enum nft_payload_csum_flags {
 enum nft_inner_type {
 	NFT_INNER_UNSPEC	= 0,
 	NFT_INNER_VXLAN,
+	NFT_INNER_GENEVE,
 };
 
 enum nft_inner_flags {
@@ -792,7 +818,7 @@ enum nft_inner_flags {
 	NFT_INNER_TH		= (1 << 3),
 };
 #define NFT_INNER_MASK		(NFT_INNER_HDRSIZE | NFT_INNER_LL | \
-				 NFT_INNER_NH |  NFT_INNER_TH)
+				 NFT_INNER_NH | NFT_INNER_TH)
 
 enum nft_inner_attributes {
 	NFTA_INNER_UNSPEC,
@@ -842,12 +868,14 @@ enum nft_exthdr_flags {
  * @NFT_EXTHDR_OP_TCP: match against tcp options
  * @NFT_EXTHDR_OP_IPV4: match against ipv4 options
  * @NFT_EXTHDR_OP_SCTP: match against sctp chunks
+ * @NFT_EXTHDR_OP_DCCP: match against dccp otions
  */
 enum nft_exthdr_op {
 	NFT_EXTHDR_OP_IPV6,
 	NFT_EXTHDR_OP_TCPOPT,
 	NFT_EXTHDR_OP_IPV4,
 	NFT_EXTHDR_OP_SCTP,
+	NFT_EXTHDR_OP_DCCP,
 	__NFT_EXTHDR_OP_MAX
 };
 #define NFT_EXTHDR_OP_MAX	(__NFT_EXTHDR_OP_MAX - 1)
@@ -861,7 +889,7 @@ enum nft_exthdr_op {
  * @NFTA_EXTHDR_LEN: extension header length (NLA_U32)
  * @NFTA_EXTHDR_FLAGS: extension header flags (NLA_U32)
  * @NFTA_EXTHDR_OP: option match type (NLA_U32)
- * @NFTA_EXTHDR_SREG: option match type (NLA_U32)
+ * @NFTA_EXTHDR_SREG: source register (NLA_U32: nft_registers)
  */
 enum nft_exthdr_attributes {
 	NFTA_EXTHDR_UNSPEC,
@@ -1245,10 +1273,10 @@ enum nft_last_attributes {
 /**
  * enum nft_log_attributes - nf_tables log expression netlink attributes
  *
- * @NFTA_LOG_GROUP: netlink group to send messages to (NLA_U32)
+ * @NFTA_LOG_GROUP: netlink group to send messages to (NLA_U16)
  * @NFTA_LOG_PREFIX: prefix to prepend to log messages (NLA_STRING)
  * @NFTA_LOG_SNAPLEN: length of payload to include in netlink message (NLA_U32)
- * @NFTA_LOG_QTHRESHOLD: queue threshold (NLA_U32)
+ * @NFTA_LOG_QTHRESHOLD: queue threshold (NLA_U16)
  * @NFTA_LOG_LEVEL: log level (NLA_U32)
  * @NFTA_LOG_FLAGS: logging flags (NLA_U32)
  */
@@ -1348,7 +1376,7 @@ enum nft_secmark_attributes {
 #define NFTA_SECMARK_MAX	(__NFTA_SECMARK_MAX - 1)
 
 /* Max security context length */
-#define NFT_SECMARK_CTX_MAXLEN		256
+#define NFT_SECMARK_CTX_MAXLEN		4096
 
 /**
  * enum nft_reject_types - nf_tables reject expression reject types
@@ -1666,7 +1694,7 @@ enum nft_flowtable_flags {
  *
  * @NFTA_FLOWTABLE_TABLE: name of the table containing the expression (NLA_STRING)
  * @NFTA_FLOWTABLE_NAME: name of this flow table (NLA_STRING)
- * @NFTA_FLOWTABLE_HOOK: netfilter hook configuration(NLA_U32)
+ * @NFTA_FLOWTABLE_HOOK: netfilter hook configuration (NLA_NESTED)
  * @NFTA_FLOWTABLE_USE: number of references to this flow table (NLA_U32)
  * @NFTA_FLOWTABLE_HANDLE: object handle (NLA_U64)
  * @NFTA_FLOWTABLE_FLAGS: flags (NLA_U32)
-- 
2.30.2

