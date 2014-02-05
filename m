From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2/5] netfilter: nft_ct: fix missing NFT_CT_L3PROTOCOL key in validity checks
Date: Wed,  5 Feb 2014 15:03:36 +0000
Message-ID: <1391612619-30347-3-git-send-email-kaber@trash.net>
References: <1391612619-30347-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57605 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbaBEPED (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Feb 2014 10:04:03 -0500
In-Reply-To: <1391612619-30347-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The key was missing in the list of valid keys, add it.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nft_ct.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 917052e..75ebfe7 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -226,6 +226,7 @@ static int nft_ct_init_validate_get(const struct nft_expr *expr,
 		if (tb[NFTA_CT_DIRECTION] != NULL)
 			return -EINVAL;
 		break;
+	case NFT_CT_L3PROTOCOL:
 	case NFT_CT_PROTOCOL:
 	case NFT_CT_SRC:
 	case NFT_CT_DST:
-- 
1.8.5.3

