From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nft] evaluate: fix crash if we add an error format rule
Date: Sat, 14 May 2016 20:43:35 +0800
Message-ID: <1463229815-39269-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-14.163.com ([220.181.12.14]:54444 "EHLO m12-14.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070AbcENMok (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 May 2016 08:44:40 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

If we add a such nft rule:
  nft add rule filter input ip protocol icmp tcp dport 0

we will always meet the assert condition:
  nft: evaluate.c:536: resolve_protocol_conflict: Assertion `base < (__PROTO_BASE_MAX - 1)' failed.
  Aborted (core dumped)
---
 src/evaluate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 53f19b2..c317761 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -533,7 +533,7 @@ static int resolve_protocol_conflict(struct eval_ctx *ctx,
 		list_add_tail(&nstmt->list, &ctx->stmt->list);
 	}
 
-	assert(base < PROTO_BASE_MAX);
+	assert(base <= PROTO_BASE_MAX);
 	/* This payload and the existing context don't match, conflict. */
 	if (ctx->pctx.protocol[base + 1].desc != NULL)
 		return 1;
-- 
2.5.5


