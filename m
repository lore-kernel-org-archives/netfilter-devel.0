From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/2] build: remove statements without obvious effect
Date: Fri,  5 Nov 2010 19:30:43 +0100
Message-ID: <1288981844-22714-3-git-send-email-jengelh@medozas.de>
References: <1288981844-22714-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:33315 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902Ab0KESas (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Nov 2010 14:30:48 -0400
In-Reply-To: <1288981844-22714-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 Makefile.am  |    4 ----
 configure.ac |    1 -
 2 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 6d5b8dd..dec85d0 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -9,7 +9,3 @@ pkgconfigdir = $(libdir)/pkgconfig
 pkgconfig_DATA = libmnl.pc
 
 ${pkgconfig_DATA}: ${top_builddir}/config.status
-
-$(OBJECTS): libtool
-libtool: $(LIBTOOL_DEPS)
-	$(SHELL) ./config.status --recheck
diff --git a/configure.ac b/configure.ac
index ea1aa4b..9281156 100644
--- a/configure.ac
+++ b/configure.ac
@@ -10,7 +10,6 @@ AM_PROG_CC_C_O
 AC_EXEEXT
 AC_DISABLE_STATIC
 LT_INIT
-AC_SUBST(LIBTOOL_DEPS)
 
 case $target in 
 *-*-linux*) ;;
-- 
1.7.1

