From: Kaarle Ritvanen <kaarle.ritvanen@datakunkku.fi>
Subject: [PATCH ipset] fix compilation with musl libc
Date: Sat, 16 Sep 2017 14:05:10 +0300
Message-ID: <20170916110510.2234-1-kaarle.ritvanen@datakunkku.fi>
Cc: Kaarle Ritvanen <kaarle.ritvanen@datakunkku.fi>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from welho-filter2.welho.com ([83.102.41.24]:48512 "EHLO
        welho-filter2.welho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751185AbdIPLO0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 16 Sep 2017 07:14:26 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Kaarle Ritvanen <kaarle.ritvanen@datakunkku.fi>
---
 src/ipset.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/ipset.c b/src/ipset.c
index 79f56b8..dffc74e 100644
--- a/src/ipset.c
+++ b/src/ipset.c
@@ -14,6 +14,7 @@
 #include <stdio.h>			/* fprintf, fgets */
 #include <stdlib.h>			/* exit */
 #include <string.h>			/* str* */
+#include <sys/types.h>			/* u_int8_t */
 
 #include <config.h>
 
-- 
2.9.5

