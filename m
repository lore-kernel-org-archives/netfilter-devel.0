Return-Path: <SRS0=20ch=WJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1418C32750
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 19:43:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A76FA206C2
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 19:43:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbfHMTns (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Aug 2019 15:43:48 -0400
Received: from correo.us.es ([193.147.175.20]:40466 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726007AbfHMTns (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Aug 2019 15:43:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E00A7DA73F
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2019 21:43:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D0FECDA7E1
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2019 21:43:42 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C6C01DA704; Tue, 13 Aug 2019 21:43:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8B1F8DA704
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2019 21:43:40 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 13 Aug 2019 21:43:40 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.218.116])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 5F0294265A2F
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2019 21:43:40 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl] include: resync nf_tables.h cache copy
Date:   Tue, 13 Aug 2019 21:43:37 +0200
Message-Id: <20190813194337.5583-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Get this header in sync with 5.3-rc1.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_tables.h | 124 ++++++++++++++++++++++++------------
 1 file changed, 82 insertions(+), 42 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 1bf4346c5278..82abaa183fc3 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -8,6 +8,7 @@
 #define NFT_SET_MAXNAMELEN	NFT_NAME_MAXLEN
 #define NFT_OBJ_MAXNAMELEN	NFT_NAME_MAXLEN
 #define NFT_USERDATA_MAXLEN	256
