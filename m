From: Florian Westphal <fw@strlen.de>
Subject: [PATCH -next] netfilter: nf_tables: fix wrong length for jump/goto verdicts
Date: Tue, 14 Apr 2015 16:44:14 +0200
Message-ID: <1429022654-24585-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:37341 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932582AbbDNOoZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Apr 2015 10:44:25 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

NFT_JUMP/GOTO erronously sets length to sizeof(void *).

We then allocate insufficient memory when such element is added to a vmap.

Suggested-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 78af83b..ad9d11f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4340,7 +4340,6 @@ static int nft_verdict_init(const struct nft_ctx *ctx, struct nft_data *data,
 	case NFT_CONTINUE:
 	case NFT_BREAK:
 	case NFT_RETURN:
-		desc->len = sizeof(data->verdict);
 		break;
 	case NFT_JUMP:
 	case NFT_GOTO:
@@ -4355,10 +4354,10 @@ static int nft_verdict_init(const struct nft_ctx *ctx, struct nft_data *data,
 
 		chain->use++;
 		data->verdict.chain = chain;
-		desc->len = sizeof(data);
 		break;
 	}
 
+	desc->len = sizeof(data->verdict);
 	desc->type = NFT_DATA_VERDICT;
 	return 0;
 }
-- 
2.0.5

