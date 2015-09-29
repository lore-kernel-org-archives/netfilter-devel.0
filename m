From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl] expr: dup: fix missing space in text output
Date: Tue, 29 Sep 2015 20:25:13 +0200
Message-ID: <1443551113-25122-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37301 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935325AbbI2SSb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Sep 2015 14:18:31 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expr/dup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/expr/dup.c b/src/expr/dup.c
index 6498972..d0fa35f 100644
--- a/src/expr/dup.c
+++ b/src/expr/dup.c
@@ -176,12 +176,12 @@ static int nftnl_expr_dup_snprintf_default(char *buf, size_t len,
 	struct nftnl_expr_dup *dup = nftnl_expr_data(e);
 
 	if (e->flags & (1 << NFTNL_EXPR_DUP_SREG_ADDR)) {
-		ret = snprintf(buf + offset, len, "sreg_addr %u", dup->sreg_addr);
+		ret = snprintf(buf + offset, len, "sreg_addr %u ", dup->sreg_addr);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
 	if (e->flags & (1 << NFTNL_EXPR_DUP_SREG_DEV)) {
-		ret = snprintf(buf + offset, len, "sreg_dev %u", dup->sreg_dev);
+		ret = snprintf(buf + offset, len, "sreg_dev %u ", dup->sreg_dev);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 	}
 
-- 
2.1.4

