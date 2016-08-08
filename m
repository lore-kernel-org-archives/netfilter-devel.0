From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 1/5, V2, libnftnl] rule: Add const modifier to rule field of expression iterator
Date: Mon,  8 Aug 2016 14:42:31 +0200
Message-ID: <20160808124235.11135-1-carlosfg@riseup.net>
References: <20160808111758.4062-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:50002 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbcHHMnI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Aug 2016 08:43:08 -0400
In-Reply-To: <20160808111758.4062-1-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Carlos Falgueras García <carlosfg@riseup.net>
---
 include/libnftnl/rule.h | 2 +-
 src/rule.c              | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/libnftnl/rule.h b/include/libnftnl/rule.h
index 2776a77..09af96c 100644
--- a/include/libnftnl/rule.h
+++ b/include/libnftnl/rule.h
@@ -70,7 +70,7 @@ int nftnl_expr_foreach(struct nftnl_rule *r,
 
 struct nftnl_expr_iter;
 
-struct nftnl_expr_iter *nftnl_expr_iter_create(struct nftnl_rule *r);
+struct nftnl_expr_iter *nftnl_expr_iter_create(const struct nftnl_rule *r);
 struct nftnl_expr *nftnl_expr_iter_next(struct nftnl_expr_iter *iter);
 void nftnl_expr_iter_destroy(struct nftnl_expr_iter *iter);
 
diff --git a/src/rule.c b/src/rule.c
index a0edca7..30b8b5e 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1026,11 +1026,11 @@ int nftnl_expr_foreach(struct nftnl_rule *r,
 EXPORT_SYMBOL_ALIAS(nftnl_expr_foreach, nft_rule_expr_foreach);
 
 struct nftnl_expr_iter {
-	struct nftnl_rule		*r;
+	const struct nftnl_rule	*r;
 	struct nftnl_expr	*cur;
 };
 
-struct nftnl_expr_iter *nftnl_expr_iter_create(struct nftnl_rule *r)
+struct nftnl_expr_iter *nftnl_expr_iter_create(const struct nftnl_rule *r)
 {
 	struct nftnl_expr_iter *iter;
 
-- 
2.8.3

