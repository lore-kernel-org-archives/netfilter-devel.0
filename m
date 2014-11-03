From: Ana Rey <anarey@gmail.com>
Subject: [libnftnf PATCH] expr: meta: Add cgroup support
Date: Mon,  3 Nov 2014 18:10:49 +0100
Message-ID: <1415034651-27242-1-git-send-email-anarey@gmail.com>
Cc: dborkman@redhat.com, Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:60520 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbaKCRKj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:10:39 -0500
Received: by mail-wg0-f42.google.com with SMTP id k14so11642686wgh.15
        for <netfilter-devel@vger.kernel.org>; Mon, 03 Nov 2014 09:10:38 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The kernel support is add in the commit:
netfilter: nft_meta: add cgroup support

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 include/linux/netfilter/nf_tables.h |    2 ++
 src/expr/meta.c                     |    3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index bb21315..a8d3a49 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -579,6 +579,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_CPU: cpu id through smp_processor_id()
  * @NFT_META_IIFGROUP: packet input interface group
  * @NFT_META_OIFGROUP: packet output interface group
+ * @NFT_META_CGROUP: packet cgroup (skb->sk->sk_classid)
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -604,6 +605,7 @@ enum nft_meta_keys {
 	NFT_META_CPU,
 	NFT_META_IIFGROUP,
 	NFT_META_OIFGROUP,
+	NFT_META_CGROUP,
 };
 
 /**
diff --git a/src/expr/meta.c b/src/expr/meta.c
index 5b5159f..59cb55b 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -23,7 +23,7 @@
 #include "expr_ops.h"
 
 #ifndef NFT_META_MAX
-#define NFT_META_MAX (NFT_META_OIFGROUP + 1)
+#define NFT_META_MAX (NFT_META_CGROUP + 1)
 #endif
 
 struct nft_expr_meta {
@@ -157,6 +157,7 @@ static const char *meta_key2str_array[NFT_META_MAX] = {
 	[NFT_META_CPU]		= "cpu",
 	[NFT_META_IIFGROUP]	= "iifgroup",
 	[NFT_META_OIFGROUP]	= "oifgroup",
+	[NFT_META_CGROUP]	= "cgroup",
 };
 
 static const char *meta_key2str(uint8_t key)
-- 
1.7.10.4

