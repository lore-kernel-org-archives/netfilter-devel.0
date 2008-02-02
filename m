From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 21/34]  Add IP2BIN module: convert IP address to binary string.
Date: Sat,  2 Feb 2008 22:24:16 +0100
Message-ID: <12019874712041-git-send-email-eric@inl.fr>
References: <1201987469575-git-send-email-eric@inl.fr>
 <1201987469368-git-send-email-eric@inl.fr>
 <12019874692227-git-send-email-eric@inl.fr>
 <12019874701613-git-send-email-eric@inl.fr>
 <12019874702005-git-send-email-eric@inl.fr>
 <12019874703998-git-send-email-eric@inl.fr>
 <12019874701589-git-send-email-eric@inl.fr>
 <12019874701366-git-send-email-eric@inl.fr>
 <12019874704144-git-send-email-eric@inl.fr>
 <12019874703136-git-send-email-eric@inl.fr>
 <12019874701552-git-send-email-eric@inl.fr>
 <12019874701370-git-send-email-eric@inl.fr>
 <12019874702349-git-send-email-eric@inl.fr>
 <12019874703504-git-send-email-eric@inl.fr>
 <12019874704067-git-send-email-eric@inl.fr>
 <12019874703897-git-send-email-eric@inl.fr>
 <12019874712066-git-send-email-eric@inl.fr>
 <1201987471474-git-send-email-eric@inl.fr>
 <1201987471346-git-send-email-eric@inl.fr>
 <12019874712309-git-send-email-eric@inl.fr>
 <12019874714080-git-send-email-eric@inl.fr>
Cc: Eric leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:45990 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757078AbYBBWNw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:13:52 -0500
In-Reply-To: <12019874714080-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Eric leblond <eric@inl.fr>

This module convert IP from internal notation to a string in binary notation
which is used by the MySQL output plugin.

Signed-off-by: Eric leblond <eric@inl.fr>
---
:100644 100644 94a14cd... 51bcc3f... M	filter/Makefile.am
:000000 100644 0000000... 7790cbd... A	filter/ulogd_filter_IP2BIN.c
 filter/Makefile.am           |    5 +-
 filter/ulogd_filter_IP2BIN.c |  229 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 233 insertions(+), 1 deletions(-)

diff --git a/filter/Makefile.am b/filter/Makefile.am
index 94a14cd..51bcc3f 100644
--- a/filter/Makefile.am
+++ b/filter/Makefile.am
@@ -6,7 +6,7 @@ noinst_HEADERS = rtnl.h iftable.h
 
 pkglib_LTLIBRARIES = ulogd_filter_IFINDEX.la ulogd_filter_PWSNIFF.la \
 		     ulogd_filter_PRINTPKT.la ulogd_filter_PRINTFLOW.la \
-		     ulogd_filter_IP2STR.la
+		     ulogd_filter_IP2STR.la ulogd_filter_IP2BIN.la
 
 ulogd_filter_IFINDEX_la_SOURCES = ulogd_filter_IFINDEX.c rtnl.c iftable.c
 ulogd_filter_IFINDEX_la_LDFLAGS = -module
@@ -17,6 +17,9 @@ ulogd_filter_PWSNIFF_la_LDFLAGS = -module
 ulogd_filter_IP2STR_la_SOURCES = ulogd_filter_IP2STR.c
 ulogd_filter_IP2STR_la_LDFLAGS = -module
 
+ulogd_filter_IP2BIN_la_SOURCES = ulogd_filter_IP2BIN.c
+ulogd_filter_IP2BIN_la_LDFLAGS = -module
+
 ulogd_filter_PRINTPKT_la_SOURCES = ulogd_filter_PRINTPKT.c ../util/printpkt.c
 ulogd_filter_PRINTPKT_la_LDFLAGS = -module
 
