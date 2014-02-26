From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH] netlink: fix chain attribute parsing
Date: Wed, 26 Feb 2014 18:46:59 +0100
Message-ID: <20140226174659.19715.82142.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:52991 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750954AbaBZRrK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Feb 2014 12:47:10 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The handle's table was being set to the chain name instead of the
chain table attribute.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/netlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/netlink.c b/src/netlink.c
index 2871888..b036dce 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -514,7 +514,7 @@ static int list_chain_cb(struct nft_chain *nlc, void *arg)
 	chain->handle.family =
 		nft_chain_attr_get_u32(nlc, NFT_CHAIN_ATTR_FAMILY);
 	chain->handle.table  =
-		xstrdup(nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_NAME));
+		xstrdup(nft_chain_attr_get_str(nlc, NFT_CHAIN_ATTR_TABLE));
 	chain->handle.handle =
 		nft_chain_attr_get_u64(nlc, NFT_CHAIN_ATTR_HANDLE);
 

