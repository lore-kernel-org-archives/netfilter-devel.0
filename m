From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH] Resent, new MARK filtering module.
Date: Sun,  8 Jun 2008 12:12:33 +0200
Message-ID: <1212919953-6635-1-git-send-email-eric@inl.fr>
References: <48493BCD.4020605@trash.net>
Cc: Eric Leblond <eric@inl.fr>
To: kaber@trash.net, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:46575 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756701AbYFHKKU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Jun 2008 06:10:20 -0400
In-Reply-To: <48493BCD.4020605@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a rework on my previous patch with suppression of mark_ce magic.

This module filters message by using the mark to decide wether or not a
packet or a flow has to be logged. It takes a mark and a mask option. It
demonstrates the usage of ULOGD_IRET_STOP which can be used to abort iteration
through the stack.
---
 filter/Makefile.am         |    5 ++-
 filter/ulogd_filter_MARK.c |  123 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 127 insertions(+), 1 deletions(-)
 create mode 100644 filter/ulogd_filter_MARK.c

diff --git a/filter/Makefile.am b/filter/Makefile.am
index 958a5de..cbeb5bc 100644
--- a/filter/Makefile.am
+++ b/filter/Makefile.am
@@ -5,7 +5,7 @@ INCLUDES = $(all_includes) -I$(top_srcdir)/include
 pkglib_LTLIBRARIES = ulogd_filter_IFINDEX.la ulogd_filter_PWSNIFF.la \
 		     ulogd_filter_PRINTPKT.la ulogd_filter_PRINTFLOW.la \
 		     ulogd_filter_IP2STR.la ulogd_filter_IP2BIN.la \
-		     ulogd_filter_MAC2STR.la
+		     ulogd_filter_MAC2STR.la ulogd_filter_MARK.la
 
 ulogd_filter_IFINDEX_la_SOURCES = ulogd_filter_IFINDEX.c
 ulogd_filter_IFINDEX_la_LDFLAGS = -module -lnfnetlink
@@ -22,6 +22,9 @@ ulogd_filter_IP2BIN_la_LDFLAGS = -module
 ulogd_filter_MAC2STR_la_SOURCES = ulogd_filter_MAC2STR.c
 ulogd_filter_MAC2STR_la_LDFLAGS = -module
 
+ulogd_filter_MARK_la_SOURCES = ulogd_filter_MARK.c
+ulogd_filter_MARK_la_LDFLAGS = -module
+
 ulogd_filter_PRINTPKT_la_SOURCES = ulogd_filter_PRINTPKT.c ../util/printpkt.c
 ulogd_filter_PRINTPKT_la_LDFLAGS = -module
 
diff --git a/filter/ulogd_filter_MARK.c b/filter/ulogd_filter_MARK.c
new file mode 100644
index 0000000..ff31fe5
--- /dev/null
+++ b/filter/ulogd_filter_MARK.c
@@ -0,0 +1,123 @@
+/* ulogd_filter_MARK.c, Version $Revision: 1500 $
+ *
+ * ulogd interpreter plugin for internal IP storage format to string conversion
+ *
+ * (C) 2008 by Eric Leblond <eric@inl.fr>
+ *
+ * Based on ulogd_filter_IFINDEX.c Harald Welte <laforge@gnumonks.org>
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
+ * $Id: ulogd_filter_IFINDEX.c 1500 2005-10-03 16:54:02Z laforge $
+ */
+
+#include <stdio.h>
+#include <ulogd/ulogd.h>
+
+enum mark_kset {
+	MARK_MARK,
+	MARK_MASK,
+};
+
+static struct config_keyset libulog_kset = {
+	.num_ces = 2,
+	.ces = {
+		[MARK_MARK] = {
+			.key 	 = "mark",
+			.type 	 = CONFIG_TYPE_INT,
+			.options = CONFIG_OPT_NONE,
+			.u.value = 0,
+		},
+		[MARK_MASK] = {
+			.key 	 = "mask",
+			.type 	 = CONFIG_TYPE_INT,
+			.options = CONFIG_OPT_NONE,
+			.u.value = 0xffffffff,
+		},
+
+	}
+};
+	
+enum input_keys {
+	KEY_CT_MARK,
+	KEY_OOB_MARK,
+	MAX_KEY = KEY_OOB_MARK,
+};
+
+static struct ulogd_key mark_inp[] = {
+	[KEY_CT_MARK] = {
+		.type = ULOGD_RET_UINT32,
+		.flags = ULOGD_RETF_NONE|ULOGD_KEYF_OPTIONAL,
+		.name = "ct.mark",
+	},
+	[KEY_OOB_MARK] = {
+		.type = ULOGD_RET_UINT32,
+		.flags = ULOGD_RETF_NONE|ULOGD_KEYF_OPTIONAL,
+		.name = "oob.mark",
+	},
+};
+
+static int interp_mark(struct ulogd_pluginstance *pi)
+{
+	struct ulogd_key *inp = pi->input.keys;
+	if (pp_is_valid(inp, KEY_CT_MARK)) {
+		if ((GET_VALUE(inp, KEY_CT_MARK).ui32 &
+			pi->config_kset->ces[MARK_MASK].u.value) !=
+			pi->config_kset->ces[MARK_MARK].u.value
+		   ) {
+			return ULOGD_IRET_STOP;
+		}
+	} else if (pp_is_valid(inp, KEY_OOB_MARK)) {
+		if ((GET_VALUE(inp, KEY_OOB_MARK).ui32 &
+			pi->config_kset->ces[MARK_MASK].u.value) !=
+			pi->config_kset->ces[MARK_MARK].u.value
+		   ) {
+			return ULOGD_IRET_STOP;
+		}
+	}
+	return ULOGD_IRET_OK;	
+}
+
+static int configure(struct ulogd_pluginstance *upi,
+		     struct ulogd_pluginstance_stack *stack)
+{
+	ulogd_log(ULOGD_DEBUG, "parsing config file section `%s', "
+		  "plugin `%s'\n", upi->id, upi->plugin->name);
+
+	config_parse_file(upi->id, upi->config_kset);
+	return 0;
+}
+
+static struct ulogd_plugin mark_pluging = {
+	.name = "MARK",
+	.input = {
+		.keys = mark_inp,
+		.num_keys = ARRAY_SIZE(mark_inp),
+		.type = ULOGD_DTYPE_PACKET | ULOGD_DTYPE_FLOW,
+		},
+	.output = {
+		.type = ULOGD_DTYPE_PACKET | ULOGD_DTYPE_FLOW,
+		},
+	.interp = &interp_mark,
+	.config_kset = &libulog_kset,
+	.configure = &configure,
+	.version = ULOGD_VERSION,
+};
+
+void __attribute__ ((constructor)) init(void);
+
+void init(void)
+{
+	ulogd_register_plugin(&mark_pluging);
+}
-- 
1.5.4.3

