From: Florian Westphal <fw@strlen.de>
Subject: [PATCH libnftnl] meta: secpath support
Date: Fri,  1 Dec 2017 13:40:20 +0100
Message-ID: <20171201124021.20973-3-fw@strlen.de>
References: <20171201124021.20973-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:40876 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752424AbdLAMk0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Dec 2017 07:40:26 -0500
In-Reply-To: <20171201124021.20973-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 include/linux/netfilter/nf_tables.h | 2 ++
 src/expr/meta.c                     | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 874fa3f239eb..64d4a25f8409 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -775,6 +775,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_OIFGROUP: packet output interface group
  * @NFT_META_CGROUP: socket control group (skb->sk->sk_classid)
  * @NFT_META_PRANDOM: a 32bit pseudo-random number
+ * @NFT_META_SECPATH: boolean, secpath_exists (!!skb->sp)
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -802,6 +803,7 @@ enum nft_meta_keys {
 	NFT_META_OIFGROUP,
 	NFT_META_CGROUP,
 	NFT_META_PRANDOM,
+	NFT_META_SECPATH,
 };
 
 /**
diff --git a/src/expr/meta.c b/src/expr/meta.c
index 2c758412bf2e..de82105de44f 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -22,7 +22,7 @@
 #include <libnftnl/rule.h>
 
 #ifndef NFT_META_MAX
-#define NFT_META_MAX (NFT_META_PRANDOM + 1)
+#define NFT_META_MAX (NFT_META_SECPATH + 1)
 #endif
 
 struct nftnl_expr_meta {
@@ -158,6 +158,7 @@ static const char *meta_key2str_array[NFT_META_MAX] = {
 	[NFT_META_OIFGROUP]	= "oifgroup",
 	[NFT_META_CGROUP]	= "cgroup",
 	[NFT_META_PRANDOM]	= "prandom",
+	[NFT_META_SECPATH]	= "secpath",
 };
 
 static const char *meta_key2str(uint8_t key)
-- 
2.13.6

