From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl 1/3] expr: numgen: use switch to handle numgen types from snprintf
Date: Tue, 30 Aug 2016 12:41:07 +0200
Message-ID: <1472553669-1910-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52228 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755916AbcH3KlV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Aug 2016 06:41:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2F45512A690
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 12:41:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1565E100A7F
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 12:41:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C026A9EBB8
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 12:41:13 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use switch instead of if branch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expr/numgen.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/src/expr/numgen.c b/src/expr/numgen.c
index 0981d72..7be8270 100644
--- a/src/expr/numgen.c
+++ b/src/expr/numgen.c
@@ -189,16 +189,17 @@ nftnl_expr_ng_snprintf_default(char *buf, size_t size,
 	struct nftnl_expr_ng *ng = nftnl_expr_data(e);
 	int len = size, offset = 0, ret;
 
-	if (ng->type == NFT_NG_INCREMENTAL) {
+	switch (ng->type) {
+	case NFT_NG_INCREMENTAL:
 		ret = snprintf(buf, len, "reg %u = inc(%u)", ng->dreg,
 			       ng->until);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-	}
-
-	if (ng->type == NFT_NG_RANDOM) {
+		break;
+	case NFT_NG_RANDOM:
 		ret = snprintf(buf, len, "reg %u = random(%u)", ng->dreg,
 			       ng->until);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+		break;
 	}
 
 	return offset;
-- 
2.1.4

