From: Eric Leblond <eric@regit.org>
Subject: [nftables PATCH] listing: only display wanted chain
Date: Mon, 18 Nov 2013 08:40:21 +0100
Message-ID: <1384760421-4238-1-git-send-email-eric@regit.org>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:45135 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab3KRHkp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Nov 2013 02:40:45 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When specifying a chain to list, all created chains were displayed
with a void content:

 # nft list chain filter
 table ip filter {
  	chain input {
  	}

  	chain new {
  		 counter packets 17971 bytes 2380637 accept
  		 counter packets 0 bytes 0 accept
  	}
  }

With the attached patch, only the asked chain is displayed:

  # nft list chain filter
  table ip filter {
  	chain new {
  		 counter packets 17971 bytes 2380637 accept # handle 36
  		 counter packets 0 bytes 0 accept # handle 40
  	}
  }

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/netlink.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/netlink.c b/src/netlink.c
index a62c357..15cba79 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -544,6 +544,10 @@ static int list_chain_cb(struct nft_chain *nlc, void *arg)
 	    strcmp(nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_TABLE), h->table) != 0)
 		return 0;
 
+	if (h->chain &&
+	    strcmp(nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_NAME), h->chain) != 0)
+		return 0;
+
 	chain = chain_alloc(nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_NAME));
 	chain->handle.family =
 		nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_FAMILY);
-- 
1.8.4.3

