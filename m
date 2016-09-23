From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl] src: display offset only if present in hash and numgen expressions
Date: Fri, 23 Sep 2016 10:19:21 +0200
Message-ID: <1474618761-26921-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60720 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932249AbcIWITl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Sep 2016 04:19:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1455412A68A
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Sep 2016 10:19:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0362BDA852
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Sep 2016 10:19:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 40919DA7F7
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Sep 2016 10:19:33 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

So nft payload python tests don't break.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expr/hash.c   | 12 ++++++++----
 src/expr/numgen.c | 15 ++++++++++-----
 2 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/src/expr/hash.c b/src/expr/hash.c
index 08f09f51e486..c235502870e6 100644
--- a/src/expr/hash.c
+++ b/src/expr/hash.c
@@ -214,12 +214,16 @@ nftnl_expr_hash_snprintf_default(char *buf, size_t size,
 	struct nftnl_expr_hash *hash = nftnl_expr_data(e);
 	int len = size, offset = 0, ret;
 
-	ret = snprintf(buf, len,
-		       "reg %u = %u + jhash(reg %u, %u, 0x%x) %% mod %u ",
-		       hash->offset, hash->dreg, hash->sreg, hash->len,
-		       hash->seed, hash->modulus);
+	ret = snprintf(buf, len, "reg %u = jhash(reg %u, %u, 0x%x) %% mod %u ",
+		       hash->dreg, hash->sreg, hash->len, hash->seed,
+		       hash->modulus);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
+	if (hash->offset) {
+		ret = snprintf(buf, len, "offset %u ", hash->offset);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
+
 	return offset;
 }
 
diff --git a/src/expr/numgen.c b/src/expr/numgen.c
index f5ca3fde025e..e4e055e347a3 100644
--- a/src/expr/numgen.c
+++ b/src/expr/numgen.c
@@ -180,17 +180,22 @@ nftnl_expr_ng_snprintf_default(char *buf, size_t size,
 
 	switch (ng->type) {
 	case NFT_NG_INCREMENTAL:
-		ret = snprintf(buf, len, "reg %u = %u + inc mod %u ", ng->dreg,
-			       ng->offset, ng->modulus);
+		ret = snprintf(buf, len, "reg %u = inc mod %u ",
+			       ng->dreg, ng->modulus);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 		break;
 	case NFT_NG_RANDOM:
-		ret = snprintf(buf, len, "reg %u = %u + random mod %u ",
-			       ng->dreg, ng->offset, ng->modulus);
+		ret = snprintf(buf, len, "reg %u = random mod %u ",
+			       ng->dreg, ng->modulus);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 		break;
 	default:
-		break;
+		return 0;
+	}
+
+	if (ng->offset) {
+		ret = snprintf(buf, len, "offset %u ", ng->offset);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
 	return offset;
-- 
2.1.4

