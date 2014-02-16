From: Nikolay Aleksandrov <nikolay@redhat.com>
Subject: [PATCH v3] netfilter: nf_tables: check if payload length is a power of 2
Date: Sun, 16 Feb 2014 14:01:58 +0100
Message-ID: <1392555718-3607-1-git-send-email-nikolay@redhat.com>
Cc: pablo@netfilter.org, kaber@trash.net,
	Nikolay Aleksandrov <nikolay@redhat.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724AbaBPNCH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Feb 2014 08:02:07 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add a check if payload's length is a power of 2 when selecting ops.
The fast ops were meant for well aligned loads, also this fixes a
small bug when using a length of 3 with some offsets which causes
only 1 byte to be loaded because the fast ops are chosen.

Signed-off-by: Nikolay Aleksandrov <nikolay@redhat.com>
---
v3: Check the length,  not the offset.
v2: use is_power_of_2, and adjust order of checks as per Patrick's comment

Sorry for the noise, I shouldn't hurry so much. This patch applies to
Dave's -net tree.

 net/netfilter/nft_payload.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index a2aeb31..85daa84 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -135,7 +135,8 @@ nft_payload_select_ops(const struct nft_ctx *ctx,
 	if (len == 0 || len > FIELD_SIZEOF(struct nft_data, data))
 		return ERR_PTR(-EINVAL);
 
-	if (len <= 4 && IS_ALIGNED(offset, len) && base != NFT_PAYLOAD_LL_HEADER)
+	if (len <= 4 && is_power_of_2(len) && IS_ALIGNED(offset, len) &&
+	    base != NFT_PAYLOAD_LL_HEADER)
 		return &nft_payload_fast_ops;
 	else
 		return &nft_payload_ops;
-- 
1.8.4.2

