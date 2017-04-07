From: James Cowgill <James.Cowgill@imgtec.com>
Subject: [PATCH iptables] extensions: libxt_hashlimit: fix 64-bit printf formats
Date: Fri, 7 Apr 2017 12:47:29 +0100
Message-ID: <1491565649-16679-1-git-send-email-James.Cowgill@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: James Cowgill <James.Cowgill@imgtec.com>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:41593 "EHLO
        mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753654AbdDGLrm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Apr 2017 07:47:42 -0400
Received: from HHMAIL01.hh.imgtec.org (unknown [10.100.10.19])
        by Forcepoint Email with ESMTPS id 758F7A36A7E95
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Apr 2017 12:47:37 +0100 (IST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

hashlimit was using "%lu" in a lot of printf format specifiers to print
64-bit integers. This is incorrect on 32-bit architectures because
"long int" is 32-bits there. On MIPS, it was causing iptables to
segfault when printing these integers.

Fix by using the correct format specifier.

Signed-off-by: James Cowgill <James.Cowgill@imgtec.com>
---
 extensions/libxt_hashlimit.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
index 52fc4fa..63cf903 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -12,9 +12,9 @@
  */
 #define _BSD_SOURCE 1
 #define _ISOC99_SOURCE 1
+#include <inttypes.h>
 #include <math.h>
 #include <stdbool.h>
-#include <stdint.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -262,7 +262,7 @@ static uint64_t parse_burst(const char *burst, int revision)
 	if (v > max)
 		xtables_error(PARAMETER_PROBLEM, "bad value for option "
 			"\"--hashlimit-burst\", value \"%s\" too large "
-				"(max %lumb).", burst, max/1024/1024);
+				"(max %" PRIu64 "mb).", burst, max/1024/1024);
 	return v;
 }
 
@@ -285,8 +285,8 @@ static bool parse_bytes(const char *rate, void *val, struct hashlimit_mt_udata *
 	tmp = (uint64_t) r * factor;
 	if (tmp > max)
 		xtables_error(PARAMETER_PROBLEM,
-			"Rate value too large \"%llu\" (max %lu)\n",
-					(unsigned long long)tmp, max);
+			"Rate value too large \"%" PRIu64 "\" (max %" PRIu64 ")\n",
+					tmp, max);
 
 	tmp = bytes_to_cost(tmp);
 	if (tmp == 0)
@@ -557,7 +557,7 @@ static void hashlimit_mt_check_v1(struct xt_fcheck_call *cb)
 		if (cb->xflags & F_BURST) {
 			if (info->cfg.burst < cost_to_bytes(info->cfg.avg))
 				xtables_error(PARAMETER_PROBLEM,
-					"burst cannot be smaller than %lub", cost_to_bytes(info->cfg.avg));
+					"burst cannot be smaller than %" PRIu64 "b", cost_to_bytes(info->cfg.avg));
 
 			burst = info->cfg.burst;
 			burst /= cost_to_bytes(info->cfg.avg);
@@ -587,7 +587,7 @@ static void hashlimit_mt_check(struct xt_fcheck_call *cb)
 		if (cb->xflags & F_BURST) {
 			if (info->cfg.burst < cost_to_bytes(info->cfg.avg))
 				xtables_error(PARAMETER_PROBLEM,
-					"burst cannot be smaller than %lub", cost_to_bytes(info->cfg.avg));
+					"burst cannot be smaller than %" PRIu64 "b", cost_to_bytes(info->cfg.avg));
 
 			burst = info->cfg.burst;
 			burst /= cost_to_bytes(info->cfg.avg);
@@ -631,7 +631,7 @@ static uint32_t print_rate(uint32_t period, int revision)
             || _rates[i].mult/period < _rates[i].mult%period)
 			break;
 
-	printf(" %lu/%s", _rates[i-1].mult / period, _rates[i-1].name);
+	printf(" %" PRIu64 "/%s", _rates[i-1].mult / period, _rates[i-1].name);
 	/* return in msec */
 	return _rates[i-1].mult / scale * 1000;
 }
-- 
2.11.0

