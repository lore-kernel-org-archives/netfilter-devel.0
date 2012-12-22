From: Eric Leblond <eric@regit.org>
Subject: [PATCH 2/2] Add GRAPHITE output module.
Date: Sat, 22 Dec 2012 12:28:31 +0100
Message-ID: <1356175711-13254-3-git-send-email-eric@regit.org>
References: <1356175711-13254-1-git-send-email-eric@regit.org>
Cc: Eric Leblond <eric@regit.org>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:54712 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab2LVL3W (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 22 Dec 2012 06:29:22 -0500
In-Reply-To: <1356175711-13254-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Graphite is a web application which provide real-time visualization
and storage of numeric time-series data. This patch adds a module
named GRAPHITE which sends NFACCT accounting data to a graphite
server.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 output/Makefile.am             |    6 +-
 output/ulogd_output_GRAPHITE.c |  246 ++++++++++++++++++++++++++++++++++++++++
 ulogd.conf.in                  |   10 ++
 3 files changed, 261 insertions(+), 1 deletion(-)
 create mode 100644 output/ulogd_output_GRAPHITE.c

diff --git a/output/Makefile.am b/output/Makefile.am
index fe0a19c..17427d0 100644
--- a/output/Makefile.am
+++ b/output/Makefile.am
@@ -6,7 +6,8 @@ SUBDIRS= pcap mysql pgsql sqlite3 dbi
 
 pkglib_LTLIBRARIES = ulogd_output_LOGEMU.la ulogd_output_SYSLOG.la \
 			 ulogd_output_OPRINT.la ulogd_output_GPRINT.la \
-			 ulogd_output_NACCT.la ulogd_output_XML.la
+			 ulogd_output_NACCT.la ulogd_output_XML.la \
+			 ulogd_output_GRAPHITE.la
 
 ulogd_output_GPRINT_la_SOURCES = ulogd_output_GPRINT.c
 ulogd_output_GPRINT_la_LDFLAGS = -avoid-version -module
@@ -28,3 +29,6 @@ ulogd_output_XML_la_LIBADD  = ${LIBNETFILTER_LOG_LIBS} \
 			      ${LIBNETFILTER_CONNTRACK_LIBS} \
 			      ${LIBNETFILTER_ACCT_LIBS}
 ulogd_output_XML_la_LDFLAGS = -avoid-version -module
+
+ulogd_output_GRAPHITE_la_SOURCES = ulogd_output_GRAPHITE.c
+ulogd_output_GRAPHITE_la_LDFLAGS = -avoid-version -module
diff --git a/output/ulogd_output_GRAPHITE.c b/output/ulogd_output_GRAPHITE.c
new file mode 100644
index 0000000..2b58f7f
--- /dev/null
+++ b/output/ulogd_output_GRAPHITE.c
@@ -0,0 +1,246 @@
+/* ulogd_GRAPHITE.c
+ *
+ * ulogd output target to feed data to a graphite system
+ *
+ * (C) 2012 by Eric Leblond <eric@regit.org>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2
+ *  as published by the Free Software Foundation
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+#include <limits.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <string.h>
+#include <errno.h>
+#include <inttypes.h>
+#include <time.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <netdb.h>
+#include <ulogd/ulogd.h>
+#include <ulogd/conffile.h>
+
+
+enum {
+	KEY_SUM_NAME,
+	KEY_SUM_PKTS,
+	KEY_SUM_BYTES,
+	KEY_OOB_TIME_SEC,
+};
+
+
+static struct ulogd_key graphite_inp[] = {
+	[KEY_SUM_NAME] {
+		.type	= ULOGD_RET_STRING,
+		.name	= "sum.name",
+	},
+	[KEY_SUM_PKTS] {
+		.type	= ULOGD_RET_UINT64,
+		.name	= "sum.pkts",
+	},
+	[KEY_SUM_BYTES] {
+		.type	= ULOGD_RET_UINT64,
+		.name	= "sum.bytes",
+	},
+	[KEY_OOB_TIME_SEC] {
+		.type = ULOGD_RET_UINT32,
+		.name = "oob.time.sec",
+	},
+};
+
+
+static struct config_keyset graphite_kset = {
+	.num_ces = 3,
+	.ces = {
+		{
+			.key = "host",
+			.type = CONFIG_TYPE_STRING,
+			.options = CONFIG_OPT_NONE,
+		},
+		{
+			.key = "port",
+			.type = CONFIG_TYPE_STRING,
+			.options = CONFIG_OPT_NONE,
+		},
+		{
+			.key = "prefix",
+			.type = CONFIG_TYPE_STRING,
+			.options = CONFIG_OPT_NONE,
+		},
+	},
+};
+
+#define host_ce(x)	(x->ces[0])
+#define port_ce(x)	(x->ces[1])
+#define prefix_ce(x)	(x->ces[2])
+
+struct graphite_instance {
+	int sck;
+};
+
+static int _connect_graphite(struct ulogd_pluginstance *pi)
+{
+	struct graphite_instance *li = (struct graphite_instance *) &pi->private;
+	char *host;
+	char * port;
+	struct addrinfo hints;
+	struct addrinfo *result, *rp;
+	int sfd, s;
+
+	ulogd_log(ULOGD_DEBUG, "connecting to graphite\n");
+
+	memset(&hints, 0, sizeof(struct addrinfo));
+	hints.ai_family = AF_UNSPEC;
+	hints.ai_socktype = SOCK_STREAM;
+	hints.ai_flags = 0;
+	hints.ai_protocol = 0;
+
+	host = host_ce(pi->config_kset).u.string;
+	port = port_ce(pi->config_kset).u.string;
+	s = getaddrinfo(host, port, &hints, &result);
+	if (s != 0) {
+		ulogd_log(ULOGD_ERROR, "getaddrinfo: %s\n", gai_strerror(s));
+		return -1;
+	}
+
+	for (rp = result; rp != NULL; rp = rp->ai_next) {
+		int on = 1;
+
+		sfd = socket(rp->ai_family, rp->ai_socktype,
+				rp->ai_protocol);
+		if (sfd == -1)
+			continue;
+
+		setsockopt(sfd, SOL_SOCKET, SO_REUSEADDR,
+			   (char *) &on, sizeof(on));
+
+		if (connect(sfd, rp->ai_addr, rp->ai_addrlen) != -1)
+			break;
+
+		close(sfd);
+	}
+
+	freeaddrinfo(result);
+
+	if (rp == NULL) {
+		ulogd_log(ULOGD_ERROR, "Could not connect\n");
+		return -1;
+	}
+
+	li->sck = sfd;
+
+	return 0;
+}
+
+static int _output_graphite(struct ulogd_pluginstance *upi)
+{
+	struct graphite_instance *li = (struct graphite_instance *) &upi->private;
+	struct ulogd_key *inp = upi->input.keys;
+	static char buf[256];
+	int ret;
+
+	time_t now;
+	int msg_size = 0;
+
+	if (ikey_get_u32(&inp[KEY_OOB_TIME_SEC]))
+		now = (time_t) ikey_get_u32(&inp[KEY_OOB_TIME_SEC]);
+	else
+		now = time(NULL);
+
+	msg_size = snprintf(buf, sizeof(buf), "%s.%s.pkts %" PRIu64
+			    " %lu\n%s.%s.bytes %" PRIu64 " %lu\n",
+		 prefix_ce(upi->config_kset).u.string,
+		 (char *)ikey_get_ptr(&inp[KEY_SUM_NAME]),
+		 ikey_get_u64(&inp[KEY_SUM_PKTS]),
+		 now,
+		 prefix_ce(upi->config_kset).u.string,
+		 (char *)ikey_get_ptr(&inp[KEY_SUM_NAME]),
+		 ikey_get_u64(&inp[KEY_SUM_BYTES]),
+		 now
+		 );
+	if (msg_size == -1) {
+		ulogd_log(ULOGD_ERROR, "Could not create message\n");
+		return ULOGD_IRET_ERR;
+	}
+	ret = send(li->sck, buf, msg_size, MSG_NOSIGNAL);
+	if (ret != msg_size) {
+		ulogd_log(ULOGD_ERROR, "Failure sending message\n");
+		if (ret == -1) {
+			return _connect_graphite(upi);
+		}
+	}
+
+	return ULOGD_IRET_OK;
+}
+
+static int start_graphite(struct ulogd_pluginstance *pi)
+{
+	char *host;
+	char *port;
+
+	ulogd_log(ULOGD_DEBUG, "starting graphite\n");
+
+	host = host_ce(pi->config_kset).u.string;
+	if (host == NULL)
+		return -1;
+	port = port_ce(pi->config_kset).u.string;
+	if (port == NULL)
+		return -1;
+	return _connect_graphite(pi);
+}
+
+static int fini_graphite(struct ulogd_pluginstance *pi) {
+	struct graphite_instance *li = (struct graphite_instance *) &pi->private;
+
+	close(li->sck);
+	li->sck = 0;
+
+	return 0;
+}
+
+static int configure_graphite(struct ulogd_pluginstance *pi,
+			    struct ulogd_pluginstance_stack *stack)
+{
+	ulogd_log(ULOGD_DEBUG, "parsing config file section %s\n", pi->id);
+	return config_parse_file(pi->id, pi->config_kset);
+}
+
+static struct ulogd_plugin graphite_plugin = {
+	.name = "GRAPHITE",
+	.input = {
+		.keys = graphite_inp,
+		.num_keys = ARRAY_SIZE(graphite_inp),
+		.type = ULOGD_DTYPE_SUM,
+	},
+	.output = {
+		.type = ULOGD_DTYPE_SINK,
+	},
+	.config_kset 	= &graphite_kset,
+	.priv_size 	= sizeof(struct graphite_instance),
+
+	.configure	= &configure_graphite,
+	.start	 	= &start_graphite,
+	.stop	 	= &fini_graphite,
+
+	.interp 	= &_output_graphite,
+	.version	= VERSION,
+};
+
+void __attribute__ ((constructor)) init(void);
+
+void init(void)
+{
+	ulogd_register_plugin(&graphite_plugin);
+}
diff --git a/ulogd.conf.in b/ulogd.conf.in
index c630b88..6aff802 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -49,6 +49,7 @@ plugin="@pkglibdir@/ulogd_output_GPRINT.so"
 #plugin="@pkglibdir@/ulogd_output_DBI.so"
 plugin="@pkglibdir@/ulogd_raw2packet_BASE.so"
 plugin="@pkglibdir@/ulogd_inpflow_NFACCT.so"
+plugin="@pkglibdir@/ulogd_output_GRAPHITE.so"
 
 # this is a stack for logging packet send by system via LOGEMU
 #stack=log1:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,emu1:LOGEMU
@@ -80,6 +81,9 @@ plugin="@pkglibdir@/ulogd_inpflow_NFACCT.so"
 # this is a stack for accounting-based logging via XML
 #stack=acct1:NFACCT,xml1:XML
 
+# this is a stack for accounting-based logging to a Graphite server
+#stack=acct1:NFACCT,graphite1:GRAPHITE
+
 # this is a stack for NFLOG packet-based logging to PCAP
 #stack=log2:NFLOG,base1:BASE,pcap1:PCAP
 
@@ -280,3 +284,9 @@ pollinterval = 2
 # Set timestamp (default is 0, which means not set). This timestamp can be
 # interpreted by the output plugin.
 #timestamp = 1
+
+[graphite1]
+host="127.0.0.1"
+port="2003"
+# Prefix of data name sent to graphite server
+prefix="netfilter.nfacct"
-- 
1.7.10.4

