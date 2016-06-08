From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next] netfilter: nft_meta: set skb->nf_trace appropriately
Date: Wed,  8 Jun 2016 20:20:10 +0800
Message-ID: <1465388410-23879-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-11.163.com ([220.181.12.11]:41644 "EHLO m12-11.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422766AbcFHMVG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jun 2016 08:21:06 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

When user add a nft rule to set nftrace to zero, for example:
  # nft add rule ip filter input nftrace set 0

We should set nf_trace to zero also.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 net/netfilter/nft_meta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 16c50b0..f4bad9d 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -227,7 +227,7 @@ void nft_meta_set_eval(const struct nft_expr *expr,
 			skb->pkt_type = value;
 		break;
 	case NFT_META_NFTRACE:
-		skb->nf_trace = 1;
+		skb->nf_trace = !!value;
 		break;
 	default:
 		WARN_ON(1);
-- 
2.5.5


