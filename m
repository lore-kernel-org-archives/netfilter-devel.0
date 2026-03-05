Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54908317141
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Mar 2026 11:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772709321; cv=none; b=roHirznU44KC53W+A2J8DZfUwn9xwhbyGpu2naiozYWhAMLEV/eRrkaxgZ86GAza+MoffHq5pbgTV5+nluKaSmhRAJDHdrXiSw74DIAV6qcjxtgOQKXpzWKTNAnPFLqg/Kj9HhXiP8xjRAlo0zihb5Nk7hGSKgBnqtLYUaIOI6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772709321; c=relaxed/simple;
	bh=2dMy+GDPwkMW4SVPjotfJoonoKxW0SYs+prgwC/ZmZI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=WACH5By0dfpmiiawr+LR4Ss0Aj2KIXEmaIeCqcdIxE+3BIwhOZMqEiltfzJhg4mYnWAoG8t8ZpnCSmCd1VSs1Wyj4j3BQgEoUj9H+dDsRoeW3+YmANQfcO9zyB88ux12OGX9cYkaABv4YUAjldlOaEi9gKDcFedJNKrTOH5yX+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Sr/H2o/A; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Sr/H2o/A"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=67GR0fv5cQV6eu1ViDD4fx24Yh6Q984g/j3er+zjJpE=; b=Sr/H2o/AOt4mZhN7zePEXnIMTT
	1VG9VOXVJGFY90lcPYUV0/NMcEnLXFKESag35pN5R6SyD+vcrWDuubI9KLPT13TIUaTVRMMtNNiiU
	zfNpHPwYj5HWS55K5Ce7OO9IGAMoZqGEZPKmP80qj7rYQNefztAOLXCzrbgy2+ZAUY6QT3v2zx/Fq
	mueZzQyVaN9zwxB8+bi5de8j7bstzBI3F8n/qPscBtHJZ8nWnoRPaFNHBtM3e0r4rbPJ6izZkOIA1
	XN0a/HKTPGDlZFsOTryIyGwjZbYa3h0k250Qk+iyuDKz7lSJ7sexTqQEeRiviRu/sC5Q+hWMKF05q
	DcyRdaVQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vy6fm-000000006wa-3UJS
	for netfilter-devel@vger.kernel.org;
	Thu, 05 Mar 2026 12:15:18 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/2] include: linux: nf_tables.h: Sync with current kernel UAPI headers
