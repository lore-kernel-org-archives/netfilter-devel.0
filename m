From: Eric Leblond <eric@regit.org>
Subject: [ulogd PATCH 2/2] json: introduce new JSON output plugin
Date: Tue, 28 Jan 2014 23:41:27 +0100
Message-ID: <1390948887-2112-3-git-send-email-eric@regit.org>
References: <1390948887-2112-1-git-send-email-eric@regit.org>
Cc: Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:56248 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432AbaA1Wl5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Jan 2014 17:41:57 -0500
In-Reply-To: <1390948887-2112-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch introduces a new JSON output plugin. This
patch displays CIM field name instead of ulogd key valu
if this CIM field is available.

The module does not display binary address but uses the
string version of them. So a complete stack is for example:
 stack=log2:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,mac2str1:HWHDR,json1:JSON

If boolean_label is set to 1, then the numeric_label put on packet
by the input plugin is coding the decision on packet. If 0, then
packet has been blocked and if non null it has been accepted.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 configure.ac               |  12 +++
 output/Makefile.am         |  10 ++
 output/ulogd_output_JSON.c | 254 +++++++++++++++++++++++++++++++++++++++++++++
 ulogd.conf.in              |  15 +++
 4 files changed, 291 insertions(+)
 create mode 100644 output/ulogd_output_JSON.c

diff --git a/configure.ac b/configure.ac
index 5e45aaa..544a256 100644
--- a/configure.ac
+++ b/configure.ac
@@ -117,6 +117,17 @@ else
 	enable_pcap="no"
 fi
 
+AC_ARG_WITH([jansson], AS_HELP_STRING([--without-jansson], [Build without JSON output plugin [default=test]]))
+AS_IF([test "x$with_jansson" != "xno"], [
+    PKG_CHECK_MODULES([libjansson], [jansson], [], [:])
+])
+AM_CONDITIONAL([HAVE_JANSSON], [test -n "$libjansson_LIBS"])
+if test "x$libjansson_LIBS" != "x"; then
+	enable_jansson="yes"
+else
+	enable_jansson="no"
+fi
+
 dnl AC_SUBST(DATABASE_DIR)
 dnl AC_SUBST(DATABASE_LIB)
 dnl AC_SUBST(DATABASE_LIB_DIR)
@@ -152,5 +163,6 @@ Ulogd configuration:
     MySQL plugin:			${enable_mysql}
     SQLITE3 plugin:			${enable_sqlite3}
     DBI plugin:				${enable_dbi}
+    JSON plugin:			${enable_jansson}
 "
 echo "You can now run 'make' and 'make install'"
diff --git a/output/Makefile.am b/output/Makefile.am
index 17427d0..ff851ad 100644
--- a/output/Makefile.am
+++ b/output/Makefile.am
@@ -9,6 +9,10 @@ pkglib_LTLIBRARIES = ulogd_output_LOGEMU.la ulogd_output_SYSLOG.la \
 			 ulogd_output_NACCT.la ulogd_output_XML.la \
 			 ulogd_output_GRAPHITE.la
 
+if HAVE_JANSSON
+pkglib_LTLIBRARIES += ulogd_output_JSON.la
+endif
+
 ulogd_output_GPRINT_la_SOURCES = ulogd_output_GPRINT.c
 ulogd_output_GPRINT_la_LDFLAGS = -avoid-version -module
 
@@ -32,3 +36,9 @@ ulogd_output_XML_la_LDFLAGS = -avoid-version -module
 
 ulogd_output_GRAPHITE_la_SOURCES = ulogd_output_GRAPHITE.c
 ulogd_output_GRAPHITE_la_LDFLAGS = -avoid-version -module
