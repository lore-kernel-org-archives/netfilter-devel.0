From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/3] xtoptions: simplify xtables_parse_interface
Date: Thu,  1 Sep 2011 11:15:50 +0200
Message-ID: <1314868551-4281-4-git-send-email-jengelh@medozas.de>
References: <1314868551-4281-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:54863 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756587Ab1IAJP4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Sep 2011 05:15:56 -0400
In-Reply-To: <1314868551-4281-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Richard Weinberger <richard@nod.at>

mask is already filled with zeros, there is no need to zero it again.

References: http://marc.info/?l=netfilter-devel&m=131445196526269&w=2
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
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
1.7.3.4