+#define NFT_OSF_MAXGENRELEN	16
 
 /**
  * enum nft_registers - nf_tables registers
@@ -191,6 +192,7 @@ enum nft_table_attributes {
  * @NFTA_CHAIN_USE: number of references to this chain (NLA_U32)
  * @NFTA_CHAIN_TYPE: type name of the string (NLA_NUL_STRING)
  * @NFTA_CHAIN_COUNTERS: counter specification of the chain (NLA_NESTED: nft_counter_attributes)
+ * @NFTA_CHAIN_FLAGS: chain flags
  */
 enum nft_chain_attributes {
 	NFTA_CHAIN_UNSPEC,
@@ -203,6 +205,7 @@ enum nft_chain_attributes {
 	NFTA_CHAIN_TYPE,
 	NFTA_CHAIN_COUNTERS,
 	NFTA_CHAIN_PAD,
+	NFTA_CHAIN_FLAGS,
 	__NFTA_CHAIN_MAX
 };
 #define NFTA_CHAIN_MAX		(__NFTA_CHAIN_MAX - 1)
@@ -268,7 +271,7 @@ enum nft_rule_compat_attributes {
  * @NFT_SET_INTERVAL: set contains intervals
  * @NFT_SET_MAP: set is used as a dictionary
  * @NFT_SET_TIMEOUT: set uses timeouts
- * @NFT_SET_EVAL: set contains expressions for evaluation
+ * @NFT_SET_EVAL: set can be updated from the evaluation path
  * @NFT_SET_OBJECT: set contains stateful objects
  */
 enum nft_set_flags {
@@ -794,6 +797,8 @@ enum nft_exthdr_attributes {
  * @NFT_META_SECPATH: boolean, secpath_exists (!!skb->sp)
  * @NFT_META_IIFKIND: packet input interface kind name (dev->rtnl_link_ops->kind)
  * @NFT_META_OIFKIND: packet output interface kind name (dev->rtnl_link_ops->kind)
+ * @NFT_META_BRI_IIFPVID: packet input bridge port pvid
+ * @NFT_META_BRI_IIFVPROTO: packet input bridge vlan proto
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -824,6 +829,8 @@ enum nft_meta_keys {
 	NFT_META_SECPATH,
 	NFT_META_IIFKIND,
 	NFT_META_OIFKIND,
+	NFT_META_BRI_IIFPVID,
+	NFT_META_BRI_IIFVPROTO,
 };
 
 /**
@@ -942,39 +949,6 @@ enum nft_socket_keys {
 #define NFT_SOCKET_MAX	(__NFT_SOCKET_MAX - 1)
 
 /**
- * enum nft_osf_attributes - nf_tables osf expression netlink attributes
- *
- * @NFTA_OSF_DREG: destination register (NLA_U32)
- * @NFTA_OSF_TTL: Value of the TTL osf option (NLA_U8)
- * @NFTA_OSF_FLAGS: flags (NLA_U32)
- */
-enum nft_osf_attributes {
-	NFTA_OSF_UNSPEC,
-	NFTA_OSF_DREG,
-	NFTA_OSF_TTL,
-	NFTA_OSF_FLAGS,
-	__NFTA_OSF_MAX,
-};
-#define NFTA_OSF_MAX (__NFTA_OSF_MAX - 1)
-
-/**
- * enum nft_synproxy_attributes - nf_tables synproxy expression
- * netlink attributes
- *
- * @NFTA_SYNPROXY_MSS: mss value sent to the backend (NLA_U16)
- * @NFTA_SYNPROXY_WSCALE: wscale value sent to the backend (NLA_U8)
- * @NFTA_SYNPROXY_FLAGS: flags (NLA_U32)
- */
-enum nft_synproxy_attributes {
-	NFTA_SYNPROXY_UNSPEC,
-	NFTA_SYNPROXY_MSS,
-	NFTA_SYNPROXY_WSCALE,
-	NFTA_SYNPROXY_FLAGS,
-	__NFTA_SYNPROXY_MAX,
-};
-#define NFTA_SYNPROXY_MAX (__NFTA_SYNPROXY_MAX - 1)
-
-/**
  * enum nft_ct_keys - nf_tables ct expression keys
  *
  * @NFT_CT_STATE: conntrack state (bitmask of enum ip_conntrack_info)
@@ -1000,7 +974,6 @@ enum nft_synproxy_attributes {
  * @NFT_CT_DST_IP: conntrack layer 3 protocol destination (IPv4 address)
  * @NFT_CT_SRC_IP6: conntrack layer 3 protocol source (IPv6 address)
  * @NFT_CT_DST_IP6: conntrack layer 3 protocol destination (IPv6 address)
- * @NFT_CT_TIMEOUT: connection tracking timeout policy assigned to conntrack
  * @NFT_CT_ID: conntrack id
  */
 enum nft_ct_keys {
@@ -1027,7 +1000,6 @@ enum nft_ct_keys {
 	NFT_CT_DST_IP,
 	NFT_CT_SRC_IP6,
 	NFT_CT_DST_IP6,
-	NFT_CT_TIMEOUT,
 	NFT_CT_ID,
 	__NFT_CT_MAX
 };
@@ -1148,6 +1120,33 @@ enum nft_log_attributes {
 #define NFTA_LOG_MAX		(__NFTA_LOG_MAX - 1)
 
 /**
+ * enum nft_log_level - nf_tables log levels
+ *
+ * @NFT_LOGLEVEL_EMERG: system is unusable
+ * @NFT_LOGLEVEL_ALERT: action must be taken immediately
+ * @NFT_LOGLEVEL_CRIT: critical conditions
+ * @NFT_LOGLEVEL_ERR: error conditions
+ * @NFT_LOGLEVEL_WARNING: warning conditions
+ * @NFT_LOGLEVEL_NOTICE: normal but significant condition
+ * @NFT_LOGLEVEL_INFO: informational
+ * @NFT_LOGLEVEL_DEBUG: debug-level messages
+ * @NFT_LOGLEVEL_AUDIT: enabling audit logging
+ */
+enum nft_log_level {
+	NFT_LOGLEVEL_EMERG,
+	NFT_LOGLEVEL_ALERT,
+	NFT_LOGLEVEL_CRIT,
+	NFT_LOGLEVEL_ERR,
+	NFT_LOGLEVEL_WARNING,
+	NFT_LOGLEVEL_NOTICE,
+	NFT_LOGLEVEL_INFO,
+	NFT_LOGLEVEL_DEBUG,
+	NFT_LOGLEVEL_AUDIT,
+	__NFT_LOGLEVEL_MAX
+};
+#define NFT_LOGLEVEL_MAX	(__NFT_LOGLEVEL_MAX - 1)
+
+/**
  * enum nft_queue_attributes - nf_tables queue expression netlink attributes
  *
  * @NFTA_QUEUE_NUM: netlink queue to send messages to (NLA_U16)
@@ -1192,7 +1191,7 @@ enum nft_quota_attributes {
 #define NFTA_QUOTA_MAX		(__NFTA_QUOTA_MAX - 1)
 
 /**
- * enum nft_secmark_attributes - nf_tables secmark expression netlink attributes
+ * enum nft_secmark_attributes - nf_tables secmark object netlink attributes
  *
  * @NFTA_SECMARK_CTX: security context (NLA_STRING)
  */
@@ -1445,7 +1444,7 @@ enum nft_ct_helper_attributes {
 };
 #define NFTA_CT_HELPER_MAX	(__NFTA_CT_HELPER_MAX - 1)
 
-enum nft_ct_timeout_attributes {
+enum nft_ct_timeout_timeout_attributes {
 	NFTA_CT_TIMEOUT_UNSPEC,
 	NFTA_CT_TIMEOUT_L3PROTO,
 	NFTA_CT_TIMEOUT_L4PROTO,
@@ -1509,8 +1508,6 @@ enum nft_object_attributes {
  * @NFTA_FLOWTABLE_HOOK: netfilter hook configuration(NLA_U32)
  * @NFTA_FLOWTABLE_USE: number of references to this flow table (NLA_U32)
  * @NFTA_FLOWTABLE_HANDLE: object handle (NLA_U64)
- * @NFTA_FLOWTABLE_SIZE: maximum size (NLA_U32)
- * @NFTA_FLOWTABLE_FLAGS: flags (NLA_U32)
  */
 enum nft_flowtable_attributes {
 	NFTA_FLOWTABLE_UNSPEC,
@@ -1520,8 +1517,6 @@ enum nft_flowtable_attributes {
 	NFTA_FLOWTABLE_USE,
 	NFTA_FLOWTABLE_HANDLE,
 	NFTA_FLOWTABLE_PAD,
-	NFTA_FLOWTABLE_SIZE,
-	NFTA_FLOWTABLE_FLAGS,
 	__NFTA_FLOWTABLE_MAX
 };
 #define NFTA_FLOWTABLE_MAX	(__NFTA_FLOWTABLE_MAX - 1)
@@ -1543,6 +1538,42 @@ enum nft_flowtable_hook_attributes {
 #define NFTA_FLOWTABLE_HOOK_MAX	(__NFTA_FLOWTABLE_HOOK_MAX - 1)
 
 /**
+ * enum nft_osf_attributes - nftables osf expression netlink attributes
+ *
+ * @NFTA_OSF_DREG: destination register (NLA_U32: nft_registers)
+ * @NFTA_OSF_TTL: Value of the TTL osf option (NLA_U8)
+ * @NFTA_OSF_FLAGS: flags (NLA_U32)
+ */
+enum nft_osf_attributes {
+	NFTA_OSF_UNSPEC,
+	NFTA_OSF_DREG,
+	NFTA_OSF_TTL,
+	NFTA_OSF_FLAGS,
+	__NFTA_OSF_MAX,
+};
+#define NFTA_OSF_MAX (__NFTA_OSF_MAX - 1)
+
+enum nft_osf_flags {
+	NFT_OSF_F_VERSION = (1 << 0),
+};
+
+/**
+ * enum nft_synproxy_attributes - nf_tables synproxy expression netlink attributes
+ *
+ * @NFTA_SYNPROXY_MSS: mss value sent to the backend (NLA_U16)
+ * @NFTA_SYNPROXY_WSCALE: wscale value sent to the backend (NLA_U8)
+ * @NFTA_SYNPROXY_FLAGS: flags (NLA_U32)
+ */
+enum nft_synproxy_attributes {
+	NFTA_SYNPROXY_UNSPEC,
+	NFTA_SYNPROXY_MSS,
+	NFTA_SYNPROXY_WSCALE,
+	NFTA_SYNPROXY_FLAGS,
+	__NFTA_SYNPROXY_MAX,
+};
+#define NFTA_SYNPROXY_MAX (__NFTA_SYNPROXY_MAX - 1)
+
+/**
  * enum nft_device_attributes - nf_tables device netlink attributes
  *
  * @NFTA_DEVICE_NAME: name of this device (NLA_STRING)
@@ -1738,10 +1769,19 @@ enum nft_tunnel_keys {
 };
 #define NFT_TUNNEL_MAX	(__NFT_TUNNEL_MAX - 1)
 
+enum nft_tunnel_mode {
+	NFT_TUNNEL_MODE_NONE,
+	NFT_TUNNEL_MODE_RX,
+	NFT_TUNNEL_MODE_TX,
+	__NFT_TUNNEL_MODE_MAX
+};
+#define NFT_TUNNEL_MODE_MAX	(__NFT_TUNNEL_MODE_MAX - 1)
+
 enum nft_tunnel_attributes {
 	NFTA_TUNNEL_UNSPEC,
 	NFTA_TUNNEL_KEY,
 	NFTA_TUNNEL_DREG,
+	NFTA_TUNNEL_MODE,
 	__NFTA_TUNNEL_MAX
 };
 #define NFTA_TUNNEL_MAX	(__NFTA_TUNNEL_MAX - 1)
-- 
2.11.0


