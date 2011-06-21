From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/7] doc: include matches/targets in manpage again
Date: Tue, 21 Jun 2011 17:53:28 +0200
Message-ID: <1308671615-17505-2-git-send-email-jengelh@medozas.de>
References: <1308671615-17505-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:40640 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756743Ab1FUPxi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jun 2011 11:53:38 -0400
In-Reply-To: <1308671615-17505-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Evil sed did not throw any warning whatsoever when it cannot find the
file.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
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

