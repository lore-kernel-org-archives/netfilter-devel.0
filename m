From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 2/2] A simple filter plugin called IP2HBIN added
Date: Sun, 15 Jan 2012 16:04:49 +0100
Message-ID: <1326639889-28836-3-git-send-email-kadlec@blackhole.kfki.hu>
References: <1326639889-28836-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	marty <martinbarrowcliff@gmail.com>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:39473 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653Ab2AOPFB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 15 Jan 2012 10:05:01 -0500
In-Reply-To: <1326639889-28836-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The plugin converts the IPv4 addresses to host order for databases
like MySQL. The expected name of the table fields are ip.hsaddr,
ip.hdaddr, etc.
---
 doc/ulogd.sgml                |    4 +
 filter/Makefile.am            |    6 +-
 filter/ulogd_filter_IP2HBIN.c |  199 +++++++++++++++++++++++++++++++++++++++++
 ulogd.conf.in                 |    1 +
 4 files changed, 209 insertions(+), 1 deletions(-)
 create mode 100644 filter/ulogd_filter_IP2HBIN.c

diff --git a/doc/ulogd.sgml b/doc/ulogd.sgml
index 0f18611..d206fa7 100644
--- a/doc/ulogd.sgml
+++ b/doc/ulogd.sgml
@@ -373,6 +373,10 @@ it basically convert mac address to a string represetation.
 <p>
 This plugin convert IP addresses to a binary form usable by databases like MySQL.
 
+<sect2>ulogd_filter_IP2HBIN.so
+<p>
+This plugin convert IP addresses to a binary form in host order usable by databases like MySQL.
+
 <sect2>ulogd_filter_IP2STR.so
 <p>
 This plugin convert IP addresses to string.
diff --git a/filter/Makefile.am b/filter/Makefile.am
index ee0a722..05f1247 100644
--- a/filter/Makefile.am
+++ b/filter/Makefile.am
@@ -6,7 +6,8 @@ AM_CFLAGS = ${regular_CFLAGS} ${LIBNFNETLINK_CFLAGS}
 pkglibexec_LTLIBRARIES = ulogd_filter_IFINDEX.la ulogd_filter_PWSNIFF.la \
 			 ulogd_filter_PRINTPKT.la ulogd_filter_PRINTFLOW.la \
 			 ulogd_filter_IP2STR.la ulogd_filter_IP2BIN.la \
-			 ulogd_filter_HWHDR.la ulogd_filter_MARK.la
+			 ulogd_filter_HWHDR.la ulogd_filter_MARK.la \
+			 ulogd_filter_IP2HBIN.la
 
 ulogd_filter_IFINDEX_la_SOURCES = ulogd_filter_IFINDEX.c
 ulogd_filter_IFINDEX_la_LDFLAGS = -avoid-version -module
@@ -21,6 +22,9 @@ ulogd_filter_IP2STR_la_LDFLAGS = -avoid-version -module
 ulogd_filter_IP2BIN_la_SOURCES = ulogd_filter_IP2BIN.c
 ulogd_filter_IP2BIN_la_LDFLAGS = -avoid-version -module
 
+ulogd_filter_IP2HBIN_la_SOURCES = ulogd_filter_IP2HBIN.c
+ulogd_filter_IP2HBIN_la_LDFLAGS = -avoid-version -module
+
 ulogd_filter_HWHDR_la_SOURCES = ulogd_filter_HWHDR.c
 ulogd_filter_HWHDR_la_LDFLAGS = -avoid-version -module
 
