From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [RFC conntrackd PATCH] conntrackd: add basic systemd notification
 support
Date: Fri, 16 Oct 2015 14:10:00 +0200
Message-ID: <20151016120800.15632.42888.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:57941 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751868AbbJPMKK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Oct 2015 08:10:10 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a basic systemd notification support.

Most of distros (Debian, RHEL, Ubuntu, ArchLinux...) use systemd as
init system.
Notifiying systemd that conntrackd is now running has many
benefits, the main being users concatenating systemd services depending on
the main conntrackd daemon being started.

The systemd support means conntrackd will require libsystemd, so a
configure swith is added:

 % ./configure --disable-systemd

We can further integrate conntrackd with systemd:
 * add watchdog support
 * report daemon errors (f.e, errno codes)
 * tell systemd conntrackd PID
 * report about conntrackd Unix socket

I've tested this against systemd 227.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
NOTE: the sd_notify() wrapper can be done in several other ways, f.e:
      https://github.com/MariaDB/server/blob/10.1/include/my_systemd.h

 configure.ac      |   12 +++++++++++-
 include/systemd.h |   10 ++++++++++
 src/Makefile.am   |    8 ++++++++
 src/main.c        |    3 +++
 src/systemd.c     |   25 +++++++++++++++++++++++++
 5 files changed, 57 insertions(+), 1 deletion(-)
 create mode 100644 include/systemd.h
 create mode 100644 src/systemd.c

diff --git a/configure.ac b/configure.ac
index 70d3729..7c378b6 100644
--- a/configure.ac
+++ b/configure.ac
@@ -61,6 +61,9 @@ AC_ARG_ENABLE([cthelper],
 AC_ARG_ENABLE([cttimeout],
         AS_HELP_STRING([--disable-cttimeout], [Do not build timeout support]),
         [enable_cttimeout="no"], [enable_cttimeout="yes"])
+AC_ARG_ENABLE([systemd],
+	AS_HELP_STRING([--disable-systemd], [Do not build systemd support]),
+	[enable_systemd="no"], [enable_systemd="yes"])
 
 PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >= 1.0.1])
 PKG_CHECK_MODULES([LIBMNL], [libmnl >= 1.0.3])
@@ -77,6 +80,12 @@ AS_IF([test "x$enable_cthelper" = "xyes"], [
 ])
 AM_CONDITIONAL([HAVE_CTHELPER], [test "x$enable_cthelper" = "xyes"])
 
+AS_IF([test "x$enable_systemd" = "xyes"], [
+	PKG_CHECK_MODULES([LIBSYSTEMD], [libsystemd >= 227])
+	AC_DEFINE([BUILD_SYSTEMD], [1], [Building systemd support])
+])
+AM_CONDITIONAL([HAVE_SYSTEMD], [test "x$enable_systemd" = "xyes"])
+
 AC_CHECK_HEADERS([linux/capability.h],, [AC_MSG_ERROR([Cannot find linux/capabibility.h])])
 
 # Checks for libraries.
@@ -146,4 +155,5 @@ AC_OUTPUT
 echo "
 conntrack-tools configuration:
   userspace conntrack helper support:	${enable_cthelper}
-  conntrack timeout support:		${enable_cttimeout}"
+  conntrack timeout support:		${enable_cttimeout}
+  systemd support:			${enable_systemd}"
diff --git a/include/systemd.h b/include/systemd.h
new file mode 100644
index 0000000..6e10b14
--- /dev/null
+++ b/include/systemd.h
@@ -0,0 +1,10 @@
+#ifndef _INCLUDE_SYSTEMD_H_
+#define _INCLUDE_SYSTEMD_H_
+
+void sd_ct_init(void);
+
+#ifndef BUILD_SYSTEMD
+void sd_ct_init(void){};
+#endif /* BUILD_SYSTEMD */
+
+#endif /* _INCLUDE_SYSTEMD_H_ */
diff --git a/src/Makefile.am b/src/Makefile.am
index a1d00f8..607f191 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -58,6 +58,10 @@ if HAVE_CTHELPER
 conntrackd_SOURCES += cthelper.c helpers.c utils.c expect.c
 endif
 
+if HAVE_SYSTEMD
+conntrackd_SOURCES += systemd.c
+endif
+
 # yacc and lex generate dirty code
 read_config_yy.o read_config_lex.o: AM_CFLAGS += -Wno-missing-prototypes -Wno-missing-declarations -Wno-implicit-function-declaration -Wno-nested-externs -Wno-undef -Wno-redundant-decls
 
@@ -68,6 +72,10 @@ if HAVE_CTHELPER
 conntrackd_LDADD += ${LIBNETFILTER_CTHELPER_LIBS} ${LIBNETFILTER_QUEUE_LIBS}
 endif
 
+if HAVE_SYSTEMD
+conntrackd_LDADD += ${LIBSYSTEMD_LIBS}
+endif
+
 conntrackd_LDFLAGS = -export-dynamic
 
 EXTRA_DIST = read_config_yy.h
diff --git a/src/main.c b/src/main.c
index dafeaee..9413db2 100644
--- a/src/main.c
+++ b/src/main.c
@@ -20,6 +20,7 @@
 #include "conntrackd.h"
 #include "log.h"
 #include "helper.h"
+#include "systemd.h"
 
 #include <sys/types.h>
 #include <sys/stat.h>
@@ -422,6 +423,8 @@ int main(int argc, char *argv[])
 	} else
 		dlog(LOG_NOTICE, "-- starting in console mode --");
 
+	sd_ct_init();
+
 	/*
 	 * run main process
 	 */
diff --git a/src/systemd.c b/src/systemd.c
new file mode 100644
index 0000000..3210b9f
--- /dev/null
+++ b/src/systemd.c
@@ -0,0 +1,25 @@
+/*
+ * (C) 2015 by Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include "systemd.h"
+#include <systemd/sd-daemon.h>
+
+void sd_ct_init(void)
+{
+	sd_notify(0, "READY=1");
+}

