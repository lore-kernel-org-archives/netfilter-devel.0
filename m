From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH libnftnl] rule: Fix comparison between rules
Date: Thu, 18 Aug 2016 17:12:36 +0200
Message-ID: <20160818151236.19924-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:56274 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754886AbcHSBMY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Aug 2016 21:12:24 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Before this patch, comparison between rules with distinct number of
expressions can returns that they are equals when they are not. Example:

	r1[e1, e2] == r2[e1, e2, e3]

Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Carlos Falgueras García <carlosfg@riseup.net>
---
 src/rule.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/rule.c b/src/rule.c
index ae7c478..9822d63 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1102,6 +1102,7 @@ bool nftnl_rule_cmp(const struct nftnl_rule *r1, const struct nftnl_rule *r2)
 		e1 = nftnl_expr_iter_next(&it1);
 		e2 = nftnl_expr_iter_next(&it2);
 	}
+	eq &= (e1 == NULL) && (e2 == NULL); /* Same number of expressions */
 
 	return eq;
 }
-- 
2.8.3

