From: pablo@netfilter.org
Subject: [PATCH 2/2] extensions: libxt_addrtype: fix type in help message
Date: Fri,  7 Sep 2012 10:55:19 +0200
Message-ID: <1347008119-3835-2-git-send-email-pablo@netfilter.org>
References: <1347008119-3835-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50183 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066Ab2IGI43 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Sep 2012 04:56:29 -0400
In-Reply-To: <1347008119-3835-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

 --limit-iface-out          Match only on the packet's incoming device

Note that it says "incoming" when it should say "outcoming"

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 extensions/libxt_addrtype.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libxt_addrtype.c b/extensions/libxt_addrtype.c
index 59072b3..d57865b 100644
--- a/extensions/libxt_addrtype.c
+++ b/extensions/libxt_addrtype.c
@@ -60,7 +60,7 @@ static void addrtype_help_v1(void)
 " [!] --src-type type[,...]      Match source address type\n"
 " [!] --dst-type type[,...]      Match destination address type\n"
 "     --limit-iface-in           Match only on the packet's incoming device\n"
-"     --limit-iface-out          Match only on the packet's incoming device\n"
+"     --limit-iface-out          Match only on the packet's outcoming device\n"
 "\n"
 "Valid types:           \n");
 	addrtype_help_types();
-- 
1.7.10.4

