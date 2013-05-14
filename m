From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [libnftables PATCH 3/7] rule: declare nft_rule_list structure at a proper place
Date: Tue, 14 May 2013 13:51:18 +0300
Message-ID: <1368528682-10041-4-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <519216B6.7060701@linux.intel.com>
 <1368528682-10041-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:2739 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284Ab3ENKve (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 May 2013 06:51:34 -0400
In-Reply-To: <1368528682-10041-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 include/libnftables/rule.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/libnftables/rule.h b/include/libnftables/rule.h
index 50222c5..e7396a4 100644
--- a/include/libnftables/rule.h
+++ b/include/libnftables/rule.h
@@ -54,6 +54,8 @@ struct nft_rule_expr_iter *nft_rule_expr_iter_create(struct nft_rule *r);
 struct nft_rule_expr *nft_rule_expr_iter_next(struct nft_rule_expr_iter *iter);
 void nft_rule_expr_iter_destroy(struct nft_rule_expr_iter *iter);
 
+struct nft_rule_list;
+
 struct nft_rule_list *nft_rule_list_alloc(void);
 void nft_rule_list_free(struct nft_rule_list *list);
 void nft_rule_list_add(struct nft_rule *r, struct nft_rule_list *list);
-- 
1.8.2.1

