From: Ana Rey <anarey@gmail.com>
Subject: [PATCH libnftnl] expr: meta: Add devgroup support
Date: Tue,  2 Sep 2014 20:36:58 +0200
Message-ID: <1409683018-11529-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:58382 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487AbaIBSed (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Sep 2014 14:34:33 -0400
Received: by mail-wi0-f176.google.com with SMTP id bs8so14835620wib.3
        for <netfilter-devel@vger.kernel.org>; Tue, 02 Sep 2014 11:34:32 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The kernel support is add in commit:
netfilter: nf_tables: add devgroup support in meta expresion

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 include/linux/netfilter/nf_tables.h |    4 ++++
 src/expr/meta.c                     |    4 +++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index c9b6f00..c000947 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -573,6 +573,8 @@ enum nft_exthdr_attributes {
  * @NFT_META_BRI_OIFNAME: packet output bridge interface name
  * @NFT_META_PKTTYPE: packet type (skb->pkt_type), special handling for loopback
  * @NFT_META_CPU: cpu id through smp_processor_id()
+ * @NFT_META_IIFGROUP: packet input interface group
+ * @NFT_META_OIFGROUP: packet output interface group
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -596,6 +598,8 @@ enum nft_meta_keys {
 	NFT_META_BRI_OIFNAME,
 	NFT_META_PKTTYPE,
 	NFT_META_CPU,
+	NFT_META_IIFGROUP,
+	NFT_META_OIFGROUP,
 };
 
 /**
diff --git a/src/expr/meta.c b/src/expr/meta.c
index 9e884d6..5b5159f 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -23,7 +23,7 @@
 #include "expr_ops.h"
 
 #ifndef NFT_META_MAX
-#define NFT_META_MAX (NFT_META_CPU + 1)
+#define NFT_META_MAX (NFT_META_OIFGROUP + 1)
 #endif
 
 struct nft_expr_meta {
@@ -155,6 +155,8 @@ static const char *meta_key2str_array[NFT_META_MAX] = {
 	[NFT_META_BRI_OIFNAME]	= "bri_oifname",
 	[NFT_META_PKTTYPE]	= "pkttype",
 	[NFT_META_CPU]		= "cpu",
+	[NFT_META_IIFGROUP]	= "iifgroup",
+	[NFT_META_OIFGROUP]	= "oifgroup",
 };
 
 static const char *meta_key2str(uint8_t key)
-- 
1.7.10.4