Date: Thu,  5 Mar 2026 12:15:12 +0100
Message-ID: <20260305111513.13910-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We want NFT_BITWISE_MASK_XOR, use the occasion to sync it entirely.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/linux/netfilter/nf_tables.h | 67 +++++++++++++++++++++++------
 1 file changed, 53 insertions(+), 14 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index c4d4d8e42dc8b..45c71f7d21c25 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -105,6 +105,7 @@ enum nft_verdicts {
  * @NFT_MSG_DESTROYSETELEM: destroy a set element (enum nft_set_elem_attributes)
  * @NFT_MSG_DESTROYOBJ: destroy a stateful object (enum nft_object_attributes)
  * @NFT_MSG_DESTROYFLOWTABLE: destroy flow table (enum nft_flowtable_attributes)
+ * @NFT_MSG_GETSETELEM_RESET: get set elements and reset attached stateful expressions (enum nft_set_elem_attributes)
  */
 enum nf_tables_msg_types {
 	NFT_MSG_NEWTABLE,
@@ -140,6 +141,7 @@ enum nf_tables_msg_types {
 	NFT_MSG_DESTROYSETELEM,
 	NFT_MSG_DESTROYOBJ,
 	NFT_MSG_DESTROYFLOWTABLE,
+	NFT_MSG_GETSETELEM_RESET,
 	NFT_MSG_MAX,
 };
 
@@ -177,13 +179,17 @@ enum nft_hook_attributes {
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
@@ -261,6 +267,7 @@ enum nft_chain_attributes {
  * @NFTA_RULE_USERDATA: user data (NLA_BINARY, NFT_USERDATA_MAXLEN)
  * @NFTA_RULE_ID: uniquely identifies a rule in a transaction (NLA_U32)
  * @NFTA_RULE_POSITION_ID: transaction unique identifier of the previous rule (NLA_U32)
+ * @NFTA_RULE_CHAIN_ID: add the rule to chain by ID, alternative to @NFTA_RULE_CHAIN (NLA_U32)
  */
 enum nft_rule_attributes {
 	NFTA_RULE_UNSPEC,
@@ -282,9 +289,11 @@ enum nft_rule_attributes {
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
@@ -385,6 +394,8 @@ enum nft_set_field_attributes {
  * @NFTA_SET_HANDLE: set handle (NLA_U64)
  * @NFTA_SET_EXPR: set expression (NLA_NESTED: nft_expr_attributes)
  * @NFTA_SET_EXPRESSIONS: list of expressions (NLA_NESTED: nft_list_attributes)
+ * @NFTA_SET_TYPE: set backend type (NLA_STRING)
+ * @NFTA_SET_COUNT: number of set elements (NLA_U32)
  */
 enum nft_set_attributes {
 	NFTA_SET_UNSPEC,
@@ -406,6 +417,8 @@ enum nft_set_attributes {
 	NFTA_SET_HANDLE,
 	NFTA_SET_EXPR,
 	NFTA_SET_EXPRESSIONS,
+	NFTA_SET_TYPE,
+	NFTA_SET_COUNT,
 	__NFTA_SET_MAX
 };
 #define NFTA_SET_MAX		(__NFTA_SET_MAX - 1)
@@ -427,7 +440,7 @@ enum nft_set_elem_flags {
  * @NFTA_SET_ELEM_KEY: key value (NLA_NESTED: nft_data)
  * @NFTA_SET_ELEM_DATA: data value of mapping (NLA_NESTED: nft_data_attributes)
  * @NFTA_SET_ELEM_FLAGS: bitmask of nft_set_elem_flags (NLA_U32)
- * @NFTA_SET_ELEM_TIMEOUT: timeout value (NLA_U64)
+ * @NFTA_SET_ELEM_TIMEOUT: timeout value, zero means never times out (NLA_U64)
  * @NFTA_SET_ELEM_EXPIRATION: expiration time (NLA_U64)
  * @NFTA_SET_ELEM_USERDATA: user data (NLA_BINARY)
  * @NFTA_SET_ELEM_EXPR: expression (NLA_NESTED: nft_expr_attributes)
@@ -555,16 +568,26 @@ enum nft_immediate_attributes {
 /**
  * enum nft_bitwise_ops - nf_tables bitwise operations
  *
- * @NFT_BITWISE_BOOL: mask-and-xor operation used to implement NOT, AND, OR and
- *                    XOR boolean operations
+ * @NFT_BITWISE_MASK_XOR: mask-and-xor operation used to implement NOT, AND, OR
+ *                        and XOR boolean operations
  * @NFT_BITWISE_LSHIFT: left-shift operation
  * @NFT_BITWISE_RSHIFT: right-shift operation
+ * @NFT_BITWISE_AND: and operation
+ * @NFT_BITWISE_OR: or operation
+ * @NFT_BITWISE_XOR: xor operation
  */
 enum nft_bitwise_ops {
-	NFT_BITWISE_BOOL,
+	NFT_BITWISE_MASK_XOR,
 	NFT_BITWISE_LSHIFT,
 	NFT_BITWISE_RSHIFT,
+	NFT_BITWISE_AND,
+	NFT_BITWISE_OR,
+	NFT_BITWISE_XOR,
 };
+/*
+ * Old name for NFT_BITWISE_MASK_XOR.  Retained for backwards-compatibility.
+ */
+#define NFT_BITWISE_BOOL NFT_BITWISE_MASK_XOR
 
 /**
  * enum nft_bitwise_attributes - nf_tables bitwise expression netlink attributes
@@ -577,6 +600,7 @@ enum nft_bitwise_ops {
  * @NFTA_BITWISE_OP: type of operation (NLA_U32: nft_bitwise_ops)
  * @NFTA_BITWISE_DATA: argument for non-boolean operations
  *                     (NLA_NESTED: nft_data_attributes)
+ * @NFTA_BITWISE_SREG2: second source register (NLA_U32: nft_registers)
  *
  * The bitwise expression supports boolean and shift operations.  It implements
  * the boolean operations by performing the following operation:
@@ -600,6 +624,7 @@ enum nft_bitwise_attributes {
 	NFTA_BITWISE_XOR,
 	NFTA_BITWISE_OP,
 	NFTA_BITWISE_DATA,
+	NFTA_BITWISE_SREG2,
 	__NFTA_BITWISE_MAX
 };
 #define NFTA_BITWISE_MAX	(__NFTA_BITWISE_MAX - 1)
@@ -856,15 +881,17 @@ enum nft_exthdr_flags {
  * enum nft_exthdr_op - nf_tables match options
  *
  * @NFT_EXTHDR_OP_IPV6: match against ipv6 extension headers
- * @NFT_EXTHDR_OP_TCP: match against tcp options
+ * @NFT_EXTHDR_OP_TCPOPT: match against tcp options
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
@@ -932,6 +959,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_SDIF: slave device interface index
  * @NFT_META_SDIFNAME: slave device interface name
  * @NFT_META_BRI_BROUTE: packet br_netfilter_broute bit
+ * @NFT_META_BRI_IIFHWADDR: packet input bridge interface ethernet address
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -972,6 +1000,7 @@ enum nft_meta_keys {
 	NFT_META_SDIFNAME,
 	NFT_META_BRI_BROUTE,
 	__NFT_META_IIFTYPE,
+	NFT_META_BRI_IIFHWADDR,
 };
 
 /**
@@ -1171,7 +1200,7 @@ enum nft_ct_attributes {
 #define NFTA_CT_MAX		(__NFTA_CT_MAX - 1)
 
 /**
- * enum nft_flow_attributes - ct offload expression attributes
+ * enum nft_offload_attributes - ct offload expression attributes
  * @NFTA_FLOW_TABLE_NAME: flow table name (NLA_STRING)
  */
 enum nft_offload_attributes {
@@ -1365,7 +1394,7 @@ enum nft_secmark_attributes {
 #define NFTA_SECMARK_MAX	(__NFTA_SECMARK_MAX - 1)
 
 /* Max security context length */
-#define NFT_SECMARK_CTX_MAXLEN		256
+#define NFT_SECMARK_CTX_MAXLEN		4096
 
 /**
  * enum nft_reject_types - nf_tables reject expression reject types
@@ -1381,7 +1410,7 @@ enum nft_reject_types {
 };
 
 /**
- * enum nft_reject_code - Generic reject codes for IPv4/IPv6
+ * enum nft_reject_inet_code - Generic reject codes for IPv4/IPv6
  *
  * @NFT_REJECT_ICMPX_NO_ROUTE: no route to host / network unreachable
  * @NFT_REJECT_ICMPX_PORT_UNREACH: port unreachable
@@ -1451,9 +1480,9 @@ enum nft_nat_attributes {
 /**
  * enum nft_tproxy_attributes - nf_tables tproxy expression netlink attributes
  *
- * NFTA_TPROXY_FAMILY: Target address family (NLA_U32: nft_registers)
- * NFTA_TPROXY_REG_ADDR: Target address register (NLA_U32: nft_registers)
- * NFTA_TPROXY_REG_PORT: Target port register (NLA_U32: nft_registers)
+ * @NFTA_TPROXY_FAMILY: Target address family (NLA_U32: nft_registers)
+ * @NFTA_TPROXY_REG_ADDR: Target address register (NLA_U32: nft_registers)
+ * @NFTA_TPROXY_REG_PORT: Target port register (NLA_U32: nft_registers)
  */
 enum nft_tproxy_attributes {
 	NFTA_TPROXY_UNSPEC,
@@ -1683,7 +1712,7 @@ enum nft_flowtable_flags {
  *
  * @NFTA_FLOWTABLE_TABLE: name of the table containing the expression (NLA_STRING)
  * @NFTA_FLOWTABLE_NAME: name of this flow table (NLA_STRING)
- * @NFTA_FLOWTABLE_HOOK: netfilter hook configuration(NLA_U32)
+ * @NFTA_FLOWTABLE_HOOK: netfilter hook configuration (NLA_NESTED)
  * @NFTA_FLOWTABLE_USE: number of references to this flow table (NLA_U32)
  * @NFTA_FLOWTABLE_HANDLE: object handle (NLA_U64)
  * @NFTA_FLOWTABLE_FLAGS: flags (NLA_U32)
@@ -1754,13 +1783,15 @@ enum nft_synproxy_attributes {
 #define NFTA_SYNPROXY_MAX (__NFTA_SYNPROXY_MAX - 1)
 
 /**
- * enum nft_device_attributes - nf_tables device netlink attributes
+ * enum nft_devices_attributes - nf_tables device netlink attributes
  *
  * @NFTA_DEVICE_NAME: name of this device (NLA_STRING)
+ * @NFTA_DEVICE_PREFIX: device name prefix, a simple wildcard (NLA_STRING)
  */
 enum nft_devices_attributes {
 	NFTA_DEVICE_UNSPEC,
 	NFTA_DEVICE_NAME,
+	NFTA_DEVICE_PREFIX,
 	__NFTA_DEVICE_MAX
 };
 #define NFTA_DEVICE_MAX		(__NFTA_DEVICE_MAX - 1)
@@ -1814,6 +1845,10 @@ enum nft_xfrm_keys {
  * @NFTA_TRACE_MARK: nfmark (NLA_U32)
  * @NFTA_TRACE_NFPROTO: nf protocol processed (NLA_U32)
  * @NFTA_TRACE_POLICY: policy that decided fate of packet (NLA_U32)
+ * @NFTA_TRACE_CT_ID: conntrack id (NLA_U32)
+ * @NFTA_TRACE_CT_DIRECTION: packets direction (NLA_U8)
+ * @NFTA_TRACE_CT_STATUS: conntrack status (NLA_U32)
+ * @NFTA_TRACE_CT_STATE: packet state (new, established, ...) (NLA_U32)
  */
 enum nft_trace_attributes {
 	NFTA_TRACE_UNSPEC,
@@ -1834,6 +1869,10 @@ enum nft_trace_attributes {
 	NFTA_TRACE_NFPROTO,
 	NFTA_TRACE_POLICY,
 	NFTA_TRACE_PAD,
+	NFTA_TRACE_CT_ID,
+	NFTA_TRACE_CT_DIRECTION,
+	NFTA_TRACE_CT_STATUS,
+	NFTA_TRACE_CT_STATE,
 	__NFTA_TRACE_MAX
 };
 #define NFTA_TRACE_MAX (__NFTA_TRACE_MAX - 1)
-- 
2.51.0

