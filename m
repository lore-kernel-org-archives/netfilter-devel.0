From: Florian Westphal <fw@strlen.de>
Subject: [PATCH libnftnl 4/9] src: ct: add zone support
Date: Fri,  3 Feb 2017 13:35:51 +0100
Message-ID: <20170203123556.17357-5-fw@strlen.de>
References: <20170203123556.17357-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:41968 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752700AbdBCMfw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Feb 2017 07:35:52 -0500
In-Reply-To: <20170203123556.17357-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter/nf_tables.h | 2 ++
 src/expr/ct.c                       | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index b00a05d1ee56..b972e72623c2 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -864,6 +864,7 @@ enum nft_rt_attributes {
  * @NFT_CT_PKTS: conntrack packets
  * @NFT_CT_BYTES: conntrack bytes
  * @NFT_CT_AVGPKT: conntrack average bytes per packet
+ * @NFT_CT_ZONE: conntrack zone
  */
 enum nft_ct_keys {
 	NFT_CT_STATE,
@@ -883,6 +884,7 @@ enum nft_ct_keys {
 	NFT_CT_PKTS,
 	NFT_CT_BYTES,
 	NFT_CT_AVGPKT,
+	NFT_CT_ZONE,
 };
 
 /**
diff --git a/src/expr/ct.c b/src/expr/ct.c
index d3d352e9f959..cdd08e95c86c 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -32,7 +32,7 @@ struct nftnl_expr_ct {
 #define IP_CT_DIR_REPLY		1
 
 #ifndef NFT_CT_MAX
-#define NFT_CT_MAX (NFT_CT_AVGPKT + 1)
+#define NFT_CT_MAX (NFT_CT_ZONE + 1)
 #endif
 
 static int
@@ -170,6 +170,7 @@ static const char *ctkey2str_array[NFT_CT_MAX] = {
 	[NFT_CT_PKTS]		= "packets",
 	[NFT_CT_BYTES]		= "bytes",
 	[NFT_CT_AVGPKT]		= "avgpkt",
+	[NFT_CT_ZONE]		= "zone",
 };
 
 static const char *ctkey2str(uint32_t ctkey)
-- 
2.10.2

