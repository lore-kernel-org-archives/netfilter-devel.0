From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl 1/2] include: synchronize nf_tables.h with nftables tree
Date: Fri,  4 Apr 2014 15:54:54 +0200
Message-ID: <1396619695-28109-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49240 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752932AbaDDNzH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Apr 2014 09:55:07 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_tables.h |   28 ++++++++++++++++++++++++++--
 src/expr/ct.c                       |    4 ++--
 2 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index bb160d5..0167279 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -212,6 +212,29 @@ enum nft_set_flags {
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
@@ -221,6 +244,8 @@ enum nft_set_flags {
  * @NFTA_SET_KEY_LEN: key data length (NLA_U32)
  * @NFTA_SET_DATA_TYPE: mapping data type (NLA_U32)
  * @NFTA_SET_DATA_LEN: mapping data length (NLA_U32)
+ * @NFTA_SET_POLICY: selection policy (NLA_U32)
+ * @NFTA_SET_DESC: set description (NLA_NESTED)
  */
 enum nft_set_attributes {
 	NFTA_SET_UNSPEC,
@@ -589,7 +614,6 @@ enum nft_meta_attributes {
  * @NFT_CT_PROTOCOL: conntrack layer 4 protocol
  * @NFT_CT_PROTO_SRC: conntrack layer 4 protocol source
  * @NFT_CT_PROTO_DST: conntrack layer 4 protocol destination
- * @NFT_CT_LABEL: conntrack label
  */
 enum nft_ct_keys {
 	NFT_CT_STATE,
@@ -605,7 +629,7 @@ enum nft_ct_keys {
 	NFT_CT_PROTOCOL,
 	NFT_CT_PROTO_SRC,
 	NFT_CT_PROTO_DST,
-	NFT_CT_LABEL,
+	NFT_CT_LABELS,
 };
 
 /**
diff --git a/src/expr/ct.c b/src/expr/ct.c
index 4c18dde..38f5169 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -33,7 +33,7 @@ struct nft_expr_ct {
 #define IP_CT_DIR_REPLY		1
 
 #ifndef NFT_CT_MAX
-#define NFT_CT_MAX (NFT_CT_LABEL + 1)
+#define NFT_CT_MAX (NFT_CT_LABELS + 1)
 #endif
 
 static int
@@ -171,7 +171,7 @@ const char *ctkey2str_array[NFT_CT_MAX] = {
 	[NFT_CT_DST]		= "dst",
 	[NFT_CT_PROTO_SRC]	= "proto_src",
 	[NFT_CT_PROTO_DST]	= "proto_dst",
-	[NFT_CT_LABEL]		= "label",
+	[NFT_CT_LABELS]		= "label",
 };
 
 static const char *ctkey2str(uint32_t ctkey)
-- 
1.7.10.4

