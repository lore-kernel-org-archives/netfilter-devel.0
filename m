From: Ansis Atteka <aatteka@nicira.com>
Subject: [PATCHv2] conntrackd: make conntrackd namespace aware
Date: Mon, 10 Sep 2012 19:50:57 -0700
Message-ID: <1347331857-6577-1-git-send-email-aatteka@nicira.com>
Cc: Ansis Atteka <aatteka@nicira.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:45645 "HELO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754850Ab2IKCvQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Sep 2012 22:51:16 -0400
Received: by mail-vb0-f70.google.com with SMTP id b23so35355vbz.1
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Sep 2012 19:51:14 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch allows conntrackd to open CT Netlink sockets into a given
network namespace. Channel sockets (e.g. UDP) would still be opened into
the same namespace where conntrackd was started.

The only binary this patch affects is conntrackd. All other binaries (e.g.
conntrack, nfct) would still operate in the same namespace where they were
started.

To make use of this patch:
1. create a network namespace: "ip netns add the_ns"
2. add "NetlinkNamespace /var/run/netns/the_ns" line to the conntrackd.conf
file inside General {...} section.

Signed-off-by: Ansis Atteka <aatteka@nicira.com>
---
 configure.ac          |    2 +-
 include/Makefile.am   |    2 +-
 include/conntrackd.h  |    6 +++
 include/namespace.h   |   13 ++++++
 src/Makefile.am       |    3 +-
 src/cthelper.c        |    4 +-
 src/ctnl.c            |   17 +++++--
 src/expect.c          |    3 +-
 src/external_inject.c |    3 +-
 src/internal_bypass.c |    5 +-
 src/namespace.c       |  122 +++++++++++++++++++++++++++++++++++++++++++++++++
 src/netlink.c         |    6 ++-
 src/read_config_lex.l |    1 +
 src/read_config_yy.y  |    8 +++-
 src/run.c             |    1 +
 src/sync-mode.c       |    4 +-
 src/sync-notrack.c    |    3 +-
 17 files changed, 186 insertions(+), 17 deletions(-)
 create mode 100644 include/namespace.h
 create mode 100644 src/namespace.c

diff --git a/configure.ac b/configure.ac
index 27ad01b..98a8091 100644
--- a/configure.ac
+++ b/configure.ac
@@ -70,7 +70,7 @@ dnl AC_CHECK_LIB([c], [main])
 
 AC_CHECK_HEADERS(arpa/inet.h)
 dnl check for inet_pton
-AC_CHECK_FUNCS(inet_pton)
+AC_CHECK_FUNCS([inet_pton, setns])
 dnl Some systems have it, but not IPv6
 if test "$ac_cv_func_inet_pton" = "yes" ; then
 AC_MSG_CHECKING(if inet_pton supports IPv6)
diff --git a/include/Makefile.am b/include/Makefile.am
index 6bd0f7f..e06fd4d 100644
--- a/include/Makefile.am
+++ b/include/Makefile.am
@@ -6,5 +6,5 @@ noinst_HEADERS = alarm.h jhash.h cache.h linux_list.h linux_rbtree.h \
 		 network.h filter.h queue.h vector.h cidr.h \
 		 traffic_stats.h netlink.h fds.h event.h bitops.h channel.h \
 		 process.h origin.h internal.h external.h date.h nfct.h \
-		 helper.h myct.h stack.h
+		 helper.h myct.h stack.h namespace.h
 
