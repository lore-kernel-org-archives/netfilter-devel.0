From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 2/2] Rename MAC2STR to HWHDR.
Date: Sat, 26 Jul 2008 17:43:48 +0200
Message-ID: <1217087028-1136-3-git-send-email-eric@inl.fr>
References: <20080724171600.GA23670@khasse.inl.fr>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@inl.fr>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:41934 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751846AbYGZPnv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Jul 2008 11:43:51 -0400
In-Reply-To: <20080724171600.GA23670@khasse.inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch renames the plugin MAC2STR to HWHDR.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 filter/Makefile.am            |    6 +-
 filter/ulogd_filter_HWHDR.c   |  241 +++++++++++++++++++++++++++++++++++++++++
 filter/ulogd_filter_MAC2STR.c |  241 -----------------------------------------
 ulogd.conf.in                 |    6 +-
 4 files changed, 247 insertions(+), 247 deletions(-)
 create mode 100644 filter/ulogd_filter_HWHDR.c
 delete mode 100644 filter/ulogd_filter_MAC2STR.c

diff --git a/filter/Makefile.am b/filter/Makefile.am
index cbeb5bc..556705c 100644
--- a/filter/Makefile.am
+++ b/filter/Makefile.am
@@ -5,7 +5,7 @@ INCLUDES = $(all_includes) -I$(top_srcdir)/include
 pkglib_LTLIBRARIES = ulogd_filter_IFINDEX.la ulogd_filter_PWSNIFF.la \
 		     ulogd_filter_PRINTPKT.la ulogd_filter_PRINTFLOW.la \
 		     ulogd_filter_IP2STR.la ulogd_filter_IP2BIN.la \
-		     ulogd_filter_MAC2STR.la ulogd_filter_MARK.la
+		     ulogd_filter_HWHDR.la ulogd_filter_MARK.la
 
 ulogd_filter_IFINDEX_la_SOURCES = ulogd_filter_IFINDEX.c
 ulogd_filter_IFINDEX_la_LDFLAGS = -module -lnfnetlink
@@ -19,8 +19,8 @@ ulogd_filter_IP2STR_la_LDFLAGS = -module
 ulogd_filter_IP2BIN_la_SOURCES = ulogd_filter_IP2BIN.c
 ulogd_filter_IP2BIN_la_LDFLAGS = -module
 
-ulogd_filter_MAC2STR_la_SOURCES = ulogd_filter_MAC2STR.c
-ulogd_filter_MAC2STR_la_LDFLAGS = -module
+ulogd_filter_HWHDR_la_SOURCES = ulogd_filter_HWHDR.c
+ulogd_filter_HWHDR_la_LDFLAGS = -module
 
 ulogd_filter_MARK_la_SOURCES = ulogd_filter_MARK.c
 ulogd_filter_MARK_la_LDFLAGS = -module
