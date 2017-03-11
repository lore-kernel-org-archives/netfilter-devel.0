From: Phil Sutter <phil@nwl.cc>
Subject: [libnftnl PATCH] expr: exthdr: Display NFT_EXTHDR_F_PRESENT in debug output
Date: Sat, 11 Mar 2017 14:27:23 +0100
Message-ID: <20170311132723.7829-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:48953 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755626AbdCKN1f (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 11 Mar 2017 08:27:35 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This allows to assert it in testsuite also.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/expr/exthdr.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index 9ed4ae1725ac1..d4f166525dc9e 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -301,9 +301,11 @@ static int nftnl_expr_exthdr_snprintf_default(char *buf, size_t len,
 					      const struct nftnl_expr *e)
 {
 	struct nftnl_expr_exthdr *exthdr = nftnl_expr_data(e);
-	return snprintf(buf, len, "load%s %ub @ %u + %u => reg %u ",
+	return snprintf(buf, len, "load%s %ub @ %u + %u%s => reg %u ",
 			op2str(exthdr->op), exthdr->len, exthdr->type,
-			exthdr->offset, exthdr->dreg);
+			exthdr->offset,
+			exthdr->flags & NFT_EXTHDR_F_PRESENT ? " present" : "",
+			exthdr->dreg);
 }
 
 static int
-- 
2.11.0

