From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl] expr: missing offset handling for snprintf() in hash and numgen
Date: Mon, 31 Oct 2016 13:32:33 +0100
Message-ID: <1477917153-14029-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34392 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941684AbcJaMc6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Oct 2016 08:32:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 038672519B2
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Oct 2016 13:32:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E796CBAC37
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Oct 2016 13:32:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5B802BAC3D
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Oct 2016 13:32:52 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fix incorrect output when offset attribute is unset.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expr/hash.c   | 2 +-
 src/expr/numgen.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/expr/hash.c b/src/expr/hash.c
index c235502870e6..83f93179c26d 100644
--- a/src/expr/hash.c
+++ b/src/expr/hash.c
@@ -220,7 +220,7 @@ nftnl_expr_hash_snprintf_default(char *buf, size_t size,
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	if (hash->offset) {
-		ret = snprintf(buf, len, "offset %u ", hash->offset);
+		ret = snprintf(buf + offset, len, "offset %u ", hash->offset);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
diff --git a/src/expr/numgen.c b/src/expr/numgen.c
index e4e055e347a3..a15f03ae834b 100644
--- a/src/expr/numgen.c
+++ b/src/expr/numgen.c
@@ -194,7 +194,7 @@ nftnl_expr_ng_snprintf_default(char *buf, size_t size,
 	}
 
 	if (ng->offset) {
-		ret = snprintf(buf, len, "offset %u ", ng->offset);
+		ret = snprintf(buf + offset, len, "offset %u ", ng->offset);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
-- 
2.1.4

