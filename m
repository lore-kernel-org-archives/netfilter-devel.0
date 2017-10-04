From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl,v2 1/4] buffer: use nftnl_expr_snprintf() from nftnl_buf_expr()
Date: Wed,  4 Oct 2017 14:23:20 +0200
Message-ID: <1507119803-15127-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42370 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751699AbdJDMX3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Oct 2017 08:23:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7B1B31DA087
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Oct 2017 14:23:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6CF48DA86B
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Oct 2017 14:23:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4F206DA86B
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Oct 2017 14:23:26 +0200 (CEST)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 17ADF40584CE
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Oct 2017 14:23:26 +0200 (CEST)
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

