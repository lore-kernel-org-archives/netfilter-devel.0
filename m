From: Eric Leblond <eric@regit.org>
Subject: [PATCH 2/4] addr: add file containing addr utility functions.
Date: Fri, 28 Dec 2012 18:29:59 +0100
Message-ID: <1356715802-11572-3-git-send-email-eric@regit.org>
References: <1356715802-11572-1-git-send-email-eric@regit.org>
Cc: Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:57965 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782Ab2L1RaV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Dec 2012 12:30:21 -0500
In-Reply-To: <1356715802-11572-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Eric Leblond <eric@regit.org>
---
 include/ulogd/addr.h |   18 ++++++++
 src/Makefile.am      |    2 +-
 src/addr.c           |  113 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 132 insertions(+), 1 deletion(-)
 create mode 100644 include/ulogd/addr.h
 create mode 100644 src/addr.c

diff --git a/include/ulogd/addr.h b/include/ulogd/addr.h
new file mode 100644
index 0000000..9c91270
--- /dev/null
+++ b/include/ulogd/addr.h
@@ -0,0 +1,18 @@
+#ifndef _ADDR_H
+#define _ADDR_H
+
+u_int32_t ulogd_bits2netmask(int bits);
+void ulogd_ipv6_cidr2mask_host(uint8_t cidr, uint32_t *res);
+void ulogd_ipv6_addr2addr_host(uint32_t *addr, uint32_t *res);
+
+struct ulogd_addr {
+	union {
+		uint32_t ipv4;
+		uint32_t ipv6[4];
+	} in;
+	uint32_t netmask;
+};
+
+int ulogd_parse_addr(char *string, size_t len, struct ulogd_addr *addr);
+
+#endif
diff --git a/src/Makefile.am b/src/Makefile.am
index 115ddd5..e462cb2 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -6,6 +6,6 @@ AM_CFLAGS = ${regular_CFLAGS}
 
 sbin_PROGRAMS = ulogd
 
-ulogd_SOURCES = ulogd.c select.c timer.c rbtree.c conffile.c hash.c
+ulogd_SOURCES = ulogd.c select.c timer.c rbtree.c conffile.c hash.c addr.c
 ulogd_LDADD   = ${libdl_LIBS}
 ulogd_LDFLAGS = -export-dynamic
diff --git a/src/addr.c b/src/addr.c
new file mode 100644
index 0000000..05320fe
--- /dev/null
+++ b/src/addr.c
@@ -0,0 +1,113 @@
+/* ulogd
+ *
+ * userspace logging daemon for the iptables ULOG target
+ * of the linux 2.4 netfilter subsystem.
+ *
+ * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
+ * (C) 2012 by Eric Leblond <eric@regit.org>
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
+#include <arpa/inet.h>
+
+#include <ulogd/ulogd.h>
+#include <ulogd/addr.h>
+
+u_int32_t ulogd_bits2netmask(int bits)
+{
+	u_int32_t netmask, bm;
+
+	if (bits >= 32 || bits < 0)
+		return(~0);
+	for (netmask = 0, bm = 0x80000000; bits; bits--, bm >>= 1)
+		netmask |= bm;
+	return netmask;
+}
+
+
+void ulogd_ipv6_cidr2mask_host(uint8_t cidr, uint32_t *res)
+{
+	int i, j;
+
+	memset(res, 0, sizeof(uint32_t)*4);
+	for (i = 0;  i < 4 && cidr > 32; i++) {
+		res[i] = 0xFFFFFFFF;
+		cidr -= 32;
+	}
+	res[i] = 0xFFFFFFFF << (32 - cidr);
+	for (j = i+1; j < 4; j++) {
+		res[j] = 0;
+	}
+}
+
+/* I need this function because I initially defined an IPv6 address as
+ * uint32 u[4]. Using char u[16] instead would allow to remove this. */
+void ulogd_ipv6_addr2addr_host(uint32_t *addr, uint32_t *res)
+{
+	int i;
+
+	memset(res, 0, sizeof(uint32_t)*4);
+	for (i = 0;  i < 4; i++) {
+		res[i] = ntohl(addr[i]);
+	}
+}
+
+int ulogd_parse_addr(char *string, size_t len, struct ulogd_addr *addr)
+{
+	char filter_addr[128];
+	char *slash;
+	char *ddash;
+	if ((ddash = strchr(string, ':')) && (ddash - string < len)) {
+		struct in6_addr raddr;
+		int i;
+		slash = strchr(string, '/');
+		if (slash == NULL) {
+			ulogd_log(ULOGD_FATAL,
+					"No network specified\n");
+			return -1;
+		}
+
+		strncpy(filter_addr, string,
+				slash - string);
+		filter_addr[slash - string] = 0;
+		if (inet_pton(AF_INET6, filter_addr, (void *)&raddr)
+				!= 1) {
+			ulogd_log(ULOGD_FATAL,
+					"error reading address\n");
+			return -1;
+		}
+		for(i = 0; i < 4; i++)
+			addr->in.ipv6[i] = raddr.s6_addr32[i];
+		addr->netmask = atoi(slash + 1);
+
+		return AF_INET6;
+	}
+	if ((ddash = strchr(string, '.')) && (ddash - string < len)) {
+		slash = strchr(string, '/');
+		if (slash == NULL) {
+			ulogd_log(ULOGD_FATAL,
+					"No network specified\n");
+			return -1;
+		}
+		strncpy(filter_addr, string,
+				slash - string);
+		filter_addr[slash - string] = 0;
+		addr->in.ipv4 = inet_addr(filter_addr);
+		addr->netmask = atoi(slash + 1);
+
+		return AF_INET;
+	}
+	return -1;
+}
-- 
1.7.10.4

