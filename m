Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07CE8C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Apr 2022 12:14:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243321AbiDDMQc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242097AbiDDMQ1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 08:16:27 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E6713D1F
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 05:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8BC5+YiS6uLPGVXIR8GTlsrQVm2G6lIMbjHK+n4zBKc=; b=NSQ1gHmBwWtfkrE5fvoaEVUU3+
        RMv/rxJltsR9liSiR2lROUWwrMB5bmEmMYIPcoosUe8chnvuV2zlrW2bujk0DnPCVKh3E6jVE1PRp
        3ySHxykPhufBsDY5UHrgQl3wfR1WccP+ApD5nRletq94/k2nXLUi2lxYE6DeAU4Vs6gx3hAuNCTQL
        o2LJzZ/q5jjIK6QL+LrT0YvuhI6oBRMz9g8a+jCT79VJrKF3PUow4YoRziyYVTFxIpcFMOaeFcL6i
        tAXg1DaP8i3mNHbBlJaxpWNIODCKVA+UXyMqTlxu5xmrLS/0/O/dxiosCE9Zq5lP2JtwNe2KzDUyS
        Rza0KIwQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nbLbI-007FTC-Vc; Mon, 04 Apr 2022 13:14:29 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [nft PATCH v4 06/32] include: update nf_tables.h
Date:   Mon,  4 Apr 2022 13:13:44 +0100
Message-Id: <20220404121410.188509-7-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220404121410.188509-1-jeremy@azazel.net>
References: <20220404121410.188509-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Bump it to 5.17-rc7.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/linux/netfilter/nf_tables.h | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 75df968d231b..466fd3f4447c 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -164,7 +164,10 @@ enum nft_hook_attributes {
  */
 enum nft_table_flags {
 	NFT_TABLE_F_DORMANT	= 0x1,
+	NFT_TABLE_F_OWNER	= 0x2,
 };
+#define NFT_TABLE_F_MASK	(NFT_TABLE_F_DORMANT | \
+				 NFT_TABLE_F_OWNER)
 
 /**
  * enum nft_table_attributes - nf_tables table netlink attributes
@@ -173,6 +176,7 @@ enum nft_table_flags {
  * @NFTA_TABLE_FLAGS: bitmask of enum nft_table_flags (NLA_U32)
  * @NFTA_TABLE_USE: number of chains in this table (NLA_U32)
  * @NFTA_TABLE_USERDATA: user data (NLA_BINARY)
+ * @NFTA_TABLE_OWNER: owner of this table through netlink portID (NLA_U32)
  */
 enum nft_table_attributes {
 	NFTA_TABLE_UNSPEC,
@@ -182,6 +186,7 @@ enum nft_table_attributes {
 	NFTA_TABLE_HANDLE,
 	NFTA_TABLE_PAD,
 	NFTA_TABLE_USERDATA,
+	NFTA_TABLE_OWNER,
 	__NFTA_TABLE_MAX
 };
 #define NFTA_TABLE_MAX		(__NFTA_TABLE_MAX - 1)
@@ -748,11 +753,13 @@ enum nft_dynset_attributes {
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
 };
 
 /**
@@ -891,7 +898,8 @@ enum nft_meta_keys {
 	NFT_META_OIF,
 	NFT_META_IIFNAME,
 	NFT_META_OIFNAME,
-	NFT_META_IIFTYPE,
+	NFT_META_IFTYPE,
+#define NFT_META_IIFTYPE	NFT_META_IFTYPE
 	NFT_META_OIFTYPE,
 	NFT_META_SKUID,
 	NFT_META_SKGID,
@@ -918,6 +926,7 @@ enum nft_meta_keys {
 	NFT_META_TIME_HOUR,
 	NFT_META_SDIF,
 	NFT_META_SDIFNAME,
+	__NFT_META_IIFTYPE,
 };
 
 /**
@@ -1013,6 +1022,7 @@ enum nft_rt_attributes {
  *
  * @NFTA_SOCKET_KEY: socket key to match
  * @NFTA_SOCKET_DREG: destination register
+ * @NFTA_SOCKET_LEVEL: cgroups2 ancestor level (only for cgroupsv2)
  */
 enum nft_socket_attributes {
 	NFTA_SOCKET_UNSPEC,
@@ -1029,6 +1039,7 @@ enum nft_socket_attributes {
  * @NFT_SOCKET_TRANSPARENT: Value of the IP(V6)_TRANSPARENT socket option
  * @NFT_SOCKET_MARK: Value of the socket mark
  * @NFT_SOCKET_WILDCARD: Whether the socket is zero-bound (e.g. 0.0.0.0 or ::0)
+ * @NFT_SOCKET_CGROUPV2: Match on cgroups version 2
  */
 enum nft_socket_keys {
 	NFT_SOCKET_TRANSPARENT,
@@ -1188,6 +1199,21 @@ enum nft_counter_attributes {
 };
 #define NFTA_COUNTER_MAX	(__NFTA_COUNTER_MAX - 1)
 
+/**
+ * enum nft_last_attributes - nf_tables last expression netlink attributes
+ *
+ * @NFTA_LAST_SET: last update has been set, zero means never updated (NLA_U32)
+ * @NFTA_LAST_MSECS: milliseconds since last update (NLA_U64)
+ */
+enum nft_last_attributes {
+	NFTA_LAST_UNSPEC,
+	NFTA_LAST_SET,
+	NFTA_LAST_MSECS,
+	NFTA_LAST_PAD,
+	__NFTA_LAST_MAX
+};
+#define NFTA_LAST_MAX	(__NFTA_LAST_MAX - 1)
+
 /**
  * enum nft_log_attributes - nf_tables log expression netlink attributes
  *
-- 
2.35.1

