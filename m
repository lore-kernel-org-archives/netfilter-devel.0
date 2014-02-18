From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 2/3 libnftnl] expr: add conntrack label match support
Date: Tue, 18 Feb 2014 10:27:23 +0100
Message-ID: <1392715644-4458-2-git-send-email-fw@strlen.de>
References: <1392715644-4458-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52422 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754556AbaBRJbR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Feb 2014 04:31:17 -0500
In-Reply-To: <1392715644-4458-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter/nf_tables.h | 2 ++
 src/expr/ct.c                       | 5 +++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 31ddd06..5bb7b72 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -585,6 +585,7 @@ enum nft_meta_attributes {
  * @NFT_CT_PROTOCOL: conntrack layer 4 protocol
  * @NFT_CT_PROTO_SRC: conntrack layer 4 protocol source
  * @NFT_CT_PROTO_DST: conntrack layer 4 protocol destination
+ * @NFT_CT_LABEL: conntrack label
  */
 enum nft_ct_keys {
 	NFT_CT_STATE,
@@ -600,6 +601,7 @@ enum nft_ct_keys {
 	NFT_CT_PROTOCOL,
 	NFT_CT_PROTO_SRC,
 	NFT_CT_PROTO_DST,
+	NFT_CT_LABEL,
 };
 
 /**
diff --git a/src/expr/ct.c b/src/expr/ct.c
index 2df761c..4c18dde 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -33,7 +33,7 @@ struct nft_expr_ct {
 #define IP_CT_DIR_REPLY		1
 
 #ifndef NFT_CT_MAX
-#define NFT_CT_MAX (NFT_CT_PROTO_DST + 1)
+#define NFT_CT_MAX (NFT_CT_LABEL + 1)
 #endif
 
 static int
@@ -170,7 +170,8 @@ const char *ctkey2str_array[NFT_CT_MAX] = {
 	[NFT_CT_SRC]		= "src",
 	[NFT_CT_DST]		= "dst",
 	[NFT_CT_PROTO_SRC]	= "proto_src",
-	[NFT_CT_PROTO_DST]	= "proto_dst"
+	[NFT_CT_PROTO_DST]	= "proto_dst",
+	[NFT_CT_LABEL]		= "label",
 };
 
 static const char *ctkey2str(uint32_t ctkey)
-- 
1.8.1.5