diff --git a/include/conntrackd.h b/include/conntrackd.h
index 19e613c..a069793 100644
--- a/include/conntrackd.h
+++ b/include/conntrackd.h
@@ -94,6 +94,7 @@ struct ct_conf {
 	int channel_type_global;
 	struct channel_conf channel[MULTICHANNEL_MAX];
 	struct local_conf local;	/* unix socket facilities */
+	char netlink_namespace[FILENAME_MAXLEN];
 	int nice;
 	int limit;
 	int refresh;
@@ -151,6 +152,11 @@ struct ct_general_state {
 	struct ct_filter		*us_filter;
 	struct exp_filter		*exp_filter;
 
+	/* namespace file descriptors for conntrackd sockets */
+	struct {
+		int cur_fd;				/* conntrack */
+		int root_fd;				/* channel*/
+	} ns;
 	struct nfct_handle		*event;         /* event handler */
 	struct nfct_filter		*filter;	/* event filter */
 	int				event_iterations_limit;
diff --git a/include/namespace.h b/include/namespace.h
new file mode 100644
index 0000000..e6dcf0a
--- /dev/null
+++ b/include/namespace.h
@@ -0,0 +1,13 @@
+#ifndef _NAMESPACE_H_
+#define _NAMESPACE_H_
+
+#include <libmnl/libmnl.h>
+#include <libnetfilter_conntrack/libnetfilter_conntrack.h>
+
+#include "conntrackd.h"
+
+int ns_init(char[FILENAME_MAXLEN]);
+struct nfct_handle *ns_nfct_open(u_int8_t, unsigned, int);
+struct mnl_socket *ns_mnl_socket_open(int, int);
+
+#endif
diff --git a/src/Makefile.am b/src/Makefile.am
index d8074d2..60314ab 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -39,7 +39,8 @@ conntrackd_SOURCES = alarm.c main.c run.c hash.c queue.c rbtree.c \
 		    external_cache.c external_inject.c \
 		    internal_cache.c internal_bypass.c \
 		    read_config_yy.y read_config_lex.l \
-		    stack.c helpers.c utils.c expect.c
+		    stack.c helpers.c utils.c expect.c \
+		    namespace.c
 
 # yacc and lex generate dirty code
 read_config_yy.o read_config_lex.o: AM_CFLAGS += -Wno-missing-prototypes -Wno-missing-declarations -Wno-implicit-function-declaration -Wno-nested-externs -Wno-undef -Wno-redundant-decls
diff --git a/src/cthelper.c b/src/cthelper.c
index c119869..ddb7fe6 100644
--- a/src/cthelper.c
+++ b/src/cthelper.c
@@ -22,6 +22,7 @@
 #include "log.h"
 #include "fds.h"
 #include "helper.h"
+#include "namespace.h"
 
 #include <unistd.h>
 #include <fcntl.h>
@@ -493,7 +494,8 @@ int cthelper_init(void)
 		return -1;
 	}
 
-	STATE_CTH(nl) = mnl_socket_open(NETLINK_NETFILTER);
+	STATE_CTH(nl) = ns_mnl_socket_open(NETLINK_NETFILTER,
+			STATE(ns).cur_fd);
 	if (STATE_CTH(nl) == NULL) {
 		dlog(LOG_ERR, "cannot open nfq socket");
 		return -1;
diff --git a/src/ctnl.c b/src/ctnl.c
index bb54727..b8c9a85 100644
--- a/src/ctnl.c
+++ b/src/ctnl.c
@@ -29,6 +29,7 @@
 #include "origin.h"
 #include "date.h"
 #include "internal.h"
+#include "namespace.h"
 
 #include <errno.h>
 #include <signal.h>
@@ -399,6 +400,10 @@ static void poll_cb(void *data)
 
 int ctnl_init(void)
 {
+	if (ns_init(CONFIG(netlink_namespace)) == -1) {
+		return -1;
+	}
+
 	if (CONFIG(flags) & CTD_STATS_MODE)
 		STATE(mode) = &stats_mode;
 	else if (CONFIG(flags) & CTD_SYNC_MODE)
@@ -417,7 +422,8 @@ int ctnl_init(void)
 	}
 
 	/* resynchronize (like 'dump' socket) but it also purges old entries */
-	STATE(resync) = nfct_open(CONFIG(netlink).subsys_id, 0);
+	STATE(resync) = ns_nfct_open(CONFIG(netlink).subsys_id, 0,
+			STATE(ns).cur_fd);
 	if (STATE(resync)== NULL) {
 		dlog(LOG_ERR, "can't open netlink handler: %s",
 		     strerror(errno));
@@ -438,7 +444,8 @@ int ctnl_init(void)
 	fcntl(nfct_fd(STATE(resync)), F_SETFL, O_NONBLOCK);
 
 	if (STATE(mode)->internal->flags & INTERNAL_F_POPULATE) {
-		STATE(dump) = nfct_open(CONFIG(netlink).subsys_id, 0);
+		STATE(dump) = ns_nfct_open(CONFIG(netlink).subsys_id, 0,
+				STATE(ns).cur_fd);
 		if (STATE(dump) == NULL) {
 			dlog(LOG_ERR, "can't open netlink handler: %s",
 			     strerror(errno));
@@ -467,7 +474,8 @@ int ctnl_init(void)
 		}
 	}
 
-	STATE(get) = nfct_open(CONFIG(netlink).subsys_id, 0);
+	STATE(get) = ns_nfct_open(CONFIG(netlink).subsys_id, 0,
+			STATE(ns).cur_fd);
 	if (STATE(get) == NULL) {
 		dlog(LOG_ERR, "can't open netlink handler: %s",
 		     strerror(errno));
@@ -481,7 +489,8 @@ int ctnl_init(void)
 					exp_get_handler, NULL);
 	}
 
-	STATE(flush) = nfct_open(CONFIG(netlink).subsys_id, 0);
+	STATE(flush) = ns_nfct_open(CONFIG(netlink).subsys_id, 0,
+			STATE(ns).cur_fd);
 	if (STATE(flush) == NULL) {
 		dlog(LOG_ERR, "cannot open flusher handler");
 		return -1;
diff --git a/src/expect.c b/src/expect.c
index 6069770..c8bdd16 100644
--- a/src/expect.c
+++ b/src/expect.c
@@ -9,6 +9,7 @@
  */
 
 #include "helper.h"
+#include "namespace.h"
 
 #include <stdio.h>
 #include <string.h>
@@ -165,7 +166,7 @@ static int cthelper_expect_cmd(struct nf_expect *exp, int cmd)
 	int ret;
 	struct nfct_handle *h;
 
-	h = nfct_open(EXPECT, 0);
+	h = ns_nfct_open(EXPECT, 0, STATE(ns).cur_fd);
 	if (!h)
 		return -1;
 
diff --git a/src/external_inject.c b/src/external_inject.c
index 0ad3478..1a65fa3 100644
--- a/src/external_inject.c
+++ b/src/external_inject.c
@@ -22,6 +22,7 @@
 #include "cache.h"
 #include "origin.h"
 #include "external.h"
+#include "namespace.h"
 #include "netlink.h"
 
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
@@ -42,7 +43,7 @@ struct {
 static int external_inject_init(void)
 {
 	/* handler to directly inject conntracks into kernel-space */
-	inject = nfct_open(CONFIG(netlink).subsys_id, 0);
+	inject = ns_nfct_open(CONFIG(netlink).subsys_id, 0, STATE(ns).cur_fd);
 	if (inject == NULL) {
 		dlog(LOG_ERR, "can't open netlink handler: %s",
 		     strerror(errno));
diff --git a/src/internal_bypass.c b/src/internal_bypass.c
index 1194339..d0671e6 100644
--- a/src/internal_bypass.c
+++ b/src/internal_bypass.c
@@ -16,6 +16,7 @@
 #include "netlink.h"
 #include "network.h"
 #include "origin.h"
+#include "namespace.h"
 
 static int internal_bypass_init(void)
 {
@@ -52,7 +53,7 @@ static void internal_bypass_ct_dump(int fd, int type)
 	u_int32_t family = AF_UNSPEC;
 	int ret;
 
-	h = nfct_open(CONFIG(netlink).subsys_id, 0);
+	h = ns_nfct_open(CONFIG(netlink).subsys_id, 0,STATE(ns).cur_fd);
 	if (h == NULL) {
 		dlog(LOG_ERR, "can't allocate memory for the internal cache");
 		return;
@@ -183,7 +184,7 @@ static void internal_bypass_exp_dump(int fd, int type)
 	u_int32_t family = AF_UNSPEC;
 	int ret;
 
-	h = nfct_open(CONFIG(netlink).subsys_id, 0);
+	h = ns_nfct_open(CONFIG(netlink).subsys_id, 0, STATE(ns).cur_fd);
 	if (h == NULL) {
 		dlog(LOG_ERR, "can't allocate memory for the internal cache");
 		return;
diff --git a/src/namespace.c b/src/namespace.c
new file mode 100644
index 0000000..3f64cb5
--- /dev/null
+++ b/src/namespace.c
@@ -0,0 +1,122 @@
+/*
+ * Copyright (C) 2012 Nicira, Inc.
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
+ *
+ * Authors:
+ *     Ansis Atteka <aatteka@nicira.com>
+ */
+#define _GNU_SOURCE
+
+#include "namespace.h"
+
+#include <errno.h>
+#include <fcntl.h>
+#include <sched.h>
+#include <sys/syscall.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+
+#include "log.h"
+
+#ifndef HAVE_SETNS
+static int setns(int fd, int nstype) {
+#ifdef __NR_setns
+#define HAVE_SETNS
+	return syscall(__NR_setns, fd, nstype);
+#else
+	return 0;
+#endif
+}
+#endif /* HAVE_SETNS */
+
+static int
+ctd_change_namespace(int fd)
+{
+	if (fd != -1) {
+#ifdef HAVE_SETNS
+		if (setns(fd, CLONE_NEWNET)) {
+			dlog(LOG_ERR, "could not switch to namespace: %s",
+					strerror(errno));
+			return -1;
+		}
+#else
+		dlog(LOG_ERR, "conntrackd was not built with namespace "
+				"support");
+#endif
+	}
+	return 0;
+}
+
+int ns_init(char netlink_namespace[FILENAME_MAXLEN]) {
+	STATE(ns).root_fd = -1;
+	STATE(ns).cur_fd = -1;
+	if (CONFIG(netlink_namespace)[0]) {
+#ifndef HAVE_SETNS
+		dlog(LOG_ERR, "conntrackd was not built with namespace "
+				"support");
+		return -1;
+#else
+		STATE(ns).cur_fd  = open(CONFIG(netlink_namespace), O_RDONLY);
+		if (STATE(ns).cur_fd == -1) {
+			dlog(LOG_ERR, "couldn't open namespace %s: %s",
+					netlink_namespace,
+					strerror(errno));
+			return -1;
+		}
+		STATE(ns).root_fd = open("/proc/self/ns/net", O_RDONLY);
+		if (STATE(ns).root_fd == -1) {
+			dlog(LOG_WARNING, "couldn't open root namespace: %s",
+					strerror(errno));
+			return -1;
+		}
+#endif
+	}
+	return 0;
+}
+
+struct nfct_handle *ns_nfct_open(u_int8_t subsys_id, unsigned subscriptions,
+		int ns_fd) {
+	struct nfct_handle *handle;
+
+	if (ctd_change_namespace(ns_fd)) {
+		return NULL;
+	}
+	handle = nfct_open(subsys_id, subscriptions);
+	if (ctd_change_namespace(STATE(ns).root_fd)) {
+		if (handle) {
+			nfct_close(handle);
+		}
+		return NULL;
+	}
+	return handle;
+}
+
+struct mnl_socket *ns_mnl_socket_open(int bus, int ns_fd) {
+	struct mnl_socket *handle;
+
+	if (ctd_change_namespace(ns_fd)) {
+		return NULL;
+	}
+	handle = mnl_socket_open(bus);
+	if (ctd_change_namespace(STATE(ns).root_fd)) {
+		if (handle) {
+			mnl_socket_close(handle);
+		}
+		return NULL;
+	}
+	return handle;
+}
diff --git a/src/netlink.c b/src/netlink.c
index bd38d99..ff8967c 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -21,6 +21,7 @@
 #include "conntrackd.h"
 #include "filter.h"
 #include "log.h"
+#include "namespace.h"
 
 #include <string.h>
 #include <errno.h>
@@ -33,7 +34,8 @@ struct nfct_handle *nl_init_event_handler(void)
 {
 	struct nfct_handle *h;
 
-	h = nfct_open(CONFIG(netlink).subsys_id, CONFIG(netlink).groups);
+	h = ns_nfct_open(CONFIG(netlink).subsys_id, CONFIG(netlink).groups,
+			STATE(ns).cur_fd);
 	if (h == NULL)
 		return NULL;
 
@@ -175,7 +177,7 @@ int nl_flush_conntrack_table_selective(void)
 	struct nfct_handle *h;
 	int ret;
 
-	h = nfct_open(CONNTRACK, 0);
+	h = ns_nfct_open(CONNTRACK, 0, STATE(ns).cur_fd);
 	if (h == NULL) {
 		dlog(LOG_ERR, "cannot open handle");
 		return -1;
diff --git a/src/read_config_lex.l b/src/read_config_lex.l
index 31fa32e..7a09c52 100644
--- a/src/read_config_lex.l
+++ b/src/read_config_lex.l
@@ -91,6 +91,7 @@ notrack		[N|n][O|o][T|t][R|r][A|a][C|c][K|k]
 "SocketBufferSizeMaxGrowth"	{ return T_BUFFER_SIZE_MAX_GROWN; /* alias */ }
 "NetlinkBufferSize"		{ return T_BUFFER_SIZE; }
 "NetlinkBufferSizeMaxGrowth"	{ return T_BUFFER_SIZE_MAX_GROWN; }
+"NetlinkNamespace"		{ return T_NETLINK_NAMESPACE; }
 "Mode"				{ return T_SYNC_MODE; }
 "ListenTo"			{ return T_LISTEN_TO; }
 "Family"			{ return T_FAMILY; }
diff --git a/src/read_config_yy.y b/src/read_config_yy.y
index c9235d3..b0985e7 100644
--- a/src/read_config_yy.y
+++ b/src/read_config_yy.y
@@ -87,7 +87,7 @@ enum {
 %token T_DISABLE_INTERNAL_CACHE T_DISABLE_EXTERNAL_CACHE T_ERROR_QUEUE_LENGTH
 %token T_OPTIONS T_TCP_WINDOW_TRACKING T_EXPECT_SYNC
 %token T_HELPER T_HELPER_QUEUE_NUM T_HELPER_POLICY T_HELPER_EXPECT_MAX
-%token T_HELPER_EXPECT_TIMEOUT
+%token T_HELPER_EXPECT_TIMEOUT T_NETLINK_NAMESPACE
 
 %token <string> T_IP T_PATH_VAL
 %token <val> T_NUMBER
@@ -1113,6 +1113,7 @@ general_line: hashsize
 	    | unix_line
 	    | netlink_buffer_size
 	    | netlink_buffer_size_max_grown
+	    | netlink_namespace
 	    | family
 	    | event_iterations_limit
 	    | poll_secs
@@ -1158,6 +1159,11 @@ netlink_events_reliable : T_NETLINK_EVENTS_RELIABLE T_OFF
 	conf.netlink.events_reliable = 0;
 };
 
+netlink_namespace : T_NETLINK_NAMESPACE T_PATH_VAL
+{
+	strncpy(conf.netlink_namespace, $2, FILENAME_MAXLEN);
+};
+
 nice : T_NICE T_SIGNED_NUMBER
 {
 	conf.nice = $2;
diff --git a/src/run.c b/src/run.c
index 3337694..ea7ce33 100644
--- a/src/run.c
+++ b/src/run.c
@@ -30,6 +30,7 @@
 #include "origin.h"
 #include "date.h"
 #include "internal.h"
+#include "namespace.h"
 
 #include <errno.h>
 #include <signal.h>
diff --git a/src/sync-mode.c b/src/sync-mode.c
index e69ecfe..8a9abad 100644
--- a/src/sync-mode.c
+++ b/src/sync-mode.c
@@ -31,6 +31,7 @@
 #include "origin.h"
 #include "internal.h"
 #include "external.h"
+#include "namespace.h"
 
 #include <errno.h>
 #include <unistd.h>
@@ -451,7 +452,8 @@ static int init_sync(void)
 			tx_queue_cb, NULL, STATE(fds)) == -1)
 		return -1;
 
-	STATE_SYNC(commit).h = nfct_open(CONFIG(netlink).subsys_id, 0);
+	STATE_SYNC(commit).h = ns_nfct_open(CONFIG(netlink).subsys_id, 0,
+			STATE(ns).cur_fd);
 	if (STATE_SYNC(commit).h == NULL) {
 		dlog(LOG_ERR, "can't create handler to commit");
 		return -1;
diff --git a/src/sync-notrack.c b/src/sync-notrack.c
index a7df4e7..1cc0aac 100644
--- a/src/sync-notrack.c
+++ b/src/sync-notrack.c
@@ -24,6 +24,7 @@
 #include "log.h"
 #include "cache.h"
 #include "fds.h"
+#include "namespace.h"
 
 #include <string.h>
 
@@ -102,7 +103,7 @@ static void kernel_resync(void)
 	u_int32_t family = AF_UNSPEC;
 	int ret;
 
-	h = nfct_open(CONFIG(netlink).subsys_id, 0);
+	h = ns_nfct_open(CONFIG(netlink).subsys_id, 0, STATE(ns).cur_fd);
 	if (h == NULL) {
 		dlog(LOG_ERR, "can't allocate memory for the internal cache");
 		return;
-- 
1.7.9.5

