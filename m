From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] output: add new plugin XML to output logs in XML
Date: Thu, 27 May 2010 14:56:17 +0200
Message-ID: <20100527125617.13787.61243.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: eleblond@edenwall.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56796 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561Ab0E0M42 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 May 2010 08:56:28 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds XML that allows to log information in XML for
ulogd2. It supports packet and flow-based accounting.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 input/flow/ulogd_inpflow_NFCT.c   |   18 +++
 input/packet/ulogd_inppkt_NFLOG.c |    9 +
 output/Makefile.am                |    6 +
 output/ulogd_output_XML.c         |  240 +++++++++++++++++++++++++++++++++++++
 ulogd.conf.in                     |   11 ++
 5 files changed, 282 insertions(+), 2 deletions(-)
 create mode 100644 output/ulogd_output_XML.c

diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index 70f3940..5f85328 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -64,6 +64,7 @@ struct nfct_pluginstance {
 	struct ulogd_timer ov_timer;	/* overrun retry timer */
 	struct hashtable *ct_active;
 	int nlbufsiz;			/* current netlink buffer size */
+	struct nf_conntrack *ct;
 };
 
 #define HTABLE_SIZE	(8192)
@@ -158,6 +159,7 @@ enum nfct_keys {
 	NFCT_FLOW_END_USEC,
 	NFCT_OOB_FAMILY,
 	NFCT_OOB_PROTOCOL,
+	NFCT_CT,
 };
 
 static struct ulogd_key nfct_okeys[] = {
@@ -379,6 +381,11 @@ static struct ulogd_key nfct_okeys[] = {
 		.flags	= ULOGD_RETF_NONE,
 		.name	= "oob.protocol",
 	},
+	{
+		.type	= ULOGD_RET_RAW,
+		.flags	= ULOGD_RETF_NONE,
+		.name	= "ct",
+	},
 };
 
 static uint32_t
@@ -453,6 +460,8 @@ static int propagate_ct(struct ulogd_pluginstance *upi,
 			struct ct_timestamp *ts)
 {
 	struct ulogd_key *ret = upi->output.keys;
+	struct nfct_pluginstance *cpi =
+			(struct nfct_pluginstance *) upi->private;
 
 	okey_set_u32(&ret[NFCT_CT_EVENT], type);
 	okey_set_u8(&ret[NFCT_OOB_FAMILY], nfct_get_attr_u8(ct, ATTR_L3PROTO));
@@ -545,6 +554,8 @@ static int propagate_ct(struct ulogd_pluginstance *upi,
 				     ts->time[STOP].tv_usec);
 		}
 	}
+	memcpy(cpi->ct, ct, nfct_sizeof(ct));
+	okey_set_ptr(&ret[NFCT_CT], cpi->ct);
 
 	ulogd_propagate_results(upi);
 
@@ -1006,6 +1017,10 @@ static int constructor_nfct_events(struct ulogd_pluginstance *upi)
 
 	ulogd_register_fd(&cpi->nfct_fd);
 
