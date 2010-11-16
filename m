From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/6] build: add some more precautionary CFLAGS
Date: Tue, 16 Nov 2010 12:43:32 +0100
Message-ID: <1289907814-32706-6-git-send-email-jengelh@medozas.de>
References: <1289907814-32706-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:47736 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933598Ab0KPLnl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Nov 2010 06:43:41 -0500
In-Reply-To: <1289907814-32706-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Make_global.am |    2 +-
 configure.ac   |    5 +++++
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/Make_global.am b/Make_global.am
index a86e3e9..62d0d46 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -21,4 +21,4 @@
 LIBVERSION=0:0:0
 
 AM_CPPFLAGS = -I$(top_srcdir)/include
-AM_CFLAGS = -Wall -Wextra -Wno-unused-parameter ${GCC_FVISIBILITY_HIDDEN}
+AM_CFLAGS = ${regular_CFLAGS} ${GCC_FVISIBILITY_HIDDEN}
diff --git a/configure.ac b/configure.ac
index 74efa45..6443581 100644
--- a/configure.ac
+++ b/configure.ac
@@ -17,5 +17,10 @@ case $target in
 *) AC_MSG_ERROR([Linux only, dude!]);;
 esac
 
+regular_CFLAGS="-D_FILE_OFFSET_BITS=64 \
+	-D_REENTRANT -Wall -Waggregate-return -Wmissing-declarations \
+	-Wmissing-prototypes -Wredundant-decls -Wshadow -Wstrict-prototypes \
+	-Wformat=2 -pipe"
+AC_SUBST([regular_CFLAGS])
 AC_CONFIG_FILES([Makefile src/Makefile include/Makefile include/libmnl/Makefile examples/Makefile examples/genl/Makefile examples/netfilter/Makefile examples/rtnl/Makefile libmnl.pc doxygen.cfg])
 AC_OUTPUT
-- 
1.7.1