diff --git a/filter/ulogd_filter_IP2HBIN.c b/filter/ulogd_filter_IP2HBIN.c
new file mode 100644
index 0000000..2716fce
--- /dev/null
+++ b/filter/ulogd_filter_IP2HBIN.c
@@ -0,0 +1,199 @@
+/* ulogd_filter_IP2HBIN.c, Version $Revision: 1.0 $
+ *
+ * ulogd interpreter plugin for internal IP storage format
+ * to binary conversion in host order
+ *
+ * (C) 2012 by Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+ *
+ * Based on ulogd_filter_IP2BIN.c Eric Leblond <eric@inl.fr>
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
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <arpa/inet.h>
+#include <ulogd/ulogd.h>
+#include <netinet/if_ether.h>
+
+enum input_keys {
+	KEY_OOB_FAMILY,
+	KEY_OOB_PROTOCOL,
+	KEY_IP_SADDR,
+	START_KEY = KEY_IP_SADDR,
+	KEY_IP_DADDR,
+	KEY_ORIG_IP_SADDR,
+	KEY_ORIG_IP_DADDR,
+	KEY_REPLY_IP_SADDR,
+	KEY_REPLY_IP_DADDR,
+	MAX_KEY = KEY_REPLY_IP_DADDR,
+};
+
+static struct ulogd_key ip2hbin_inp[] = {
+	[KEY_OOB_FAMILY] = {
+		.type = ULOGD_RET_UINT8,
+		.flags = ULOGD_RETF_NONE,
+		.name = "oob.family",
+	},
+	[KEY_OOB_PROTOCOL] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "oob.protocol",
+	},
+	[KEY_IP_SADDR] = {
+		.type = ULOGD_RET_IPADDR,
+		.flags = ULOGD_RETF_NONE|ULOGD_KEYF_OPTIONAL,
+		.name = "ip.saddr",
+	},
+	[KEY_IP_DADDR] = {
+		.type = ULOGD_RET_IPADDR,
+		.flags = ULOGD_RETF_NONE|ULOGD_KEYF_OPTIONAL,
+		.name = "ip.daddr",
+	},
+	[KEY_ORIG_IP_SADDR] = {
+		.type 	= ULOGD_RET_IPADDR,
+		.flags 	= ULOGD_RETF_NONE|ULOGD_KEYF_OPTIONAL,
+		.name	= "orig.ip.saddr",
+	},
+	[KEY_ORIG_IP_DADDR] = {
+		.type	= ULOGD_RET_IPADDR,
+		.flags	= ULOGD_RETF_NONE|ULOGD_KEYF_OPTIONAL,
+		.name	= "orig.ip.daddr",
+	},
+	[KEY_REPLY_IP_SADDR] = {
+		.type 	= ULOGD_RET_IPADDR,
+		.flags 	= ULOGD_RETF_NONE|ULOGD_KEYF_OPTIONAL,
+		.name	= "reply.ip.saddr",
+	},
+	[KEY_REPLY_IP_DADDR] = {
+		.type	= ULOGD_RET_IPADDR,
+		.flags	= ULOGD_RETF_NONE|ULOGD_KEYF_OPTIONAL,
+		.name	= "reply.ip.daddr",
+	},
+};
+
+static struct ulogd_key ip2hbin_keys[] = {
+	{
+		.type = ULOGD_RET_IPADDR,
+		.name = "ip.hsaddr",
+	},
+	{
+		.type = ULOGD_RET_IPADDR,
+		.name = "ip.hdaddr",
+	},
+	{
+		.type = ULOGD_RET_IPADDR,
+		.name = "orig.ip.hsaddr",
+	},
+	{
+		.type = ULOGD_RET_IPADDR,
+		.name = "orig.ip.hdaddr",
+	},
+	{
+		.type = ULOGD_RET_IPADDR,
+		.name = "reply.ip.hsaddr",
+	},
+	{
+		.type = ULOGD_RET_IPADDR,
+		.name = "reply.ip.hdaddr",
+	},
+};
+
+static int interp_ip2hbin(struct ulogd_pluginstance *pi)
+{
+	struct ulogd_key *ret = pi->output.keys;
+	struct ulogd_key *inp = pi->input.keys;
+	u_int8_t family = ikey_get_u8(&inp[KEY_OOB_FAMILY]);
+	u_int8_t convfamily = family;
+	int i;
+	int fret;
+
+	switch (family) {
+	case AF_INET:
+	case AF_INET6:
+		break;
+	case AF_BRIDGE:
+		if (!pp_is_valid(inp, KEY_OOB_PROTOCOL)) {
+			ulogd_log(ULOGD_NOTICE,
+				  "No protocol inside AF_BRIDGE packet\n");
+			return ULOGD_IRET_ERR;
+		}
+		switch (ikey_get_u16(&inp[KEY_OOB_PROTOCOL])) {
+		case ETH_P_IPV6:
+			convfamily = AF_INET6;
+			break;
+		case ETH_P_IP:
+			convfamily = AF_INET;
+			break;
+		case ETH_P_ARP:
+			convfamily = AF_INET;
+			break;
+		default:
+			ulogd_log(ULOGD_NOTICE,
+				  "Unknown protocol inside AF_BRIDGE packet\n");
+			return ULOGD_IRET_ERR;
+		}
+		break;
+	default:
+		ulogd_log(ULOGD_NOTICE,
+			  "Unknown protocol inside packet\n");
+		return ULOGD_IRET_ERR;
+	}
+
+	/* Iter on all addr fields */
+	for(i = START_KEY; i < MAX_KEY; i++) {
+		if (pp_is_valid(inp, i)) {
+			switch (convfamily) {
+			case AF_INET:
+				okey_set_u32(&ret[i-START_KEY],
+					ntohl(ikey_get_u32(&inp[i])));
+				break;
+			case AF_INET6:
+				okey_set_ptr(&ret[i-START_KEY],
+					(struct in6_addr *)ikey_get_u128(&inp[i]));
+				break;
+			default:
+				;
+				break;
+			}
+		}
+	}
+
+	return ULOGD_IRET_OK;
+}
+
+static struct ulogd_plugin ip2hbin_pluging = {
+	.name = "IP2HBIN",
+	.input = {
+		.keys = ip2hbin_inp,
+		.num_keys = ARRAY_SIZE(ip2hbin_inp),
+		.type = ULOGD_DTYPE_PACKET | ULOGD_DTYPE_FLOW,
+		},
+	.output = {
+		.keys = ip2hbin_keys,
+		.num_keys = ARRAY_SIZE(ip2hbin_keys),
+		.type = ULOGD_DTYPE_PACKET | ULOGD_DTYPE_FLOW,
+		},
+	.interp = &interp_ip2hbin,
+	.version = ULOGD_VERSION,
+};
+
+void __attribute__ ((constructor)) init(void);
+
+void init(void)
+{
+	ulogd_register_plugin(&ip2hbin_pluging);
+}
diff --git a/ulogd.conf.in b/ulogd.conf.in
index 5fe2639..ac7bcae 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -32,6 +32,7 @@ plugin="@pkglibexecdir@/ulogd_inpflow_NFCT.so"
 plugin="@pkglibexecdir@/ulogd_filter_IFINDEX.so"
 plugin="@pkglibexecdir@/ulogd_filter_IP2STR.so"
 plugin="@pkglibexecdir@/ulogd_filter_IP2BIN.so"
+#plugin="@pkglibexecdir@/ulogd_filter_IP2HBIN.so"
 plugin="@pkglibexecdir@/ulogd_filter_PRINTPKT.so"
 plugin="@pkglibexecdir@/ulogd_filter_HWHDR.so"
 plugin="@pkglibexecdir@/ulogd_filter_PRINTFLOW.so"
-- 
1.7.0.4