+	cpi->ct = nfct_new();
+	if (cpi->ct == NULL)
+		goto err_nfctobj;
+
 	if (usehash_ce(upi->config_kset).u.value != 0) {
 		int family = AF_UNSPEC;
 		struct nfct_handle *h;
@@ -1071,6 +1086,8 @@ err_pgh:
 err_ovh:
 	hashtable_destroy(cpi->ct_active);
 err_hashtable:
+	nfct_destroy(cpi->ct);
+err_nfctobj:
 	ulogd_unregister_fd(&cpi->nfct_fd);
 	nfct_close(cpi->cth);
 err_cth:
@@ -1139,6 +1156,7 @@ static int destructor_nfct_events(struct ulogd_pluginstance *upi)
 	if (rc < 0)
 		return rc;
 
+	nfct_destroy(cpi->ct);
 
 	if (usehash_ce(upi->config_kset).u.value != 0) {
 		ulogd_del_timer(&cpi->ov_timer);
diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt_NFLOG.c
index 3fd866e..7e2f5a4 100644
--- a/input/packet/ulogd_inppkt_NFLOG.c
+++ b/input/packet/ulogd_inppkt_NFLOG.c
@@ -138,6 +138,7 @@ enum nflog_keys {
 	NFLOG_KEY_RAW_TYPE,
 	NFLOG_KEY_RAW_MAC_SADDR,
 	NFLOG_KEY_RAW_MAC_ADDRLEN,
+	NFLOG_KEY_RAW,
 };
 
 static struct ulogd_key output_keys[] = {
@@ -304,7 +305,11 @@ static struct ulogd_key output_keys[] = {
 		.flags = ULOGD_RETF_NONE,
 		.name = "raw.type",
 	},
-
+	[NFLOG_KEY_RAW] = {
+		.type = ULOGD_RET_RAW,
+		.flags = ULOGD_RETF_NONE,
+		.name = "raw",
+	},
 };
 
 static inline int
@@ -390,6 +395,8 @@ interp_packet(struct ulogd_pluginstance *upi, u_int8_t pf_family,
 	if (nflog_get_seq_global(ldata, &seq) == 0)
 		okey_set_u32(&ret[NFLOG_KEY_OOB_SEQ_GLOBAL], seq);
 
+	okey_set_ptr(&ret[NFLOG_KEY_RAW], ldata);
+
 	ulogd_propagate_results(upi);
 	return 0;
 }
diff --git a/output/Makefile.am b/output/Makefile.am
index a4335c8..8aa8e08 100644
--- a/output/Makefile.am
+++ b/output/Makefile.am
@@ -5,7 +5,7 @@ SUBDIRS= pcap mysql pgsql sqlite3 dbi
 
 pkglib_LTLIBRARIES = ulogd_output_LOGEMU.la ulogd_output_SYSLOG.la \
 		     ulogd_output_OPRINT.la ulogd_output_IPFIX.la \
-		     ulogd_output_NACCT.la
+		     ulogd_output_NACCT.la ulogd_output_XML.la
 
 ulogd_output_LOGEMU_la_SOURCES = ulogd_output_LOGEMU.c
 ulogd_output_LOGEMU_la_LDFLAGS = -avoid-version -module
@@ -21,3 +21,7 @@ ulogd_output_IPFIX_la_LDFLAGS = -avoid-version -module
 
 ulogd_output_NACCT_la_SOURCES = ulogd_output_NACCT.c
 ulogd_output_NACCT_la_LDFLAGS = -avoid-version -module
+
+ulogd_output_XML_la_SOURCES = ulogd_output_XML.c
+ulogd_output_XML_la_LDFLAGS = -avoid-version -module -lnetfilter_log \
+			      -lnetfilter_conntrack
diff --git a/output/ulogd_output_XML.c b/output/ulogd_output_XML.c
new file mode 100644
index 0000000..397258b
--- /dev/null
+++ b/output/ulogd_output_XML.c
@@ -0,0 +1,240 @@
+/* ulogd_XML.c.
+ *
+ * ulogd output target for XML logging.
+ *
+ * (C) 2010 by Pablo Neira Ayuso <pablo@netfilter.org>
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
+ */
+
+#include <libnetfilter_conntrack/libnetfilter_conntrack.h>
+#include <libnetfilter_log/libnetfilter_log.h>
+#include <ulogd/ulogd.h>
+#include <sys/param.h>
+#include <time.h>
+#include <errno.h>
+
+#ifndef ULOGD_XML_DEFAULT_DIR
+#define ULOGD_XML_DEFAULT_DIR "/var/log/"
+#endif
+
+enum {
+	KEY_CT,
+	KEY_PCKT,
+};
+
+static struct ulogd_key xml_inp[] = {
+	[KEY_CT] = {
+                .type = ULOGD_RET_RAW,
+                .flags = ULOGD_RETF_NONE | ULOGD_KEYF_OPTIONAL,
+                .name = "ct",
+	},
+	[KEY_PCKT] = {
+                .type = ULOGD_RET_RAW,
+                .flags = ULOGD_RETF_NONE | ULOGD_KEYF_OPTIONAL,
+                .name = "raw",
+	},
+};
+
+enum {
+	CFG_XML_DIR,
+	CFG_XML_SYNC,
+	CFG_XML_STDOUT,
+};
+
+static struct config_keyset xml_kset = {
+	.num_ces = 3,
+	.ces = {
+		[CFG_XML_DIR] = {
+			.key = "directory", 
+			.type = CONFIG_TYPE_STRING, 
+			.options = CONFIG_OPT_NONE,
+			.u = { .string = ULOGD_XML_DEFAULT_DIR },
+		},
+		[CFG_XML_SYNC] = {
+			.key = "sync",
+			.type = CONFIG_TYPE_INT,
+			.options = CONFIG_OPT_NONE,
+			.u = { .value = 0 },
+		},
+		[CFG_XML_STDOUT] = {
+			.key = "stdout",
+			.type = CONFIG_TYPE_INT,
+			.options = CONFIG_OPT_NONE,
+			.u = { .value = 0 },
+		},
+	},
+};
+
+struct xml_priv {
+        FILE *of;
+};
+
+static int
+xml_output_flow(struct ulogd_key *inp, char *buf, ssize_t size)
+{
+	struct nf_conntrack *ct = ikey_get_ptr(&inp[KEY_CT]);
+	int tmp;
+
+	tmp = nfct_snprintf(buf, size, ct, 0, NFCT_O_XML,
+			    NFCT_OF_SHOW_LAYER3 | NFCT_OF_ID | NFCT_OF_TIME);
+	if (tmp < 0 || tmp >= size)
+		return -1;
+
+	return 0;
+}
+
+static int
+xml_output_packet(struct ulogd_key *inp, char *buf, ssize_t size)
+{
+	struct nflog_data *ldata = ikey_get_ptr(&inp[KEY_PCKT]);
+	int tmp;
+
+	tmp = nflog_snprintf_xml(buf, size, ldata, NFLOG_XML_ALL);
+	if (tmp < 0 || tmp >= size)
+		return -1;
+
+	return 0;
+}
+
+static int xml_output(struct ulogd_pluginstance *upi)
+{
+	struct ulogd_key *inp = upi->input.keys;
+	struct xml_priv *opi = (struct xml_priv *) &upi->private;
+	static char buf[4096];
+	int ret = -1;
+
+	if (pp_is_valid(inp, KEY_CT))
+		ret = xml_output_flow(inp, buf, sizeof(buf));
+	else if (pp_is_valid(inp, KEY_PCKT))
+		ret = xml_output_packet(inp, buf, sizeof(buf));
+
+	if (ret < 0)
+		return ULOGD_IRET_ERR;
+
+	fprintf(opi->of, "%s\n", buf);
+	if (upi->config_kset->ces[CFG_XML_SYNC].u.value != 0)
+		fflush(opi->of);
+
+	return ULOGD_IRET_OK;
+}
+
+static int xml_configure(struct ulogd_pluginstance *upi,
+			 struct ulogd_pluginstance_stack *stack)
+{
+	int ret;
+
+	ret = config_parse_file(upi->id, upi->config_kset);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int xml_fini(struct ulogd_pluginstance *pi)
+{
+	struct xml_priv *op = (struct xml_priv *) &pi->private;
+	struct ulogd_pluginstance *input_plugin =
+		llist_entry(pi->stack->list.next,
+			    struct ulogd_pluginstance, list);
+
+	/* the initial tag depends on the source. */
+	if (input_plugin->plugin->output.type & ULOGD_DTYPE_FLOW)
+		fprintf(op->of, "</conntrack>\n");
+	else if (input_plugin->plugin->output.type & ULOGD_DTYPE_RAW)
+		fprintf(op->of, "</packet>\n");
+
+	if (op->of != stdout)
+		fclose(op->of);
+
+	return 0;
+}
+
+static int xml_start(struct ulogd_pluginstance *upi)
+{
+	struct xml_priv *op = (struct xml_priv *) &upi->private;
+	char buf[PATH_MAX], filename[FILENAME_MAX];
+	time_t now;
+	struct tm *tm;
+	int ret;
+
+	if (upi->config_kset->ces[CFG_XML_STDOUT].u.value != 0) {
+		op->of = stdout;
+	} else {
+		now = time(NULL);
+		tm = localtime(&now);
+		ret = snprintf(filename, sizeof(filename),
+			       "ulogd-%.2d%.2d%.4d-%.2d%.2d%.2d.xml",
+			       tm->tm_mday, tm->tm_mon + 1, 1900 + tm->tm_year,
+			       tm->tm_hour, tm->tm_min, tm->tm_sec);
+
+		if (ret == -1 || ret >= (int)sizeof(filename))
+			return -1;
+
+		ret = snprintf(buf, sizeof(buf), "%s/%s",
+			       upi->config_kset->ces[CFG_XML_DIR].u.string,
+			       filename);
+		if (ret == -1 || ret >= (int)sizeof(buf))
+			return -1;
+
+		op->of = fopen(buf, "a");
+		if (!op->of) {
+			ulogd_log(ULOGD_FATAL, "can't open XML file: %s\n", 
+				  strerror(errno));
+			return -1;
+		}
+	}
+	fprintf(op->of, "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n");
+
+	struct ulogd_pluginstance *input_plugin =
+		llist_entry(upi->stack->list.next,
+			    struct ulogd_pluginstance, list);
+
+	if (input_plugin->plugin->output.type & ULOGD_DTYPE_FLOW)
+		fprintf(op->of, "<conntrack>\n");
+	else if (input_plugin->plugin->output.type & ULOGD_DTYPE_RAW)
+		fprintf(op->of, "<packet>\n");
+
+	if (upi->config_kset->ces[CFG_XML_SYNC].u.value != 0)
+		fflush(op->of);
+
+	return 0;
+}
+
+static struct ulogd_plugin xml_plugin = {
+	.name = "XML",
+	.input = {
+		.keys = xml_inp,
+		.num_keys = ARRAY_SIZE(xml_inp),
+		.type = ULOGD_DTYPE_FLOW,
+	},
+	.output = {
+		.type = ULOGD_DTYPE_SINK,
+	},
+	.config_kset	= &xml_kset,
+	.priv_size	= sizeof(struct xml_priv),
+	
+	.configure	= &xml_configure,
+	.start		= &xml_start,
+	.stop		= &xml_fini,
+	.interp		= &xml_output,
+	.version	= ULOGD_VERSION,
+};
+
+void __attribute__ ((constructor)) init(void);
+
+void init(void)
+{
+	ulogd_register_plugin(&xml_plugin);
+}
diff --git a/ulogd.conf.in b/ulogd.conf.in
index b77d726..1101046 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -37,6 +37,7 @@ plugin="@libdir@/ulogd/ulogd_filter_PRINTFLOW.so"
 #plugin="@libdir@/ulogd/ulogd_filter_MARK.so"
 plugin="@libdir@/ulogd/ulogd_output_LOGEMU.so"
 plugin="@libdir@/ulogd/ulogd_output_SYSLOG.so"
+plugin="@libdir@/ulogd/ulogd_output_XML.so"
 #plugin="@libdir@/ulogd/ulogd_output_OPRINT.so"
 #plugin="@libdir@/ulogd/ulogd_output_NACCT.so"
 #plugin="@libdir@/ulogd/ulogd_output_PCAP.so"
@@ -63,6 +64,12 @@ plugin="@libdir@/ulogd/ulogd_raw2packet_BASE.so"
 # this is a stack for flow-based logging via OPRINT
 #stack=ct1:NFCT,op1:OPRINT
 
+# this is a stack for flow-based logging via XML
+#stack=ct1:NFCT,xml1:XML
+
+# this is a stack for logging in XML
+#stack=log1:NFLOG,xml1:XML
+
 # this is a stack for NFLOG packet-based logging to PCAP
 #stack=log2:NFLOG,base1:BASE,pcap1:PCAP
 
@@ -146,6 +153,10 @@ sync=1
 file="/var/log/ulogd_oprint.log"
 sync=1
 
+[xml1]
+directory="/var/log/"
+sync=1
+
 [pcap1]
 sync=1
 

