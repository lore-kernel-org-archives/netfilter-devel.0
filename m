From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/2] build: use AM_CPPFLAGS
Date: Fri, 31 Dec 2010 00:43:25 +0100
Message-ID: <1293752607-13822-2-git-send-email-jengelh@medozas.de>
References: <1293752607-13822-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:43845 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390Ab0L3Xna (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Dec 2010 18:43:30 -0500
In-Reply-To: <1293752607-13822-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Make_global.am |    2 +-
 configure.ac   |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/Make_global.am b/Make_global.am
index 7049189..1c9ed63 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -20,5 +20,5 @@
 #
 LIBVERSION=0:1:0
 
-AM_CPPFLAGS = -I$(top_srcdir)/include
+AM_CPPFLAGS = ${regular_CPPFLAGS} -I${top_srcdir}/include
 AM_CFLAGS = ${regular_CFLAGS} ${GCC_FVISIBILITY_HIDDEN}
diff --git a/configure.ac b/configure.ac
index 264242a..819cbf7 100644
--- a/configure.ac
+++ b/configure.ac
@@ -17,10 +17,11 @@ case $target in
 *) AC_MSG_ERROR([Linux only, dude!]);;
 esac
 
-regular_CFLAGS="-D_FILE_OFFSET_BITS=64 \
-	-D_REENTRANT -Wall -Waggregate-return -Wmissing-declarations \
+regular_CPPFLAGS="-D_FILE_OFFSET_BITS=64 -D_REENTRANT"
+regular_CFLAGS="-Wall -Waggregate-return -Wmissing-declarations \
 	-Wmissing-prototypes -Wredundant-decls -Wshadow -Wstrict-prototypes \
 	-Wformat=2 -pipe"
+AC_SUBST([regular_CPPFLAGS])
 AC_SUBST([regular_CFLAGS])
 AC_CONFIG_FILES([Makefile src/Makefile include/Makefile include/libmnl/Makefile include/linux/Makefile examples/Makefile examples/genl/Makefile examples/netfilter/Makefile examples/rtnl/Makefile libmnl.pc doxygen.cfg])
 AC_OUTPUT
-- 
1.7.1

