From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 06/12] src: netlink: don't truncate set key lengths
Date: Sun, 16 Aug 2015 21:05:49 +0200
Message-ID: <1439751955-31190-7-git-send-email-fw@strlen.de>
References: <1439751955-31190-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34747 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751500AbbHPTGM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Aug 2015 15:06:12 -0400
In-Reply-To: <1439751955-31190-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If key is e.g. 12 bits, pretend its 16 instead of 8.  This is needed
to make sets work with header fields with size not divisible by 8.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 8ede8e6..b1296cf 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1100,7 +1100,7 @@ static int netlink_add_set_compat(struct netlink_ctx *ctx,
 	nft_set_attr_set_u32(nls, NFT_SET_ATTR_KEY_TYPE,
 			     dtype_map_to_kernel(set->keytype));
 	nft_set_attr_set_u32(nls, NFT_SET_ATTR_KEY_LEN,
-			     set->keylen / BITS_PER_BYTE);
+			     div_round_up(set->keylen, BITS_PER_BYTE));
 	if (set->flags & NFT_SET_MAP) {
 		nft_set_attr_set_u32(nls, NFT_SET_ATTR_DATA_TYPE,
 				     dtype_map_to_kernel(set->datatype));
@@ -1135,7 +1135,7 @@ static int netlink_add_set_batch(struct netlink_ctx *ctx,
 	nft_set_attr_set_u32(nls, NFT_SET_ATTR_KEY_TYPE,
 			     dtype_map_to_kernel(set->keytype));
 	nft_set_attr_set_u32(nls, NFT_SET_ATTR_KEY_LEN,
-			     set->keylen / BITS_PER_BYTE);
+			     div_round_up(set->keylen, BITS_PER_BYTE));
 	if (set->flags & NFT_SET_MAP) {
 		nft_set_attr_set_u32(nls, NFT_SET_ATTR_DATA_TYPE,
 				     dtype_map_to_kernel(set->datatype));
-- 
2.0.5

