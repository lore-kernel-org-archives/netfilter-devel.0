From: Valentina Giusti <valentina.giusti@microon.de>
Subject: [PATCH 2/3] libnftnl: add attribute for cpu handling the packet
Date: Wed,  6 Aug 2014 23:59:51 +0200
Message-ID: <1407362392-24837-3-git-send-email-valentina.giusti@microon.de>
References: <1407362392-24837-1-git-send-email-valentina.giusti@microon.de>
To: coreteam@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.microon.de ([37.252.125.21]:54654 "EHLO gattino.microon.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753916AbaHFWGN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Aug 2014 18:06:13 -0400
In-Reply-To: <1407362392-24837-1-git-send-email-valentina.giusti@microon.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Valentina Giusti <valentina.giusti@microon.de>
---
 include/linux/netfilter/nf_tables.h | 1 +
 src/expr/meta.c                     | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 801bdd1..6058a8a 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -592,6 +592,7 @@ enum nft_meta_keys {
 	NFT_META_L4PROTO,
 	NFT_META_BRI_IIFNAME,
 	NFT_META_BRI_OIFNAME,
+	NFT_META_CPU,
 };
 
 /**
diff --git a/src/expr/meta.c b/src/expr/meta.c
index 85097b5..6a2f299 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -23,7 +23,7 @@
 #include "expr_ops.h"
 
 #ifndef NFT_META_MAX
-#define NFT_META_MAX (NFT_META_BRI_OIFNAME + 1)
+#define NFT_META_MAX (NFT_META_CPU + 1)
 #endif
 
 struct nft_expr_meta {
@@ -153,6 +153,7 @@ static const char *meta_key2str_array[NFT_META_MAX] = {
 	[NFT_META_SECMARK]	= "secmark",
 	[NFT_META_BRI_IIFNAME]	= "bri_iifname",
 	[NFT_META_BRI_OIFNAME]	= "bri_oifname",
+	[NFT_META_CPU]		= "cpu",
 };
 
 static const char *meta_key2str(uint8_t key)
-- 
2.0.0.rc2

