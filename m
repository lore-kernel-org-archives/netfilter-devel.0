From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 06/13] No ipt in xt
Date: Thu, 4 Oct 2007 12:12:20 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710041209500.7253@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710041209210.7253@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58025 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201AbXJDKMV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Oct 2007 06:12:21 -0400
Received: from localhost (localhost [127.0.0.1])
	by sovereign.computergmbh.de (Postfix) with ESMTP id 5A39D1C0624CB
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Oct 2007 12:12:20 +0200 (CEST)
In-Reply-To: <Pine.LNX.4.64.0710041209210.7253@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Cease using ipt_entry_match (replaced by xt_entry_match).

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 extensions/libxt_connlimit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: iptables/extensions/libxt_connlimit.c
===================================================================
--- iptables.orig/extensions/libxt_connlimit.c
+++ iptables/extensions/libxt_connlimit.c
@@ -24,7 +24,7 @@ static const struct option connlimit_opt
 	{NULL},
 };
 
-static void connlimit_init(struct ipt_entry_match *match)
+static void connlimit_init(struct xt_entry_match *match)
 {
 	struct xt_connlimit_info *info = (void *)match->data;
 	info->v4_mask = 0xFFFFFFFFUL;
