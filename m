Return-Path: <SRS0=FL4W=WF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD2DAC31E40
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Aug 2019 11:48:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8633B2166E
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Aug 2019 11:48:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406561AbfHILst (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 9 Aug 2019 07:48:49 -0400
Received: from correo.us.es ([193.147.175.20]:52882 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405723AbfHILss (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Aug 2019 07:48:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7BC66F2621
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Aug 2019 13:48:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6BBA51150DA
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Aug 2019 13:48:46 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 614F01150D8; Fri,  9 Aug 2019 13:48:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4A532A590
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Aug 2019 13:48:44 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 09 Aug 2019 13:48:44 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (149.103.108.93.rev.vodafone.pt [93.108.103.149])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id B232C4265A2F
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Aug 2019 13:48:42 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] include: refresh nf_tables.h cached copy
Date:   Fri,  9 Aug 2019 13:48:31 +0200
Message-Id: <20190809114831.6123-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Refresh it to fetch what we have in 5.3-rc1.

Remove NFT_OSF_F_VERSION definition, this is already available in
include/linux/netfilter/nf_tables.h

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_tables.h | 21 +++++++++++++++++----
 include/osf.h                       |  2 --
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index adc08935fb58..82abaa183fc3 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -192,6 +192,7 @@ enum nft_table_attributes {
  * @NFTA_CHAIN_USE: number of references to this chain (NLA_U32)
  * @NFTA_CHAIN_TYPE: type name of the string (NLA_NUL_STRING)
  * @NFTA_CHAIN_COUNTERS: counter specification of the chain (NLA_NESTED: nft_counter_attributes)
+ * @NFTA_CHAIN_FLAGS: chain flags
  */
 enum nft_chain_attributes {
 	NFTA_CHAIN_UNSPEC,
@@ -204,6 +205,7 @@ enum nft_chain_attributes {
 	NFTA_CHAIN_TYPE,
 	NFTA_CHAIN_COUNTERS,
 	NFTA_CHAIN_PAD,
+	NFTA_CHAIN_FLAGS,
 	__NFTA_CHAIN_MAX
 };
 #define NFTA_CHAIN_MAX		(__NFTA_CHAIN_MAX - 1)
@@ -730,7 +732,7 @@ enum nft_exthdr_flags {
  *
  * @NFT_EXTHDR_OP_IPV6: match against ipv6 extension headers
  * @NFT_EXTHDR_OP_TCP: match against tcp options
- * @NFT_EXTHDR_OP_IPV4: match against ip options
+ * @NFT_EXTHDR_OP_IPV4: match against ipv4 options
  */
 enum nft_exthdr_op {
 	NFT_EXTHDR_OP_IPV6,
@@ -795,6 +797,8 @@ enum nft_exthdr_attributes {
  * @NFT_META_SECPATH: boolean, secpath_exists (!!skb->sp)
  * @NFT_META_IIFKIND: packet input interface kind name (dev->rtnl_link_ops->kind)
  * @NFT_META_OIFKIND: packet output interface kind name (dev->rtnl_link_ops->kind)
+ * @NFT_META_BRI_IIFPVID: packet input bridge port pvid
+ * @NFT_META_BRI_IIFVPROTO: packet input bridge vlan proto
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -825,6 +829,8 @@ enum nft_meta_keys {
 	NFT_META_SECPATH,
 	NFT_META_IIFKIND,
 	NFT_META_OIFKIND,
+	NFT_META_BRI_IIFPVID,
+	NFT_META_BRI_IIFVPROTO,
 };
 
 /**
@@ -968,6 +974,7 @@ enum nft_socket_keys {
  * @NFT_CT_DST_IP: conntrack layer 3 protocol destination (IPv4 address)
  * @NFT_CT_SRC_IP6: conntrack layer 3 protocol source (IPv6 address)
  * @NFT_CT_DST_IP6: conntrack layer 3 protocol destination (IPv6 address)
+ * @NFT_CT_ID: conntrack id
  */
 enum nft_ct_keys {
 	NFT_CT_STATE,
@@ -993,6 +1000,7 @@ enum nft_ct_keys {
 	NFT_CT_DST_IP,
 	NFT_CT_SRC_IP6,
 	NFT_CT_DST_IP6,
+	NFT_CT_ID,
 	__NFT_CT_MAX
 };
 #define NFT_CT_MAX		(__NFT_CT_MAX - 1)
@@ -1445,7 +1453,7 @@ enum nft_ct_timeout_timeout_attributes {
 };
 #define NFTA_CT_TIMEOUT_MAX	(__NFTA_CT_TIMEOUT_MAX - 1)
 
-enum nft_ct_expect_attributes {
+enum nft_ct_expectation_attributes {
 	NFTA_CT_EXPECT_UNSPEC,
 	NFTA_CT_EXPECT_L3PROTO,
 	NFTA_CT_EXPECT_L4PROTO,
@@ -1534,18 +1542,23 @@ enum nft_flowtable_hook_attributes {
  *
  * @NFTA_OSF_DREG: destination register (NLA_U32: nft_registers)
  * @NFTA_OSF_TTL: Value of the TTL osf option (NLA_U8)
+ * @NFTA_OSF_FLAGS: flags (NLA_U32)
  */
 enum nft_osf_attributes {
 	NFTA_OSF_UNSPEC,
 	NFTA_OSF_DREG,
 	NFTA_OSF_TTL,
+	NFTA_OSF_FLAGS,
 	__NFTA_OSF_MAX,
 };
 #define NFTA_OSF_MAX (__NFTA_OSF_MAX - 1)
 
+enum nft_osf_flags {
+	NFT_OSF_F_VERSION = (1 << 0),
+};
+
 /**
- * enum nft_synproxy_attributes - nftables synproxy expression
- * netlink attributes
+ * enum nft_synproxy_attributes - nf_tables synproxy expression netlink attributes
  *
  * @NFTA_SYNPROXY_MSS: mss value sent to the backend (NLA_U16)
  * @NFTA_SYNPROXY_WSCALE: wscale value sent to the backend (NLA_U8)
diff --git a/include/osf.h b/include/osf.h
index 2eef257c2b51..8f6f5840620e 100644
--- a/include/osf.h
+++ b/include/osf.h
@@ -1,8 +1,6 @@
 #ifndef NFTABLES_OSF_H
 #define NFTABLES_OSF_H
 
-#define NFT_OSF_F_VERSION	0x1
-
 struct expr *osf_expr_alloc(const struct location *loc, const uint8_t ttl,
 			    const uint32_t flags);
 
-- 
2.11.0

