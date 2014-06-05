From: Yuxuan Shui <yshuiv7@gmail.com>
Subject: [PATCH libnftnl 2/3] meta: Add support for SKPID and SKSID meta keys
Date: Thu,  5 Jun 2014 22:19:15 +0800
Message-ID: <1401977956-15500-2-git-send-email-yshuiv7@gmail.com>
References: <1401977956-15500-1-git-send-email-yshuiv7@gmail.com>
Cc: Yuxuan Shui <yshuiv7@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:59829 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbaFEOUW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:20:22 -0400
Received: by mail-pb0-f53.google.com with SMTP id md12so1178533pbc.12
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Jun 2014 07:20:22 -0700 (PDT)
In-Reply-To: <1401977956-15500-1-git-send-email-yshuiv7@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add SKPID and SKSID meta keys so we can implement PID and SID matching
rules in nft.

Signed-off-by: Yuxuan Shui <yshuiv7@gmail.com>
---
 include/linux/netfilter/nf_tables.h | 4 ++++
 src/expr/meta.c                     | 4 +++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 2a88f64..cea17d4 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -571,6 +571,8 @@ enum nft_exthdr_attributes {
  * @NFT_META_L4PROTO: layer 4 protocol number
  * @NFT_META_BRI_IIFNAME: packet input bridge interface name
  * @NFT_META_BRI_OIFNAME: packet output bridge interface name
+ * @NFT_META_SKPID: origination socket owner PID
+ * @NFT_META_SKSID: origination socket owner SID
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -592,6 +594,8 @@ enum nft_meta_keys {
 	NFT_META_L4PROTO,
 	NFT_META_BRI_IIFNAME,
 	NFT_META_BRI_OIFNAME,
+	NFT_META_SKPID,
+	NFT_META_SKSID,
 };
 
 /**
diff --git a/src/expr/meta.c b/src/expr/meta.c
index fb945f0..1568544 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -23,7 +23,7 @@
 #include "expr_ops.h"
 
 #ifndef NFT_META_MAX
-#define NFT_META_MAX (NFT_META_BRI_OIFNAME + 1)
+#define NFT_META_MAX (NFT_META_SKSID + 1)
 #endif
 
 struct nft_expr_meta {
@@ -155,6 +155,8 @@ static const char *meta_key2str_array[NFT_META_MAX] = {
 	[NFT_META_SECMARK]	= "secmark",
 	[NFT_META_BRI_IIFNAME]	= "bri_iifname",
 	[NFT_META_BRI_OIFNAME]	= "bri_oifname",
+	[NFT_META_SKPID]	= "skpid",
+	[NFT_META_SKSID]	= "sksid",
 };
 
 static const char *meta_key2str(uint8_t key)
-- 
1.9.3

