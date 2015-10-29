From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [conntrackd PATCH 2/2] conntrackd: add systemd support
Date: Thu, 29 Oct 2015 15:25:45 +0100
Message-ID: <144612874551.2345.9279304326772060336.stgit@r2d2.cica.es>
References: <144612873979.2345.143124768646944099.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: jengelh@inai.de, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:44459 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757182AbbJ2OZw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Oct 2015 10:25:52 -0400
In-Reply-To: <144612873979.2345.143124768646944099.stgit@r2d2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds basic systemd support.

The feature can be enabled/disabled at configure time:
 ./configure --disable-systemd

(by default it's enabled)

* tell systemd about conntrackd readiness:

When conntrackd starts, it will send systemd the data "READY=1".
At the point the data is sent, conntrackd is fully ready to work
(configuration was OK, sockets OK, et all), so other actions depending
on conntrackd can be safely chained in the machine boot process.

* tell systemd about conntrackd shutting down:

If the admin kills conntrackd with `conntrackd -k', the data "STOPPING=1"
will be send to systemd so it learns about the daemon shutting down. Same
for manual signals.

* watchdog support:

The admin can configure systemd to watch the conntrackd daemon and perform
some actions if conntrackd dies: restart it, reboot the machine, etc...

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 configure.ac        |   12 +++++++++-
 include/Makefile.am |    2 +-
 include/systemd.h   |   18 +++++++++++++++
 src/Makefile.am     |    8 +++++++
 src/main.c          |    9 +++++++-
 src/run.c           |    2 ++
 src/systemd.c       |   61 +++++++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 109 insertions(+), 3 deletions(-)
 create mode 100644 include/systemd.h
 create mode 100644 src/systemd.c

diff --git a/configure.ac b/configure.ac
index f326f96..14beb53 100644
--- a/configure.ac
+++ b/configure.ac
@@ -61,6 +61,9 @@ AC_ARG_ENABLE([cthelper],
 AC_ARG_ENABLE([cttimeout],
         AS_HELP_STRING([--disable-cttimeout], [Do not build timeout support]),
         [enable_cttimeout="$enableval"], [enable_cttimeout="yes"])
+AC_ARG_ENABLE([systemd],
+        AS_HELP_STRING([--disable-systemd], [Do not build systemd support]),
+        [enable_systemd="$enableval"], [enable_systemd="yes"])
 
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
diff --git a/include/Makefile.am b/include/Makefile.am
index 6bd0f7f..e81463a 100644
--- a/include/Makefile.am
+++ b/include/Makefile.am
@@ -6,5 +6,5 @@ noinst_HEADERS = alarm.h jhash.h cache.h linux_list.h linux_rbtree.h \
 		 network.h filter.h queue.h vector.h cidr.h \
 		 traffic_stats.h netlink.h fds.h event.h bitops.h channel.h \
 		 process.h origin.h internal.h external.h date.h nfct.h \
-		 helper.h myct.h stack.h
+		 helper.h myct.h stack.h systemd.h
 
diff --git a/include/systemd.h b/include/systemd.h
new file mode 100644
index 0000000..b501738
--- /dev/null
+++ b/include/systemd.h
@@ -0,0 +1,18 @@
+#ifndef _INCLUDE_SYSTEMD_H_
+#define _INCLUDE_SYSTEMD_H_
+
+#include <sys/types.h>
+
+void sd_ct_watchdog_init(void);
+void sd_ct_init(int type);
+void sd_ct_mainpid(pid_t pid);
+void sd_ct_stop(void);
+
+#ifndef BUILD_SYSTEMD
+#define sd_ct_watchdog_init(x) do {} while(0)
+#define sd_ct_init(x) do {} while(0)
+#define sd_ct_mainpid(x) do {} while(0)
+#define sd_ct_stop(x) do {} while(0)
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
index dafeaee..c85dd6d 100644
--- a/src/main.c
+++ b/src/main.c
@@ -20,6 +20,7 @@
 #include "conntrackd.h"
 #include "log.h"
 #include "helper.h"
+#include "systemd.h"
 
 #include <sys/types.h>
 #include <sys/stat.h>
@@ -403,6 +404,8 @@ int main(int argc, char *argv[])
 	do_chdir("/");
 	close(STDIN_FILENO);
 
+	sd_ct_watchdog_init();
+
 	/* Daemonize conntrackd */
 	if (type == DAEMON) {
 		pid_t pid;
@@ -410,8 +413,10 @@ int main(int argc, char *argv[])
 		if ((pid = fork()) == -1) {
 			perror("fork has failed: ");
 			exit(EXIT_FAILURE);
-		} else if (pid)
+		} else if (pid) {
+			sd_ct_mainpid(pid);
 			exit(EXIT_SUCCESS);
+		}
 
 		setsid();
 
@@ -422,6 +427,8 @@ int main(int argc, char *argv[])
 	} else
 		dlog(LOG_NOTICE, "-- starting in console mode --");
 
+	sd_ct_init(type);
+
 	/*
 	 * run main process
 	 */
diff --git a/src/run.c b/src/run.c
index a9d4862..b71369b 100644
--- a/src/run.c
+++ b/src/run.c
@@ -30,6 +30,7 @@
 #include "origin.h"
 #include "date.h"
 #include "internal.h"
+#include "systemd.h"
 
 #include <errno.h>
 #include <signal.h>
@@ -64,6 +65,7 @@ void killer(int signo)
 	dlog(LOG_NOTICE, "---- shutdown received ----");
 	close_log();
 
+	sd_ct_stop();
 	exit(0);
 }
 
diff --git a/src/systemd.c b/src/systemd.c
new file mode 100644
index 0000000..9b26da8
--- /dev/null
+++ b/src/systemd.c
@@ -0,0 +1,61 @@
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
+#include "conntrackd.h"
+#include "alarm.h"
+#include <systemd/sd-daemon.h>
+#include <sys/types.h>
+#include <unistd.h>
+
+struct alarm_block	sd_watchdog;
+uint64_t		sd_watchdog_interval;
+
+static void sd_ct_watchdog_alarm(struct alarm_block *a, void *data)
+{
+	sd_notify(0, "WATCHDOG=1");
+	add_alarm(&sd_watchdog, 0, sd_watchdog_interval);
+}
+
+void sd_ct_watchdog_init(void)
+{
+	/* ignoring systemd API erros: only care if admin expects watchdog */
+	if (sd_watchdog_enabled(0, &sd_watchdog_interval) < 1)
+		return;
+
+	/* from man page, recommended interval is half of set by admin */
+	sd_watchdog_interval = sd_watchdog_interval / 2;
+
+	init_alarm(&sd_watchdog, &sd_watchdog_interval, sd_ct_watchdog_alarm);
+	add_alarm(&sd_watchdog, 0, sd_watchdog_interval);
+}
+
+void sd_ct_init(int type)
+{
+	sd_notify(0, "READY=1");
+}
+
+void sd_ct_mainpid(pid_t pid)
+{
+	sd_notifyf(0, "MAINPID=%d", pid);
+}
+
+void sd_ct_stop(void)
+{
+	sd_notify(0, "STOPPING=1");
+}

