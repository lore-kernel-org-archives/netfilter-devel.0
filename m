From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 2/4] Add parsing module for raw.mac.
Date: Wed, 23 Jul 2008 23:20:46 +0200
Message-ID: <1216848048-13516-2-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:39931 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754639AbYGWVUu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jul 2008 17:20:50 -0400
In-Reply-To: <>
References: <>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a module named RAWMAC which is in charge of parsing the
hardware header to extract source and destination hardware address.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 filter/Makefile.am           |    6 +-
 filter/ulogd_filter_RAWMAC.c |  214 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 219 insertions(+), 1 deletions(-)
 create mode 100644 filter/ulogd_filter_RAWMAC.c

diff --git a/filter/Makefile.am b/filter/Makefile.am
index cbeb5bc..3ac2fac 100644
--- a/filter/Makefile.am
+++ b/filter/Makefile.am
@@ -5,7 +5,8 @@ INCLUDES = $(all_includes) -I$(top_srcdir)/include
 pkglib_LTLIBRARIES = ulogd_filter_IFINDEX.la ulogd_filter_PWSNIFF.la \
 		     ulogd_filter_PRINTPKT.la ulogd_filter_PRINTFLOW.la \
 		     ulogd_filter_IP2STR.la ulogd_filter_IP2BIN.la \
-		     ulogd_filter_MAC2STR.la ulogd_filter_MARK.la
+		     ulogd_filter_MAC2STR.la ulogd_filter_MARK.la \
+		     ulogd_filter_RAWMAC.la
 
 ulogd_filter_IFINDEX_la_SOURCES = ulogd_filter_IFINDEX.c
 ulogd_filter_IFINDEX_la_LDFLAGS = -module -lnfnetlink
@@ -22,6 +23,9 @@ ulogd_filter_IP2BIN_la_LDFLAGS = -module
 ulogd_filter_MAC2STR_la_SOURCES = ulogd_filter_MAC2STR.c
 ulogd_filter_MAC2STR_la_LDFLAGS = -module
 
+ulogd_filter_RAWMAC_la_SOURCES = ulogd_filter_RAWMAC.c
+ulogd_filter_RAWMAC_la_LDFLAGS = -module
+
 ulogd_filter_MARK_la_SOURCES = ulogd_filter_MARK.c
 ulogd_filter_MARK_la_LDFLAGS = -module
 
