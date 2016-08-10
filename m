From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 2/3, libnftnl] expr: Fix lookup builder
Date: Wed, 10 Aug 2016 17:12:04 +0200
Message-ID: <20160810151205.24975-2-carlosfg@riseup.net>
References: <20160810151205.24975-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:51717 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933580AbcHJUcS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Aug 2016 16:32:18 -0400
In-Reply-To: <20160810151205.24975-1-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Deleted wrong braces that cause unwanted behaviour.

Signed-off-by: Carlos Falgueras García <carlosfg@riseup.net>
---
 src/expr/lookup.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index 57612d1..60da653 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -122,12 +122,11 @@ nftnl_expr_lookup_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 		mnl_attr_put_u32(nlh, NFTA_LOOKUP_DREG, htonl(lookup->dreg));
 	if (e->flags & (1 << NFTNL_EXPR_LOOKUP_SET))
 		mnl_attr_put_strz(nlh, NFTA_LOOKUP_SET, lookup->set_name);
-	if (e->flags & (1 << NFTNL_EXPR_LOOKUP_SET_ID)) {
+	if (e->flags & (1 << NFTNL_EXPR_LOOKUP_SET_ID))
 		mnl_attr_put_u32(nlh, NFTA_LOOKUP_SET_ID,
 				 htonl(lookup->set_id));
 	if (e->flags & (1 << NFTNL_EXPR_LOOKUP_FLAGS))
 		mnl_attr_put_u32(nlh, NFTA_LOOKUP_FLAGS, htonl(lookup->flags));
-	}
 }
 
 static int
-- 
2.8.3

