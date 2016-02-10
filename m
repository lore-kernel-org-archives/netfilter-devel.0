From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH ulogd 4/7] filter: add new filter for Netflow ICMP_TYPE
Date: Wed, 10 Feb 2016 11:01:56 +0900
Message-ID: <20160210020156.GE17470@gmail.com>
References: <20160206104249.GA19349@gmail.com>
 <a53f427c-6b04-4d3b-898e-ba63fc949f5a@email.android.com>
 <20160210015358.GA17470@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:33720 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203AbcBJCCB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Feb 2016 21:02:01 -0500
Received: by mail-pa0-f65.google.com with SMTP id y7so246794paa.0
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Feb 2016 18:02:01 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20160210015358.GA17470@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This filter creates ICMP_TYPE Netflow v9 from IPFIX icmpTypeIPv4
and icmpCodeIPv4.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 filter/Makefile.am             |   6 ++-
 filter/ulogd_filter_PACKICMP.c | 101 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 106 insertions(+), 1 deletion(-)
 create mode 100644 filter/ulogd_filter_PACKICMP.c

diff --git a/filter/Makefile.am b/filter/Makefile.am
index 875850b..70a2bcc 100644
--- a/filter/Makefile.am
+++ b/filter/Makefile.am
@@ -7,7 +7,8 @@ pkglib_LTLIBRARIES = ulogd_filter_IFINDEX.la ulogd_filter_PWSNIFF.la \
 			 ulogd_filter_PRINTPKT.la ulogd_filter_PRINTFLOW.la \
 			 ulogd_filter_IP2STR.la ulogd_filter_IP2BIN.la \
 			 ulogd_filter_HWHDR.la ulogd_filter_MARK.la \
-			 ulogd_filter_IP2HBIN.la
+			 ulogd_filter_IP2HBIN.la \
+			 ulogd_filter_PACKICMP.la
 
 ulogd_filter_IFINDEX_la_SOURCES = ulogd_filter_IFINDEX.c
 ulogd_filter_IFINDEX_la_LDFLAGS = -avoid-version -module
@@ -36,3 +37,6 @@ ulogd_filter_PRINTPKT_la_LDFLAGS = -avoid-version -module
 
 ulogd_filter_PRINTFLOW_la_SOURCES = ulogd_filter_PRINTFLOW.c ../util/printflow.c
 ulogd_filter_PRINTFLOW_la_LDFLAGS = -avoid-version -module
+
+ulogd_filter_PACKICMP_la_SOURCES = ulogd_filter_PACKICMP.c
+ulogd_filter_PACKICMP_la_LDFLAGS = -avoid-version -module
diff --git a/filter/ulogd_filter_PACKICMP.c b/filter/ulogd_filter_PACKICMP.c
new file mode 100644
index 0000000..802b5ef
--- /dev/null
+++ b/filter/ulogd_filter_PACKICMP.c
@@ -0,0 +1,101 @@
+/* ulogd_filter_PACKICMP.c
+ *
+ * ulogd interpreter plugin for IPFIX / Netflow v9 to create
+ * icmpTypeCodeIPv4
+ *
+ * (C) 2014 by Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
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
+
+#include <arpa/inet.h>
+
+#include <ulogd/ulogd.h>
+#include <ulogd/ipfix_protocol.h>
+
+enum input_key_index {
+	IKEY_ICMP_CODE,
+	IKEY_ICMP_TYPE,
+	IKEY_MAX,
+};
+
+static struct ulogd_key input_keys[] = {
+	[IKEY_ICMP_CODE] = {
+		.type	= ULOGD_RET_UINT8,
+		.flags	= ULOGD_RETF_NONE,
+		.name	= "icmp.code",
+	},
+	[IKEY_ICMP_TYPE] = {
+		.type	= ULOGD_RET_UINT8,
+		.flags	= ULOGD_RETF_NONE,
+		.name	= "icmp.type",
+	},
+};
+
+enum output_key_index {
+	OKEY_V4,
+	OKEY_MAX,
+};
+
+static struct ulogd_key output_keys[] = {
+	[OKEY_V4] = {
+		.type	= ULOGD_RET_UINT16,
+		.flags	= ULOGD_RETF_NONE,
+		.name	= "icmp.typecode4",
+		.ipfix	= {
+			.vendor		= IPFIX_VENDOR_IETF,
+			.field_id	= IPFIX_icmpTypeCodeIPv4,
+		},
+	},
+};
+
+static int interp_packicmp(struct ulogd_pluginstance *pi)
+{
+	struct ulogd_key *ret = pi->output.keys;
+	struct ulogd_key *inp = pi->input.keys;
+
+	if (!pp_is_valid(inp, IKEY_ICMP_TYPE)
+	    || !pp_is_valid(inp, IKEY_ICMP_CODE))
+		return ULOGD_IRET_OK;
+
+	okey_set_u16(&ret[OKEY_V4],
+		     ikey_get_u8(&inp[IKEY_ICMP_TYPE]) << 8
+		     | ikey_get_u8(&inp[IKEY_ICMP_CODE]));
+
+	return ULOGD_IRET_OK;
+}
+
+static struct ulogd_plugin packicmp_plugin = {
+	.name	= "PACKICMP",
+	.input	= {
+		.keys     = input_keys,
+		.num_keys = IKEY_MAX,
+		.type     = ULOGD_DTYPE_PACKET | ULOGD_DTYPE_FLOW,
+		},
+	.output	= {
+		.keys     = output_keys,
+		.num_keys = OKEY_MAX,
+		.type     = ULOGD_DTYPE_PACKET | ULOGD_DTYPE_FLOW,
+		},
+	.interp	= &interp_packicmp,
+	.version = VERSION,
+};
+
+void __attribute__ ((constructor)) init(void);
+
+void init(void)
+{
+	ulogd_register_plugin(&packicmp_plugin);
+}
-- 
2.1.4

