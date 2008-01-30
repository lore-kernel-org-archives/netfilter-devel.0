From: heitzenberger@astaro.com
Subject: [ULOGD RFC 22/30] Add set_sockbuf_len()
Date: Wed, 30 Jan 2008 19:59:09 +0100
Message-ID: <20080130190129.323941901@kruemel.intranet.astaro.de>
References: <20080130185847.693274384@kruemel.intranet.astaro.de>
Cc: holger@eitzenberger.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-64.dex002.intermedia.net ([64.78.20.13]:4031 "EHLO
	dhost002-64.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754031AbYA3TBq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:01:46 -0500
Content-Disposition: inline; filename=ulogd-add-set_sockbuf_len.diff
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: ulogd-netfilter/include/ulogd/common.h
===================================================================
--- ulogd-netfilter.orig/include/ulogd/common.h
+++ ulogd-netfilter/include/ulogd/common.h
@@ -47,4 +47,6 @@
 #define pr_debug(fmt, ...)
 #endif /* DEBUG */
 
+int set_sockbuf_len(int fd, int rcv_len, int snd_len);
+
 #endif /* COMMON_H */
Index: ulogd-netfilter/src/common.c
===================================================================
--- /dev/null
+++ ulogd-netfilter/src/common.c
@@ -0,0 +1,52 @@
+/*
+ * common.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ * Holger Eitzenberger <holger@eitzenberger.org>, 2007.
+ */
+#include <ulogd/ulogd.h>
+#include <ulogd/common.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+
+
+int
+set_sockbuf_len(int fd, int rcv_len, int snd_len)
+{
+	int ret;
+
+	pr_debug("%s: fd=%d rcv-len=%d snd-len\n", __func__, fd, rcv_len,
+			 snd_len);
+
+	if (snd_len > 0) {
+		ret = setsockopt(fd, SOL_SOCKET, SO_SNDBUF, &snd_len,
+						 sizeof(snd_len));
+		if (ret < 0) {
+			ulogd_log(ULOGD_ERROR, "setsockopt: SO_SNDBUF: %m\n");
+			return -1;
+		}
+	}
+
+	if (rcv_len > 0) {
+		ret = setsockopt(fd, SOL_SOCKET, SO_RCVBUF, &rcv_len,
+						 sizeof(rcv_len));
+		if (ret < 0) {
+			ulogd_log(ULOGD_ERROR, "setsockopt: SO_RCVBUF: %m\n");
+			return -1;
+		}
+	}
+
+	return 0;
+}
Index: ulogd-netfilter/src/Makefile.am
===================================================================
--- ulogd-netfilter.orig/src/Makefile.am
+++ ulogd-netfilter/src/Makefile.am
@@ -5,5 +5,5 @@ AM_CPPFLAGS = $(all_includes) -I$(top_sr
 
 sbin_PROGRAMS = ulogd
 
-ulogd_SOURCES = ulogd.c ifi.c select.c timer.c signal.c conffile.c
+ulogd_SOURCES = ulogd.c ifi.c select.c timer.c signal.c common.c conffile.c
 ulogd_LDFLAGS = -export-dynamic -lpthread

-- 
