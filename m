From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: exthdr: add missign attributes to policy
Date: Mon, 11 Dec 2017 10:14:27 +0100
Message-ID: <20171211091427.29076-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:57602 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751622AbdLKJPx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Dec 2017 04:15:53 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_exthdr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index a0a93d987a3b..47ec1046ad11 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -214,6 +214,8 @@ static const struct nla_policy nft_exthdr_policy[NFTA_EXTHDR_MAX + 1] = {
 	[NFTA_EXTHDR_OFFSET]		= { .type = NLA_U32 },
 	[NFTA_EXTHDR_LEN]		= { .type = NLA_U32 },
 	[NFTA_EXTHDR_FLAGS]		= { .type = NLA_U32 },
+	[NFTA_EXTHDR_OP]		= { .type = NLA_U32 },
+	[NFTA_EXTHDR_SREG]		= { .type = NLA_U32 },
 };
 
 static int nft_exthdr_init(const struct nft_ctx *ctx,
-- 
2.13.6