diff --git a/filter/ulogd_filter_HWHDR.c b/filter/ulogd_filter_HWHDR.c
new file mode 100644
index 0000000..d2cbbe0
--- /dev/null
+++ b/filter/ulogd_filter_HWHDR.c
@@ -0,0 +1,241 @@
+/* ulogd_filter_HWHDR.c, Version $Revision: 1500 $
+ *
+ * ulogd interpreter plugin for HW header
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
+	KEY_RAW_TYPE,
+	KEY_OOB_PROTOCOL,
+	KEY_RAW_MAC,
+	KEY_RAW_MACLEN,
+	KEY_RAW_MAC_SADDR,
+	KEY_RAW_MAC_ADDRLEN,
+};
+
+enum output_keys {
+	KEY_HWHDR_TYPE,
+	KEY_HWHDR_PROTOCOL,
+	KEY_HWHDR_SADDR,
+	KEY_HWHDR_DADDR,
+	KEY_HWHDR_ADDR,
+};
+
+static struct ulogd_key hwhdr_inp[] = {
+	[KEY_RAW_TYPE] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE|ULOGD_KEYF_OPTIONAL,
+		.name = "raw.type",
+	},
+	[KEY_OOB_PROTOCOL] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "oob.protocol",
+	},
+	[KEY_RAW_MAC] = {
+		.type = ULOGD_RET_RAW,
+		.flags = ULOGD_RETF_NONE|ULOGD_KEYF_OPTIONAL,
+		.name = "raw.mac",
+	},
+	[KEY_RAW_MACLEN] = { 
+		.type = ULOGD_RET_UINT16, 
+		.flags = ULOGD_RETF_NONE|ULOGD_KEYF_OPTIONAL,
+		.name = "raw.mac_len", 
+	},
+	[KEY_RAW_MAC_SADDR] = {
+		.type = ULOGD_RET_RAW,
+		.flags = ULOGD_RETF_NONE|ULOGD_KEYF_OPTIONAL,
+		.name = "raw.mac.saddr",
+	},
+	[KEY_RAW_MAC_ADDRLEN] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE|ULOGD_KEYF_OPTIONAL,
+		.name = "raw.mac.addrlen",
+	},
+};
+
+static struct ulogd_key hwhdr_keys[] = {
+	[KEY_HWHDR_TYPE] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "raw.type",
+	},
+	[KEY_HWHDR_PROTOCOL] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "oob.protocol",
+	},
+	[KEY_HWHDR_SADDR] = {
+		.type = ULOGD_RET_STRING,
+		.flags = ULOGD_RETF_FREE,
+		.name = "mac.saddr.str",
+	},
+	[KEY_HWHDR_DADDR] = {
+		.type = ULOGD_RET_STRING,
+		.flags = ULOGD_RETF_FREE,
+		.name = "mac.daddr.str",
+	},
+	[KEY_HWHDR_ADDR] = {
+		.type = ULOGD_RET_STRING,
+		.flags = ULOGD_RETF_FREE,
+		.name = "mac.str",
+	},
+};
+
+static int parse_mac2str(struct ulogd_key *ret, unsigned char *mac,
+			 int okey, int len)
+{
+	char *mac_str = calloc(len/sizeof(char)*3, sizeof(char));
+	char *buf_cur = mac_str;
+	int i;
+
+	if (mac_str == NULL)
+		return ULOGD_IRET_ERR;
+
+	for (i = 0; i < len; i++)
+		buf_cur += sprintf(buf_cur, "%02x%c", mac[i],
+				i == len - 1 ? 0 : ':');
+
+	ret[okey].u.value.ptr = mac_str;
+	ret[okey].flags |= ULOGD_RETF_VALID;
+
+	return ULOGD_IRET_OK;
+}
+
+static int parse_ethernet(struct ulogd_key *ret, struct ulogd_key *inp)
+{
+	int fret;
+	if (! pp_is_valid(inp, KEY_RAW_MAC_SADDR)) {
+		fret = parse_mac2str(ret, 
+				     GET_VALUE(inp, KEY_RAW_MAC).ptr
+					+ ETH_ALEN,
+				     KEY_HWHDR_SADDR, ETH_ALEN);
+		if (fret != ULOGD_IRET_OK)
+			return fret;
+	}
+	fret = parse_mac2str(ret, GET_VALUE(inp, KEY_RAW_MAC).ptr,
+			     KEY_HWHDR_DADDR, ETH_ALEN);
+	if (fret != ULOGD_IRET_OK)
+		return fret;
+
+	ret[KEY_HWHDR_PROTOCOL].u.value.ui16 =
+		ntohs(*(u_int16_t *) (GET_VALUE(inp, KEY_RAW_MAC).ptr
+					+ 2 * ETH_ALEN));
+	ret[KEY_HWHDR_PROTOCOL].flags |= ULOGD_RETF_VALID;
+
+	return ULOGD_IRET_OK;
+}
+
+static int interp_hwhdr(struct ulogd_pluginstance *pi)
+{
+	struct ulogd_key *ret = pi->output.keys;
+	struct ulogd_key *inp = pi->input.keys;
+	u_int16_t type = 0;
+
+	if (pp_is_valid(inp, KEY_OOB_PROTOCOL)) {
+		ret[KEY_HWHDR_PROTOCOL].u.value.ui16 =
+			GET_VALUE(inp, KEY_OOB_PROTOCOL).ui16;
+		ret[KEY_HWHDR_PROTOCOL].flags |= ULOGD_RETF_VALID;
+	}
+
+	if (pp_is_valid(inp, KEY_RAW_MAC_SADDR)) {
+		int fret;
+		fret = parse_mac2str(ret,
+				     GET_VALUE(inp, KEY_RAW_MAC_SADDR).ptr,
+				     KEY_HWHDR_SADDR,
+				     GET_VALUE(inp, KEY_RAW_MAC_ADDRLEN).ui16);
+		if (fret != ULOGD_IRET_OK)
+			return fret;
+	}
+
+	if (! pp_is_valid(inp, KEY_RAW_MAC)) {
+		if (GET_VALUE(inp, KEY_RAW_MAC_ADDRLEN).ui16 == ETH_ALEN) {
+			ret[KEY_HWHDR_TYPE].u.value.ui16 = ARPHRD_ETHER;
+			ret[KEY_HWHDR_TYPE].flags |= ULOGD_RETF_VALID;
+		} else {
+			ret[KEY_HWHDR_TYPE].u.value.ui16 = ARPHRD_VOID;
+			ret[KEY_HWHDR_TYPE].flags |= ULOGD_RETF_VALID;
+		}
+		return ULOGD_IRET_OK;
+	}
+
+	if (pp_is_valid(inp, KEY_RAW_TYPE)) {
+		/* NFLOG with Linux >= 2.6.27 case */
+		ret[KEY_HWHDR_TYPE].u.value.ui16 = type =
+			GET_VALUE(inp, KEY_RAW_TYPE).ui16;
+		ret[KEY_HWHDR_TYPE].flags |= ULOGD_RETF_VALID;
+	} else {
+		/* ULOG case, treat ethernet encapsulation */
+		if (GET_VALUE(inp, KEY_RAW_MACLEN).ui16 == ETH_HLEN) {
+			ret[KEY_HWHDR_TYPE].u.value.ui16 = type = ARPHRD_ETHER;
+			ret[KEY_HWHDR_TYPE].flags |= ULOGD_RETF_VALID;
+		} else {
+			ret[KEY_HWHDR_TYPE].u.value.ui16 = type = ARPHRD_VOID;
+			ret[KEY_HWHDR_TYPE].flags |= ULOGD_RETF_VALID;
+		}
+	}
+
+	switch (type) {
+		case ARPHRD_ETHER:
+			parse_ethernet(ret, inp);
+		default:
+			/* convert raw header to string */
+			return parse_mac2str(ret,
+					     GET_VALUE(inp, KEY_RAW_MAC).ptr,
+					     KEY_HWHDR_ADDR,
+					     GET_VALUE(inp,
+						     KEY_RAW_MACLEN).ui16);
+	}
+	return ULOGD_IRET_OK;
+}
+
+
+
+static struct ulogd_plugin hwhdr_pluging = {
+	.name = "HWHDR",
+	.input = {
+		.keys = hwhdr_inp,
+		.num_keys = ARRAY_SIZE(hwhdr_inp),
+		.type = ULOGD_DTYPE_PACKET,
+		},
+	.output = {
+		.keys = hwhdr_keys,
+		.num_keys = ARRAY_SIZE(hwhdr_keys),
+		.type = ULOGD_DTYPE_PACKET,
+		},
+	.interp = &interp_hwhdr,
+	.version = ULOGD_VERSION,
+};
+
+void __attribute__ ((constructor)) init(void);
+
+void init(void)
+{
+	ulogd_register_plugin(&hwhdr_pluging);
+}
diff --git a/filter/ulogd_filter_MAC2STR.c b/filter/ulogd_filter_MAC2STR.c
deleted file mode 100644
index b4c3864..0000000
--- a/filter/ulogd_filter_MAC2STR.c
+++ /dev/null
@@ -1,241 +0,0 @@
-/* ulogd_filter_MAC2STR.c, Version $Revision: 1500 $
- *
- * ulogd interpreter plugin for HWMAC
- *
- * (C) 2008 by Eric Leblond <eric@inl.fr>
- *
- * Based on ulogd_filter_IFINDEX.c Harald Welte <laforge@gnumonks.org>
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License version 2
- *  as published by the Free Software Foundation
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- *
- * $Id: ulogd_filter_IFINDEX.c 1500 2005-10-03 16:54:02Z laforge $
- */
-
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-#include <arpa/inet.h>
-#include <linux/if_arp.h>
-#include <linux/if_ether.h>
-#include <ulogd/ulogd.h>
-
-enum input_keys {
-	KEY_RAW_TYPE,
-	KEY_OOB_PROTOCOL,
-	KEY_RAW_MAC,
-	KEY_RAW_MACLEN,
-	KEY_RAW_MAC_SADDR,
-	KEY_RAW_MAC_ADDRLEN,
-};
-
-enum output_keys {
-	KEY_MAC_TYPE,
-	KEY_MAC_PROTOCOL,
-	KEY_MAC_SADDR,
-	KEY_MAC_DADDR,
-	KEY_MAC_ADDR,
-};
-
-static struct ulogd_key mac2str_inp[] = {
-	[KEY_RAW_TYPE] = {
-		.type = ULOGD_RET_UINT16,
-		.flags = ULOGD_RETF_NONE|ULOGD_KEYF_OPTIONAL,
-		.name = "raw.type",
-	},
-	[KEY_OOB_PROTOCOL] = {
-		.type = ULOGD_RET_UINT16,
-		.flags = ULOGD_RETF_NONE,
-		.name = "oob.protocol",
-	},
-	[KEY_RAW_MAC] = {
-		.type = ULOGD_RET_RAW,
-		.flags = ULOGD_RETF_NONE|ULOGD_KEYF_OPTIONAL,
-		.name = "raw.mac",
-	},
-	[KEY_RAW_MACLEN] = { 
-		.type = ULOGD_RET_UINT16, 
-		.flags = ULOGD_RETF_NONE|ULOGD_KEYF_OPTIONAL,
-		.name = "raw.mac_len", 
-	},
-	[KEY_RAW_MAC_SADDR] = {
-		.type = ULOGD_RET_RAW,
-		.flags = ULOGD_RETF_NONE|ULOGD_KEYF_OPTIONAL,
-		.name = "raw.mac.saddr",
-	},
-	[KEY_RAW_MAC_ADDRLEN] = {
-		.type = ULOGD_RET_UINT16,
-		.flags = ULOGD_RETF_NONE|ULOGD_KEYF_OPTIONAL,
-		.name = "raw.mac.addrlen",
-	},
-};
-
-static struct ulogd_key mac2str_keys[] = {
-	[KEY_MAC_TYPE] = {
-		.type = ULOGD_RET_UINT16,
-		.flags = ULOGD_RETF_NONE,
-		.name = "raw.type",
-	},
-	[KEY_MAC_PROTOCOL] = {
-		.type = ULOGD_RET_UINT16,
-		.flags = ULOGD_RETF_NONE,
-		.name = "oob.protocol",
-	},
-	[KEY_MAC_SADDR] = {
-		.type = ULOGD_RET_STRING,
-		.flags = ULOGD_RETF_FREE,
-		.name = "mac.saddr.str",
-	},
-	[KEY_MAC_DADDR] = {
-		.type = ULOGD_RET_STRING,
-		.flags = ULOGD_RETF_FREE,
-		.name = "mac.daddr.str",
-	},
-	[KEY_MAC_ADDR] = {
-		.type = ULOGD_RET_STRING,
-		.flags = ULOGD_RETF_FREE,
-		.name = "mac.str",
-	},
-};
-
-static int parse_mac2str(struct ulogd_key *ret, unsigned char *mac,
-			 int okey, int len)
-{
-	char *mac_str = calloc(len/sizeof(char)*3, sizeof(char));
-	char *buf_cur = mac_str;
-	int i;
-
-	if (mac_str == NULL)
-		return ULOGD_IRET_ERR;
-
-	for (i = 0; i < len; i++)
-		buf_cur += sprintf(buf_cur, "%02x%c", mac[i],
-				i == len - 1 ? 0 : ':');
-
-	ret[okey].u.value.ptr = mac_str;
-	ret[okey].flags |= ULOGD_RETF_VALID;
-
-	return ULOGD_IRET_OK;
-}
-
-static int parse_ethernet(struct ulogd_key *ret, struct ulogd_key *inp)
-{
-	int fret;
-	if (! pp_is_valid(inp, KEY_RAW_MAC_SADDR)) {
-		fret = parse_mac2str(ret, 
-				     GET_VALUE(inp, KEY_RAW_MAC).ptr
-					+ ETH_ALEN,
-				     KEY_MAC_SADDR, ETH_ALEN);
-		if (fret != ULOGD_IRET_OK)
-			return fret;
-	}
-	fret = parse_mac2str(ret, GET_VALUE(inp, KEY_RAW_MAC).ptr,
-			     KEY_MAC_DADDR, ETH_ALEN);
-	if (fret != ULOGD_IRET_OK)
-		return fret;
-
-	ret[KEY_MAC_PROTOCOL].u.value.ui16 =
-		ntohs(*(u_int16_t *) (GET_VALUE(inp, KEY_RAW_MAC).ptr
-					+ 2 * ETH_ALEN));
-	ret[KEY_MAC_PROTOCOL].flags |= ULOGD_RETF_VALID;
-
-	return ULOGD_IRET_OK;
-}
-
-static int interp_mac2str(struct ulogd_pluginstance *pi)
-{
-	struct ulogd_key *ret = pi->output.keys;
-	struct ulogd_key *inp = pi->input.keys;
-	u_int16_t type = 0;
-
-	if (pp_is_valid(inp, KEY_OOB_PROTOCOL)) {
-		ret[KEY_MAC_PROTOCOL].u.value.ui16 =
-			GET_VALUE(inp, KEY_OOB_PROTOCOL).ui16;
-		ret[KEY_MAC_PROTOCOL].flags |= ULOGD_RETF_VALID;
-	}
-
-	if (pp_is_valid(inp, KEY_RAW_MAC_SADDR)) {
-		int fret;
-		fret = parse_mac2str(ret,
-				     GET_VALUE(inp, KEY_RAW_MAC_SADDR).ptr,
-				     KEY_MAC_SADDR,
-				     GET_VALUE(inp, KEY_RAW_MAC_ADDRLEN).ui16);
-		if (fret != ULOGD_IRET_OK)
-			return fret;
-	}
-
-	if (! pp_is_valid(inp, KEY_RAW_MAC)) {
-		if (GET_VALUE(inp, KEY_RAW_MAC_ADDRLEN).ui16 == ETH_ALEN) {
-			ret[KEY_MAC_TYPE].u.value.ui16 = ARPHRD_ETHER;
-			ret[KEY_MAC_TYPE].flags |= ULOGD_RETF_VALID;
-		} else {
-			ret[KEY_MAC_TYPE].u.value.ui16 = ARPHRD_VOID;
-			ret[KEY_MAC_TYPE].flags |= ULOGD_RETF_VALID;
-		}
-		return ULOGD_IRET_OK;
-	}
-
-	if (pp_is_valid(inp, KEY_RAW_TYPE)) {
-		/* NFLOG with Linux >= 2.6.27 case */
-		ret[KEY_MAC_TYPE].u.value.ui16 = type =
-			GET_VALUE(inp, KEY_RAW_TYPE).ui16;
-		ret[KEY_MAC_TYPE].flags |= ULOGD_RETF_VALID;
-	} else {
-		/* ULOG case, treat ethernet encapsulation */
-		if (GET_VALUE(inp, KEY_RAW_MACLEN).ui16 == ETH_HLEN) {
-			ret[KEY_MAC_TYPE].u.value.ui16 = type = ARPHRD_ETHER;
-			ret[KEY_MAC_TYPE].flags |= ULOGD_RETF_VALID;
-		} else {
-			ret[KEY_MAC_TYPE].u.value.ui16 = type = ARPHRD_VOID;
-			ret[KEY_MAC_TYPE].flags |= ULOGD_RETF_VALID;
-		}
-	}
-
-	switch (type) {
-		case ARPHRD_ETHER:
-			parse_ethernet(ret, inp);
-		default:
-			/* convert raw header to string */
-			return parse_mac2str(ret,
-					     GET_VALUE(inp, KEY_RAW_MAC).ptr,
-					     KEY_MAC_ADDR,
-					     GET_VALUE(inp,
-						     KEY_RAW_MACLEN).ui16);
-	}
-	return ULOGD_IRET_OK;
-}
-
-
-
-static struct ulogd_plugin mac2str_pluging = {
-	.name = "MAC2STR",
-	.input = {
-		.keys = mac2str_inp,
-		.num_keys = ARRAY_SIZE(mac2str_inp),
-		.type = ULOGD_DTYPE_PACKET,
-		},
-	.output = {
-		.keys = mac2str_keys,
-		.num_keys = ARRAY_SIZE(mac2str_keys),
-		.type = ULOGD_DTYPE_PACKET,
-		},
-	.interp = &interp_mac2str,
-	.version = ULOGD_VERSION,
-};
-
-void __attribute__ ((constructor)) init(void);
-
-void init(void)
-{
-	ulogd_register_plugin(&mac2str_pluging);
-}
diff --git a/ulogd.conf.in b/ulogd.conf.in
index a32234d..a86fc16 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -39,7 +39,7 @@ plugin="@libdir@/ulogd/ulogd_filter_IFINDEX.so"
 plugin="@libdir@/ulogd/ulogd_filter_IP2STR.so"
 plugin="@libdir@/ulogd/ulogd_filter_IP2BIN.so"
 plugin="@libdir@/ulogd/ulogd_filter_PRINTPKT.so"
