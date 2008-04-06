From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 02/24] Correct the family member value of libxt_mark revision 1
Date: Sun,  6 Apr 2008 17:26:59 +0200
Message-ID: <e64620b8cc13342ae6d91ab532ba89f0bcbe8b32.1207495183.git.jengelh@computergmbh.de>
References: <1207495642-21055-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56465 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbYDFP1X (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Apr 2008 11:27:23 -0400
In-Reply-To: <1207495642-21055-1-git-send-email-jengelh@computergmbh.de>
In-Reply-To: <bd573e5e48763aa655cdb6e3f70a6f647c3868c7.1207495183.git.jengelh@computergmbh.de>
References: <bd573e5e48763aa655cdb6e3f70a6f647c3868c7.1207495183.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

libxt_mark rev1 used AF_INET6 in the class structure where it should
have used AF_INET.
---
 extensions/libxt_mark.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/extensions/libxt_mark.c b/extensions/libxt_mark.c
index 1dfcc58..af7f844 100644
--- a/extensions/libxt_mark.c
+++ b/extensions/libxt_mark.c
@@ -182,7 +182,7 @@ static struct xtables_match mark_mt_reg = {
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

