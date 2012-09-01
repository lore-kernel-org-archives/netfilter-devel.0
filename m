From: Ansis Atteka <aatteka@nicira.com>
Subject: [PATCH] conntrackd: make conntrackd namespace aware
Date: Fri, 31 Aug 2012 18:11:55 -0700
Message-ID: <1346461915-6309-1-git-send-email-aatteka@nicira.com>
Cc: Ansis Atteka <aatteka@nicira.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:60549 "HELO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755424Ab2IABML (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 31 Aug 2012 21:12:11 -0400
Received: by qaat11 with SMTP id t11so2936929qaa.1
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Aug 2012 18:12:09 -0700 (PDT)
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
 include/Makefile.am   |    2 +-
 include/conntrackd.h  |    2 +
 include/namespace.h   |   12 ++++++
 src/Makefile.am       |    3 +-
 src/cthelper.c        |    3 +-
 src/ctnl.c            |   20 +++++++--
 src/expect.c          |    4 +-
 src/external_inject.c |    3 +-
 src/internal_bypass.c |    5 ++-
 src/namespace.c       |  112 +++++++++++++++++++++++++++++++++++++++++++++++++
 src/netlink.c         |    6 ++-
 src/read_config_lex.l |    1 +
 src/read_config_yy.y  |    8 +++-
 src/run.c             |    3 ++
 src/sync-mode.c       |    4 +-
 src/sync-notrack.c    |    3 +-
 16 files changed, 175 insertions(+), 16 deletions(-)
 create mode 100644 include/namespace.h
 create mode 100644 src/namespace.c

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
index 19e613c..c349d72 100644
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
@@ -143,6 +144,7 @@ struct ct_conf {
 #define STATE(x) st.x
 
 struct ct_general_state {
+	int					ns_fd;		/* namespace fd for NL sockets */
 	sigset_t 			block;
 	FILE 				*log;
 	FILE				*stats_log;
diff --git a/include/namespace.h b/include/namespace.h
new file mode 100644
index 0000000..668a270
--- /dev/null
+++ b/include/namespace.h
@@ -0,0 +1,12 @@
+#ifndef _NAMESPACE_H_
+#define _NAMESPACE_H_
+
+#include <libmnl/libmnl.h>
+#include <libnetfilter_conntrack/libnetfilter_conntrack.h>
+
+void init_namespaces(void);
+
+struct nfct_handle *nfct_open_ns(u_int8_t, unsigned, int);
+struct mnl_socket *mnl_socket_open_ns(int, int);
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
index c119869..b165900 100644
--- a/src/cthelper.c
+++ b/src/cthelper.c
@@ -22,6 +22,7 @@
 #include "log.h"
 #include "fds.h"
 #include "helper.h"
+#include "namespace.h"
 
 #include <unistd.h>
 #include <fcntl.h>
@@ -493,7 +494,7 @@ int cthelper_init(void)
 		return -1;
 	}
 
-	STATE_CTH(nl) = mnl_socket_open(NETLINK_NETFILTER);
+	STATE_CTH(nl) = mnl_socket_open_ns(NETLINK_NETFILTER, STATE(ns_fd));
 	if (STATE_CTH(nl) == NULL) {
 		dlog(LOG_ERR, "cannot open nfq socket");
 		return -1;
diff --git a/src/ctnl.c b/src/ctnl.c
index bb54727..65784c3 100644
--- a/src/ctnl.c
+++ b/src/ctnl.c
@@ -29,6 +29,7 @@
 #include "origin.h"
 #include "date.h"
 #include "internal.h"
+#include "namespace.h"
 
 #include <errno.h>
 #include <signal.h>
@@ -399,6 +400,17 @@ static void poll_cb(void *data)
 
 int ctnl_init(void)
 {
+	if (CONFIG(netlink_namespace)[0]) {
+		STATE(ns_fd) = open(CONFIG(netlink_namespace), O_RDONLY);
+		if (STATE(ns_fd) == -1) {
+			dlog(LOG_ERR, "could not open network namespace %s: %s",
+				 CONFIG(netlink_namespace), strerror(errno));
+			return -1;
+		}
+	} else {
+		STATE(ns_fd) = -1;
+	}
+
 	if (CONFIG(flags) & CTD_STATS_MODE)
 		STATE(mode) = &stats_mode;
 	else if (CONFIG(flags) & CTD_SYNC_MODE)
@@ -417,7 +429,7 @@ int ctnl_init(void)
 	}
 
 	/* resynchronize (like 'dump' socket) but it also purges old entries */
-	STATE(resync) = nfct_open(CONFIG(netlink).subsys_id, 0);
+	STATE(resync) = nfct_open_ns(CONFIG(netlink).subsys_id, 0, STATE(ns_fd));
 	if (STATE(resync)== NULL) {
 		dlog(LOG_ERR, "can't open netlink handler: %s",
 		     strerror(errno));
@@ -438,7 +450,7 @@ int ctnl_init(void)
 	fcntl(nfct_fd(STATE(resync)), F_SETFL, O_NONBLOCK);
 
 	if (STATE(mode)->internal->flags & INTERNAL_F_POPULATE) {
-		STATE(dump) = nfct_open(CONFIG(netlink).subsys_id, 0);
+		STATE(dump) = nfct_open_ns(CONFIG(netlink).subsys_id, 0, STATE(ns_fd));
 		if (STATE(dump) == NULL) {
 			dlog(LOG_ERR, "can't open netlink handler: %s",
 			     strerror(errno));
@@ -467,7 +479,7 @@ int ctnl_init(void)
 		}
 	}
 
-	STATE(get) = nfct_open(CONFIG(netlink).subsys_id, 0);
+	STATE(get) = nfct_open_ns(CONFIG(netlink).subsys_id, 0, STATE(ns_fd));
 	if (STATE(get) == NULL) {
 		dlog(LOG_ERR, "can't open netlink handler: %s",
 		     strerror(errno));
@@ -481,7 +493,7 @@ int ctnl_init(void)
 					exp_get_handler, NULL);
 	}
 
-	STATE(flush) = nfct_open(CONFIG(netlink).subsys_id, 0);
+	STATE(flush) = nfct_open_ns(CONFIG(netlink).subsys_id, 0, STATE(ns_fd));
 	if (STATE(flush) == NULL) {
 		dlog(LOG_ERR, "cannot open flusher handler");
 		return -1;
diff --git a/src/expect.c b/src/expect.c
index 6069770..bedec2c 100644
--- a/src/expect.c
+++ b/src/expect.c
@@ -8,7 +8,9 @@
  * This code has been sponsored by Vyatta Inc. <http://www.vyatta.com>
  */
 
+#include "conntrackd.h"
 #include "helper.h"
+#include "namespace.h"
 
 #include <stdio.h>
 #include <string.h>
@@ -165,7 +167,7 @@ static int cthelper_expect_cmd(struct nf_expect *exp, int cmd)
 	int ret;
 	struct nfct_handle *h;
 
-	h = nfct_open(EXPECT, 0);
+	h = nfct_open_ns(EXPECT, 0, STATE(ns_fd));
 	if (!h)
 		return -1;
 
diff --git a/src/external_inject.c b/src/external_inject.c
index 0ad3478..5a6680b 100644
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
+	inject = nfct_open_ns(CONFIG(netlink).subsys_id, 0, STATE(ns_fd));
 	if (inject == NULL) {
 		dlog(LOG_ERR, "can't open netlink handler: %s",
 		     strerror(errno));
diff --git a/src/internal_bypass.c b/src/internal_bypass.c
index 1194339..520c55d 100644
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
+	h = nfct_open_ns(CONFIG(netlink).subsys_id, 0, STATE(ns_fd));
 	if (h == NULL) {
 		dlog(LOG_ERR, "can't allocate memory for the internal cache");
 		return;
@@ -183,7 +184,7 @@ static void internal_bypass_exp_dump(int fd, int type)
 	u_int32_t family = AF_UNSPEC;
 	int ret;
 
-	h = nfct_open(CONFIG(netlink).subsys_id, 0);
+	h = nfct_open_ns(CONFIG(netlink).subsys_id, 0, STATE(ns_fd));
 	if (h == NULL) {
 		dlog(LOG_ERR, "can't allocate memory for the internal cache");
 		return;
diff --git a/src/namespace.c b/src/namespace.c
new file mode 100644
index 0000000..03db222
--- /dev/null
+++ b/src/namespace.c
@@ -0,0 +1,112 @@
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
+#include <fcntl.h>
+#include <sched.h>
+#include <sys/syscall.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+
+#include "conntrackd.h"
+#include "log.h"
+
+#ifndef CLONE_NEWNET
+#define CLONE_NEWNET 0x40000000
+#endif
+
+#ifndef __NR_setns
+#ifdef __x86_64
+#define __NR_setns 308
+#endif
+#ifdef __i386
+#define __NR_setns 346
+#endif
+#endif
+
+#ifdef __NR_setns
+
+static int root_fd = -1;
+
+void init_namespaces(void) {
+	root_fd = open("/proc/self/ns/net", O_RDONLY);
+	if (root_fd == -1) {
+		dlog(LOG_WARNING, "could not open current namespace");
+	}
+}
+
+struct nfct_handle *nfct_open_ns(u_int8_t subsys_id, unsigned subscriptions,
+								 int ns_fd) {
+	struct nfct_handle *handle = NULL;
+
+	if (ns_fd != -1 && syscall(__NR_setns, ns_fd, CLONE_NEWNET)) {
+		dlog(LOG_ERR, "could not switch between namespaces");
+	} else {
+		handle = nfct_open(subsys_id, subscriptions);
+		if (ns_fd != -1 && syscall(__NR_setns, root_fd, CLONE_NEWNET)) {
+			dlog(LOG_ERR, "fatal: could not switch back to main namespace");
+		}
+	}
+	return handle;
+}
+
+struct mnl_socket *mnl_socket_open_ns(int bus, int ns_fd) {
+	struct mnl_socket *handle = NULL;
+
+	if (ns_fd != -1 && syscall(__NR_setns, ns_fd, CLONE_NEWNET)) {
+		dlog(LOG_ERR, "could not switch between namespaces");
+	} else {
+		handle = mnl_socket_open(bus);
+		if (ns_fd != -1 && syscall(__NR_setns, root_fd, CLONE_NEWNET)) {
+			dlog(LOG_ERR, "fatal: could not switch back to main namespace");
+		}
+	}
+	return handle;
+}
+
+#else
+
+void init_namespaces(void) {
+}
+
+struct nfct_handle *nfct_open_ns(u_int8_t subsys_id, unsigned subscriptions,
+								 int ns_fd) {
+	if (ns_fd == -1) {
+		return nfct_open(subsys_id, subscriptions);
+	} else {
+		dlog(LOG_ERR, "network namespaces are not supported on this system");
+		return NULL;
+	}
+}
+
+struct mnl_socket *mnl_socket_open_ns(int bus, int ns_fd) {
+	if (ns_fd == -1) {
+		return mnl_socket_open(bus);
+	} else {
+		dlog(LOG_ERR, "network namespaces are not supported on this system");
+		return NULL;
+	}
+}
+
+#endif
diff --git a/src/netlink.c b/src/netlink.c
index bd38d99..c71b463 100644
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
+	h = nfct_open_ns(CONFIG(netlink).subsys_id, CONFIG(netlink).groups,
+					 STATE(ns_fd));
 	if (h == NULL)
 		return NULL;
 
@@ -175,7 +177,7 @@ int nl_flush_conntrack_table_selective(void)
 	struct nfct_handle *h;
 	int ret;
 
-	h = nfct_open(CONNTRACK, 0);
+	h = nfct_open_ns(CONNTRACK, 0, STATE(ns_fd));
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
index 3337694..7aa5032 100644
--- a/src/run.c
+++ b/src/run.c
@@ -30,6 +30,7 @@
 #include "origin.h"
 #include "date.h"
 #include "internal.h"
+#include "namespace.h"
 
 #include <errno.h>
 #include <signal.h>
@@ -252,6 +253,8 @@ init(void)
 		return -1;
 
 	/* Initialization */
+	init_namespaces();
+
 	if (CONFIG(flags) & (CTD_SYNC_MODE | CTD_STATS_MODE))
 		if (ctnl_init() < 0)
 			return -1;
diff --git a/src/sync-mode.c b/src/sync-mode.c
index e69ecfe..de58b8c 100644
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
+	STATE_SYNC(commit).h = nfct_open_ns(CONFIG(netlink).subsys_id, 0,
+										STATE(ns_fd));
 	if (STATE_SYNC(commit).h == NULL) {
 		dlog(LOG_ERR, "can't create handler to commit");
 		return -1;
diff --git a/src/sync-notrack.c b/src/sync-notrack.c
index a7df4e7..d8010fb 100644
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
+	h = nfct_open_ns(CONFIG(netlink).subsys_id, 0, STATE(ns_fd));
 	if (h == NULL) {
 		dlog(LOG_ERR, "can't allocate memory for the internal cache");
 		return;
-- 
1.7.9.5

