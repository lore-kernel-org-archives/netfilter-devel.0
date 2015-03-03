From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2/3] netfilter: nf_tables: consolidate tracing invocations
Date: Tue,  3 Mar 2015 20:10:05 +0000
Message-ID: <1425413406-6804-3-git-send-email-kaber@trash.net>
References: <1425413406-6804-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44983 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbbCCUKL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Mar 2015 15:10:11 -0500
In-Reply-To: <1425413406-6804-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* JUMP and GOTO are equivalent except for JUMP pushing the current
  context to the stack

* RETURN and implicit RETURN (CONTINUE) are equivalent except that
  the logged rule number differs

Result:

  nft_do_chain              | -112
 1 function changed, 112 bytes removed, diff: -112

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nf_tables_core.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 074067d..77165bf 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -170,26 +170,23 @@ next_rule:
 
 	switch (data[NFT_REG_VERDICT].verdict) {
 	case NFT_JUMP:
-		nft_trace_packet(pkt, chain, rulenum, NFT_TRACE_RULE);
-
 		BUG_ON(stackptr >= NFT_JUMP_STACK_SIZE);
 		jumpstack[stackptr].chain = chain;
 		jumpstack[stackptr].rule  = rule;
 		jumpstack[stackptr].rulenum = rulenum;
 		stackptr++;
-		chain = data[NFT_REG_VERDICT].chain;
-		goto do_chain;
+		/* fall through */
 	case NFT_GOTO:
 		nft_trace_packet(pkt, chain, rulenum, NFT_TRACE_RULE);
 
 		chain = data[NFT_REG_VERDICT].chain;
 		goto do_chain;
+	case NFT_CONTINUE:
+		rulenum++;
+		/* fall through */
 	case NFT_RETURN:
 		nft_trace_packet(pkt, chain, rulenum, NFT_TRACE_RETURN);
 		break;
-	case NFT_CONTINUE:
-		nft_trace_packet(pkt, chain, ++rulenum, NFT_TRACE_RETURN);
-		break;
 	default:
 		WARN_ON(1);
 	}
-- 
2.1.0