diff --git a/filter/ulogd_filter_IP2BIN.c b/filter/ulogd_filter_IP2BIN.c
new file mode 100644
index 0000000..7790cbd
--- /dev/null
+++ b/filter/ulogd_filter_IP2BIN.c
@@ -0,0 +1,229 @@
+/* ulogd_filter_IP2BIN.c, Version $Revision: 1500 $
+ *
+ * ulogd interpreter plugin for internal IP storage format to binary conversion
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
+ *
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
+	KEY_OOB_FAMILY,
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
+static struct ulogd_key ip2bin_inp[] = {
+	[KEY_OOB_FAMILY] = {
+		.type = ULOGD_RET_UINT8,
+		.flags = ULOGD_RETF_NONE,
+		.name = "oob.family",
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
+static struct ulogd_key ip2bin_keys[] = {
+	{
+		.type = ULOGD_RET_RAW,
+		.flags = ULOGD_RETF_FREE,
+		.name = "ip.saddr.bin",
+	},
+	{
+		.type = ULOGD_RET_RAW,
+		.flags = ULOGD_RETF_FREE,
+		.name = "ip.daddr.bin",
+	},
+	{
+		.type = ULOGD_RET_RAW,
+		.flags = ULOGD_RETF_FREE,
+		.name = "orig.ip.saddr.bin",
+	},
+	{
+		.type = ULOGD_RET_RAW,
+		.flags = ULOGD_RETF_FREE,
+		.name = "orig.ip.daddr.bin",
+	},
+	{
+		.type = ULOGD_RET_RAW,
+		.flags = ULOGD_RETF_FREE,
+		.name = "reply.ip.saddr.bin",
+	},
+	{
+		.type = ULOGD_RET_RAW,
+		.flags = ULOGD_RETF_FREE,
+		.name = "reply.ip.daddr.bin",
+	},
+
+};
+
+#define GET_VALUE(res, x)	(res[x].u.source->u.value)
+#define GET_FLAGS(res, x)	(res[x].u.source->flags)
+#define pp_is_valid(res, x)	(res[x].u.source && (GET_FLAGS(res, x) & ULOGD_RETF_VALID))
+
+/**
+ * Convert IPv4 address (as 32-bit unsigned integer) to IPv6 address:
+ * add 96 bits prefix "::ffff:" to get IPv6 address "::ffff:a.b.c.d".
+ */
+inline void uint32_to_ipv6(const uint32_t ipv4, struct in6_addr *ipv6)
+{
+	ipv6->s6_addr32[0] = 0x00000000;
+	ipv6->s6_addr32[1] = 0x00000000;
+	ipv6->s6_addr32[2] = htonl(0xffff);
+	ipv6->s6_addr32[3] = ipv4;
+}
+
+static char *ip2bin(struct ulogd_key* inp, int index, char family)
+{
+	char tmp[IPADDR_LENGTH];
+	unsigned char *addr8;
+	struct in6_addr *addr;
+	char *buffer;
+	int i, written;
+
+	switch (family) {
+		case AF_INET6:
+			addr = GET_VALUE(inp, index).ptr;
+			break;
+		case AF_INET:
+			/* Convert IPv4 to IPv4 in IPv6 */
+			uint32_to_ipv6(GET_VALUE(inp, index).ui32, addr);
+			break;
+		default:
+			/* TODO handle error */
+			ulogd_log(ULOGD_NOTICE, "Unknown protocol family\n");
+			return;
+	}
+
+	buffer = tmp;
+	/* format IPv6 to BINARY(16) as "0x..." */
+	buffer[0] = '0';
+	buffer[1] = 'x';
+	buffer += 2;
+	addr8 = &addr->s6_addr[0];
+	for (i = 0; i < 4; i++) {
+		written = sprintf(buffer, "%02x%02x%02x%02x",
+				addr8[0], addr8[1], addr8[2], addr8[3]);
+		if (written != 2 * 4) {
+			buffer[0] = 0;
+			return;
+		}
+		buffer += written;
+		addr8 += 4;
+	}
+	buffer[0] = 0;
+
+	return strdup(tmp);
+}
+
+static int interp_ip2bin(struct ulogd_pluginstance *pi)
+{
+	struct ulogd_key *ret = pi->output.keys;
+	struct ulogd_key *inp = pi->input.keys;
+	int i;
+	int oob_family = GET_VALUE(inp, KEY_OOB_FAMILY).ui8;
+
+	/* Iter on all addr fields */
+	for(i = START_KEY; i < MAX_KEY; i++) {
+		if (pp_is_valid(inp, i)) {
+			ret[i-1].u.value.ptr = ip2bin(inp, i, oob_family);
+			ret[i-1].flags |= ULOGD_RETF_VALID;
+		}
+	}
+
+	return 0;
+}
+
+static int ip2bin_start(struct ulogd_pluginstance *upi)
+{
+	return 0;
+}
+
+static int ip2bin_fini(struct ulogd_pluginstance *upi)
+{
+	return 0;
+}
+
+static struct ulogd_plugin ifindex_plugin = {
+	.name = "IP2BIN",
+	.input = {
+		.keys = ip2bin_inp,
+		.num_keys = ARRAY_SIZE(ip2bin_inp),
+		.type = ULOGD_DTYPE_PACKET | ULOGD_DTYPE_FLOW,
+		},
+	.output = {
+		.keys = ip2bin_keys,
+		.num_keys = ARRAY_SIZE(ip2bin_keys),
+		.type = ULOGD_DTYPE_PACKET | ULOGD_DTYPE_FLOW,
+		},
+	.interp = &interp_ip2bin,
+
+	.start = &ip2bin_start,
+	.stop = &ip2bin_fini,
+	.version = ULOGD_VERSION,
+};
+
+void __attribute__ ((constructor)) init(void);
+
+void init(void)
+{
+	ulogd_register_plugin(&ifindex_plugin);
+}
-- 
1.5.2.5

