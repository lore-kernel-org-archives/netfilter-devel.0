From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 5/7] libxt_devgroup: guard against negative numbers
Date: Sat, 28 Jul 2012 19:21:07 +0200
Message-ID: <1343496069-5442-6-git-send-email-jengelh@inai.de>
References: <1343496069-5442-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:34337 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943Ab2G1RVQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 28 Jul 2012 13:21:16 -0400
In-Reply-To: <1343496069-5442-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

More corrections of the strtoul kind.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 extensions/libxt_devgroup.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/extensions/libxt_devgroup.c b/extensions/libxt_devgroup.c
index 69ae279..4a69c82 100644
--- a/extensions/libxt_devgroup.c
+++ b/extensions/libxt_devgroup.c
@@ -46,14 +46,16 @@ static void devgroup_parse_groupspec(const char *arg, unsigned int *group,
 				     unsigned int *mask)
 {
 	char *end;
+	bool ok;
 
-	*group = strtoul(arg, &end, 0);
-	if (end != arg && (*end == '/' || *end == '\0')) {
+	ok = xtables_strtoui(arg, &end, group, 0, UINT32_MAX);
+	if (ok && (*end == '/' || *end == '\0')) {
 		if (*end == '/')
-			*mask = strtoul(end + 1, &end, 0);
+			ok = xtables_strtoui(end + 1, NULL, mask,
+			                     0, UINT32_MAX);
 		else
 			*mask = ~0U;
-		if (*end != '\0' || end == arg)
+		if (!ok)
 			xtables_error(PARAMETER_PROBLEM,
 				      "Bad group value \"%s\"", arg);
 	} else {
-- 
1.7.7

