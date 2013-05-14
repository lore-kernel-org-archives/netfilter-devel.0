From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [libnftables PATCH 4/7] expr: remove inconsistent and non implemented function
Date: Tue, 14 May 2013 13:51:19 +0300
Message-ID: <1368528682-10041-5-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <519216B6.7060701@linux.intel.com>
 <1368528682-10041-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:2739 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284Ab3ENKvg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 May 2013 06:51:36 -0400
In-Reply-To: <1368528682-10041-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 include/libnftables/expr.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/libnftables/expr.h b/include/libnftables/expr.h
index 6d5d4e3..d899e41 100644
--- a/include/libnftables/expr.h
+++ b/include/libnftables/expr.h
@@ -27,8 +27,6 @@ uint32_t nft_rule_expr_get_u32(struct nft_rule_expr *expr, uint16_t type);
 uint64_t nft_rule_expr_get_u64(struct nft_rule_expr *expr, uint16_t type);
 const char *nft_rule_expr_get_str(struct nft_rule_expr *expr, uint16_t type);
 
-struct list_head *nft_rule_expr_list_head(struct nft_rule_expr *expr);
-
 void nft_rule_expr_build_payload(struct nlmsghdr *nlh, struct nft_rule_expr *expr);
 
 enum {
-- 
1.8.2.1

