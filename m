From: Richard Weinberger <richard@nod.at>
Subject: [PATCH] iptables: Simplify xtables_parse_interface()
Date: Sat, 27 Aug 2011 15:32:31 +0200
Message-ID: <1314451951-27722-1-git-send-email-richard@nod.at>
Cc: Richard Weinberger <richard@nod.at>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a.ns.miles-group.at ([95.130.255.143]:36343 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610Ab1H0Nco (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 27 Aug 2011 09:32:44 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

mask is already filled with zeros, there is no need to zero it again.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 iptables/xtables.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/iptables/xtables.c b/iptables/xtables.c
index 233efa3..e72aa28 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -515,15 +515,13 @@ void xtables_parse_interface(const char *arg, char *vianame,
 
 	strcpy(vianame, arg);
 	if (vialen == 0)
-		memset(mask, 0, IFNAMSIZ);
+		return;
 	else if (vianame[vialen - 1] == '+') {
 		memset(mask, 0xFF, vialen - 1);
-		memset(mask + vialen - 1, 0, IFNAMSIZ - vialen + 1);
 		/* Don't remove `+' here! -HW */
 	} else {
 		/* Include nul-terminator in match */
 		memset(mask, 0xFF, vialen + 1);
-		memset(mask + vialen + 1, 0, IFNAMSIZ - vialen - 1);
 		for (i = 0; vianame[i]; i++) {
 			if (vianame[i] == '/' ||
 			    vianame[i] == ' ') {
-- 
1.7.6.1

