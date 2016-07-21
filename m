From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl] expr: lookup: print flags only if they are available
Date: Thu, 21 Jul 2016 19:16:23 +0200
Message-ID: <1469121383-20673-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37328 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300AbcGURQd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Jul 2016 13:16:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 66711210564
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Jul 2016 19:16:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 589D8FAB53
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Jul 2016 19:16:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 32A869D106
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Jul 2016 19:16:27 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Follow same approach as with other objects, print what it is set only.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expr/lookup.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index 16cfce2..97478c2 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -264,8 +264,10 @@ nftnl_expr_lookup_snprintf_default(char *buf, size_t size,
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
-	ret = snprintf(buf + offset, len, "0x%x ", l->flags);
-	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	if (e->flags & (1 << NFTNL_EXPR_LOOKUP_FLAGS)) {
+		ret = snprintf(buf + offset, len, "0x%x ", l->flags);
+		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
+	}
 
 	return offset;
 }
-- 
2.1.4

