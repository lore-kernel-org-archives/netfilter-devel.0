From: Manuel Messner <mm@skelett.io>
Subject: [PATCH nftables 1/7] include: linux: netfilter: nf_tables: copy file from nf-next
Date: Tue,  7 Feb 2017 03:14:09 +0100
Message-ID: <20170207021415.22460-2-mm@skelett.io>
References: <20170207021415.22460-1-mm@skelett.io>
Cc: fw@strlen.de, mm@skelett.io
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from relay.ox.registrar-servers.com ([199.188.203.174]:41751 "EHLO
        relay.ox.registrar-servers.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751592AbdBGCTw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Feb 2017 21:19:52 -0500
Received: from MTA-06-3.privateemail.com (mta-06-3.privateemail.com [198.54.127.59])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay.ox.registrar-servers.com (Postfix) with ESMTPS id DF96CB0119
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Feb 2017 21:14:27 -0500 (EST)
In-Reply-To: <20170207021415.22460-1-mm@skelett.io>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Manuel Messner <mm@skelett.io>
Reviewed-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter/nf_tables.h | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index b00a05d..6c0c9ef 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -705,12 +705,13 @@ enum nft_payload_attributes {
 #define NFTA_PAYLOAD_MAX	(__NFTA_PAYLOAD_MAX - 1)
 
 /**
- * enum nft_exthdr_attributes - nf_tables IPv6 extension header expression netlink attributes
+ * enum nft_exthdr_attributes - nf_tables extension header expression netlink attributes
  *
  * @NFTA_EXTHDR_DREG: destination register (NLA_U32: nft_registers)
  * @NFTA_EXTHDR_TYPE: extension header type (NLA_U8)
  * @NFTA_EXTHDR_OFFSET: extension header offset (NLA_U32)
  * @NFTA_EXTHDR_LEN: extension header length (NLA_U32)
+ * @NFTA_EXTHDR_OP: option match type (NLA_U8)
  */
 enum nft_exthdr_attributes {
 	NFTA_EXTHDR_UNSPEC,
@@ -718,11 +719,25 @@ enum nft_exthdr_attributes {
 	NFTA_EXTHDR_TYPE,
 	NFTA_EXTHDR_OFFSET,
 	NFTA_EXTHDR_LEN,
+	NFTA_EXTHDR_OP,
 	__NFTA_EXTHDR_MAX
 };
 #define NFTA_EXTHDR_MAX		(__NFTA_EXTHDR_MAX - 1)
 
 /**
+ * enum nft_exthdr_op - nf_tables match options
+ *
+ * @NFT_EXTHDR_OP_IPV6: match against ipv6 extension headers
+ * @NFT_EXTHDR_OP_TCP: match against tcp options
+ */
+enum nft_exthdr_op {
+	NFT_EXTHDR_OP_IPV6,
+	NFT_EXTHDR_OP_TCPOPT,
+	__NFT_EXTHDR_OP_MAX
+};
+#define NFT_EXTHDR_OP_MAX	(__NFT_EXTHDR_OP_MAX - 1)
+
+/**
  * enum nft_meta_keys - nf_tables meta expression keys
  *
  * @NFT_META_LEN: packet length (skb->len)
-- 
2.11.1

