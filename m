From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH libnftnl] expr: data_reg: Fix DATA_CHAIN comparison
Date: Wed, 24 Aug 2016 14:22:16 +0200
Message-ID: <20160824122216.29351-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:49209 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753012AbcHXMX6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Aug 2016 08:23:58 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Splits DATA_VERDICT and DATA_CHAIN comparison. A verdict can have a NULL
chain (accept, drop, etc) so segfault will happen when strcmp is call.

Signed-off-by: Carlos Falgueras García <carlosfg@riseup.net>
---
 src/expr/data_reg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index a954e95..395e9f6 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -387,6 +387,7 @@ bool nftnl_data_reg_cmp(const union nftnl_data_reg *r1,
 		return	r1->len == r2->len &&
 			!memcmp(r1->val, r2->val, r1->len);
 	case DATA_VERDICT:
+		return	r1->verdict == r2->verdict;
 	case DATA_CHAIN:
 		return	r1->verdict == r2->verdict &&
 			!strcmp(r1->chain, r2->chain);
-- 
2.9.3