-plugin="@libdir@/ulogd/ulogd_filter_MAC2STR.so"
+plugin="@libdir@/ulogd/ulogd_filter_HWHDR.so"
 plugin="@libdir@/ulogd/ulogd_filter_PRINTFLOW.so"
 #plugin="@libdir@/ulogd/ulogd_filter_MARK.so"
 plugin="@libdir@/ulogd/ulogd_output_LOGEMU.so"
@@ -76,10 +76,10 @@ plugin="@libdir@/ulogd/ulogd_raw2packet_BASE.so"
 #stack=log1:NFLOG,base1:BASE,pcap1:PCAP
 
 # this is a stack for logging packet to MySQL
-#stack=log1:NFLOG,base1:BASE,ifi1:IFINDEX,ip2bin1:IP2BIN,mac2str1:MAC2STR,mysql1:MYSQL
+#stack=log1:NFLOG,base1:BASE,ifi1:IFINDEX,ip2bin1:IP2BIN,hwhdr1:HWHDR,mysql1:MYSQL
 
 # this is a stack for logging IPv6 packet to PGsql after a collect via NFLOG
-#stack=log2:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,mac2str1:MAC2STR,pgsql1:PGSQL
+#stack=log2:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,hwhdr1:HWHDR,pgsql1:PGSQL
 
 # this is a stack for logging ebtables packets to syslog after a collect via NFLOG
 #stack=log3:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,sys1:SYSLOG
-- 
1.5.4.3

