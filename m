From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH 1/3] expr: masq: optional printing of flags attr in
 snprintf_default
Date: Thu, 02 Oct 2014 13:58:36 +0200
Message-ID: <20141002115836.10972.3637.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org, anayrey@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:59076 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751176AbaJBL6q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Oct 2014 07:58:46 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The flags attribute is optional. Thus we should print only if it
was originally set.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 0 files changed

diff --git a/src/expr/masq.c b/src/expr/masq.c
index 6a1c609..c8a6a8d 100644
--- a/src/expr/masq.c
+++ b/src/expr/masq.c
@@ -169,8 +169,10 @@ static int nft_rule_expr_masq_snprintf_default(char *buf, size_t len,
 {
 	struct nft_expr_masq *masq = nft_expr_data(e);
 
-	return snprintf(buf, len, " flags %u ",
-			 masq->flags);
+	if (e->flags & (1 << NFT_EXPR_MASQ_FLAGS))
+		return snprintf(buf, len, "flags %u", masq->flags);
+
+	return 0;
 }
 
 static int nft_rule_expr_masq_snprintf(char *buf, size_t len, uint32_t type,

