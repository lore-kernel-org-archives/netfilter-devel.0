From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl 1/3] buffer: use nftnl_expr_snprintf() from nftnl_buf_expr()
Date: Wed,  4 Oct 2017 14:09:30 +0200
Message-ID: <1507118972-18478-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60768 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751910AbdJDMJs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Oct 2017 08:09:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A2CF81BFA87
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Oct 2017 14:09:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 94B36DA385
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Oct 2017 14:09:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7F276DA918
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Oct 2017 14:09:36 +0200 (CEST)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3D4C040584CD
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Oct 2017 14:09:36 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This helper function deals with no ->snprintf() indirection in
expression and safe buffer nul-termination, use it.

Fixes: 059b9bf6fb31 ("src: Use nftnl_buf to export XML/JSON rules")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/buffer.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/src/buffer.c b/src/buffer.c
index f9d5a838c4ab..9ec86af121c9 100644
--- a/src/buffer.c
+++ b/src/buffer.c
@@ -14,6 +14,7 @@
 #include <string.h>
 #include <buffer.h>
 #include <libnftnl/common.h>
+#include <libnftnl/expr.h>
 #include "internal.h"
 
 int nftnl_buf_update(struct nftnl_buf *b, int ret)
@@ -206,8 +207,8 @@ int nftnl_buf_expr(struct nftnl_buf *b, int type, uint32_t flags,
 	case NFTNL_OUTPUT_JSON:
 		nftnl_buf_put(b, "{");
 		nftnl_buf_str(b, type, expr->ops->name, TYPE);
-		ret = expr->ops->snprintf(b->buf + b->off, b->len, type, flags,
-					  expr);
+		ret = nftnl_expr_snprintf(b->buf + b->off, b->len, expr, type,
+					  flags);
 		if (ret > 0)
 			nftnl_buf_update(b, ret);
 		else
-- 
2.1.4

