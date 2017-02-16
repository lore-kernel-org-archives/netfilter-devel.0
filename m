From: Phil Sutter <phil@nwl.cc>
Subject: [libnftnl PATCH] exthdr: Add missing exthdr flags cases
Date: Thu, 16 Feb 2017 12:32:24 +0100
Message-ID: <20170216113224.30193-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:42315 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752983AbdBPLcg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Feb 2017 06:32:36 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Looks like some chunks went by the board while merging with exthdr->op
patch.

Fixes: 4196376330468 ("exthdr: Add support for exthdr flags")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/expr/exthdr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index 143ad549ee1ea..c44c1a75a5ea9 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -292,6 +292,8 @@ static int nftnl_expr_exthdr_export(char *buf, size_t len,
 		nftnl_buf_u32(&b, type, exthdr->len, LEN);
 	if (e->flags & (1 << NFTNL_EXPR_EXTHDR_OP))
 		nftnl_buf_u32(&b, type, exthdr->op, OP);
+	if (e->flags & (1 << NFTNL_EXPR_EXTHDR_FLAGS))
+		nftnl_buf_u32(&b, type, exthdr->flags, FLAGS);
 
 	return nftnl_buf_done(&b);
 }
@@ -338,6 +340,8 @@ static bool nftnl_expr_exthdr_cmp(const struct nftnl_expr *e1,
 		eq &= (h1->type == h2->type);
 	if (e1->flags & (1 << NFTNL_EXPR_EXTHDR_OP))
 		eq &= (h1->op == h2->op);
+	if (e1->flags & (1 << NFTNL_EXPR_EXTHDR_FLAGS))
+		eq &= (h1->flags == h2->flags);
 
 	return eq;
 }
-- 
2.11.0

