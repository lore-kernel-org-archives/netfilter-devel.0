From: Jan Engelhardt <jengelh@medozas.de>
Subject: doc: put iptables version into manpage
Date: Thu, 8 Jan 2009 13:50:00 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901081349500.17175@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38171 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489AbZAHMuC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Jan 2009 07:50:02 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

parent f19f52defad1145b062528db75eab6db43be7446
commit e994c6afd02cf70fc85256bb143df496e24effc3
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Thu Jan 8 13:49:36 2009 +0100

doc: put iptables version into manpage

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am    |    4 ++--
 ip6tables.8.in |    2 +-
 iptables.8.in  |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index ced23b3..fd4d93f 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -89,10 +89,10 @@ sbin_PROGRAMS += iptables iptables-multi iptables-restore iptables-save \
 endif
 
 iptables.8: ${srcdir}/iptables.8.in extensions/matches4.man extensions/targets4.man
-	${AM_VERBOSE_GEN} sed -e '/@MATCH@/ r extensions/matches4.man' -e '/@TARGET@/ r extensions/targets4.man' $< >$@;
+	${AM_VERBOSE_GEN} sed -e 's/@PACKAGE_AND_VERSION@/${PACKAGE} ${PACKAGE_VERSION}/g' -e '/@MATCH@/ r extensions/matches4.man' -e '/@TARGET@/ r extensions/targets4.man' $< >$@;
 
 ip6tables.8: ${srcdir}/ip6tables.8.in extensions/matches6.man extensions/targets6.man
-	${AM_VERBOSE_GEN} sed -e '/@MATCH@/ r extensions/matches6.man' -e '/@TARGET@/ r extensions/targets6.man' $< >$@;
+	${AM_VERBOSE_GEN} sed -e 's/@PACKAGE_AND_VERSION@/${PACKAGE} ${PACKAGE_VERSION}/g' -e '/@MATCH@/ r extensions/matches6.man' -e '/@TARGET@/ r extensions/targets6.man' $< >$@;
 
 extensions/%:
 	${MAKE} ${AM_MAKEFLAGS} -C $(@D) $(@F)
diff --git a/ip6tables.8.in b/ip6tables.8.in
index 669a961..3b473bf 100644
--- a/ip6tables.8.in
+++ b/ip6tables.8.in
@@ -1,4 +1,4 @@
-.TH IP6TABLES 8 "Jul 03, 2008" "" ""
+.TH IP6TABLES 8 "" "@PACKAGE_AND_VERSION@" "@PACKAGE_AND_VERSION@"
 .\"
 .\" Man page written by Andras Kis-Szabo <kisza@sch.bme.hu>
 .\" It is based on iptables man page.
diff --git a/iptables.8.in b/iptables.8.in
index 9947da4..b9d6383 100644
--- a/iptables.8.in
+++ b/iptables.8.in
@@ -1,4 +1,4 @@
-.TH IPTABLES 8 "Jul 03, 2008" "" ""
+.TH IPTABLES 8 "" "@PACKAGE_AND_VERSION@" "@PACKAGE_AND_VERSION@"
 .\"
 .\" Man page written by Herve Eychenne <rv@wallfire.org> (May 1999)
 .\" It is based on ipchains page.

