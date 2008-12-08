From: Jan Engelhardt <jengelh@medozas.de>
Subject: libxt_rateest: fix segfault
Date: Mon, 8 Dec 2008 18:24:11 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0812081818050.2016@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36201 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487AbYLHRYM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Dec 2008 12:24:12 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 48c13b071a7f37ea57f93312c2547d5512b78f3e
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Mon Dec 8 18:23:12 2008 +0100

libxt_rateest: fix segfault

When running `ip6tables -m rateest` without any other arguments,
rateest did segfault.
---
 extensions/libxt_rateest.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/extensions/libxt_rateest.c b/extensions/libxt_rateest.c
index ebea437..f0dd577 100644
--- a/extensions/libxt_rateest.c
+++ b/extensions/libxt_rateest.c
@@ -306,7 +306,7 @@ rateest_final_check(unsigned int flags)
 {
 	struct xt_rateest_match_info *info = rateest_info;
 
-	if (!(info->flags & XT_RATEEST_MATCH_REL))
+	if (info != NULL && !(info->flags & XT_RATEEST_MATCH_REL))
 		info->flags |= XT_RATEEST_MATCH_ABS;
 }
 
