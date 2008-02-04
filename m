From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [NETFILTER]: xt_iprange: add missing #include
Date: Mon, 4 Feb 2008 21:51:45 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802042150520.16441@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:44539 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756574AbYBDUvq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Feb 2008 15:51:46 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit dc8a57c343a3d26b75b02968572fb05f0e579424
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Mon Feb 4 20:54:44 2008 +0100

    [NETFILTER]: xt_iprange: add missing #include
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

diff --git a/net/netfilter/xt_iprange.c b/net/netfilter/xt_iprange.c
index 624eeda..f5c21d4 100644
--- a/net/netfilter/xt_iprange.c
+++ b/net/netfilter/xt_iprange.c
@@ -13,6 +13,7 @@
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 #include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_iprange.h>
 #include <linux/netfilter_ipv4/ipt_iprange.h>
 
 static bool

