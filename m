From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [libnftables PATCH] expr: Fix header inclusion for integer types
Date: Wed,  3 Jul 2013 12:42:20 +0300
Message-ID: <1372844540-8336-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:59540 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754240Ab3GCJmj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Jul 2013 05:42:39 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 include/libnftables/expr.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/libnftables/expr.h b/include/libnftables/expr.h
index 38cd698..92710df 100644
--- a/include/libnftables/expr.h
+++ b/include/libnftables/expr.h
@@ -1,6 +1,7 @@
 #ifndef _RULE_EXPR_H_
 #define _RULE_EXPR_H_
 
+#include <stdint.h>
 #include <stdbool.h>
 
 #ifdef __cplusplus
-- 
1.8.2.1

