From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 08/10] src: add a comment wrt. reject dependency insertion
Date: Tue,  9 May 2017 17:51:20 +0200
Message-ID: <20170509155122.26356-9-fw@strlen.de>
References: <20170509155122.26356-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:44566 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755832AbdEIPvh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 May 2017 11:51:37 -0400
In-Reply-To: <20170509155122.26356-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

at first I thought this was a bug but this in fact seems the right
thing, add a comment/example why adding dependency as first statement makes
sense.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index 1cfe7675162e..27cee98916db 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2015,6 +2015,14 @@ static int stmt_reject_gen_dependency(struct eval_ctx *ctx, struct stmt *stmt,
 	if (payload_gen_dependency(ctx, payload, &nstmt) < 0)
 		return -1;
 
+	/*
+	 * Unlike payload deps this adds the dependency at the beginning, i.e.
+	 * log ... reject with tcp-reset
+	 * turns into
+	 * meta l4proto tcp log ... reject with tcp-reset
+	 *
+	 * Otherwise we'd log things that won't be rejected.
+	 */
 	list_add(&nstmt->list, &ctx->rule->stmts);
 	return 0;
 }
-- 
2.10.2

