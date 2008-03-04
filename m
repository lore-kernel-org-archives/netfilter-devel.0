From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 03/24] Correct the family member value of libxt_mark revision
 1
Date: Tue, 4 Mar 2008 16:53:15 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803041652560.7660@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0803040519150.7660@fbirervta.pbzchgretzou.qr>
 <47CD6296.90303@trash.net> <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53729 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757440AbYCDPxQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2008 10:53:16 -0500
In-Reply-To: <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit f9dac58a3eda2c4c1783f670865ff64dabdb97b7
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Thu Feb 14 02:10:34 2008 +0100

    Correct the family member value of libxt_mark revision 1
    
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
