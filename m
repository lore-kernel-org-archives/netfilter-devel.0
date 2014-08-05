From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH v2] expr: meta: Add pkttype support
Date: Tue,  5 Aug 2014 20:30:18 +0200
Message-ID: <1407263418-4371-1-git-send-email-anarey@gmail.com>
References: <1402593473-4904-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>,
	Alvaro Neira Ayuso <alvaroneay@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:56849 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756274AbaHES2o (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Aug 2014 14:28:44 -0400
Received: by mail-wg0-f51.google.com with SMTP id b13so1439574wgh.34
        for <netfilter-devel@vger.kernel.org>; Tue, 05 Aug 2014 11:28:43 -0700 (PDT)
In-Reply-To: <1402593473-4904-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add pkttype support in meta. The pkttype option does not set.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Signed-off-by: Ana Rey <anarey@gmail.com>
---
[Changes in v2:]
Fix the description of @NFT_META_PKTTYPE expression keys


 include/linux/netfilter/nf_tables.h |    2 ++
 src/expr/meta.c                     |    3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 801bdd1..72ad208 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -571,6 +571,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_L4PROTO: layer 4 protocol number
  * @NFT_META_BRI_IIFNAME: packet input bridge interface name
  * @NFT_META_BRI_OIFNAME: packet output bridge interface name
+ * @NFT_META_PKTTYPE: Packet type
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
index 85097b5..35ca177 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -23,7 +23,7 @@
 #include "expr_ops.h"
 
 #ifndef NFT_META_MAX
-#define NFT_META_MAX (NFT_META_BRI_OIFNAME + 1)
+#define NFT_META_MAX (NFT_META_PKTTYPE + 1)
 #endif
 
 struct nft_expr_meta {
@@ -153,6 +153,7 @@ static const char *meta_key2str_array[NFT_META_MAX] = {
 	[NFT_META_SECMARK]	= "secmark",
 	[NFT_META_BRI_IIFNAME]	= "bri_iifname",
 	[NFT_META_BRI_OIFNAME]	= "bri_oifname",
+	[NFT_META_PKTTYPE]	= "pkttype"
 };
 
 static const char *meta_key2str(uint8_t key)
-- 
1.7.10.4

