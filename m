From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [nftables-kernel PATCH 2/7] netfilter: nf_tables: Use byteorder operands length relevantly
Date: Mon, 14 Oct 2013 15:46:51 +0300
Message-ID: <1381754816-28472-3-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1381754816-28472-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:52811 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755988Ab3JNMrE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Oct 2013 08:47:04 -0400
In-Reply-To: <1381754816-28472-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 net/netfilter/nft_byteorder.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/netfilter/nft_byteorder.c b/net/netfilter/nft_byteorder.c
index d213b98..c39ed8d 100644
--- a/net/netfilter/nft_byteorder.c
+++ b/net/netfilter/nft_byteorder.c
@@ -110,8 +110,6 @@ static int nft_byteorder_init(const struct nft_ctx *ctx,
 	}
 
 	priv->len = ntohl(nla_get_be32(tb[NFTA_BYTEORDER_LEN]));
-	// FIXME: something is corrupting the attribute value
-	priv->len = 4;
 	if (priv->len == 0 || priv->len > FIELD_SIZEOF(struct nft_data, data))
 		return -EINVAL;
 
-- 
1.8.3.2

