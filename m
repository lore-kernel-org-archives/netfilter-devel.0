From: pablo@netfilter.org
Subject: [PATCH 1/3] output: add GPRINT plugin
Date: Wed, 22 Feb 2012 13:33:31 +0100
Message-ID: <1329914013-2132-2-git-send-email-pablo@netfilter.org>
References: <1329914013-2132-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50060 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065Ab2BVMdv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Feb 2012 07:33:51 -0500
In-Reply-To: <1329914013-2132-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

This patch adds GPRINT which is a generalization of OPRINT.

It display the set of key-values separated by commas. This is
the generic print that you can attach to whatever kind of
input plugin.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 output/Makefile.am           |    5 +-
 output/ulogd_output_GPRINT.c |  270 ++++++++++++++++++++++++++++++++++++++++++
 ulogd.conf.in                |    6 +
 3 files changed, 280 insertions(+), 1 deletions(-)
 create mode 100644 output/ulogd_output_GPRINT.c

diff --git a/output/Makefile.am b/output/Makefile.am
index 2ec6e8d..bb93b28 100644
--- a/output/Makefile.am
+++ b/output/Makefile.am
@@ -5,9 +5,12 @@ AM_CFLAGS = ${regular_CFLAGS} ${LIBNETFILTER_LOG_CFLAGS} \
 SUBDIRS= pcap mysql pgsql sqlite3 dbi
 
 pkglibexec_LTLIBRARIES = ulogd_output_LOGEMU.la ulogd_output_SYSLOG.la \
-			 ulogd_output_OPRINT.la \
+			 ulogd_output_OPRINT.la ulogd_output_GPRINT.la \
 			 ulogd_output_NACCT.la ulogd_output_XML.la
 
+ulogd_output_GPRINT_la_SOURCES = ulogd_output_GPRINT.c
+ulogd_output_GPRINT_la_LDFLAGS = -avoid-version -module
+
 ulogd_output_LOGEMU_la_SOURCES = ulogd_output_LOGEMU.c
 ulogd_output_LOGEMU_la_LDFLAGS = -avoid-version -module
 
