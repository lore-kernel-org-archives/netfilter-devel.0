From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 4/4] netfilter: xtables: don't attempt to alloc more than 4g
Date: Sat, 19 Mar 2016 22:51:34 +0100
Message-ID: <1458424294-8678-4-git-send-email-fw@strlen.de>
References: <1458424294-8678-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:35268 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932143AbcCSVv1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Mar 2016 17:51:27 -0400
In-Reply-To: <1458424294-8678-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We track size in unsigned int everywhere, so better don't
even bother trying to alloc this size.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/x_tables.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 582c9cf..3740717 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -659,7 +659,7 @@ struct xt_table_info *xt_alloc_table_info(unsigned int size)
 	struct xt_table_info *info = NULL;
 	size_t sz = sizeof(*info) + size;
 
-	if (sz < sizeof(*info))
+	if (sz < sizeof(*info) || sz > UINT_MAX)
 		return NULL;
 
 	/* Pedantry: prevent them from hitting BUG() in vmalloc.c --RR */
-- 
2.4.10

