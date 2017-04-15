From: Florian Westphal <fw@strlen.de>
Subject: [PATCH libnftnl 2/3] src: ct eventmask support
Date: Sat, 15 Apr 2017 10:45:04 +0200
Message-ID: <20170415084505.26176-3-fw@strlen.de>
References: <20170415084505.26176-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:56832 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752042AbdDOIoy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Apr 2017 04:44:54 -0400
In-Reply-To: <20170415084505.26176-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_tables.h | 2 ++
 src/expr/ct.c                       | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 8f3842690d17..683f6f88fcac 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -901,6 +901,7 @@ enum nft_rt_attributes {
  * @NFT_CT_BYTES: conntrack bytes
  * @NFT_CT_AVGPKT: conntrack average bytes per packet
  * @NFT_CT_ZONE: conntrack zone
+ * @NFT_CT_EVENTMASK: ctnetlink events to be generated for this conntrack
  */
 enum nft_ct_keys {
 	NFT_CT_STATE,
@@ -921,6 +922,7 @@ enum nft_ct_keys {
 	NFT_CT_BYTES,
 	NFT_CT_AVGPKT,
 	NFT_CT_ZONE,
+	NFT_CT_EVENTMASK,
 };
 
 /**
diff --git a/src/expr/ct.c b/src/expr/ct.c
index cdd08e95c86c..0fba0d668010 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -32,7 +32,7 @@ struct nftnl_expr_ct {
 #define IP_CT_DIR_REPLY		1
 
 #ifndef NFT_CT_MAX
-#define NFT_CT_MAX (NFT_CT_ZONE + 1)
+#define NFT_CT_MAX (NFT_CT_EVENTMASK + 1)
 #endif
 
 static int
@@ -171,6 +171,7 @@ static const char *ctkey2str_array[NFT_CT_MAX] = {
 	[NFT_CT_BYTES]		= "bytes",
 	[NFT_CT_AVGPKT]		= "avgpkt",
 	[NFT_CT_ZONE]		= "zone",
+	[NFT_CT_EVENTMASK]	= "eventmask",
 };
 
 static const char *ctkey2str(uint32_t ctkey)
-- 
2.10.2

