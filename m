From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [PATCH 1/5] netfilter: nf_tables: Stack expression type depending on their family
Date: Tue,  8 Apr 2014 14:25:20 +0300
Message-ID: <1396956324-17803-2-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1396956324-17803-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:62297 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756239AbaDHLZl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Apr 2014 07:25:41 -0400
In-Reply-To: <1396956324-17803-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

To ensure family tight expression gets selected in priority to family
agnostic ones.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 net/netfilter/nf_tables_api.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 33045a5..700a522 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1093,7 +1093,10 @@ static void nft_ctx_init(struct nft_ctx *ctx,
 int nft_register_expr(struct nft_expr_type *type)
 {
 	nfnl_lock(NFNL_SUBSYS_NFTABLES);
-	list_add_tail(&type->list, &nf_tables_expressions);
+	if (type->family == NFPROTO_UNSPEC)
+		list_add_tail(&type->list, &nf_tables_expressions);
+	else
+		list_add(&type->list, &nf_tables_expressions);
 	nfnl_unlock(NFNL_SUBSYS_NFTABLES);
 	return 0;
 }
-- 
1.8.3.2

