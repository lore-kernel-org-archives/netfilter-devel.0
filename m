From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 3/5][IPTABLES]: Build adjustments
Date: Thu, 24 Jan 2008 20:02:31 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801242002000.12676@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801242000350.12676@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:42591 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbYAXTCc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jan 2008 14:02:32 -0500
In-Reply-To: <Pine.LNX.4.64.0801242000350.12676@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

A few build system changes.
	* ip6tables needs IP6T_LIB_DIR
	* correctly trigger rebuild of master manpages when
	  submanpages have been touched

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de.

---
 configure.ac              |    2 +-
 extensions/GNUmakefile.in |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

Index: iptables/configure.ac
===================================================================
--- iptables.orig/configure.ac
+++ iptables/configure.ac
@@ -40,7 +40,7 @@ regular_CFLAGS="-D_LARGEFILE_SOURCE=1 -D
 	-D_REENTRANT -Wall -Waggregate-return -Wmissing-declarations \
 	-Wmissing-prototypes -Wredundant-decls -Wshadow -Wstrict-prototypes \
 	-Winline -pipe -DIPTABLES_VERSION=\\\"$PACKAGE_VERSION\\\" \
-	-DIPT_LIB_DIR=\\\"\${iptdir}\\\"";
+	-DIPT_LIB_DIR=\\\"\${iptdir}\\\" -DIP6T_LIB_DIR=\\\"\${iptdir}\\\"";
 kinclude_CFLAGS="-I\"$kbuilddir/include\" -I\"$ksourcedir/include\"";
 
 # Remove workarounds soon
Index: iptables/extensions/GNUmakefile.in
===================================================================
--- iptables.orig/extensions/GNUmakefile.in
+++ iptables/extensions/GNUmakefile.in
@@ -192,14 +192,14 @@ man_run    = \
 		fi; \
 	done >$@;
 
-matches4.man: .initext4.dd $(wildcard lib*.man)
+matches4.man: .initext4.dd $(wildcard ${srcdir}/lib*.man)
 	$(call man_run,$(call ex_matches,${pfx_build_mod} ${pf4_build_mod}))
 
-matches6.man: .initext6.dd $(wildcard lib*.man)
+matches6.man: .initext6.dd $(wildcard ${srcdir}/lib*.man)
 	$(call man_run,$(call ex_matches,${pfx_build_mod} ${pf6_build_mod}))
 
-targets4.man: .initext4.dd $(wildcard lib*.man)
+targets4.man: .initext4.dd $(wildcard ${srcdir}/lib*.man)
 	$(call man_run,$(call ex_targets,${pfx_build_mod} ${pf4_build_mod}))
 
-targets6.man: .initext6.dd $(wildcard lib*.man)
+targets6.man: .initext6.dd $(wildcard ${srcdir}/lib*.man)
 	$(call man_run,$(call ex_targets,${pfx_build_mod} ${pf6_build_mod}))
