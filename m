From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH] segtree: Fix expr_value_cmp()
Date: Thu,  6 Jul 2017 16:25:28 +0200
Message-ID: <20170706142528.19715-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:35849 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751741AbdGFOZl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Jul 2017 10:25:41 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Instead of returning the result of mpz_cmp(), this function returned 1
unless both elements were equal and the first one had
EXPR_F_INTERVAL_END set.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/segtree.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/src/segtree.c b/src/segtree.c
index a2316a7b98041..f53536210018d 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -602,10 +602,12 @@ static int expr_value_cmp(const void *p1, const void *p2)
 	int ret;
 
 	ret = mpz_cmp(expr_value(e1)->value, expr_value(e2)->value);
-	if (ret == 0 && (e1->flags & EXPR_F_INTERVAL_END))
-		return -1;
-	else
-		return 1;
+	if (ret == 0) {
+		if (e1->flags & EXPR_F_INTERVAL_END)
+			return -1;
+		else if (e2->flags & EXPR_F_INTERVAL_END)
+			return 1;
+	}
 
 	return ret;
 }
-- 
2.13.1

