From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH libnftnl] src: ct: add average bytes per packet counter support
Date: Sun, 25 Dec 2016 20:02:20 +0800
Message-ID: <1482667340-64061-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-15.163.com ([220.181.12.15]:52654 "EHLO m12-15.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753235AbcLYMCw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Dec 2016 07:02:52 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

Similar to ct packets/bytes ...

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 include/linux/netfilter/nf_tables.h | 5 +++++
 src/expr/ct.c                       | 3 ++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 881d49e..b00a05d 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -860,6 +860,10 @@ enum nft_rt_attributes {
  * @NFT_CT_PROTOCOL: conntrack layer 4 protocol
  * @NFT_CT_PROTO_SRC: conntrack layer 4 protocol source
  * @NFT_CT_PROTO_DST: conntrack layer 4 protocol destination
+ * @NFT_CT_LABELS: conntrack labels
+ * @NFT_CT_PKTS: conntrack packets
+ * @NFT_CT_BYTES: conntrack bytes
+ * @NFT_CT_AVGPKT: conntrack average bytes per packet
  */
 enum nft_ct_keys {
 	NFT_CT_STATE,
@@ -878,6 +882,7 @@ enum nft_ct_keys {
 	NFT_CT_LABELS,
 	NFT_CT_PKTS,
 	NFT_CT_BYTES,
+	NFT_CT_AVGPKT,
 };
 
 /**
diff --git a/src/expr/ct.c b/src/expr/ct.c
index e680738..d3d352e 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -32,7 +32,7 @@ struct nftnl_expr_ct {
 #define IP_CT_DIR_REPLY		1
 
 #ifndef NFT_CT_MAX
-#define NFT_CT_MAX (NFT_CT_BYTES + 1)
+#define NFT_CT_MAX (NFT_CT_AVGPKT + 1)
 #endif
 
 static int
@@ -169,6 +169,7 @@ static const char *ctkey2str_array[NFT_CT_MAX] = {
 	[NFT_CT_LABELS]		= "label",
 	[NFT_CT_PKTS]		= "packets",
 	[NFT_CT_BYTES]		= "bytes",
+	[NFT_CT_AVGPKT]		= "avgpkt",
 };
 
 static const char *ctkey2str(uint32_t ctkey)
-- 
2.5.5