+
+if HAVE_JANSSON
+ulogd_output_JSON_la_SOURCES = ulogd_output_JSON.c
+ulogd_output_JSON_la_LIBADD  = ${libjansson_LIBS}
+ulogd_output_JSON_la_LDFLAGS = -avoid-version -module
+endif
diff --git a/output/ulogd_output_JSON.c b/output/ulogd_output_JSON.c
new file mode 100644
index 0000000..04158a8
--- /dev/null
+++ b/output/ulogd_output_JSON.c
@@ -0,0 +1,254 @@
+/* ulogd_output_JSON.c
+ *
+ * ulogd output target for logging to a file in JSON format.
+ *
+ * (C) 2014 by Eric Leblond <eric@regit.org>
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
+#include <inttypes.h>
+#include <ulogd/ulogd.h>
+#include <ulogd/conffile.h>
+#include <jansson.h>
+
+#ifndef ULOGD_JSON_DEFAULT
+#define ULOGD_JSON_DEFAULT	"/var/log/ulogd.json"
+#endif
+
+#ifndef ULOGD_JSON_DEFAULT_DEVICE
+#define ULOGD_JSON_DEFAULT_DEVICE "Netfilter"
+#endif
+
+struct json_priv {
+	FILE *of;
+};
+
+enum json_conf {
+	JSON_CONF_FILENAME = 0,
+	JSON_CONF_SYNC,
+	JSON_CONF_TIMESTAMP,
+	JSON_CONF_DEVICE,
+	JSON_CONF_BOOLEAN_LABEL,
+	JSON_CONF_MAX
+};
+
+static struct config_keyset json_kset = {
+	.num_ces = JSON_CONF_MAX,
+	.ces = {
+		[JSON_CONF_FILENAME] = {
+			.key = "file",
+			.type = CONFIG_TYPE_STRING,
+			.options = CONFIG_OPT_NONE,
+			.u = {.string = ULOGD_JSON_DEFAULT },
+		},
+		[JSON_CONF_SYNC] = {
+			.key = "sync",
+			.type = CONFIG_TYPE_INT,
+			.options = CONFIG_OPT_NONE,
+			.u = { .value = 0 },
+		},
+		[JSON_CONF_TIMESTAMP] = {
+			.key = "timestamp",
+			.type = CONFIG_TYPE_INT,
+			.options = CONFIG_OPT_NONE,
+			.u = { .value = 1 },
+		},
+		[JSON_CONF_DEVICE] = {
+			.key = "device",
+			.type = CONFIG_TYPE_STRING,
+			.options = CONFIG_OPT_NONE,
+			.u = { .string = ULOGD_JSON_DEFAULT_DEVICE },
+		},
+		[JSON_CONF_BOOLEAN_LABEL] = {
+			.key = "boolean_label",
+			.type = CONFIG_TYPE_INT,
+			.options = CONFIG_OPT_NONE,
+			.u = { .value = 0 },
+		},
+	},
+};
+
+static int json_interp(struct ulogd_pluginstance *upi)
+{
+	struct json_priv *opi = (struct json_priv *) &upi->private;
+	unsigned int i;
+	json_t *msg;
+
+	msg = json_object();
+	if (!msg) {
+		ulogd_log(ULOGD_ERROR, "Unable to create JSON object\n");
+		return ULOGD_IRET_ERR;
+	}
+
+	if (upi->config_kset->ces[JSON_CONF_TIMESTAMP].u.value != 0) {
+		time_t now;
+		char *timestr = NULL;
+		now = time(NULL);
+
+		timestr = ctime(&now);
+		timestr[strlen(timestr) - 1] = '\0';
+
+		json_object_set_new(msg, "timestamp", json_string(timestr));
+	}
+
+	if (upi->config_kset->ces[JSON_CONF_DEVICE].u.string) {
+		char *dvc = upi->config_kset->ces[JSON_CONF_DEVICE].u.string;
+		json_object_set_new(msg, "dvc", json_string(dvc));
+	}
+
+
+
+	for (i = 0; i < upi->input.num_keys; i++) {
+		struct ulogd_key *key = upi->input.keys[i].u.source;
+		char *field_name;
+
+		if (!key)
+			continue;
+
+		if (!IS_VALID(*key))
+			continue;
+
+		field_name = key->cim_name ? key->cim_name : key->name;
+
+		switch (key->type) {
+		case ULOGD_RET_STRING:
+			json_object_set_new(msg, field_name, json_string(key->u.value.ptr));
+			break;
+		case ULOGD_RET_BOOL:
+		case ULOGD_RET_INT8:
+		case ULOGD_RET_INT16:
+		case ULOGD_RET_INT32:
+			json_object_set_new(msg, field_name, json_integer(key->u.value.i32));
+			break;
+		case ULOGD_RET_UINT8:
+			if ((upi->config_kset->ces[JSON_CONF_BOOLEAN_LABEL].u.value != 0)
+					&& (!strcmp(key->name, "raw.label"))) {
+				if (key->u.value.ui8)
+					json_object_set_new(msg, "action", json_string("allowed"));
+				else
+					json_object_set_new(msg, "action", json_string("blocked"));
+				break;
+			}
+		case ULOGD_RET_UINT16:
+		case ULOGD_RET_UINT32:
+		case ULOGD_RET_UINT64:
+			json_object_set_new(msg, field_name, json_integer(key->u.value.ui64));
+		default:
+			/* don't know how to interpret this key. */
+			break;
+		}
+	}
+
+	json_dumpf(msg, opi->of, 0);
+	fprintf(opi->of, "\n");
+
+	json_decref(msg);
+
+	if (upi->config_kset->ces[JSON_CONF_SYNC].u.value != 0)
+		fflush(opi->of);
+
+	return ULOGD_IRET_OK;
+}
+
+static void sighup_handler_print(struct ulogd_pluginstance *upi, int signal)
+{
+	struct json_priv *oi = (struct json_priv *) &upi->private;
+	FILE *old = oi->of;
+
+	switch (signal) {
+	case SIGHUP:
+		ulogd_log(ULOGD_NOTICE, "JSON: reopening logfile\n");
+		oi->of = fopen(upi->config_kset->ces[0].u.string, "a");
+		if (!oi->of) {
+			ulogd_log(ULOGD_ERROR, "can't open JSON "
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
+static int json_configure(struct ulogd_pluginstance *upi,
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
+static int json_init(struct ulogd_pluginstance *upi)
+{
+	struct json_priv *op = (struct json_priv *) &upi->private;
+
+	op->of = fopen(upi->config_kset->ces[0].u.string, "a");
+	if (!op->of) {
+		ulogd_log(ULOGD_FATAL, "can't open JSON log file: %s\n",
+			strerror(errno));
+		return -1;
+	}
+	return 0;
+}
+
+static int json_fini(struct ulogd_pluginstance *pi)
+{
+	struct json_priv *op = (struct json_priv *) &pi->private;
+
+	if (op->of != stdout)
+		fclose(op->of);
+
+	return 0;
+}
+
+static struct ulogd_plugin json_plugin = {
+	.name = "JSON",
+	.input = {
+		.type = ULOGD_DTYPE_PACKET | ULOGD_DTYPE_FLOW | ULOGD_DTYPE_SUM,
+	},
+	.output = {
+		.type = ULOGD_DTYPE_SINK,
+	},
+	.configure = &json_configure,
+	.interp	= &json_interp,
+	.start 	= &json_init,
+	.stop	= &json_fini,
+	.signal = &sighup_handler_print,
+	.config_kset = &json_kset,
+	.version = VERSION,
+};
+
+void __attribute__ ((constructor)) init(void);
+
+void init(void)
+{
+	ulogd_register_plugin(&json_plugin);
+}
diff --git a/ulogd.conf.in b/ulogd.conf.in
index 0f9df7b..8893175 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -49,6 +49,7 @@ plugin="@pkglibdir@/ulogd_output_GPRINT.so"
 plugin="@pkglibdir@/ulogd_raw2packet_BASE.so"
 plugin="@pkglibdir@/ulogd_inpflow_NFACCT.so"
 plugin="@pkglibdir@/ulogd_output_GRAPHITE.so"
+#plugin="@pkglibdir@/ulogd_output_JSON.so"
 
 # this is a stack for logging packet send by system via LOGEMU
 #stack=log1:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,emu1:LOGEMU
@@ -92,6 +93,9 @@ plugin="@pkglibdir@/ulogd_output_GRAPHITE.so"
 # this is a stack for logging packet to PGsql after a collect via NFLOG
 #stack=log2:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,mac2str1:HWHDR,pgsql1:PGSQL
 
+# this is a stack for logging packet to JSON formatted file after a collect via NFLOG
+#stack=log2:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,mac2str1:HWHDR,json1:JSON
+
 # this is a stack for logging packets to syslog after a collect via NFLOG
 #stack=log3:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,sys1:SYSLOG
 
@@ -195,6 +199,17 @@ timestamp=1
 directory="/var/log/"
 sync=1
 
+[json1]
+sync=1
+#file="/var/log/ulogd.json"
+#timestamp=0
+# device name to be used in JSON message
+#device="My awesome Netfilter firewall"
+# If boolean_label is set to 1 then the numeric_label put on packet
+# by the input plugin is coding the action on packet: if 0, then
+# packet has been blocked and if non null it has been accepted.
+#boolean_label=1
+
 [pcap1]
 #default file is /var/log/ulogd.pcap
 #file="/var/log/ulogd.pcap"
-- 
1.9.rc1

