From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH v2] evaluate: reject: fix crash on NULL location with bridge and tcp reset
Date: Wed, 26 Nov 2014 12:07:51 +0100
Message-ID: <1417000071-22579-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:52281 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaKZLHd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Nov 2014 06:07:33 -0500
Received: by mail-wi0-f171.google.com with SMTP id bs8so12118351wib.4
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Nov 2014 03:07:31 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If we use tcp reset with a network protocol that tcp is not supported,
we display an error. This error use the reject.expr location which is NULL,
therefore we have a crash. This patch replaces it using the reject statement
to display the error like:

Rule:
 nft add bridge filter input ether type vlan reject with tcp reset
Output:
 <cmdline>:1:46-51: Error: cannot reject this ether type
 add rule bridge filter input ether type vlan reject with tcp reset
                              ~~~~~~~~~~~~~~~ ^^^^^^

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[changes in v2]
* Enhanced title and description

 src/evaluate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 3eeb614..00e55b7 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1277,7 +1277,7 @@ static int stmt_evaluate_reject_bridge_family(struct eval_ctx *ctx,
 		case __constant_htons(ETH_P_IPV6):
 			break;
 		default:
-			return stmt_binary_error(ctx, stmt->reject.expr,
+			return stmt_binary_error(ctx, stmt,
 				    &ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR],
 				    "cannot reject this ether type");
 		}
-- 
1.7.10.4

