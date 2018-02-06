From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH] Enable automerge feature for anonymous sets
Date: Tue,  6 Feb 2018 19:18:47 +0100
Message-ID: <20180206181847.14434-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org,
        Jeff Kletsky <netfilter@allycomm.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:47790 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752599AbeBFSS7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Feb 2018 13:18:59 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Automatic merging of adjacent/overlapping ranges upon insertion has
clear benefits performance- and readability-wise. The drawbacks which
led to disabling it by default don't apply to anonymous sets since they
are read-only anyway, so enable this feature for them again.

Cc: Jeff Kletsky <netfilter@allycomm.com>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/evaluate.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index aa7c28e8b00ff..076855e257e77 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -87,6 +87,7 @@ static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
 	set->handle.set = xstrdup(name);
 	set->key	= key;
 	set->init	= expr;
+	set->automerge	= set->flags & NFT_SET_INTERVAL;
 
 	if (ctx->table != NULL)
 		list_add_tail(&set->list, &ctx->table->sets);
-- 
2.15.1

