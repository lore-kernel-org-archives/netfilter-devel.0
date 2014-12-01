From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/5] meta: set base field on clones
Date: Mon,  1 Dec 2014 12:45:50 +0100
Message-ID: <1417434354-5782-2-git-send-email-pablo@netfilter.org>
References: <1417434354-5782-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41607 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021AbaLALno (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:43:44 -0500
In-Reply-To: <1417434354-5782-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Set missing field on meta expression clone.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/meta.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/src/meta.c b/src/meta.c
index 9c1ea58..f33837c 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -439,6 +439,7 @@ static bool meta_expr_cmp(const struct expr *e1, const struct expr *e2)
 static void meta_expr_clone(struct expr *new, const struct expr *expr)
 {
 	new->meta.key = expr->meta.key;
+	new->meta.base = expr->meta.base;
 }
 
 /**
-- 
1.7.10.4

