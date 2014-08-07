From: Ana Rey <anarey@gmail.com>
Subject: [PATCH] [libnftnl] expr: meta: Add cpu support for meta expresion
Date: Thu,  7 Aug 2014 09:00:55 +0200
Message-ID: <1407394858-26841-1-git-send-email-anarey@gmail.com>
Cc: eric.dumazet@gmail.com, Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:60667 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314AbaHGG6z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Aug 2014 02:58:55 -0400
Received: by mail-we0-f170.google.com with SMTP id w62so3659293wes.29
        for <netfilter-devel@vger.kernel.org>; Wed, 06 Aug 2014 23:58:54 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The cpu attribute does not set.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 include/linux/netfilter/nf_tables.h |    2 ++
 src/expr/meta.c                     |    5 +++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 72ad208..67218f3 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -572,6 +572,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_BRI_IIFNAME: packet input bridge interface name
  * @NFT_META_BRI_OIFNAME: packet output bridge interface name
  * @NFT_META_PKTTYPE: Packet type
+ * @NFT_META_CPU: Packet cpu
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -594,6 +595,7 @@ enum nft_meta_keys {
 	NFT_META_BRI_IIFNAME,
 	NFT_META_BRI_OIFNAME,
 	NFT_META_PKTTYPE,
+	NFT_META_CPU,
 };
 
 /**
diff --git a/src/expr/meta.c b/src/expr/meta.c
index 35ca177..9e884d6 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -23,7 +23,7 @@
 #include "expr_ops.h"
 
 #ifndef NFT_META_MAX
-#define NFT_META_MAX (NFT_META_PKTTYPE + 1)
+#define NFT_META_MAX (NFT_META_CPU + 1)
 #endif
 
 struct nft_expr_meta {
@@ -153,7 +153,8 @@ static const char *meta_key2str_array[NFT_META_MAX] = {
 	[NFT_META_SECMARK]	= "secmark",
 	[NFT_META_BRI_IIFNAME]	= "bri_iifname",
 	[NFT_META_BRI_OIFNAME]	= "bri_oifname",
-	[NFT_META_PKTTYPE]	= "pkttype"
+	[NFT_META_PKTTYPE]	= "pkttype",
+	[NFT_META_CPU]		= "cpu",
 };
 
 static const char *meta_key2str(uint8_t key)
-- 
1.7.10.4

