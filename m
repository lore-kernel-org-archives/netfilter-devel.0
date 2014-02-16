From: Nikolay Aleksandrov <nikolay@redhat.com>
Subject: [PATCH v2] netfilter: nf_tables: check if payload offset is a power of 2
Date: Sun, 16 Feb 2014 13:22:18 +0100
Message-ID: <1392553338-1978-1-git-send-email-nikolay@redhat.com>
Cc: pablo@netfilter.org, kaber@trash.net,
	Nikolay Aleksandrov <nikolay@redhat.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026AbaBPMWa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Feb 2014 07:22:30 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add a check if payload's offset is a power of 2 when selecting ops.
The fast ops were meant for well aligned offsets, also this fixes a
small bug when using unaligned offset and length of 3 which causes
only 1 byte to be loaded because the fast ops are chosen.

Signed-off-by: Nikolay Aleksandrov <nikolay@redhat.com>
---
v2: use is_power_of_2, and adjust order of checks as per Patrick's comment

Sorry for the noise, I shouldn't hurry so much. This patch applies to
Dave's -net tree.

 net/netfilter/nft_payload.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index a2aeb31..3321ce0 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -135,7 +135,8 @@ nft_payload_select_ops(const struct nft_ctx *ctx,
 	if (len == 0 || len > FIELD_SIZEOF(struct nft_data, data))
 		return ERR_PTR(-EINVAL);
 
-	if (len <= 4 && IS_ALIGNED(offset, len) && base != NFT_PAYLOAD_LL_HEADER)
+	if (len <= 4 && is_power_of_2(offset) && IS_ALIGNED(offset, len) &&
+	    base != NFT_PAYLOAD_LL_HEADER)
 		return &nft_payload_fast_ops;
 	else
 		return &nft_payload_ops;
-- 
1.8.4.2