diff --git a/filter/ulogd_filter_RAWMAC.c b/filter/ulogd_filter_RAWMAC.c
new file mode 100644
index 0000000..efe910a
--- /dev/null
+++ b/filter/ulogd_filter_RAWMAC.c
@@ -0,0 +1,214 @@
+/* ulogd_filter_RAWMAC.c, Version $Revision: 1500 $
+ *
+ * ulogd interpreter plugin for RAWMAC
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
+#include <linux/if_arp.h>
+#include <linux/if_ether.h>
+#include <ulogd/ulogd.h>
+
+enum input_keys {
+	KEY_RAW_MAC,
+	KEY_RAW_MACLEN,
+	KEY_RAW_TYPE,
+	KEY_RAW_MAC_SADDR,
+	KEY_RAW_MAC_ADDRLEN,
+	KEY_OOB_PROTOCOL,
+};
+
+enum output_keys {
+	KEY_MAC_TYPE,
+	KEY_MAC_SADDR,
+	KEY_MAC_DADDR,
+	KEY_MAC_PROTOCOL,
+	KEY_MAC_ADDR_LEN,
+};
+
+static struct ulogd_key rawmac_inp[] = {
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
+	[KEY_RAW_TYPE] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE|ULOGD_KEYF_OPTIONAL,
+		.name = "raw.type",
+	},
+	[KEY_RAW_MAC_SADDR] = {
+		.type = ULOGD_RET_RAW,
+		.flags = ULOGD_RETF_NONE|ULOGD_KEYF_OPTIONAL,
+		.name = "raw.mac.saddr",
+	},
+	[KEY_RAW_MAC_ADDRLEN] = {
+		.type = ULOGD_RET_RAW,
+		.flags = ULOGD_RETF_NONE|ULOGD_KEYF_OPTIONAL,
+		.name = "raw.mac.addrlen",
+	},
+	[KEY_OOB_PROTOCOL] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "oob.protocol",
+	},
+
+};
+
+static struct ulogd_key rawmac_keys[] = {
+	[KEY_MAC_TYPE] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "raw.type",
+	},
+	[KEY_MAC_SADDR] = {
+		.type = ULOGD_RET_RAW,
+		.flags = ULOGD_RETF_NONE,
+		.name = "raw.mac.saddr",
+	},
+	[KEY_MAC_DADDR] = {
+		.type = ULOGD_RET_RAW,
+		.flags = ULOGD_RETF_NONE,
+		.name = "raw.mac.daddr",
+	},
+	[KEY_MAC_PROTOCOL] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "oob.protocol",
+	},
+	[KEY_MAC_ADDR_LEN] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "raw.mac.addrlen",
+	},
+};
+
+static int parse_ethernet(struct ulogd_key *ret, struct ulogd_key *inp)
+{
+	ret[KEY_MAC_SADDR].u.value.ptr =
+		(unsigned char *) GET_VALUE(inp, KEY_RAW_MAC).ptr + ETH_ALEN;
+	ret[KEY_MAC_SADDR].flags |= ULOGD_RETF_VALID;
+	ret[KEY_MAC_DADDR].u.value.ptr =
+		(unsigned char *) GET_VALUE(inp, KEY_RAW_MAC).ptr;
+	ret[KEY_MAC_DADDR].flags |= ULOGD_RETF_VALID;
+
+	ret[KEY_MAC_PROTOCOL].u.value.ui16 =
+		ntohs(*(u_int16_t *) (GET_VALUE(inp, KEY_RAW_MAC).ptr
+					+ 2 * ETH_ALEN));
+	ret[KEY_MAC_PROTOCOL].flags |= ULOGD_RETF_VALID;
+	ret[KEY_MAC_ADDR_LEN].u.value.ui16 = ETH_ALEN;
+	ret[KEY_MAC_ADDR_LEN].flags |= ULOGD_RETF_VALID;
+
+}
+
+static int parse_rawmac(struct ulogd_key *ret, struct ulogd_key *inp, int type)
+{
+	switch (type) {
+		case ARPHRD_ETHER:
+			return parse_ethernet(ret, inp);
+		default:
+			ulogd_log(ULOGD_NOTICE, "Unsupported hardware type (%d), "
+				  "unable to parse.\n", GET_VALUE(ret, KEY_RAW_TYPE).ui16);
+	}
+	return ULOGD_IRET_OK;
+}
+
+static int interp_rawmac(struct ulogd_pluginstance *pi)
+{
+	struct ulogd_key *ret = pi->output.keys;
+	struct ulogd_key *inp = pi->input.keys;
+	u_int16_t type;
+
+	if (pp_is_valid(inp, KEY_OOB_PROTOCOL)) {
+		ret[KEY_MAC_PROTOCOL].u.value.ui16 =
+			GET_VALUE(inp, KEY_OOB_PROTOCOL).ui16;
+		ret[KEY_MAC_PROTOCOL].flags |= ULOGD_RETF_VALID;
+	}
+
+	if (pp_is_valid(inp, KEY_RAW_MAC_SADDR)) {
+		ret[KEY_MAC_SADDR].u.value.ptr =
+			GET_VALUE(inp, KEY_RAW_MAC_SADDR).ptr;
+		ret[KEY_MAC_SADDR].flags |= ULOGD_RETF_VALID;
+	}
+
+	if (pp_is_valid(inp, KEY_RAW_MAC_ADDRLEN)) {
+		ret[KEY_MAC_ADDR_LEN].u.value.ui16 =
+			GET_VALUE(inp, KEY_RAW_MAC_ADDRLEN).ui16;
+		ret[KEY_MAC_ADDR_LEN].flags |= ULOGD_RETF_VALID;
+	}
+
+	if (! pp_is_valid(inp, KEY_RAW_MAC))
+		return ULOGD_IRET_OK;
+
+	if (pp_is_valid(inp, KEY_RAW_TYPE)) {
+		ret[KEY_MAC_TYPE].u.value.ui16 = type =
+			GET_VALUE(inp, KEY_RAW_TYPE).ui16;
+		ret[KEY_MAC_TYPE].flags |= ULOGD_RETF_VALID;
+	} else {
+		if (! pp_is_valid(inp, KEY_RAW_MACLEN)) {
+			if (GET_VALUE(inp, KEY_RAW_MAC_ADDRLEN).ui16 == ETH_ALEN) {
+				ret[KEY_MAC_TYPE].u.value.ui16 = type =
+					ARPHRD_ETHER;
+				ret[KEY_MAC_TYPE].flags |= ULOGD_RETF_VALID;
+			}
+			return ULOGD_IRET_OK;
+		}
+		/* Will parse if this is ethernet encapsulation */
+		if (GET_VALUE(inp, KEY_RAW_MACLEN).ui16 == ETH_HLEN) {
+			ret[KEY_MAC_TYPE].u.value.ui16 = type = ARPHRD_ETHER;
+			ret[KEY_MAC_TYPE].flags |= ULOGD_RETF_VALID;
+		} else
+			return ULOGD_IRET_OK;
+	}
+
+	return parse_rawmac(ret, inp, type);
+}
+
+static struct ulogd_plugin rawmac_pluging = {
+	.name = "RAWMAC",
+	.input = {
+		.keys = rawmac_inp,
+		.num_keys = ARRAY_SIZE(rawmac_inp),
+		.type = ULOGD_DTYPE_PACKET,
+		},
+	.output = {
+		.keys = rawmac_keys,
+		.num_keys = ARRAY_SIZE(rawmac_keys),
+		.type = ULOGD_DTYPE_PACKET,
+		},
+	.interp = &interp_rawmac,
+	.version = ULOGD_VERSION,
+};
+
+void __attribute__ ((constructor)) init(void);
+
+void init(void)
+{
+	ulogd_register_plugin(&rawmac_pluging);
+}
-- 
1.5.4.3

