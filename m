From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH] expr: meta: Add pkttype support
Date: Thu, 12 Jun 2014 19:17:51 +0200
Message-ID: <1402593473-4904-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>,
	Alvaro Neira Ayuso <alvaroneay@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:50789 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbaFLRSG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Jun 2014 13:18:06 -0400
Received: by mail-wg0-f45.google.com with SMTP id l18so1583311wgh.4
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Jun 2014 10:18:04 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add pkttype support in meta. The pkttype option does not set.

Before, If we want to declare a pktype, It has used a syntax like this:

nft add rule ip filter input meta pkttype broadcast

Joint work with Alvaro Neira Ayuso <alvaroneay@gmail.com>

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Signed-off-by: Ana Rey <anarey@gmail.com>
---
 include/linux/netfilter/nf_tables.h | 2 ++
 src/expr/meta.c                     | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 2a88f64..9eb5153 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -571,6 +571,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_L4PROTO: layer 4 protocol number
  * @NFT_META_BRI_IIFNAME: packet input bridge interface name
  * @NFT_META_BRI_OIFNAME: packet output bridge interface name
+ * @NFT_META_PKTTYPE: Packet class
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -592,6 +593,7 @@ enum nft_meta_keys {
 	NFT_META_L4PROTO,
 	NFT_META_BRI_IIFNAME,
 	NFT_META_BRI_OIFNAME,
+	NFT_META_PKTTYPE,
 };
 
 /**
diff --git a/src/expr/meta.c b/src/expr/meta.c
index fb945f0..24057f2 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -23,7 +23,7 @@
 #include "expr_ops.h"
 
 #ifndef NFT_META_MAX
-#define NFT_META_MAX (NFT_META_BRI_OIFNAME + 1)
+#define NFT_META_MAX (NFT_META_PKTTYPE + 1)
 #endif
 
 struct nft_expr_meta {
@@ -155,6 +155,7 @@ static const char *meta_key2str_array[NFT_META_MAX] = {
 	[NFT_META_SECMARK]	= "secmark",
 	[NFT_META_BRI_IIFNAME]	= "bri_iifname",
 	[NFT_META_BRI_OIFNAME]	= "bri_oifname",
+	[NFT_META_PKTTYPE]	= "pkttype"
 };
 
 static const char *meta_key2str(uint8_t key)
-- 
2.0.0

