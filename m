From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: [PATCH libnftables] Add support for the connmark meta key
Date: Mon,  6 Jan 2014 17:58:21 +0100
Message-ID: <1389027501-16877-1-git-send-email-kristian.evensen@gmail.com>
Cc: Kristian Evensen <kristian.evensen@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:60415 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517AbaAFQ6c (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:58:32 -0500
Received: by mail-ee0-f47.google.com with SMTP id e51so6746740eek.6
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Jan 2014 08:58:31 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Kristian Evensen <kristian.evensen@gmail.com>

This patch adds support for the connmark meta key, which enables
setting/retrieveing the connection mark of a tracked connection.

Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
---
 include/linux/netfilter/nf_tables.h | 2 ++
 src/expr/meta.c                     | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index e08f80e..5797501 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -452,6 +452,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_NFTRACE: packet nftrace bit
  * @NFT_META_RTCLASSID: realm value of packet's route (skb->dst->tclassid)
  * @NFT_META_SECMARK: packet secmark (skb->secmark)
+ * @NFT_META_CONNMARK: used to get/set the connection mark
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -469,6 +470,7 @@ enum nft_meta_keys {
 	NFT_META_NFTRACE,
 	NFT_META_RTCLASSID,
 	NFT_META_SECMARK,
+	NFT_META_CONNMARK,
 };
 
 /**
diff --git a/src/expr/meta.c b/src/expr/meta.c
index 6899d69..3264aa1 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -23,7 +23,7 @@
 #include "expr_ops.h"
 
 #ifndef NFT_META_MAX
-#define NFT_META_MAX (NFT_META_SECMARK + 1)
+#define NFT_META_MAX (NFT_META_CONNMARK + 1)
 #endif
 
 struct nft_expr_meta {
@@ -152,6 +152,7 @@ const char *meta_key2str_array[NFT_META_MAX] = {
 	[NFT_META_NFTRACE]	= "nftrace",
 	[NFT_META_RTCLASSID]	= "rtclassid",
 	[NFT_META_SECMARK]	= "secmark",
+	[NFT_META_CONNMARK]	= "connmark",
 };
 
 static const char *meta_key2str(uint8_t key)
-- 
1.8.3.2

