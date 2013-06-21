From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/5] src: get it sync with current include/linux/netfilter/nf_tables.h
Date: Fri, 21 Jun 2013 16:42:15 +0200
Message-ID: <1371825739-3669-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, eric@regit.org, tomasz.bursztyka@linux.intel.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41713 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161369Ab3FUOma (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Jun 2013 10:42:30 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This requires removing the NFT_CT_L3PROTOCOL which is not
there anymore and remove references to that definition in
other parts of the code.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_tables.h |   55 ++++++++++++++++++++++++++++++-----
 src/ct.c                            |    3 --
 src/parser.y                        |    2 --
 src/scanner.l                       |    1 -
 4 files changed, 47 insertions(+), 14 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 1c23073..8300089 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -1,6 +1,8 @@
 #ifndef _LINUX_NF_TABLES_H
 #define _LINUX_NF_TABLES_H
 
+#define NFT_CHAIN_MAXNAMELEN 32
+
 enum nft_registers {
 	NFT_REG_VERDICT,
 	NFT_REG_1,
@@ -46,6 +48,8 @@ enum nf_tables_msg_types {
 	NFT_MSG_NEWSETELEM,
 	NFT_MSG_GETSETELEM,
 	NFT_MSG_DELSETELEM,
+	NFT_MSG_COMMIT,
+	NFT_MSG_ABORT,
 	NFT_MSG_MAX,
 };
 
@@ -76,6 +80,15 @@ enum nft_hook_attributes {
 #define NFTA_HOOK_MAX		(__NFTA_HOOK_MAX - 1)
 
 /**
+ * enum nft_table_flags - nf_tables table flags
+ *
+ * @NFT_TABLE_F_DORMANT: this table is not active
+ */
+enum nft_table_flags {
+	NFT_TABLE_F_DORMANT	= 0x1,
+};
+
+/**
  * enum nft_table_attributes - nf_tables table netlink attributes
  *
  * @NFTA_TABLE_NAME: name of the table (NLA_STRING)
@@ -83,6 +96,7 @@ enum nft_hook_attributes {
 enum nft_table_attributes {
 	NFTA_TABLE_UNSPEC,
 	NFTA_TABLE_NAME,
+	NFTA_TABLE_FLAGS,
 	__NFTA_TABLE_MAX
 };
 #define NFTA_TABLE_MAX		(__NFTA_TABLE_MAX - 1)
@@ -97,12 +111,22 @@ enum nft_table_attributes {
 enum nft_chain_attributes {
 	NFTA_CHAIN_UNSPEC,
 	NFTA_CHAIN_TABLE,
+	NFTA_CHAIN_HANDLE,
 	NFTA_CHAIN_NAME,
 	NFTA_CHAIN_HOOK,
+	NFTA_CHAIN_POLICY,
+	NFTA_CHAIN_USE,
+	NFTA_CHAIN_TYPE,
+	NFTA_CHAIN_COUNTERS,
 	__NFTA_CHAIN_MAX
 };
 #define NFTA_CHAIN_MAX		(__NFTA_CHAIN_MAX - 1)
 
+enum {
+	NFT_RULE_F_COMMIT	= (1 << 0),
+	NFT_RULE_F_MASK		= NFT_RULE_F_COMMIT,
+};
+
 /**
  * enum nft_rule_attributes - nf_tables rule netlink attributes
  *
@@ -117,10 +141,25 @@ enum nft_rule_attributes {
 	NFTA_RULE_CHAIN,
 	NFTA_RULE_HANDLE,
 	NFTA_RULE_EXPRESSIONS,
+	NFTA_RULE_FLAGS,
+	NFTA_RULE_COMPAT,
 	__NFTA_RULE_MAX
 };
 #define NFTA_RULE_MAX		(__NFTA_RULE_MAX - 1)
 
+enum nft_rule_compat_flags {
+	NFT_RULE_COMPAT_F_INV	= (1 << 1),
+	NFT_RULE_COMPAT_F_MASK	= NFT_RULE_COMPAT_F_INV,
+};
+
+enum nft_rule_compat_attributes {
+	NFTA_RULE_COMPAT_UNSPEC,
+	NFTA_RULE_COMPAT_PROTO,
+	NFTA_RULE_COMPAT_FLAGS,
+	__NFTA_RULE_COMPAT_MAX
+};
+#define NFTA_RULE_COMPAT_MAX	(__NFTA_RULE_COMPAT_MAX - 1)
+
 /**
  * enum nft_set_flags - nf_tables set flags
  *
@@ -310,6 +349,7 @@ enum nft_bitwise_attributes {
 };
 #define NFTA_BITWISE_MAX	(__NFTA_BITWISE_MAX - 1)
 
+
 enum nft_byteorder_ops {
 	NFT_BYTEORDER_NTOH,
 	NFT_BYTEORDER_HTON,
@@ -462,10 +502,9 @@ enum nft_meta_attributes {
  * @NFT_CT_SECMARK: conntrack secmark value
  * @NFT_CT_EXPIRATION: relative conntrack expiration time in ms
  * @NFT_CT_HELPER: connection tracking helper assigned to conntrack
- * @NFT_CT_L3PROTOCOL: conntrack layer 3 protocol
+ * @NFT_CT_PROTOCOL: conntrack layer 3 protocol
  * @NFT_CT_SRC: conntrack layer 3 protocol source (IPv4/IPv6 address)
  * @NFT_CT_DST: conntrack layer 3 protocol destination (IPv4/IPv6 address)
- * @NFT_CT_PROTOCOL: conntrack layer 4 protocol
  * @NFT_CT_PROTO_SRC: conntrack layer 4 protocol source
  * @NFT_CT_PROTO_DST: conntrack layer 4 protocol destination
  */
@@ -477,10 +516,9 @@ enum nft_ct_keys {
 	NFT_CT_SECMARK,
 	NFT_CT_EXPIRATION,
 	NFT_CT_HELPER,
-	NFT_CT_L3PROTOCOL,
+	NFT_CT_PROTOCOL,
 	NFT_CT_SRC,
 	NFT_CT_DST,
-	NFT_CT_PROTOCOL,
 	NFT_CT_PROTO_SRC,
 	NFT_CT_PROTO_DST,
 };
@@ -595,10 +633,11 @@ enum nft_nat_types {
 enum nft_nat_attributes {
 	NFTA_NAT_UNSPEC,
 	NFTA_NAT_TYPE,
-	NFTA_NAT_ADDR_MIN,
-	NFTA_NAT_ADDR_MAX,
-	NFTA_NAT_PROTO_MIN,
-	NFTA_NAT_PROTO_MAX,
+	NFTA_NAT_FAMILY,
+	NFTA_NAT_REG_ADDR_MIN,
+	NFTA_NAT_REG_ADDR_MAX,
+	NFTA_NAT_REG_PROTO_MIN,
+	NFTA_NAT_REG_PROTO_MAX,
 	__NFTA_NAT_MAX
 };
 #define NFTA_NAT_MAX		(__NFTA_NAT_MAX - 1)
diff --git a/src/ct.c b/src/ct.c
index 1baefed..ebca9b7 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -111,9 +111,6 @@ static const struct ct_template ct_templates[] = {
 					      4 * BITS_PER_BYTE),
 	[NFT_CT_HELPER]		= CT_TEMPLATE("helper",	    &string_type,
 					      BYTEORDER_INVALID, 0),
-	[NFT_CT_L3PROTOCOL]	= CT_TEMPLATE("l3proto",    &invalid_type,
-					      BYTEORDER_INVALID,
-					      BITS_PER_BYTE),
 	[NFT_CT_SRC]		= CT_TEMPLATE("saddr",	    &invalid_type,
 					      BYTEORDER_BIG_ENDIAN, 0),
 	[NFT_CT_DST]		= CT_TEMPLATE("daddr",	    &invalid_type,
diff --git a/src/parser.y b/src/parser.y
index 2923b59..25a362f 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -295,7 +295,6 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token STATUS			"status"
 %token EXPIRATION		"expiration"
 %token HELPER			"helper"
-%token L3PROTOCOL		"l3proto"
 %token PROTO_SRC		"proto-src"
 %token PROTO_DST		"proto-dst"
 
@@ -1309,7 +1308,6 @@ ct_key			:	STATE		{ $$ = NFT_CT_STATE; }
 			|	SECMARK		{ $$ = NFT_CT_SECMARK; }
 			|	EXPIRATION	{ $$ = NFT_CT_EXPIRATION; }
 			|	HELPER		{ $$ = NFT_CT_HELPER; }
-			|	L3PROTOCOL	{ $$ = NFT_CT_L3PROTOCOL; }
 			|	SADDR		{ $$ = NFT_CT_SRC; }
 			|	DADDR		{ $$ = NFT_CT_DST; }
 			|	PROTOCOL	{ $$ = NFT_CT_PROTOCOL; }
diff --git a/src/scanner.l b/src/scanner.l
index fe7b86c..c2cf621 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -382,7 +382,6 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "status"		{ return STATUS; }
 "expiration"		{ return EXPIRATION; }
 "helper"		{ return HELPER; }
-"l3proto"		{ return L3PROTOCOL; }
 "proto-src"		{ return PROTO_SRC; }
 "proto-dst"		{ return PROTO_DST; }
 
-- 
1.7.10.4

