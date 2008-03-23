From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 05/14] New MAC2STR plugin for hwmac address conversion.
Date: Sun, 23 Mar 2008 17:25:13 +0100
Message-ID: <12062895232654-git-send-email-eric@inl.fr>
References: <1206289522679-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:55044 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752708AbYCWQZZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Mar 2008 12:25:25 -0400
In-Reply-To: <1206289522679-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch introduces a new plugin MAC2STR which is in charge
of conversion to string of MAC address. It is used by database
output plugin to store MAC related information.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 filter/Makefile.am            |    6 ++-
 filter/ulogd_filter_MAC2STR.c |  111 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 116 insertions(+), 1 deletions(-)
 create mode 100644 filter/ulogd_filter_MAC2STR.c

diff --git a/filter/Makefile.am b/filter/Makefile.am
index 52b639c..958a5de 100644
--- a/filter/Makefile.am
+++ b/filter/Makefile.am
@@ -4,7 +4,8 @@ INCLUDES = $(all_includes) -I$(top_srcdir)/include
 
 pkglib_LTLIBRARIES = ulogd_filter_IFINDEX.la ulogd_filter_PWSNIFF.la \
 		     ulogd_filter_PRINTPKT.la ulogd_filter_PRINTFLOW.la \
-		     ulogd_filter_IP2STR.la ulogd_filter_IP2BIN.la
+		     ulogd_filter_IP2STR.la ulogd_filter_IP2BIN.la \
+		     ulogd_filter_MAC2STR.la
 
 ulogd_filter_IFINDEX_la_SOURCES = ulogd_filter_IFINDEX.c
 ulogd_filter_IFINDEX_la_LDFLAGS = -module -lnfnetlink
@@ -18,6 +19,9 @@ ulogd_filter_IP2STR_la_LDFLAGS = -module
 ulogd_filter_IP2BIN_la_SOURCES = ulogd_filter_IP2BIN.c
 ulogd_filter_IP2BIN_la_LDFLAGS = -module
 
+ulogd_filter_MAC2STR_la_SOURCES = ulogd_filter_MAC2STR.c
+ulogd_filter_MAC2STR_la_LDFLAGS = -module
+
 ulogd_filter_PRINTPKT_la_SOURCES = ulogd_filter_PRINTPKT.c ../util/printpkt.c
 ulogd_filter_PRINTPKT_la_LDFLAGS = -module
 
diff --git a/filter/ulogd_filter_MAC2STR.c b/filter/ulogd_filter_MAC2STR.c
new file mode 100644
index 0000000..38d0565
--- /dev/null
+++ b/filter/ulogd_filter_MAC2STR.c
@@ -0,0 +1,111 @@
+/* ulogd_filter_MAC2STR.c, Version $Revision: 1500 $
+ *
+ * ulogd interpreter plugin for HWMAC
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
+#include <stdlib.h>
+#include <string.h>
+#include <arpa/inet.h>
+#include <ulogd/ulogd.h>
+
+#define IPADDR_LENGTH 128
+
+enum input_keys {
+	KEY_RAW_MAC,
+	KEY_RAW_MACLEN,
+};
+
+enum output_keys {
+	KEY_MAC_SADDR,
+};
+
+static struct ulogd_key mac2str_inp[] = {
+	[KEY_RAW_MAC] = {
+		.type = ULOGD_RET_RAW,
+		.flags = ULOGD_RETF_NONE,
+		.name = "raw.mac",
+	},
+	[KEY_RAW_MACLEN] = { 
+		.type = ULOGD_RET_UINT16, 
+		.flags = ULOGD_RETF_NONE, 
+		.name = "raw.mac_len", 
+	},
+
+};
+
+static struct ulogd_key mac2str_keys[] = {
+	{
+		.type = ULOGD_RET_STRING,
+		.flags = ULOGD_RETF_FREE,
+		.name = "mac.saddr.str",
+	},
+};
+
+static int interp_mac2str(struct ulogd_pluginstance *pi)
+{
+	struct ulogd_key *ret = pi->output.keys;
+	struct ulogd_key *inp = pi->input.keys;
+
+	if (pp_is_valid(inp, KEY_RAW_MAC)) {
+		unsigned char *mac = (unsigned char *) GET_VALUE(inp, KEY_RAW_MAC).ptr;
+		int len = GET_VALUE(inp, KEY_RAW_MACLEN).ui16;
+		char *mac_str = calloc(len/sizeof(char)*3, sizeof(char));
+		char *buf_cur = mac_str;
+		int i;
+		
+		if (mac_str == NULL)
+			return -1;
+
+		for (i = 0; i < len; i++)
+			buf_cur += sprintf(buf_cur, "%02x%c", mac[i],
+					   i == len - 1 ? 0 : ':');
+
+		ret[KEY_MAC_SADDR].u.value.ptr = mac_str;
+		ret[KEY_MAC_SADDR].flags |= ULOGD_RETF_VALID;
+	}
+
+	return 0;
+}
+
+static struct ulogd_plugin mac2str_pluging = {
+	.name = "MAC2STR",
+	.input = {
+		.keys = mac2str_inp,
+		.num_keys = ARRAY_SIZE(mac2str_inp),
+		.type = ULOGD_DTYPE_PACKET,
+		},
+	.output = {
+		.keys = mac2str_keys,
+		.num_keys = ARRAY_SIZE(mac2str_keys),
+		.type = ULOGD_DTYPE_PACKET,
+		},
+	.interp = &interp_mac2str,
+	.version = ULOGD_VERSION,
+};
+
+void __attribute__ ((constructor)) init(void);
+
+void init(void)
+{
+	ulogd_register_plugin(&mac2str_pluging);
+}
-- 
1.5.2.5

