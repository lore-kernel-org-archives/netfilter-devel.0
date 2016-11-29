From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] expr: call expr->ops->snprintf only if defined
Date: Tue, 29 Nov 2016 21:40:44 +0100
Message-ID: <1480452044-9926-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60210 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757237AbcK2Uk5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Nov 2016 15:40:57 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B8566174D13
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 21:40:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A93B0DA38E
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 21:40:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 41A3CDA38E
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 21:40:52 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The notrack expression comes with no ->ops->snprintf, so skip this from
nftnl_expr_snprintf() if not set.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/expr.c b/src/expr.c
index 2779b3c42217..8d5c56206867 100644
--- a/src/expr.c
+++ b/src/expr.c
@@ -281,6 +281,9 @@ int nftnl_expr_snprintf(char *buf, size_t size, const struct nftnl_expr *expr,
 	int ret;
 	unsigned int offset = 0, len = size;
 
+	if (!expr->ops->snprintf)
+		return 0;
+
 	ret = expr->ops->snprintf(buf+offset, len, type, flags, expr);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
-- 
2.1.4

