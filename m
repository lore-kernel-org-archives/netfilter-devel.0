From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [libnftables PATCH 5/7] map: fix nft_rule_expr_build_payload export
Date: Tue, 14 May 2013 13:51:20 +0300
Message-ID: <1368528682-10041-6-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <519216B6.7060701@linux.intel.com>
 <1368528682-10041-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:2739 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284Ab3ENKvh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 May 2013 06:51:37 -0400
In-Reply-To: <1368528682-10041-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 src/libnftables.map | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/libnftables.map b/src/libnftables.map
index 957e3b6..3f98287 100644
--- a/src/libnftables.map
+++ b/src/libnftables.map
@@ -72,6 +72,7 @@ global:
   nft_rule_expr_get_u32;
   nft_rule_expr_get_u64;
   nft_rule_expr_get_str;
+  nft_rule_expr_build_payload;
   nft_rule_expr_free;
 
   nft_rule_list_alloc;
-- 
1.8.2.1

