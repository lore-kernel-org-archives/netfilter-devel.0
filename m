From: Jiri Moravec <jim.lkml@gmail.com>
Subject: Xtables-addons 1.14 - DHCPMAC.Kconfig problem
Date: Thu, 02 Apr 2009 22:58:47 +0200
Message-ID: <gr38uq$mud$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:55850 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755268AbZDBU70 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Apr 2009 16:59:26 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1LpU0O-0007yt-7o
	for netfilter-devel@vger.kernel.org; Thu, 02 Apr 2009 20:59:20 +0000
Received: from 78.156.136.66 ([78.156.136.66])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Apr 2009 20:59:20 +0000
Received: from jim.lkml by 78.156.136.66 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Apr 2009 20:59:20 +0000
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

DHCPMAC.Kconfig some way lost TARGET_ ...

diff -Nupr v1.14/extensions/xt_DHCPMAC.Kconfig v1.14-r1/extensions/xt_DHCPMAC.Kconfig
--- v1.14/extensions/xt_DHCPMAC.Kconfig	2009-04-02 22:44:11.000000000 +0200
+++ v1.14-r1/extensions/xt_DHCPMAC.Kconfig	2009-04-02 22:44:43.000000000 +0200
@@ -1,4 +1,4 @@
-config NETFILTER_XT_DHCPMAC
+config NETFILTER_XT_TARGET_DHCPMAC
 	tristate '"DHCPMAC" DHCP address matching and manipulation support'
 	depends on NETFILTER_XTABLES
 	depends on IP_NF_MANGLE || IP6_NF_MANGLE

