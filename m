From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [conntrackd PATCH v3] conntrackd: add systemd support
Date: Fri, 13 Nov 2015 11:59:35 +0100
Message-ID: <144741224967.19762.12430502552848102506.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:42364 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932180AbbKMK7q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Nov 2015 05:59:46 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds basic systemd support.

The feature can be enabled/disabled at configure time:
 ./configure --disable-systemd

Also, at runtime in conntrackd.conf
General {
	Systemd on|off
}

(by default it's enabled both at runtime and at configure time)

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
v2: change functions definitions to static inline if no BUILD_SYSTEMD,
    and set watchdog variables as static.

v3: add runtime systemd configuration. Report warnings.

 configure.ac                     |   12 +++++-
 doc/stats/conntrackd.conf        |    8 ++++
 doc/sync/alarm/conntrackd.conf   |    8 ++++
 doc/sync/ftfw/conntrackd.conf    |    8 ++++
 doc/sync/notrack/conntrackd.conf |    8 ++++
 include/Makefile.am              |    2 -
 include/conntrackd.h             |    1 
 include/systemd.h                |   18 ++++++++
 src/Makefile.am                  |    8 ++++
 src/main.c                       |    9 ++++
 src/read_config_lex.l            |    1 
 src/read_config_yy.y             |   19 +++++++++
 src/run.c                        |    2 +
 src/systemd.c                    |   82 ++++++++++++++++++++++++++++++++++++++
 14 files changed, 183 insertions(+), 3 deletions(-)
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
diff --git a/doc/stats/conntrackd.conf b/doc/stats/conntrackd.conf
index 16d7a80..b1cca07 100644
--- a/doc/stats/conntrackd.conf
+++ b/doc/stats/conntrackd.conf
@@ -3,6 +3,14 @@
 #
 General {
 	#
+	# Enable systemd support. If conntrackd is compiled with the proper
+	# configuration, you can use a systemd service unit of Type=notify
+	# and use conntrackd with systemd watchdog as well.
+	# Default is: on
+	#
+	#Systemd off
+
+	#
 	# Set the nice value of the daemon. This value goes from -20
 	# (most favorable scheduling) to 19 (least favorable). Using a
 	# negative value reduces the chances to lose state-change events.
diff --git a/doc/sync/alarm/conntrackd.conf b/doc/sync/alarm/conntrackd.conf
index 0223745..39deb47 100644
--- a/doc/sync/alarm/conntrackd.conf
+++ b/doc/sync/alarm/conntrackd.conf
@@ -218,6 +218,14 @@ Sync {
 #
 General {
 	#
+	# Enable systemd support. If conntrackd is compiled with the proper
+	# configuration, you can use a systemd service unit of Type=notify
+	# and use conntrackd with systemd watchdog as well.
+	# Default is: on
+	#
+	#Systemd off
+
+	#
 	# Set the nice value of the daemon, this value goes from -20
 	# (most favorable scheduling) to 19 (least favorable). Using a
 	# very low value reduces the chances to lose state-change events.
diff --git a/doc/sync/ftfw/conntrackd.conf b/doc/sync/ftfw/conntrackd.conf
index 65e7b77..60d7d97 100644
--- a/doc/sync/ftfw/conntrackd.conf
+++ b/doc/sync/ftfw/conntrackd.conf
@@ -241,6 +241,14 @@ Sync {
 #
 General {
 	#
+	# Enable systemd support. If conntrackd is compiled with the proper
+	# configuration, you can use a systemd service unit of Type=notify
+	# and use conntrackd with systemd watchdog as well.
+	# Default is: on
+	#
+	#Systemd off
+
+	#
 	# Set the nice value of the daemon, this value goes from -20
 	# (most favorable scheduling) to 19 (least favorable). Using a
 	# very low value reduces the chances to lose state-change events.
diff --git a/doc/sync/notrack/conntrackd.conf b/doc/sync/notrack/conntrackd.conf
index 3d036fb..b9d42ba 100644
--- a/doc/sync/notrack/conntrackd.conf
+++ b/doc/sync/notrack/conntrackd.conf
@@ -280,6 +280,14 @@ Sync {
 #
 General {
 	#
+	# Enable systemd support. If conntrackd is compiled with the proper
+	# configuration, you can use a systemd service unit of Type=notify
+	# and use conntrackd with systemd watchdog as well.
+	# Default is: on
+	#
+	#Systemd off
+
+	#
 	# Set the nice value of the daemon, this value goes from -20
 	# (most favorable scheduling) to 19 (least favorable). Using a
 	# very low value reduces the chances to lose state-change events.
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
 
diff --git a/include/conntrackd.h b/include/conntrackd.h
index d338fc4..f8b11a7 100644
--- a/include/conntrackd.h
+++ b/include/conntrackd.h
@@ -109,6 +109,7 @@ struct ct_conf {
 	int poll_kernel_secs;
 	int filter_from_kernelspace;
 	int event_iterations_limit;
+	int systemd;
 	struct {
 		int error_queue_length;
 	} channelc;
diff --git a/include/systemd.h b/include/systemd.h
new file mode 100644
index 0000000..d05d2f3
--- /dev/null
+++ b/include/systemd.h
@@ -0,0 +1,18 @@
+#ifndef _INCLUDE_SYSTEMD_H_
+#define _INCLUDE_SYSTEMD_H_
+
+#include <sys/types.h>
+
+#ifdef BUILD_SYSTEMD
+void sd_ct_watchdog_init(void);
+void sd_ct_init(void);
+void sd_ct_mainpid(pid_t pid);
+void sd_ct_stop(void);
+#else /* BUILD_SYSTEMD */
+static inline void sd_ct_watchdog_init(void) {};
+static inline void sd_ct_init(void) {};
+static inline void sd_ct_mainpid(pid_t pid) {};
+static inline void sd_ct_stop(void) {};
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
index dafeaee..161f654 100644
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
 
+	sd_ct_init();
+
 	/*
 	 * run main process
 	 */
diff --git a/src/read_config_lex.l b/src/read_config_lex.l
index 8350069..2404058 100644
--- a/src/read_config_lex.l
+++ b/src/read_config_lex.l
@@ -148,6 +148,7 @@ notrack		[N|n][O|o][T|t][R|r][A|a][C|c][K|k]
 "Policy"			{ return T_HELPER_POLICY; }
 "ExpectMax"			{ return T_HELPER_EXPECT_MAX; }
 "ExpectTimeout"			{ return T_HELPER_EXPECT_TIMEOUT; }
+"Systemd"			{ return T_SYSTEMD; }
 
 {is_on}			{ return T_ON; }
 {is_off}		{ return T_OFF; }
diff --git a/src/read_config_yy.y b/src/read_config_yy.y
index 73fabbf..58ad2d0 100644
--- a/src/read_config_yy.y
+++ b/src/read_config_yy.y
@@ -89,6 +89,7 @@ enum {
 %token T_OPTIONS T_TCP_WINDOW_TRACKING T_EXPECT_SYNC
 %token T_HELPER T_HELPER_QUEUE_NUM T_HELPER_QUEUE_LEN T_HELPER_POLICY
 %token T_HELPER_EXPECT_TIMEOUT T_HELPER_EXPECT_MAX
+%token T_SYSTEMD
 
 %token <string> T_IP T_PATH_VAL
 %token <val> T_NUMBER
@@ -1122,8 +1123,15 @@ general_line: hashsize
 	    | netlink_events_reliable
 	    | nice
 	    | scheduler
+	    | systemd
 	    ;
 
+systemd: T_SYSTEMD T_ON { /* already enabled in init_config() */ };
+systemd: T_SYSTEMD T_OFF
+{
+	conf.systemd = 0;
+};
+
 netlink_buffer_size: T_BUFFER_SIZE T_NUMBER
 {
 	conf.netlink_buffer_size = $2;
@@ -1856,6 +1864,9 @@ init_config(char *filename)
 	CONFIG(stats).syslog_facility = -1;
 	CONFIG(netlink).subsys_id = -1;
 
+	/* enable systemd by default */
+	CONFIG(systemd) = 1;
+
 	/* Initialize list of user-space helpers */
 	INIT_LIST_HEAD(&CONFIG(cthelper).list);
 
@@ -1865,6 +1876,14 @@ init_config(char *filename)
 	yyparse();
 	fclose(fp);
 
+#ifndef BUILD_SYSTEMD
+	if (CONFIG(systemd) == 1) {
+		print_err(CTD_CFG_WARN, "systemd runtime support activated but"
+					" conntrackd was built without support"
+					" for it. Recompile conntrackd");
+	}
+#endif /* BUILD_SYSTEMD */
+
 	/* set to default is not specified */
 	if (strcmp(CONFIG(lockfile), "") == 0)
 		strncpy(CONFIG(lockfile), DEFAULT_LOCKFILE, FILENAME_MAXLEN);
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
index 0000000..4eb880c
--- /dev/null
+++ b/src/systemd.c
@@ -0,0 +1,82 @@
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
+#include <string.h>
+
+static struct alarm_block	sd_watchdog;
+static uint64_t			sd_watchdog_interval;
+
+static void sd_ct_watchdog_alarm(struct alarm_block *a, void *data)
+{
+	sd_notify(0, "WATCHDOG=1");
+	add_alarm(&sd_watchdog, 0, sd_watchdog_interval);
+}
+
+void sd_ct_watchdog_init(void)
+{
+	int ret;
+
+	if (CONFIG(systemd) == 0)
+		return;
+
+	ret = sd_watchdog_enabled(0, &sd_watchdog_interval);
+	if (ret < 0) {
+		fprintf(stderr, "WARNING: failed to get watchdog details from"
+				" systemd: %s\n", strerror(-ret));
+		return;
+	} else if (ret == 0) {
+		/* no watchdog required */
+		return;
+	}
+
+	/* from man page, recommended interval is half of set by admin */
+	sd_watchdog_interval = sd_watchdog_interval / 2;
+
+	init_alarm(&sd_watchdog, &sd_watchdog_interval, sd_ct_watchdog_alarm);
+	add_alarm(&sd_watchdog, 0, sd_watchdog_interval);
+}
+
+void sd_ct_init(void)
+{
+	if (CONFIG(systemd) == 0)
+		return;
+
+	sd_notify(0, "READY=1");
+}
+
+void sd_ct_mainpid(pid_t pid)
+{
+	if (CONFIG(systemd) == 0)
+		return;
+
+	sd_notifyf(0, "MAINPID=%d", pid);
+}
+
+void sd_ct_stop(void)
+{
+	if (CONFIG(systemd) == 0)
+		return;
+
+	sd_notify(0, "STOPPING=1");
+}

