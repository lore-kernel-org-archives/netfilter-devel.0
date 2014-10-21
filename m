From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH 2/4 v2] evaluate: accept a reject reason with incorrect network context
Date: Tue, 21 Oct 2014 16:15:44 +0200
Message-ID: <1413900946-15820-2-git-send-email-alvaroneay@gmail.com>
References: <1413900946-15820-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:36363 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932702AbaJUOW7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Oct 2014 10:22:59 -0400
Received: by mail-wi0-f181.google.com with SMTP id hi2so1982521wib.8
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Oct 2014 07:22:56 -0700 (PDT)
In-Reply-To: <1413900946-15820-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft add rule bridge test-bridge input ether type ip \
				reject with icmpv6 type no-route

This rule pass the evaluation step but the network context is incompatible with
the reject reason. In that cases, we have to throw an error like "conflicting
protocols specified: ip vs ip6"

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[no changes in v2]

 src/evaluate.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index e26e2f8..017d9b0 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1258,6 +1258,8 @@ static int stmt_evaluate_reject_bridge_family(struct eval_ctx *ctx,
 	case __constant_htons(ETH_P_IP):
 		if (NFPROTO_IPV4 == stmt->reject.family)
 			break;
+		return stmt_error(ctx, stmt,
+				  "conflicting protocols specified: ip vs ip6");
 	case __constant_htons(ETH_P_IPV6):
 		if (NFPROTO_IPV6 == stmt->reject.family)
 			break;
-- 
1.7.10.4

