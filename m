From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 4/4] netfilter: nf_tables: accept QUEUE/DROP verdict parameters
Date: Tue, 18 Feb 2014 18:06:50 +0000
Message-ID: <1392746810-22456-5-git-send-email-kaber@trash.net>
References: <1392746810-22456-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62024 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbaBRSHC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Feb 2014 13:07:02 -0500
In-Reply-To: <1392746810-22456-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Allow userspace to specify the queue number or the errno code for QUEUE
and DROP verdicts.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nf_tables_api.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4b7e14d..0b56340 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3174,9 +3174,16 @@ static int nft_verdict_init(const struct nft_ctx *ctx, struct nft_data *data,
 	data->verdict = ntohl(nla_get_be32(tb[NFTA_VERDICT_CODE]));
 
 	switch (data->verdict) {
-	case NF_ACCEPT:
-	case NF_DROP:
-	case NF_QUEUE:
+	default:
+		switch (data->verdict & NF_VERDICT_MASK) {
+		case NF_ACCEPT:
+		case NF_DROP:
+		case NF_QUEUE:
+			break;
+		default:
+			return -EINVAL;
+		}
+		/* fall through */
 	case NFT_CONTINUE:
 	case NFT_BREAK:
 	case NFT_RETURN:
@@ -3197,8 +3204,6 @@ static int nft_verdict_init(const struct nft_ctx *ctx, struct nft_data *data,
 		data->chain = chain;
 		desc->len = sizeof(data);
 		break;
-	default:
-		return -EINVAL;
 	}
 
 	desc->type = NFT_DATA_VERDICT;
-- 
1.8.5.3

