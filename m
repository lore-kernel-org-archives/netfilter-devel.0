From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2/2] netfilter: nft_meta: use raw_smp_processor_id()
Date: Wed, 25 Mar 2015 08:09:56 +0000
Message-ID: <1427270996-6311-2-git-send-email-kaber@trash.net>
References: <1427270996-6311-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45369 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbbCYILU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2015 04:11:20 -0400
In-Reply-To: <1427270996-6311-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Using smp_processor_id() triggers warnings with PREEMPT_RCU. There is no
point in disabling preemption since we only collect the numeric value,
so use raw_smp_processor_id() instead.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nft_meta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index abe6811..5197874 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -153,7 +153,7 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 		}
 		break;
 	case NFT_META_CPU:
-		dest->data[0] = smp_processor_id();
+		dest->data[0] = raw_smp_processor_id();
 		break;
 	case NFT_META_IIFGROUP:
 		if (in == NULL)
-- 
2.1.0

