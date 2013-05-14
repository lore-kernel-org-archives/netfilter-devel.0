From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables PATCH 3/6] xtables: policy can be changed only on builtin chain
Date: Tue, 14 May 2013 13:52:04 +0300
Message-ID: <1368528727-10127-4-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <519216B6.7060701@linux.intel.com>
 <1368528727-10127-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:46611 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757020Ab3ENKwR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 May 2013 06:52:17 -0400
In-Reply-To: <1368528727-10127-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 574383d..afbba84 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -503,16 +503,9 @@ __nft_chain_set(struct nft_handle *h, const char *table,
 		c = nft_chain_builtin_alloc(_t, _c, policy);
 		if (c == NULL)
 			return -1;
-
 	} else {
-		/* This is a custom chain */
-		c = nft_chain_alloc();
-		if (c == NULL)
-			return -1;
-
-		nft_chain_attr_set(c, NFT_CHAIN_ATTR_TABLE, (char *)table);
-		nft_chain_attr_set(c, NFT_CHAIN_ATTR_NAME, (char *)chain);
-		nft_chain_attr_set_u32(c, NFT_CHAIN_ATTR_POLICY, policy);
+		errno = ENOENT;
+		return -1;
 	}
 
 	if (counters) {
-- 
1.8.2.1

