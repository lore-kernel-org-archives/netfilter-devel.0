Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F0A1C433DB
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Feb 2021 10:34:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5642764F60
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Feb 2021 10:34:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235520AbhBDKdl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 4 Feb 2021 05:33:41 -0500
Received: from mail-wm1-f45.google.com ([209.85.128.45]:36371 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234873AbhBDKcv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Feb 2021 05:32:51 -0500
Received: by mail-wm1-f45.google.com with SMTP id i9so2545083wmq.1
        for <netfilter-devel@vger.kernel.org>; Thu, 04 Feb 2021 02:32:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=Sn75pFb+uO13qGnRK00Ex/Nv1mTLzT2+r3MUuphDvLA=;
        b=R5Nzc1Fi8+qN+uxrXbCG3WL8JieBsNoOP0bTVuKisTjn+ymGEbCNzR5oHT9xb+L7zD
         EXTOIO9Bv55XdCI9EOElHyYipV8GP1B92kNy5wBMzDgxPg1KuROcCdHR1IRHv9Ky58Ot
         7u5BIQlDdEB6qLp3MjhG68l0lAfaUCL/8J9JEpxqBzJ44TMs9nuSTblzCobanYKaKGBp
         GryIzaJih5u1VUJwq2qSr3EgNpyB7NHEVyEnl1NQMQFNTexezqJuiY3bscfYueln8rRR
         ayn8UPWKRRNCEoycywepAougjOU8HhtR+YI/njlQh8Y6JVIYX/wo4a4mlx2JtjgE925m
         qRig==
X-Gm-Message-State: AOAM530fXnzEo0ivBNB71lnmMzo/zfqeOQkYTfyo5W5wqbw7LKfmxTWO
        va41torzD9LM2bRGFOcl/vTqV3Vu2I8=
X-Google-Smtp-Source: ABdhPJwLmJzzmcWTtHPjA8kevjntPUXuwAE737LaXYB6HQMMPPDTkBlAdrz3GNga8zyIMaXwLYpBdQ==
X-Received: by 2002:a05:600c:4e8e:: with SMTP id f14mr6834546wmq.139.1612434728354;
        Thu, 04 Feb 2021 02:32:08 -0800 (PST)
Received: from localhost (217.216.74.49.dyn.user.ono.com. [217.216.74.49])
        by smtp.gmail.com with ESMTPSA id u3sm8354770wre.54.2021.02.04.02.32.07
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 02:32:07 -0800 (PST)
Subject: [RFC conntrack-tools PATCH] conntrack-tools: introduce conntrackdctl
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Date:   Thu, 04 Feb 2021 11:32:06 +0100
Message-ID: <161243463641.9380.7754148010781645692.stgit@endurance>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Separate conntrackd command line client functionalities into a different
binary.

This should help with several things:
 * avoid reading and parsing the config file, which can fail in some enviroments, for example if
   conntrackd is running inside a netns and the referenced interfaces/addresses doesn't exist in
   the namespace conntrackd client command is running from.
 * easily update conntrakdctl with more functionalities without polluting the daemon binary
 * easier code maintenance

Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
---
NOTE: this is just an idea, comments welcome. I have plans to extend this new binary with more
options in the future.

 include/local.h     |   10 +-
 src/.gitignore      |    1 
 src/Makefile.am     |    5 +
 src/conntrackdctl.c |  292 +++++++++++++++++++++++++++++++++++++++++++++++++++
 src/local.c         |   18 +--
 src/main.c          |  223 +++------------------------------------
 6 files changed, 325 insertions(+), 224 deletions(-)
 create mode 100644 src/conntrackdctl.c

diff --git a/include/local.h b/include/local.h
index 9379446..505708b 100644
--- a/include/local.h
+++ b/include/local.h
@@ -5,6 +5,8 @@
 #define UNIX_PATH_MAX   108
 #endif
 
+#define DEFAULT_SOCKET_PATH "/var/run/conntrackd.ctl"
+
 struct local_conf {
 	int reuseaddr;
 	char path[UNIX_PATH_MAX + 1];
@@ -26,11 +28,7 @@ void local_server_destroy(struct local_server *server);
 int do_local_server_step(struct local_server *server, void *data, 
 			 int (*process)(int fd, void *data));
 
-/* local client */
-int local_client_create(struct local_conf *conf);
-void local_client_destroy(int fd);
-int do_local_client_step(int fd, void (*process)(char *buf));
-int do_local_request(int, struct local_conf *,void (*step)(char *buf));
-void local_step(char *buf);
+/* local client, conntrackdctl */
+int do_local_request(int request, const char *socket_path);
 
 #endif
diff --git a/src/.gitignore b/src/.gitignore
index 55a0d27..fd09ef1 100644
--- a/src/.gitignore
+++ b/src/.gitignore
@@ -1,6 +1,7 @@
 /conntrack
 /conntrackd
 /nfct
+/conntrackdctl
 
 /read_config_lex.c
 /read_config_yy.c
diff --git a/src/Makefile.am b/src/Makefile.am
index 2e66ee9..ca9e43a 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -8,7 +8,7 @@ AM_YFLAGS = -d
 
 CLEANFILES = read_config_yy.c read_config_lex.c
 
-sbin_PROGRAMS = conntrack conntrackd nfct
+sbin_PROGRAMS = conntrack conntrackd nfct conntrackdctl
 
 conntrack_SOURCES = conntrack.c
 conntrack_LDADD = ../extensions/libct_proto_tcp.la ../extensions/libct_proto_udp.la ../extensions/libct_proto_udplite.la ../extensions/libct_proto_icmp.la ../extensions/libct_proto_icmpv6.la ../extensions/libct_proto_sctp.la ../extensions/libct_proto_dccp.la ../extensions/libct_proto_gre.la ../extensions/libct_proto_unknown.la ${LIBNETFILTER_CONNTRACK_LIBS} ${LIBMNL_LIBS} ${LIBNFNETLINK_LIBS}
@@ -54,6 +54,9 @@ conntrackd_SOURCES = alarm.c main.c run.c hash.c queue.c queue_tx.c rbtree.c \
 		    read_config_yy.y read_config_lex.l \
 		    stack.c resync.c
 
+conntrackdctl_SOURCES = conntrackdctl.c local.c
+conntrackdctl_LDADD   = ${libdl_LIBS}
+
 if HAVE_CTHELPER
 conntrackd_SOURCES += cthelper.c helpers.c utils.c expect.c
 endif
diff --git a/src/conntrackdctl.c b/src/conntrackdctl.c
new file mode 100644
index 0000000..42f9449
--- /dev/null
+++ b/src/conntrackdctl.c
@@ -0,0 +1,292 @@
+/*
+ * (C) 2006-2011 by Pablo Neira Ayuso <pablo@netfilter.org>
+ * (C) 2011 by Vyatta Inc. <http://www.vyatta.com>
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
+#include "conntrackd.h"
+#include "log.h"
+#include "helper.h"
+#include "systemd.h"
+#include "resync.h"
+
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <sys/utsname.h>
+#include <string.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <limits.h>
+
+static const char usage_client_commands[] =
+	"conntrackdctl options:\n"
+        "  -u <path>, full path to the Unix domain socket used to connect to conntrackd. "
+        "Defaults to '/var/run/conntrackd.ctl'\n"
+	"  -c [ct|expect], commit external cache to conntrack table\n"
+	"  -f [internal|external], flush internal and external cache\n"
+	"  -F [ct|expect], flush kernel conntrack table\n"
+	"  -i [ct|expect], display content of the internal cache\n"
+	"  -e [ct|expect], display the content of the external cache\n"
+	"  -k, kill conntrack daemon\n"
+	"  -s [network|cache|runtime|link|rsqueue|queue|ct|expect] dump statistics. "
+	"Defaults to 'ct'\n"
+	"  -R [ct|expect], resync with kernel conntrack table\n"
+	"  -n, request resync with other node (only FT-FW and NOTRACK modes)\n"
+	"  -B, force a bulk send to other replica firewalls\n"
+	"  -x, dump cache in XML format (requires -i or -e)\n"
+	"  -t, reset the kernel timeout (see PurgeTimeout clause)\n"
+	"  -v, show version information\n"
+	"  -h, show this help message\n";
+
+static void
+show_usage(char *progname)
+{
+	fprintf(stdout, "conntrackdctl utility to interact with conntrackd, v%s\n", VERSION);
+	fprintf(stdout, "Usage: %s [options]\n\n", progname);
+	fprintf(stdout, "%s\n", usage_client_commands);
+}
+
+static void
+show_version(void)
+{
+	fprintf(stdout, "conntrackdctl utilty to interact with conntrackd, v%s. ", VERSION);
+	fprintf(stdout, "Licensed under GPLv2.\n");
+	fprintf(stdout, "(C) 2006-2009 Pablo Neira Ayuso ");
+	fprintf(stdout, "<pablo@netfilter.org>\n");
+}
+
+static int
+set_action_by_table(int i, int argc, char *argv[],
+		    int ct_action, int exp_action, int dfl_action, int *action)
+{
+	if (i+1 < argc && argv[i+1][0] != '-') {
+		if (strncmp(argv[i+1], "ct", strlen(argv[i+1])) == 0) {
+			*action = ct_action;
+			i++;
+		} else if (strncmp(argv[i+1], "expect",
+						strlen(argv[i+1])) == 0) {
+			*action = exp_action;
+			i++;
+		}
+	} else
+		*action = dfl_action;
+
+	return i;
+}
+
+static void set_exec_env(void)
+{
+	umask(0177);
+	close(STDIN_FILENO);
+	if (chdir("/"))
+		fprintf(stderr, "WARNING: could not chdir to '/' (root): %s", strerror(errno));
+}
+
+int main(int argc, char *argv[])
+{
+	char socket_path[PATH_MAX + 1] = {};
+	int i, action = -1;
+	struct utsname u;
+	int version, major, minor;
+
+	/* Check kernel version: it must be >= 2.6.18 */
+	if (uname(&u) == -1) {
+		fprintf(stderr, "ERROR: can't retrieve kernel version via uname()");
+		exit(EXIT_FAILURE);
+	}
+	sscanf(u.release, "%d.%d.%d", &version, &major, &minor);
+	if (version < 2 && major < 6 && minor < 18) {
+		fprintf(stderr, "ERROR: Linux kernel version must be >= 2.6.18");
+		exit(EXIT_FAILURE);
+	}
+
+	for (i=1; i<argc; i++) {
+		switch(argv[i][1]) {
+		case 'c':
+			i = set_action_by_table(i, argc, argv,
+						CT_COMMIT, EXP_COMMIT,
+						ALL_COMMIT, &action);
+			break;
+		case 'i':
+			i = set_action_by_table(i, argc, argv,
+						CT_DUMP_INTERNAL,
+						EXP_DUMP_INTERNAL,
+						CT_DUMP_INTERNAL, &action);
+			break;
+		case 'e':
+			i = set_action_by_table(i, argc, argv,
+						CT_DUMP_EXTERNAL,
+						EXP_DUMP_EXTERNAL,
+						CT_DUMP_EXTERNAL, &action);
+			break;
+		case 'F':
+			i = set_action_by_table(i, argc, argv,
+						CT_FLUSH_MASTER,
+						EXP_FLUSH_MASTER,
+						ALL_FLUSH_MASTER, &action);
+			break;
+		case 'f':
+			if (i+1 < argc && argv[i+1][0] != '-') {
+				if (strncmp(argv[i+1], "internal",
+					    strlen(argv[i+1])) == 0) {
+					action = CT_FLUSH_INT_CACHE;
+					i++;
+				} else if (strncmp(argv[i+1], "external",
+						 strlen(argv[i+1])) == 0) {
+					action = CT_FLUSH_EXT_CACHE;
+					i++;
+				} else {
+					fprintf(stderr, "unknown parameter `%s' "
+					     "for option `-f'", argv[i + 1]);
+					exit(EXIT_FAILURE);
+				}
+			} else {
+				/* default to general flushing */
+				action = ALL_FLUSH_CACHE;
+			}
+			break;
+		case 'R':
+			i = set_action_by_table(i, argc, argv,
+						CT_RESYNC_MASTER,
+						EXP_RESYNC_MASTER,
+						ALL_RESYNC_MASTER, &action);
+			break;
+		case 'B':
+			action = SEND_BULK;
+			break;
+		case 't':
+			action = RESET_TIMERS;
+			break;
+		case 'k':
+			action = KILL;
+			break;
+		case 's':
+			/* we've got a parameter */
+			if (i+1 < argc && argv[i+1][0] != '-') {
+				if (strncmp(argv[i+1], "network",
+					    strlen(argv[i+1])) == 0) {
+					action = STATS_NETWORK;
+					i++;
+				} else if (strncmp(argv[i+1], "cache",
+						 strlen(argv[i+1])) == 0) {
+					action = STATS_CACHE;
+					i++;
+				} else if (strncmp(argv[i+1], "runtime",
+						 strlen(argv[i+1])) == 0) {
+					action = STATS_RUNTIME;
+					i++;
+				} else if (strncmp(argv[i+1], "multicast",
+						 strlen(argv[i+1])) == 0) {
+					fprintf(stderr, "WARNING: use `link' "
+					     "instead of `multicast' as "
+					     "parameter.");
+					action = STATS_LINK;
+					i++;
+				} else if (strncmp(argv[i+1], "link",
+						 strlen(argv[i+1])) == 0) {
+					action = STATS_LINK;
+					i++;
+				} else if (strncmp(argv[i+1], "rsqueue",
+						strlen(argv[i+1])) == 0) {
+					action = STATS_RSQUEUE;
+					i++;
+				} else if (strncmp(argv[i+1], "process",
+						 strlen(argv[i+1])) == 0) {
+					action = STATS_PROCESS;
+					i++;
+				} else if (strncmp(argv[i+1], "queue",
+						strlen(argv[i+1])) == 0) {
+					action = STATS_QUEUE;
+					i++;
+				} else if (strncmp(argv[i+1], "ct",
+						strlen(argv[i+1])) == 0) {
+					action = STATS;
+					i++;
+				} else if (strncmp(argv[i+1], "expect",
+						strlen(argv[i+1])) == 0) {
+					action = EXP_STATS;
+					i++;
+				} else {
+					fprintf(stderr, "ERROR: unknown parameter `%s' "
+					     "for option `-s'", argv[i + 1]);
+					exit(EXIT_FAILURE);
+				}
+			} else {
+				/* default to general statistics */
+				action = STATS;
+			}
+			break;
+		case 'n':
+			action = REQUEST_DUMP;
+			break;
+		case 'x':
+			if (action == CT_DUMP_INTERNAL)
+				action = CT_DUMP_INT_XML;
+			else if (action == CT_DUMP_EXTERNAL)
+				action = CT_DUMP_EXT_XML;
+			else if (action == EXP_DUMP_INTERNAL)
+				action = EXP_DUMP_INT_XML;
+			else if (action == EXP_DUMP_EXTERNAL)
+				action = EXP_DUMP_EXT_XML;
+			else {
+				show_usage(argv[0]);
+				fprintf(stderr,  "ERROR: invalid parameters");
+				exit(EXIT_FAILURE);
+
+			}
+			break;
+                case 'u':
+			if (++i < argc) {
+				if (strlen(argv[i]) > PATH_MAX) {
+					fprintf(stderr, "WARNING: path to Unix socket too long. "
+						"Cutting it down to %d characters\n", PATH_MAX);
+				}
+				snprintf(socket_path, PATH_MAX, "%s", argv[i]);
+				break;
+			}
+			show_usage(argv[0]);
+			fprintf(stderr, "ERROR: missing Unix socket path\n");
+			exit(EXIT_FAILURE);
+			break;
+
+		case 'v':
+			show_version();
+			exit(EXIT_SUCCESS);
+		case 'h':
+			show_usage(argv[0]);
+			exit(EXIT_SUCCESS);
+		default:
+			show_usage(argv[0]);
+			fprintf(stderr, "ERROR: unknown option: %s\n", argv[i]);
+			exit(EXIT_FAILURE);
+		}
+	}
+
+	if (!socket_path[0])
+		strcpy(socket_path, DEFAULT_SOCKET_PATH);
+
+	set_exec_env();
+
+	if (do_local_request(action, socket_path) == -1) {
+		fprintf(stderr, "ERROR: unable to contact conntrackd. Check if it is running, "
+			"permissions, and the Unix socket path is right (tried '%s')\n",
+			socket_path);
+		exit(EXIT_FAILURE);
+	}
+	exit(EXIT_SUCCESS);
+}
diff --git a/src/local.c b/src/local.c
index 2b67885..dfb0d4c 100644
--- a/src/local.c
+++ b/src/local.c
@@ -91,7 +91,7 @@ int do_local_server_step(struct local_server *server, void *data,
 	return 0;
 }
 
-int local_client_create(struct local_conf *conf)
+static int local_client_create(const char *socket_path)
 {
 	socklen_t len;
 	struct sockaddr_un local;
@@ -101,7 +101,7 @@ int local_client_create(struct local_conf *conf)
 		return -1;
 
 	local.sun_family = AF_UNIX;
-	strcpy(local.sun_path, conf->path);
+	strcpy(local.sun_path, socket_path);
 	len = strlen(local.sun_path) + sizeof(local.sun_family);
 
 	if (connect(fd, (struct sockaddr *) &local, len) == -1) {
@@ -112,12 +112,12 @@ int local_client_create(struct local_conf *conf)
 	return fd;
 }
 
-void local_client_destroy(int fd)
+static void local_client_destroy(int fd)
 {
 	close(fd);
 }
 
-int do_local_client_step(int fd, void (*process)(char *buf))
+static int do_local_client_step(int fd, void (*process)(char *buf))
 {
 	char buf[1024];
 
@@ -132,18 +132,16 @@ int do_local_client_step(int fd, void (*process)(char *buf))
 	return 0;
 }
 
-void local_step(char *buf)
+static void local_step(char *buf)
 {
 	printf("%s", buf);
 }
 
-int do_local_request(int request,
-		     struct local_conf *conf,
-		     void (*step)(char *buf))
+int do_local_request(int request, const char *socket_path)
 {
 	int fd, ret;
 
-	fd = local_client_create(conf);
+	fd = local_client_create(socket_path);
 	if (fd == -1)
 		return -1;
 
@@ -151,7 +149,7 @@ int do_local_request(int request,
 	if (ret == -1)
 		goto err1;
 
-	do_local_client_step(fd, step);
+	do_local_client_step(fd, local_step);
 
 	local_client_destroy(fd);
 
diff --git a/src/main.c b/src/main.c
index 31e0eed..a4e7dd4 100644
--- a/src/main.c
+++ b/src/main.c
@@ -43,29 +43,12 @@ static const char usage_general_commands[] =
 	"  -v, display conntrackd version\n"
 	"  -h, display this help information\n";
 
-static const char usage_client_commands[] =
-	"Client mode commands:\n"
-	"  -c [ct|expect], commit external cache to conntrack table\n"
-	"  -f [internal|external], flush internal and external cache\n"
-	"  -F [ct|expect], flush kernel conntrack table\n"
-	"  -i [ct|expect], display content of the internal cache\n"
-	"  -e [ct|expect], display the content of the external cache\n"
-	"  -k, kill conntrack daemon\n"
-	"  -s  [network|cache|runtime|link|rsqueue|queue|ct|expect], "
-		"dump statistics\n"
-	"  -R [ct|expect], resync with kernel conntrack table\n"
-	"  -n, request resync with other node (only FT-FW and NOTRACK modes)\n"
-	"  -B, force a bulk send to other replica firewalls\n"
-	"  -x, dump cache in XML format (requires -i or -e)\n"
-	"  -t, reset the kernel timeout (see PurgeTimeout clause)\n";
-
 static void
 show_usage(char *progname)
 {
 	fprintf(stdout, "Connection tracking userspace daemon v%s\n", VERSION);
 	fprintf(stdout, "Usage: %s [commands] [options]\n\n", progname);
 	fprintf(stdout, "%s\n", usage_general_commands);
-	fprintf(stdout, "%s\n", usage_client_commands);
 }
 
 static void
@@ -77,39 +60,6 @@ show_version(void)
 	fprintf(stdout, "<pablo@netfilter.org>\n");
 }
 
-static void
-set_operation_mode(int *current, int want, char *argv[])
-{
-	if (*current == NOT_SET) {
-		*current = want;
-		return;
-	}
-	if (*current != want) {
-		show_usage(argv[0]);
-		dlog(LOG_ERR, "Invalid parameters");
-		exit(EXIT_FAILURE);
-	}
-}
-
-static int
-set_action_by_table(int i, int argc, char *argv[],
-		    int ct_action, int exp_action, int dfl_action, int *action)
-{
-	if (i+1 < argc && argv[i+1][0] != '-') {
-		if (strncmp(argv[i+1], "ct", strlen(argv[i+1])) == 0) {
-			*action = ct_action;
-			i++;
-		} else if (strncmp(argv[i+1], "expect",
-						strlen(argv[i+1])) == 0) {
-			*action = exp_action;
-			i++;
-		}
-	} else
-		*action = dfl_action;
-
-	return i;
-}
-
 static void
 do_chdir(const char *d)
 {
@@ -121,8 +71,7 @@ do_chdir(const char *d)
 int main(int argc, char *argv[])
 {
 	char config_file[PATH_MAX + 1] = {};
-	int ret, i, action = -1;
-	int type = 0;
+	int ret, i;
 	struct utsname u;
 	int version, major, minor;
 
@@ -140,29 +89,8 @@ int main(int argc, char *argv[])
 	for (i=1; i<argc; i++) {
 		switch(argv[i][1]) {
 		case 'd':
-			set_operation_mode(&type, DAEMON, argv);
 			CONFIG(running_mode) = DAEMON;
 			break;
-		case 'c':
-			set_operation_mode(&type, REQUEST, argv);
-			i = set_action_by_table(i, argc, argv,
-						CT_COMMIT, EXP_COMMIT,
-						ALL_COMMIT, &action);
-			break;
-		case 'i':
-			set_operation_mode(&type, REQUEST, argv);
-			i = set_action_by_table(i, argc, argv,
-						CT_DUMP_INTERNAL,
-						EXP_DUMP_INTERNAL,
-						CT_DUMP_INTERNAL, &action);
-			break;
-		case 'e':
-			set_operation_mode(&type, REQUEST, argv);
-			i = set_action_by_table(i, argc, argv,
-						CT_DUMP_EXTERNAL,
-						EXP_DUMP_EXTERNAL,
-						CT_DUMP_EXTERNAL, &action);
-			break;
 		case 'C':
 			if (++i < argc) {
 				if (strlen(argv[i]) > PATH_MAX) {
@@ -176,136 +104,26 @@ int main(int argc, char *argv[])
 			show_usage(argv[0]);
 			dlog(LOG_ERR, "Missing config filename");
 			break;
-		case 'F':
-			set_operation_mode(&type, REQUEST, argv);
-			i = set_action_by_table(i, argc, argv,
-						CT_FLUSH_MASTER,
-						EXP_FLUSH_MASTER,
-						ALL_FLUSH_MASTER, &action);
-			break;
-		case 'f':
-			set_operation_mode(&type, REQUEST, argv);
-			if (i+1 < argc && argv[i+1][0] != '-') {
-				if (strncmp(argv[i+1], "internal",
-					    strlen(argv[i+1])) == 0) {
-					action = CT_FLUSH_INT_CACHE;
-					i++;
-				} else if (strncmp(argv[i+1], "external",
-						 strlen(argv[i+1])) == 0) {
-					action = CT_FLUSH_EXT_CACHE;
-					i++;
-				} else {
-					dlog(LOG_ERR, "unknown parameter `%s' "
-					     "for option `-f'", argv[i + 1]);
-					exit(EXIT_FAILURE);
-				}
-			} else {
-				/* default to general flushing */
-				action = ALL_FLUSH_CACHE;
-			}
-			break;
-		case 'R':
-			set_operation_mode(&type, REQUEST, argv);
-			i = set_action_by_table(i, argc, argv,
-						CT_RESYNC_MASTER,
-						EXP_RESYNC_MASTER,
-						ALL_RESYNC_MASTER, &action);
-			break;
-		case 'B':
-			set_operation_mode(&type, REQUEST, argv);
-			action = SEND_BULK;
-			break;
-		case 't':
-			set_operation_mode(&type, REQUEST, argv);
-			action = RESET_TIMERS;
-			break;
-		case 'k':
-			set_operation_mode(&type, REQUEST, argv);
-			action = KILL;
-			break;
-		case 's':
-			set_operation_mode(&type, REQUEST, argv);
-			/* we've got a parameter */
-			if (i+1 < argc && argv[i+1][0] != '-') {
-				if (strncmp(argv[i+1], "network",
-					    strlen(argv[i+1])) == 0) {
-					action = STATS_NETWORK;
-					i++;
-				} else if (strncmp(argv[i+1], "cache",
-						 strlen(argv[i+1])) == 0) {
-					action = STATS_CACHE;
-					i++;
-				} else if (strncmp(argv[i+1], "runtime",
-						 strlen(argv[i+1])) == 0) {
-					action = STATS_RUNTIME;
-					i++;
-				} else if (strncmp(argv[i+1], "multicast",
-						 strlen(argv[i+1])) == 0) {
-					dlog(LOG_WARNING, "use `link' "
-					     "instead of `multicast' as "
-					     "parameter.");
-					action = STATS_LINK;
-					i++;
-				} else if (strncmp(argv[i+1], "link",
-						 strlen(argv[i+1])) == 0) {
-					action = STATS_LINK;
-					i++;
-				} else if (strncmp(argv[i+1], "rsqueue",
-						strlen(argv[i+1])) == 0) {
-					action = STATS_RSQUEUE;
-					i++;
-				} else if (strncmp(argv[i+1], "process",
-						 strlen(argv[i+1])) == 0) {
-					action = STATS_PROCESS;
-					i++;
-				} else if (strncmp(argv[i+1], "queue",
-						strlen(argv[i+1])) == 0) {
-					action = STATS_QUEUE;
-					i++;
-				} else if (strncmp(argv[i+1], "ct",
-						strlen(argv[i+1])) == 0) {
-					action = STATS;
-					i++;
-				} else if (strncmp(argv[i+1], "expect",
-						strlen(argv[i+1])) == 0) {
-					action = EXP_STATS;
-					i++;
-				} else {
-					dlog(LOG_ERR, "unknown parameter `%s' "
-					     "for option `-s'", argv[i + 1]);
-					exit(EXIT_FAILURE);
-				}
-			} else {
-				/* default to general statistics */
-				action = STATS;
-			}
-			break;
-		case 'n':
-			set_operation_mode(&type, REQUEST, argv);
-			action = REQUEST_DUMP;
-			break;
-		case 'x':
-			if (action == CT_DUMP_INTERNAL)
-				action = CT_DUMP_INT_XML;
-			else if (action == CT_DUMP_EXTERNAL)
-				action = CT_DUMP_EXT_XML;
-			else if (action == EXP_DUMP_INTERNAL)
-				action = EXP_DUMP_INT_XML;
-			else if (action == EXP_DUMP_EXTERNAL)
-				action = EXP_DUMP_EXT_XML;
-			else {
-				show_usage(argv[0]);
-				dlog(LOG_ERR,  "Invalid parameters");
-				exit(EXIT_FAILURE);
-
-			}
-			break;
 		case 'v':
 			show_version();
 			exit(EXIT_SUCCESS);
 		case 'h':
 			show_usage(argv[0]);
 			exit(EXIT_SUCCESS);
+		case 'c':
+		case 'f':
+		case 'F':
+		case 'i':
+		case 'e':
+		case 'k':
+		case 's':
+		case 'R':
+		case 'n':
+		case 'B':
+		case 'x':
+		case 't':
+			dlog(LOG_WARNING, "ignored option, use conntrackdctl instead");
+			break;
 		default:
 			show_usage(argv[0]);
 			dlog(LOG_ERR, "Unknown option: %s", argv[i]);
@@ -333,15 +151,6 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	if (type == REQUEST) {
-		if (do_local_request(action, &conf.local, local_step) == -1) {
-			dlog(LOG_ERR, "can't connect: is conntrackd "
-			     "running? appropriate permissions?");
-			exit(EXIT_FAILURE);
-		}
-		exit(EXIT_SUCCESS);
-	}
-
 	/*
 	 * Setting up logging
 	 */
@@ -377,7 +186,7 @@ int main(int argc, char *argv[])
 	sd_ct_watchdog_init();
 
 	/* Daemonize conntrackd */
-	if (type == DAEMON) {
+	if (CONFIG(running_mode) == DAEMON) {
 		pid_t pid;
 
 		if ((pid = fork()) == -1) {

