From: Peter Volkov <pva@gentoo.org>
Subject: [patch] iptables-1.4.11.1: Fix man page generation
Date: Thu, 16 Jun 2011 15:20:16 +0400
Message-ID: <1308223216.9715.2.camel@tablet>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-5yPWRo/V6S8IZgsrXr/r"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:44528 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958Ab1FPL6i (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jun 2011 07:58:38 -0400
Received: from [192.168.1.6] (ppp85-141-172-27.pppoe.mtu-net.ru [85.141.172.27])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: pva)
	by smtp.gentoo.org (Postfix) with ESMTPSA id 2BCB81B4001
	for <netfilter-devel@vger.kernel.org>; Thu, 16 Jun 2011 11:58:36 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-5yPWRo/V6S8IZgsrXr/r
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi! Generated iptables and ip6tables man pages miss extensions
documentation. This patch aims to fix that. Please apply.

With best regards,
--
Peter.

--=-5yPWRo/V6S8IZgsrXr/r
Content-Disposition: attachment; filename*0=0001-Fix-manpage-generation-add-extensions-documentation.patc; filename*1=h
Content-Type: text/x-patch; name="0001-Fix-manpage-generation-add-extensions-documentation.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 2ca070d86813d143a004e41f5e37d0146372a573 Mon Sep 17 00:00:00 2001
From: Peter Volkov <pva@gentoo.org>
Date: Thu, 16 Jun 2011 15:09:21 +0400
Subject: [PATCH] Fix manpage generation add extensions documentation

Due to typo generated ip{,6}tables manpages do not include documentation
from extensions directory. Fix this.
---
 iptables/Makefile.am |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index 13cca9c..a068278 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -51,10 +51,10 @@ v6_sbin_links  = ip6tables ip6tables-restore ip6tables-save
 endif
 
 iptables.8: ${srcdir}/iptables.8.in ../extensions/matches4.man ../extensions/targets4.man
-	${AM_VERBOSE_GEN} sed -e 's/@PACKAGE_AND_VERSION@/${PACKAGE} ${PACKAGE_VERSION}/g' -e '/@MATCH@/ r extensions/matches4.man' -e '/@TARGET@/ r extensions/targets4.man' $< >$@;
+	${AM_VERBOSE_GEN} sed -e 's/@PACKAGE_AND_VERSION@/${PACKAGE} ${PACKAGE_VERSION}/g' -e '/@MATCH@/ r ../extensions/matches4.man' -e '/@TARGET@/ r ../extensions/targets4.man' $< >$@;
 
 ip6tables.8: ${srcdir}/ip6tables.8.in ../extensions/matches6.man ../extensions/targets6.man
-	${AM_VERBOSE_GEN} sed -e 's/@PACKAGE_AND_VERSION@/${PACKAGE} ${PACKAGE_VERSION}/g' -e '/@MATCH@/ r extensions/matches6.man' -e '/@TARGET@/ r extensions/targets6.man' $< >$@;
+	${AM_VERBOSE_GEN} sed -e 's/@PACKAGE_AND_VERSION@/${PACKAGE} ${PACKAGE_VERSION}/g' -e '/@MATCH@/ r ../extensions/matches6.man' -e '/@TARGET@/ r ../extensions/targets6.man' $< >$@;
 
 pkgconfig_DATA = xtables.pc
 
-- 
1.7.3.4


--=-5yPWRo/V6S8IZgsrXr/r--

