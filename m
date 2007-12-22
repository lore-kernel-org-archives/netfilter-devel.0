From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [NETFILTER] xt_helper match fixes
Date: Sat, 22 Dec 2007 03:39:41 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712220339130.8607@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55148 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbXLVCjm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Dec 2007 21:39:42 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


If the @helper variable is not used, what do we grab it for? Use it.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 net/netfilter/xt_helper.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6_nosov/net/netfilter/xt_helper.c
===================================================================
--- linux-2.6_nosov.orig/net/netfilter/xt_helper.c
+++ linux-2.6_nosov/net/netfilter/xt_helper.c
@@ -52,8 +52,8 @@ helper_mt(const struct sk_buff *skb, con
 	if (info->name[0] == '\0')
 		ret = !ret;
 	else
-		ret ^= !strncmp(master_help->helper->name, info->name,
-				strlen(master_help->helper->name));
+		ret ^= !strncmp(helper->name, info->name,
+				strlen(helper->name));
 	return ret;
 }
 

