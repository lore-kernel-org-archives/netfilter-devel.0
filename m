From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH 1/2 v3] evaluate: reject: accept a reject reason with incorrect network context
Date: Wed, 22 Oct 2014 15:25:52 +0200
Message-ID: <1413984353-16029-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:54282 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbaJVNZh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Oct 2014 09:25:37 -0400
Received: by mail-wi0-f178.google.com with SMTP id r20so1363579wiv.5
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Oct 2014 06:25:35 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft add rule bridge test-bridge input ether type ip \
				reject with icmpv6 type no-route

This rule pass the evaluation step but the network context is incompatible with
the reject reason. In that cases, we have to throw an error like "conflicting
protocols specified: ip vs ip6"

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[no changes in v3]

 src/evaluate.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index ff46fda..977f6b4 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1237,6 +1237,8 @@ static int stmt_evaluate_reject_family(struct eval_ctx *ctx, struct stmt *stmt,
 			case __constant_htons(ETH_P_IP):
 				if (NFPROTO_IPV4 == stmt->reject.family)
 					break;
+				return stmt_error(ctx, stmt,
+				  "conflicting protocols specified: ip vs ip6");
 			case __constant_htons(ETH_P_IPV6):
 				if (NFPROTO_IPV6 == stmt->reject.family)
 					break;
-- 
1.7.10.4

