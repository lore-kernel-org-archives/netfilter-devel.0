From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [PATCH libnftnl 4/5] meta: Add support for input and output bridge interface name
Date: Tue,  8 Apr 2014 14:25:23 +0300
Message-ID: <1396956324-17803-5-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1396956324-17803-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:36650 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756550AbaDHLZr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Apr 2014 07:25:47 -0400
In-Reply-To: <1396956324-17803-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add support for dedicated bridge meta key, related to device names:
- NFT_META_BRI_IIFNAME
- NFT_META_BRI_OIFNAME

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 include/linux/netfilter/nf_tables.h | 4 ++++
 src/expr/meta.c                     | 4 +++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index bb160d5..5b7bed5 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -536,6 +536,8 @@ enum nft_exthdr_attributes {
  * @NFT_META_SECMARK: packet secmark (skb->secmark)
  * @NFT_META_NFPROTO: netfilter protocol
  * @NFT_META_L4PROTO: layer 4 protocol number
+ * @NFT_META_BRI_IIFNAME: packet input bridge interface name
+ * @NFT_META_BRI_OIFNAME: packet output bridge interface name
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -555,6 +557,8 @@ enum nft_meta_keys {
 	NFT_META_SECMARK,
 	NFT_META_NFPROTO,
 	NFT_META_L4PROTO,
+	NFT_META_BRI_IIFNAME,
+	NFT_META_BRI_OIFNAME,
 };
 
 /**
diff --git a/src/expr/meta.c b/src/expr/meta.c
index bee2f4c..fb945f0 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -23,7 +23,7 @@
 #include "expr_ops.h"
 
 #ifndef NFT_META_MAX
-#define NFT_META_MAX (NFT_META_L4PROTO + 1)
+#define NFT_META_MAX (NFT_META_BRI_OIFNAME + 1)
 #endif
 
 struct nft_expr_meta {
@@ -153,6 +153,8 @@ static const char *meta_key2str_array[NFT_META_MAX] = {
 	[NFT_META_NFTRACE]	= "nftrace",
 	[NFT_META_RTCLASSID]	= "rtclassid",
 	[NFT_META_SECMARK]	= "secmark",
+	[NFT_META_BRI_IIFNAME]	= "bri_iifname",
+	[NFT_META_BRI_OIFNAME]	= "bri_oifname",
 };
 
 static const char *meta_key2str(uint8_t key)
-- 
1.8.3.2

