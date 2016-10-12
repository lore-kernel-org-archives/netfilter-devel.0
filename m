From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf] netfilter: nft_hash: add missing NFTA_HASH_OFFSET's nla_policy
Date: Wed, 12 Oct 2016 21:10:45 +0800
Message-ID: <1476277845-58642-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, nevola@gmail.com,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-13.163.com ([220.181.12.13]:41349 "EHLO m12-13.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755542AbcJLNM3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Oct 2016 09:12:29 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

Missing the nla_policy description will also miss the validation check
in kernel.

Fixes: 70ca767ea1b2 ("netfilter: nft_hash: Add hash offset value")
Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 net/netfilter/nft_hash.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index 09473b4..baf694d 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -44,6 +44,7 @@ static const struct nla_policy nft_hash_policy[NFTA_HASH_MAX + 1] = {
 	[NFTA_HASH_LEN]		= { .type = NLA_U32 },
 	[NFTA_HASH_MODULUS]	= { .type = NLA_U32 },
 	[NFTA_HASH_SEED]	= { .type = NLA_U32 },
+	[NFTA_HASH_OFFSET]	= { .type = NLA_U32 },
 };
 
 static int nft_hash_init(const struct nft_ctx *ctx,
-- 
2.5.5


