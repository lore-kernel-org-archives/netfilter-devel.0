From: Jiri Moravec <jim.lkml@gmail.com>
Subject: Xtables-addons 1.14 - DHCPMAC help
Date: Fri, 03 Apr 2009 03:14:00 +0200
Message-ID: <gr3ntd$uu6$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:52950 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356AbZDCBOf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Apr 2009 21:14:35 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1LpXzM-0000Ev-CS
	for netfilter-devel@vger.kernel.org; Fri, 03 Apr 2009 01:14:32 +0000
Received: from 78.156.136.66 ([78.156.136.66])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Fri, 03 Apr 2009 01:14:32 +0000
Received: from jim.lkml by 78.156.136.66 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Fri, 03 Apr 2009 01:14:32 +0000
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Another problem with DHCPMAC:

diff -Nupr 1.14-r1/extensions/libxt_DHCPMAC.c 1.14-r2/extensions/libxt_DHCPMAC.c
--- 1.14-r1/extensions/libxt_DHCPMAC.c	2009-04-03 03:04:57.000000000 +0200
+++ 1.14-r2/extensions/libxt_DHCPMAC.c	2009-04-03 03:05:13.000000000 +0200
@@ -30,7 +30,7 @@ static const struct option dhcpmac_tg_op
 static void dhcpmac_tg_help(void)
 {
 	printf(
-"DHCPADDDR target options:\n"
+"DHCPMAC target options:\n"
 "  --set-mac lladdr[/mask]    Set MAC address in DHCP Client Host field\n"
 	);
 }

