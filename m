From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 16/34]  Introduce IP2STR module which convert IP to string.
Date: Sat,  2 Feb 2008 22:24:11 +0100
Message-ID: <12019874712066-git-send-email-eric@inl.fr>
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
Cc: Eric leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:46000 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761831AbYBBWO0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:14:26 -0500
In-Reply-To: <12019874703897-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Eric leblond <eric@inl.fr>

This module is a generic module which is used to convert an IP from internal
representation to string representation. This is a task needed by several modules
like printpkt or pgsql. This module factorizes the code.

Signed-off-by: Eric leblond <eric@inl.fr>
---
:100644 100644 b3207f9... 94a14cd... M	filter/Makefile.am
:000000 100644 0000000... 68a4ed7... A	filter/ulogd_filter_IP2STR.c
 filter/Makefile.am           |    6 +-
 filter/ulogd_filter_IP2STR.c |  198 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 203 insertions(+), 1 deletions(-)

diff --git a/filter/Makefile.am b/filter/Makefile.am
index b3207f9..94a14cd 100644
--- a/filter/Makefile.am
+++ b/filter/Makefile.am
@@ -5,7 +5,8 @@ INCLUDES = $(all_includes) -I$(top_srcdir)/include
 noinst_HEADERS = rtnl.h iftable.h
 
 pkglib_LTLIBRARIES = ulogd_filter_IFINDEX.la ulogd_filter_PWSNIFF.la \
-		     ulogd_filter_PRINTPKT.la ulogd_filter_PRINTFLOW.la
+		     ulogd_filter_PRINTPKT.la ulogd_filter_PRINTFLOW.la \
+		     ulogd_filter_IP2STR.la
 
 ulogd_filter_IFINDEX_la_SOURCES = ulogd_filter_IFINDEX.c rtnl.c iftable.c
 ulogd_filter_IFINDEX_la_LDFLAGS = -module
@@ -13,6 +14,9 @@ ulogd_filter_IFINDEX_la_LDFLAGS = -module
 ulogd_filter_PWSNIFF_la_SOURCES = ulogd_filter_PWSNIFF.c
 ulogd_filter_PWSNIFF_la_LDFLAGS = -module
 
+ulogd_filter_IP2STR_la_SOURCES = ulogd_filter_IP2STR.c
+ulogd_filter_IP2STR_la_LDFLAGS = -module
+
 ulogd_filter_PRINTPKT_la_SOURCES = ulogd_filter_PRINTPKT.c ../util/printpkt.c
 ulogd_filter_PRINTPKT_la_LDFLAGS = -module
 
diff --git a/filter/ulogd_filter_IP2STR.c b/filter/ulogd_filter_IP2STR.c
new file mode 100644
index 0000000..68a4ed7
--- /dev/null
+++ b/filter/ulogd_filter_IP2STR.c
@@ -0,0 +1,198 @@
+/* ulogd_filter_IP2STR.c, Version $Revision: 1500 $
+ *
+ * ulogd interpreter plugin for ifindex to ifname conversion
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
+static struct ulogd_key ip2str_inp[] = {
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
+static struct ulogd_key ip2str_keys[] = {
+	{
+		.type = ULOGD_RET_STRING,
+		.flags = ULOGD_RETF_FREE,
+		.name = "ip.saddr.str",
+	},
+	{
+		.type = ULOGD_RET_STRING,
+		.flags = ULOGD_RETF_FREE,
+		.name = "ip.daddr.str",
+	},
+	{
+		.type = ULOGD_RET_STRING,
+		.flags = ULOGD_RETF_FREE,
+		.name = "orig.ip.saddr.str",
+	},
+	{
+		.type = ULOGD_RET_STRING,
+		.flags = ULOGD_RETF_FREE,
+		.name = "orig.ip.daddr.str",
+	},
+	{
+		.type = ULOGD_RET_STRING,
+		.flags = ULOGD_RETF_FREE,
+		.name = "reply.ip.saddr.str",
+	},
+	{
+		.type = ULOGD_RET_STRING,
+		.flags = ULOGD_RETF_FREE,
+		.name = "reply.ip.daddr.str",
+	},
+
+};
+
+#define GET_VALUE(res, x)	(res[x].u.source->u.value)
+#define GET_FLAGS(res, x)	(res[x].u.source->flags)
+#define pp_is_valid(res, x)	(res[x].u.source && (GET_FLAGS(res, x) & ULOGD_RETF_VALID))
+
+
+static char *ip2str(struct ulogd_key* inp, int index, char family)
+{
+	char tmp[IPADDR_LENGTH];
+	switch (family) {
+		case AF_INET6:
+			inet_ntop(AF_INET6,
+					&GET_VALUE(inp, index).ptr,
+					tmp, sizeof(tmp));
+			break;
+		case AF_INET:
+			inet_ntop(AF_INET,
+					&GET_VALUE(inp, index).ui32,
+					tmp, sizeof(tmp));
+			break;
+		default:
+			/* TODO error handling */
+			ulogd_log(ULOGD_NOTICE, "Unknown protocol family\n");
+			return NULL;
+	}
+	return strdup(tmp);
+}
+
+static int interp_ip2str(struct ulogd_pluginstance *pi)
+{
+	struct ulogd_key *ret = pi->output.keys;
+	struct ulogd_key *inp = pi->input.keys;
+	int i;
+	int oob_family = GET_VALUE(inp, KEY_OOB_FAMILY).ui8;
+
+	/* Iter on all addr fields */
+	for(i = START_KEY; i < MAX_KEY; i++) {
+		if (pp_is_valid(inp, i)) {
+			ret[i-1].u.value.ptr = ip2str(inp, i,
+						      oob_family);
+			ret[i-1].flags |= ULOGD_RETF_VALID;
+		}
+	}
+
+	return 0;
+}
+
+static int ip2str_start(struct ulogd_pluginstance *upi)
+{
+	return 0;
+}
+
+static int ip2str_fini(struct ulogd_pluginstance *upi)
+{
+	return 0;
+}
+
+static struct ulogd_plugin ifindex_plugin = {
+	.name = "IP2STR",
+	.input = {
+		.keys = ip2str_inp,
+		.num_keys = ARRAY_SIZE(ip2str_inp),
+		.type = ULOGD_DTYPE_PACKET | ULOGD_DTYPE_FLOW,
+		},
+	.output = {
+		.keys = ip2str_keys,
+		.num_keys = ARRAY_SIZE(ip2str_keys),
+		.type = ULOGD_DTYPE_PACKET | ULOGD_DTYPE_FLOW,
+		},
+	.interp = &interp_ip2str,
+
+	.start = &ip2str_start,
+	.stop = &ip2str_fini,
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

