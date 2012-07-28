From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 3/7] libxt_u32: do bounds checking for @'s operands
Date: Sat, 28 Jul 2012 19:21:05 +0200
Message-ID: <1343496069-5442-4-git-send-email-jengelh@inai.de>
References: <1343496069-5442-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:34344 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954Ab2G1RVQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 28 Jul 2012 13:21:16 -0400
In-Reply-To: <1343496069-5442-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Using only strtoul is prone to accept all values, including negative
ones which are not explicitly allowed. Therefore, use xtables_strtoui
with bounds checking.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 extensions/libxt_u32.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/extensions/libxt_u32.c b/extensions/libxt_u32.c
index 6d024fb..2a7f5d8 100644
--- a/extensions/libxt_u32.c
+++ b/extensions/libxt_u32.c
@@ -88,17 +88,13 @@ static void u32_dump(const struct xt_u32 *data)
 /* string_to_number() is not quite what we need here ... */
 static uint32_t parse_number(const char **s, int pos)
 {
-	uint32_t number;
+	unsigned int number;
 	char *end;
 
-	errno  = 0;
-	number = strtoul(*s, &end, 0);
-	if (end == *s)
+	if (!xtables_strtoui(*s, &end, &number, 0, UINT32_MAX) ||
+	    end == *s)
 		xtables_error(PARAMETER_PROBLEM,
-			   "u32: at char %d: expected number", pos);
-	if (errno != 0)
-		xtables_error(PARAMETER_PROBLEM,
-			   "u32: at char %d: error reading number", pos);
+			"u32: at char %d: not a number or out of range", pos);
 	*s = end;
 	return number;
 }
-- 
1.7.7

