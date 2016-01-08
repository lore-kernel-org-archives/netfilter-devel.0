From: Florian Westphal <fw@strlen.de>
Subject: [PATCH libnftnl 1/6] src: ct: add packet and byte counter support
Date: Fri,  8 Jan 2016 10:42:46 +0100
Message-ID: <1452246171-13943-2-git-send-email-fw@strlen.de>
References: <1452246171-13943-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:47935 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752272AbcAHJud (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Jan 2016 04:50:33 -0500
In-Reply-To: <1452246171-13943-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter/nf_tables.h | 2 ++
 src/expr/ct.c                       | 4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index f77693b..7091d91 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -755,6 +755,8 @@ enum nft_ct_keys {
 	NFT_CT_PROTO_SRC,
 	NFT_CT_PROTO_DST,
 	NFT_CT_LABELS,
+	NFT_CT_PKTS,
+	NFT_CT_BYTES,
 };
 
 /**
diff --git a/src/expr/ct.c b/src/expr/ct.c
index 584dffe..4bee6b1 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -32,7 +32,7 @@ struct nftnl_expr_ct {
 #define IP_CT_DIR_REPLY		1
 
 #ifndef NFT_CT_MAX
-#define NFT_CT_MAX (NFT_CT_LABELS + 1)
+#define NFT_CT_MAX (NFT_CT_BYTES + 1)
 #endif
 
 static int
@@ -167,6 +167,8 @@ const char *ctkey2str_array[NFT_CT_MAX] = {
 	[NFT_CT_PROTO_SRC]	= "proto_src",
 	[NFT_CT_PROTO_DST]	= "proto_dst",
 	[NFT_CT_LABELS]		= "label",
+	[NFT_CT_PKTS]		= "packets",
+	[NFT_CT_BYTES]		= "bytes",
 };
 
 static const char *ctkey2str(uint32_t ctkey)
-- 
2.4.10

