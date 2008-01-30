From: heitzenberger@astaro.com
Subject: [ULOGD RFC 01/30] Add NACCT output plugin
Date: Wed, 30 Jan 2008 19:58:48 +0100
Message-ID: <20080130190126.478113568@kruemel.intranet.astaro.de>
References: <20080130185847.693274384@kruemel.intranet.astaro.de>
Cc: holger@eitzenberger.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-46.dex002.intermedia.net ([64.78.21.140]:58645 "EHLO
	dhost002-46.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751092AbYA3TBk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:01:40 -0500
Content-Disposition: inline; filename=ulogd-NACCT-plugin.diff
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: ulogd-netfilter/output/Makefile.am
===================================================================
--- ulogd-netfilter.orig/output/Makefile.am
+++ ulogd-netfilter/output/Makefile.am
@@ -4,7 +4,8 @@ LIBS=""
 SUBDIRS= pcap mysql pgsql sqlite3
 
 pkglib_LTLIBRARIES = ulogd_output_LOGEMU.la ulogd_output_SYSLOG.la \
-		     ulogd_output_OPRINT.la ulogd_output_IPFIX.la
+		     ulogd_output_OPRINT.la ulogd_output_IPFIX.la \
+			 ulogd_output_NACCT.la
 
 ulogd_output_LOGEMU_la_SOURCES = ulogd_output_LOGEMU.c
 ulogd_output_LOGEMU_la_LDFLAGS = -module
@@ -18,3 +19,5 @@ ulogd_output_OPRINT_la_LDFLAGS = -module
 ulogd_output_IPFIX_la_SOURCES = ulogd_output_IPFIX.c
 ulogd_output_IPFIX_la_LDFLAGS = -module
 
+ulogd_output_NACCT_la_SOURCES = ulogd_output_NACCT.c
+ulogd_output_NACCT_la_LDFLAGS = -module
Index: ulogd-netfilter/output/ulogd_output_NACCT.c
===================================================================
--- /dev/null
+++ ulogd-netfilter/output/ulogd_output_NACCT.c
@@ -0,0 +1,206 @@
+/*
+ * ulogd_outpout_NACCT.c
+ *
+ * ulogd output plugin for accounting which tries to stay mostly
+ * compatible with nacct output.
+ *
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 
+ * as published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ * Holger Eitzenberger <holger@eitzenberger.org>  Astaro AG 2008
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+#include <arpa/inet.h>
+#include <ulogd/ulogd.h>
+#include <ulogd/conffile.h>
+
+#define NACCT_FILE_DEFAULT	"/var/log/nacctdata.log"
+
+#define HIPQUAD(addr) \
+        ((unsigned char *)&addr)[3], \
+        ((unsigned char *)&addr)[2], \
+        ((unsigned char *)&addr)[1], \
+        ((unsigned char *)&addr)[0]
+
+/* config accessors (lazy me...) */
+#define NACCT_CFG_FILE(pi)	((pi)->config_kset->ces[0].u.string)
+#define NACCT_CFG_SYNC(pi)	((pi)->config_kset->ces[1].u.value)
+
+#define KEY(pi,idx)		((pi)->input.keys[(idx)].u.source)
+
+/* input keys */
+#define KEY_IP_SADDR(pi)		KEY(pi, 0)
+#define KEY_IP_DADDR(pi)		KEY(pi, 1)
+#define KEY_IP_PROTO(pi)		KEY(pi, 2)
+#define KEY_L4_SPORT(pi)		KEY(pi, 3)
+#define KEY_L4_DPORT(pi)		KEY(pi, 4)
+#define KEY_RAW_PKTLEN(pi)		KEY(pi, 5)
+#define KEY_RAW_PKTCNT(pi)		KEY(pi, 6)
+#define KEY_ICMP_CODE(pi)		KEY(pi, 7)
+#define KEY_ICMP_TYPE(pi)		KEY(pi, 8)
+#define KEY_FLOW_START(pi)		KEY(pi, 11)
+#define KEY_FLOW_END(pi)		KEY(pi, 13)
+
+struct nacct_priv {
+	FILE *of;
+};
+
+
+static int
+nacct_interp(struct ulogd_pluginstance *pi)
+{
+	struct nacct_priv *priv = (struct nacct_priv *)&pi->private;
+	static char buf[80];
+
+	/* try to be as close to nacct as possible.  Instead of nacct's
+	   'timestamp' value use 'flow.end.sec' */
+	if (KEY_IP_PROTO(pi)->u.value.ui8 == IPPROTO_ICMP) {
+		snprintf(buf, sizeof(buf),
+				 "%u\t%u\t%u.%u.%u.%u\t%u\t%u.%u.%u.%u\t%u\t%u\t%u",
+				 KEY_FLOW_END(pi)->u.value.ui32,
+				 KEY_IP_PROTO(pi)->u.value.ui8,
+				 HIPQUAD(KEY_IP_SADDR(pi)->u.value.ui32),
+				 KEY_ICMP_TYPE(pi)->u.value.ui8,
+				 HIPQUAD(KEY_IP_DADDR(pi)->u.value.ui32),
+				 KEY_ICMP_CODE(pi)->u.value.ui8,
+				 KEY_RAW_PKTCNT(pi)->u.value.ui32,
+				 KEY_RAW_PKTLEN(pi)->u.value.ui32);
+	} else {
+		snprintf(buf, sizeof(buf),
+				 "%u\t%u\t%u.%u.%u.%u\t%u\t%u.%u.%u.%u\t%u\t%u\t%u",
+				 KEY_FLOW_END(pi)->u.value.ui32,
+				 KEY_IP_PROTO(pi)->u.value.ui8,
+				 HIPQUAD(KEY_IP_SADDR(pi)->u.value.ui32),
+				 KEY_L4_SPORT(pi)->u.value.ui8,
+				 HIPQUAD(KEY_IP_DADDR(pi)->u.value.ui32),
+				 KEY_L4_DPORT(pi)->u.value.ui8,
+				 KEY_RAW_PKTCNT(pi)->u.value.ui32,
+				 KEY_RAW_PKTLEN(pi)->u.value.ui32);
+	}
+
+	fprintf(priv->of, "%s\n", buf);
+
+	if (NACCT_CFG_SYNC(pi) != 0)
+		fflush(priv->of);
+
+	return 0;
+}
+
+static struct config_keyset nacct_kset = {
+	.num_ces = 2,
+	.ces = {
+		{
+			.key = "file", 
+			.type = CONFIG_TYPE_STRING, 
+			.options = CONFIG_OPT_NONE,
+			.u = {.string = NACCT_FILE_DEFAULT },
+		},
+		{
+			.key = "sync",
+			.type = CONFIG_TYPE_INT,
+			.options = CONFIG_OPT_NONE,
+			.u = { .value = 0 },
+		},
+	},
+};
+
+static void
+sighup_handler_print(struct ulogd_pluginstance *pi, int signal)
+{
+	struct nacct_priv *oi = (struct nacct_priv *)&pi->private;
+
+	switch (signal) {
+	case SIGHUP:
+	{
+		ulogd_log(ULOGD_NOTICE, "NACCT: reopening logfile\n");
+		fclose(oi->of);
+		oi->of = fopen(NACCT_CFG_FILE(pi), "a");
+		if (!oi->of)
+			ulogd_log(ULOGD_ERROR, "%s: %s\n", NACCT_CFG_FILE(pi),
+					  strerror(errno));
+		break;
+	}
+
+	default:
+		break;
+	}
+}
+
+static int
+nacct_conf(struct ulogd_pluginstance *pi,
+		   struct ulogd_pluginstance_stack *stack)
+{
+	int ret;
+
+	if ((ret = ulogd_wildcard_inputkeys(pi)) < 0)
+		return ret;
+
+	if ((ret = config_parse_file(pi->id, pi->config_kset)) < 0)
+		return ret;
+
+	return 0;
+}
+
+static int
+nacct_init(struct ulogd_pluginstance *pi)
+{
+	struct nacct_priv *op = (struct nacct_priv *)&pi->private;
+
+	if ((op->of = fopen(NACCT_CFG_FILE(pi), "a")) == NULL) {
+		ulogd_log(ULOGD_FATAL, "%s: %s\n", 
+				  NACCT_CFG_FILE(pi), strerror(errno));
+		return -1;
+	}		
+	return 0;
+}
+
+static int
+nacct_fini(struct ulogd_pluginstance *pi)
+{
+	struct nacct_priv *op = (struct nacct_priv *)&pi->private;
+
+	if (op->of != stdout)
+		fclose(op->of);
+
+	return 0;
+}
+
+static struct ulogd_plugin nacct_plugin = {
+	.name = "NACCT", 
+	.input = {
+		.type = ULOGD_DTYPE_PACKET | ULOGD_DTYPE_FLOW,
+	},
+	.output = {
+		.type = ULOGD_DTYPE_SINK,
+	},
+	.configure = &nacct_conf,
+	.interp	= &nacct_interp,
+	.start 	= &nacct_init,
+	.stop	= &nacct_fini,
+	.signal = &sighup_handler_print,
+	.config_kset = &nacct_kset,
+	.version = ULOGD_VERSION,
+};
+
+void __attribute__ ((constructor)) init(void);
+
+void
+init(void)
+{
+	ulogd_register_plugin(&nacct_plugin);
+}

-- 
