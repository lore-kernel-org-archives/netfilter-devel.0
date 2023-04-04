Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E77ACC6FD1D
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Apr 2023 09:46:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234186AbjDDJqQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Apr 2023 05:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234198AbjDDJqN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Apr 2023 05:46:13 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BCA12D73
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Apr 2023 02:45:51 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pjdEb-0004jq-Ow; Tue, 04 Apr 2023 11:45:49 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH iptables 1/2] include: update nf_tables uapi header
Date:   Tue,  4 Apr 2023 11:45:43 +0200
Message-Id: <20230404094544.2892-1-fw@strlen.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Taken from nf-next.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter/nf_tables.h | 59 ++++++++++++++++++++++++++---
 1 file changed, 54 insertions(+), 5 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index e94d1fa554cb..c4d4d8e42dc8 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -97,6 +97,14 @@ enum nft_verdicts {
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
  */
 enum nf_tables_msg_types {
 	NFT_MSG_NEWTABLE,
@@ -124,6 +132,14 @@ enum nf_tables_msg_types {
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
 	NFT_MSG_MAX,
 };
 
@@ -669,7 +685,7 @@ enum nft_range_ops {
  * enum nft_range_attributes - nf_tables range expression netlink attributes
  *
  * @NFTA_RANGE_SREG: source register of data to compare (NLA_U32: nft_registers)
- * @NFTA_RANGE_OP: cmp operation (NLA_U32: nft_cmp_ops)
+ * @NFTA_RANGE_OP: cmp operation (NLA_U32: nft_range_ops)
  * @NFTA_RANGE_FROM_DATA: data range from (NLA_NESTED: nft_data_attributes)
  * @NFTA_RANGE_TO_DATA: data range to (NLA_NESTED: nft_data_attributes)
  */
@@ -753,11 +769,14 @@ enum nft_dynset_attributes {
  * @NFT_PAYLOAD_LL_HEADER: link layer header
  * @NFT_PAYLOAD_NETWORK_HEADER: network header
  * @NFT_PAYLOAD_TRANSPORT_HEADER: transport header
+ * @NFT_PAYLOAD_INNER_HEADER: inner header / payload
  */
 enum nft_payload_bases {
 	NFT_PAYLOAD_LL_HEADER,
 	NFT_PAYLOAD_NETWORK_HEADER,
 	NFT_PAYLOAD_TRANSPORT_HEADER,
+	NFT_PAYLOAD_INNER_HEADER,
+	NFT_PAYLOAD_TUN_HEADER,
 };
 
 /**
@@ -777,6 +796,32 @@ enum nft_payload_csum_flags {
 	NFT_PAYLOAD_L4CSUM_PSEUDOHDR = (1 << 0),
 };
 
+enum nft_inner_type {
+	NFT_INNER_UNSPEC	= 0,
+	NFT_INNER_VXLAN,
+	NFT_INNER_GENEVE,
+};
+
+enum nft_inner_flags {
+	NFT_INNER_HDRSIZE	= (1 << 0),
+	NFT_INNER_LL		= (1 << 1),
+	NFT_INNER_NH		= (1 << 2),
+	NFT_INNER_TH		= (1 << 3),
+};
+#define NFT_INNER_MASK		(NFT_INNER_HDRSIZE | NFT_INNER_LL | \
+				 NFT_INNER_NH | NFT_INNER_TH)
+
+enum nft_inner_attributes {
+	NFTA_INNER_UNSPEC,
+	NFTA_INNER_NUM,
+	NFTA_INNER_TYPE,
+	NFTA_INNER_FLAGS,
+	NFTA_INNER_HDRSIZE,
+	NFTA_INNER_EXPR,
+	__NFTA_INNER_MAX
+};
+#define NFTA_INNER_MAX	(__NFTA_INNER_MAX - 1)
+
 /**
  * enum nft_payload_attributes - nf_tables payload expression netlink attributes
  *
@@ -833,7 +878,7 @@ enum nft_exthdr_op {
  * @NFTA_EXTHDR_LEN: extension header length (NLA_U32)
  * @NFTA_EXTHDR_FLAGS: extension header flags (NLA_U32)
  * @NFTA_EXTHDR_OP: option match type (NLA_U32)
- * @NFTA_EXTHDR_SREG: option match type (NLA_U32)
+ * @NFTA_EXTHDR_SREG: source register (NLA_U32: nft_registers)
  */
 enum nft_exthdr_attributes {
 	NFTA_EXTHDR_UNSPEC,
@@ -886,6 +931,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_TIME_HOUR: hour of day (in seconds)
  * @NFT_META_SDIF: slave device interface index
  * @NFT_META_SDIFNAME: slave device interface name
+ * @NFT_META_BRI_BROUTE: packet br_netfilter_broute bit
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -896,7 +942,8 @@ enum nft_meta_keys {
 	NFT_META_OIF,
 	NFT_META_IIFNAME,
 	NFT_META_OIFNAME,
-	NFT_META_IIFTYPE,
+	NFT_META_IFTYPE,
+#define NFT_META_IIFTYPE	NFT_META_IFTYPE
 	NFT_META_OIFTYPE,
 	NFT_META_SKUID,
 	NFT_META_SKGID,
@@ -923,6 +970,8 @@ enum nft_meta_keys {
 	NFT_META_TIME_HOUR,
 	NFT_META_SDIF,
 	NFT_META_SDIFNAME,
+	NFT_META_BRI_BROUTE,
+	__NFT_META_IIFTYPE,
 };
 
 /**
@@ -1213,10 +1262,10 @@ enum nft_last_attributes {
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
-- 
2.39.2