diff --git a/output/ulogd_output_GPRINT.c b/output/ulogd_output_GPRINT.c
new file mode 100644
index 0000000..759a0ca
--- /dev/null
+++ b/output/ulogd_output_GPRINT.c
@@ -0,0 +1,270 @@
+/* ulogd_GPRINT.c
+ *
+ * ulogd output target for logging to a file in comma-separated key-value.
+ * This is a generalization of ulogd_GPRINT.c
+ *
+ * (C) 2000-2005 by Harald Welte <laforge@gnumonks.org>
+ * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
+ * (C) 2012 by Intra2net AG <http://www.intra2net.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2
+ *  as published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <time.h>
+#include <errno.h>
+#include <ulogd/ulogd.h>
+#include <ulogd/conffile.h>
+
+#ifndef ULOGD_GPRINT_DEFAULT
+#define ULOGD_GPRINT_DEFAULT	"/var/log/ulogd.gprint"
+#endif
+
+struct gprint_priv {
+	FILE *of;
+};
+
+enum gprint_conf {
+	GPRINT_CONF_FILENAME = 0,
+	GPRINT_CONF_SYNC,
+	GPRINT_CONF_TIMESTAMP,
+	GPRINT_CONF_MAX
+};
+
+static struct config_keyset gprint_kset = {
+	.num_ces = GPRINT_CONF_MAX,
+	.ces = {
+		[GPRINT_CONF_FILENAME] = {
+			.key = "file",
+			.type = CONFIG_TYPE_STRING,
+			.options = CONFIG_OPT_NONE,
+			.u = {.string = ULOGD_GPRINT_DEFAULT },
+		},
+		[GPRINT_CONF_SYNC] = {
+			.key = "sync",
+			.type = CONFIG_TYPE_INT,
+			.options = CONFIG_OPT_NONE,
+			.u = { .value = 0 },
+		},
+		[GPRINT_CONF_TIMESTAMP] = {
+			.key = "timestamp",
+			.type = CONFIG_TYPE_INT,
+			.options = CONFIG_OPT_NONE,
+			.u = { .value = 0 },
+		},
+	},
+};
+
+#define NIPQUAD(addr) \
+        ((unsigned char *)&addr)[0], \
+        ((unsigned char *)&addr)[1], \
+        ((unsigned char *)&addr)[2], \
+        ((unsigned char *)&addr)[3]
+
+static int gprint_interp(struct ulogd_pluginstance *upi)
+{
+	struct gprint_priv *opi = (struct gprint_priv *) &upi->private;
+	unsigned int i;
+	char buf[4096];
+	int rem = sizeof(buf), size = 0, ret;
+
+	if (upi->config_kset->ces[GPRINT_CONF_TIMESTAMP].u.value != 0) {
+		struct tm tm;
+		time_t now;
+
+		now = time(NULL);
+		localtime_r(&now, &tm);
+
+		ret = snprintf(buf+size, rem,
+				"timestamp=%.4u/%.2u/%.2u-%.2u:%.2u:%.2u,",
+				1900 + tm.tm_year, tm.tm_mon + 1, tm.tm_mday,
+				tm.tm_hour, tm.tm_min, tm.tm_sec);
+		if (ret < 0)
+			return ULOGD_IRET_OK;
+		rem -= ret;
+		size += ret;
+	}
+
+	for (i = 0; i < upi->input.num_keys; i++) {
+		struct ulogd_key *key = upi->input.keys[i].u.source;
+
+		if (!key)
+			continue;
+
+		if (!IS_VALID(*key))
+			continue;
+
+		switch (key->type) {
+		case ULOGD_RET_STRING:
+			ret = snprintf(buf+size, rem, "%s=", key->name);
+			if (ret < 0)
+				break;
+			rem -= ret;
+			size += ret;
+
+			ret = snprintf(buf+size, rem, "%s,",
+					(char *) key->u.value.ptr);
+			if (ret < 0)
+				break;
+			rem -= ret;
+			size += ret;
+			break;
+		case ULOGD_RET_BOOL:
+		case ULOGD_RET_INT8:
+		case ULOGD_RET_INT16:
+		case ULOGD_RET_INT32:
+			ret = snprintf(buf+size, rem, "%s=", key->name);
+			if (ret < 0)
+				break;
+			rem -= ret;
+			size += ret;
+
+			ret = snprintf(buf+size, rem, "%d,", key->u.value.i32);
+			if (ret < 0)
+				break;
+			rem -= ret;
+			size += ret;
+			break;
+		case ULOGD_RET_UINT8:
+		case ULOGD_RET_UINT16:
+		case ULOGD_RET_UINT32:
+		case ULOGD_RET_UINT64:
+			ret = snprintf(buf+size, rem, "%s=", key->name);
+			if (ret < 0)
+				break;
+			rem -= ret;
+			size += ret;
+
+			ret = snprintf(buf+size, rem, "%lu,",
+					key->u.value.ui64);
+			if (ret < 0)
+				break;
+			rem -= ret;
+			size += ret;
+			break;
+		case ULOGD_RET_IPADDR:
+			ret = snprintf(buf+size, rem, "%s=", key->name);
+			if (ret < 0)
+				break;
+			rem -= ret;
+			size += ret;
+
+			ret = snprintf(buf+size, rem, "%u.%u.%u.%u,",
+				NIPQUAD(key->u.value.ui32));
+			if (ret < 0)
+				break;
+			rem -= ret;
+			size += ret;
+			break;
+		default:
+			/* don't know how to interpret this key. */
+			break;
+		}
+	}
+	buf[size-1]='\0';
+	fprintf(opi->of, "%s\n", buf);
+
+	if (upi->config_kset->ces[GPRINT_CONF_SYNC].u.value != 0)
+		fflush(opi->of);
+
+	return ULOGD_IRET_OK;
+}
+
+static void sighup_handler_print(struct ulogd_pluginstance *upi, int signal)
+{
+	struct gprint_priv *oi = (struct gprint_priv *) &upi->private;
+	FILE *old = oi->of;
+
+	switch (signal) {
+	case SIGHUP:
+		ulogd_log(ULOGD_NOTICE, "GPRINT: reopening logfile\n");
+		oi->of = fopen(upi->config_kset->ces[0].u.string, "a");
+		if (!oi->of) {
+			ulogd_log(ULOGD_ERROR, "can't open GPRINT "
+					       "log file: %s\n",
+				  strerror(errno));
+			oi->of = old;
+		} else {
+			fclose(old);
+		}
+		break;
+	default:
+		break;
+	}
+}
+
+static int gprint_configure(struct ulogd_pluginstance *upi,
+			    struct ulogd_pluginstance_stack *stack)
+{
+	int ret;
+
+	ret = ulogd_wildcard_inputkeys(upi);
+	if (ret < 0)
+		return ret;
+
+	ret = config_parse_file(upi->id, upi->config_kset);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int gprint_init(struct ulogd_pluginstance *upi)
+{
+	struct gprint_priv *op = (struct gprint_priv *) &upi->private;
+
+	op->of = fopen(upi->config_kset->ces[0].u.string, "a");
+	if (!op->of) {
+		ulogd_log(ULOGD_FATAL, "can't open GPRINT log file: %s\n", 
+			strerror(errno));
+		return -1;
+	}
+	return 0;
+}
+
+static int gprint_fini(struct ulogd_pluginstance *pi)
+{
+	struct gprint_priv *op = (struct gprint_priv *) &pi->private;
+
+	if (op->of != stdout)
+		fclose(op->of);
+
+	return 0;
+}
+
+static struct ulogd_plugin gprint_plugin = {
+	.name = "GPRINT",
+	.input = {
+		.type = ULOGD_DTYPE_PACKET | ULOGD_DTYPE_FLOW,
+	},
+	.output = {
+		.type = ULOGD_DTYPE_SINK,
+	},
+	.configure = &gprint_configure,
+	.interp	= &gprint_interp,
+	.start 	= &gprint_init,
+	.stop	= &gprint_fini,
+	.signal = &sighup_handler_print,
+	.config_kset = &gprint_kset,
+	.version = ULOGD_VERSION,
+};
+
+void __attribute__ ((constructor)) init(void);
+
+void init(void)
+{
+	ulogd_register_plugin(&gprint_plugin);
+}
diff --git a/ulogd.conf.in b/ulogd.conf.in
index ac7bcae..c0c8559 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -42,6 +42,7 @@ plugin="@pkglibexecdir@/ulogd_output_SYSLOG.so"
 plugin="@pkglibexecdir@/ulogd_output_XML.so"
 #plugin="@pkglibexecdir@/ulogd_output_SQLITE3.so"
 #plugin="@pkglibexecdir@/ulogd_output_OPRINT.so"
+plugin="@pkglibexecdir@/ulogd_output_GPRINT.so"
 #plugin="@pkglibexecdir@/ulogd_output_NACCT.so"
 #plugin="@pkglibexecdir@/ulogd_output_PCAP.so"
 #plugin="@pkglibexecdir@/ulogd_output_PGSQL.so"
@@ -167,6 +168,11 @@ sync=1
 file="/var/log/ulogd_oprint.log"
 sync=1
 
+[gp1]
+file="/var/log/ulogd_gprint.log"
+sync=1
+timestamp=1
+
 [xml1]
 directory="/var/log/"
 sync=1
-- 
1.7.7.3

