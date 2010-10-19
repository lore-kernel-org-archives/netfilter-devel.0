From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/8] build: use libmnl's pkgconfig files
Date: Tue, 19 Oct 2010 18:12:17 +0200
Message-ID: <1287504742-12922-5-git-send-email-jengelh@medozas.de>
References: <1287504742-12922-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:53567 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755043Ab0JSQMb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Oct 2010 12:12:31 -0400
In-Reply-To: <1287504742-12922-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

libmnl installs .pc files that we can directly use and which are
preferable over AC_CHECK_LIB.

Also make sure that libipset.so is linked with libmnl, otherwise
linking errors can ensue when a program tries to link to libipset.

Furthermore, remove the now-unused LIBS variable.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac    |    5 +----
 lib/Makefile.am |    4 ++--
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/configure.ac b/configure.ac
index 906ef84..99129ea 100644
--- a/configure.ac
+++ b/configure.ac
@@ -109,10 +109,7 @@ AC_PROG_INSTALL
 AC_PROG_LN_S
 
 dnl Checks for libraries
-AC_CHECK_LIB([mnl], [mnl_socket_open])
-if test x"${ac_cv_lib_mnl_mnl_socket_open}" = xno; then
-  AC_MSG_ERROR(libmnl not found)
-fi
+PKG_CHECK_MODULES([libmnl], [libmnl >= 1])
 
 dnl Checks for header files
 
diff --git a/lib/Makefile.am b/lib/Makefile.am
index bf4e133..74f36e8 100644
--- a/lib/Makefile.am
+++ b/lib/Makefile.am
@@ -1,11 +1,11 @@
 include $(top_srcdir)/Make_global.am
 
-AM_CFLAGS += -fPIC
-LIBS =
+AM_CFLAGS += -fPIC ${libmnl_CFLAGS}
 
 lib_LTLIBRARIES = libipset.la
 
 libipset_la_LDFLAGS = -version-info $(LIBVERSION)
+libipset_la_LIBADD  = ${libmnl_LIBS}
 libipset_la_SOURCES = \
 	data.c \
 	mnl.c \
-- 
1.7.1

