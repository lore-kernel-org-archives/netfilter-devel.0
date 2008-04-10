From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 01/13] Correct the family member value of libxt_mark revision 1
Date: Thu, 10 Apr 2008 09:38:06 +0200
Message-ID: <f8e3139e003f45acd60f10a40644de0ad1eefaec.1207813085.git.jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50168 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649AbYDJHiT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Apr 2008 03:38:19 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

libxt_mark rev1 used AF_INET6 in the class structure where it should
have used AF_INET.
---
 extensions/libxt_mark.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/extensions/libxt_mark.c b/extensions/libxt_mark.c
index af7f844..a2c9baf 100644
--- a/extensions/libxt_mark.c
+++ b/extensions/libxt_mark.c
@@ -197,7 +197,7 @@ static struct xtables_match mark_mt6_reg = {
 	.version        = IPTABLES_VERSION,
 	.name           = "mark",
 	.revision       = 1,
-	.family         = AF_INET6,
+	.family         = AF_INET,
 	.size           = XT_ALIGN(sizeof(struct xt_mark_mtinfo1)),
 	.userspacesize  = XT_ALIGN(sizeof(struct xt_mark_mtinfo1)),
 	.help           = mark_mt_help,
-- 
1.5.5.rc3

