From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: [PATCH ipset] Add bash completion to the install routine.
Date: Thu, 25 Feb 2016 16:01:40 +0100
Message-ID: <1456412500-4534-1-git-send-email-mart.frauenlob@chello.at>
Cc: kadlec@blackhole.kfki.hu
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vie01a-qmta-at02-2.mx.upcmail.net ([62.179.121.176]:30193 "EHLO
	vie01a-qmta-at02-2.mx.upcmail.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760613AbcBYPVX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Feb 2016 10:21:23 -0500
Received: from [172.31.218.22] (helo=vie01a-dmta-at01-1.mx.upcmail.net)
	by vie01a-pqmta-at02.mx.upcmail.net with esmtps (UNKNOWN:AES256-GCM-SHA384:256)
	(Exim 4.72)
	(envelope-from <mart.frauenlob@chello.at>)
	id 1aYxQp-0007Ox-HH
	for netfilter-devel@vger.kernel.org; Thu, 25 Feb 2016 16:02:19 +0100
Received: from [172.31.216.43] (helo=vie01a-pemc-psmtp-pe01)
	by vie01a-dmta-at01.mx.upcmail.net with esmtp (Exim 4.72)
	(envelope-from <mart.frauenlob@chello.at>)
	id 1aYxQm-0003rY-NE
	for netfilter-devel@vger.kernel.org; Thu, 25 Feb 2016 16:02:16 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add the configure option --enable-bashcompl (default disabled).
The PKG_CHECK_VAR requires pkg-config 0.28 or greater.

Signed-off-by: Mart Frauenlob <mart.frauenlob@chello.at>
---
 Makefile.am       |    2 +-
 configure.ac      |   16 +++++++++++++++-
 utils/Makefile.am |    4 ++++
 3 files changed, 20 insertions(+), 2 deletions(-)
 create mode 100644 utils/Makefile.am

diff --git a/Makefile.am b/Makefile.am
index a3f31dd..684ebee 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -15,7 +15,7 @@ else
 IP_SET_MAX=$(MAXSETS)
 endif
 
-SUBDIRS		= include/libipset lib src
+SUBDIRS		= include/libipset lib src utils
 
 sparse:
 	$(MAKE) -C lib sparse-check
diff --git a/configure.ac b/configure.ac
index 6627ee7..a74bb0f 100644
--- a/configure.ac
+++ b/configure.ac
@@ -39,6 +39,17 @@ AC_ARG_WITH([ksource],
 AM_CONDITIONAL(WITH_KBUILDDIR, test "$KBUILDDIR" != "")
 AC_SUBST(KBUILDDIR)
 
+dnl ipset bash compspec - bash shell programmable completion
+AC_ARG_ENABLE([bashcompl],
+	AS_HELP_STRING([--enable-bashcompl],
+	[Install bash completion for ipset]),
+	[enable_bashcompl="$enableval"], [enable_bashcompl="no"])
+
+if test "x$enable_bashcompl" = "xyes"; then
+	PKG_CHECK_VAR(bashcompdir, [bash-completion], [completionsdir], , bashcompdir="${sysconfdir}/bash_completion.d")
+	AC_SUBST(bashcompdir)
+fi
+
 if test "$BUILDKMOD" == "yes"
 then
 dnl Sigh: check kernel version dependencies
@@ -480,13 +491,16 @@ dnl Checks for library functions.
 
 dnl Generate output
 AC_CONFIG_FILES([Makefile include/libipset/Makefile
-	lib/Makefile lib/libipset.pc src/Makefile
+	lib/Makefile lib/libipset.pc src/Makefile utils/Makefile
 	kernel/include/linux/netfilter/ipset/ip_set_compat.h])
 AC_OUTPUT
 
 dnl Summary
 AC_MSG_RESULT([])
 AC_MSG_RESULT([$PACKAGE userspace tool configuration:])
+if test "x$bashcompdir" != "x"; then
+	AC_MSG_RESULT([    Bash completion directory: ${bashcompdir}])
+fi
 if test "x$enable_settype_modules" != "xyes"; then
 	AC_MSG_RESULT([    Dynamic module loading: disabled])
 else
diff --git a/utils/Makefile.am b/utils/Makefile.am
new file mode 100644
index 0000000..40128d3
--- /dev/null
+++ b/utils/Makefile.am
@@ -0,0 +1,4 @@
+include $(top_srcdir)/Make_global.am
+
+bashcompdir = @bashcompdir@
+dist_bashcomp_DATA = ipset_bash_completion/ipset
-- 
1.7.2.5

