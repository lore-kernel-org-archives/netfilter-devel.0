From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl 3/3] expr: hash: missing trailing space and modulus in hexadecimal in snprintf
Date: Tue, 30 Aug 2016 12:41:09 +0200
Message-ID: <1472553669-1910-3-git-send-email-pablo@netfilter.org>
References: <1472553669-1910-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52238 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756771AbcH3KlV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Aug 2016 06:41:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5A74312A68E
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 12:41:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4B276100A6C
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 12:41:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4A0EB100A78
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 12:41:17 +0200 (CEST)
In-Reply-To: <1472553669-1910-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Before patch:

	[ hash reg 1 = jhash(reg 2, 8, 3735928559) % modulus 2]

After patch:

	[ hash reg 1 = jhash(reg 2, 8, 0xdeadbeef) % mod 2 ]

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expr/hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/expr/hash.c b/src/expr/hash.c
index a3439d8..2d61508 100644
--- a/src/expr/hash.c
+++ b/src/expr/hash.c
@@ -235,7 +235,7 @@ nftnl_expr_hash_snprintf_default(char *buf, size_t size,
 	struct nftnl_expr_hash *hash = nftnl_expr_data(e);
 	int len = size, offset = 0, ret;
 
-	ret = snprintf(buf, len, "reg %u = jhash(reg %u, %u, %u) %% modulus %u",
+	ret = snprintf(buf, len, "reg %u = jhash(reg %u, %u, 0x%x) %% mod %u ",
 		       hash->dreg, hash->sreg, hash->len, hash->seed,
 		       hash->modulus);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
-- 
2.1.4

