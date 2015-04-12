From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 02/10] datatype: less strict time parsing
Date: Sun, 12 Apr 2015 13:16:10 +0100
Message-ID: <1428840978-27226-3-git-send-email-kaber@trash.net>
References: <1428840978-27226-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58907 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbbDLMQX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 Apr 2015 08:16:23 -0400
In-Reply-To: <1428840978-27226-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Don't require hours to be in range 0-23 and minutes/seconds in range 0-59.
The time_type is used for relative times where it is entirely reasonable
to specify 180s instead of 3m.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/datatype.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index 0772b50..1c83715 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -831,10 +831,6 @@ static struct error_record *time_type_parse(const struct expr *sym,
 			}
 			h = str2int(tmp, c, k);
 			k = 0;
-			if (h > 23) {
-				return error(&sym->location,
-					     "Hour needs to be 0-23");
-			}
 			mask |= HOUR;
 			break;
 		case 'm':
@@ -844,10 +840,6 @@ static struct error_record *time_type_parse(const struct expr *sym,
 			}
 			m = str2int(tmp, c, k);
 			k = 0;
-			if (m > 59) {
-				return error(&sym->location,
-					     "Minute needs to be 0-59");
-			}
 			mask |= MIN;
 			break;
 		case 's':
@@ -857,10 +849,6 @@ static struct error_record *time_type_parse(const struct expr *sym,
 			}
 			s = str2int(tmp, c, k);
 			k = 0;
-			if (s > 59) {
-				return error(&sym->location,
-					     "second needs to be 0-59");
-			}
 			mask |= SECS;
 			break;
 		default:
-- 
2.1.0

