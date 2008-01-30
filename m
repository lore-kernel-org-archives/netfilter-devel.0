From: heitzenberger@astaro.com
Subject: [ULOGD RFC 02/30] common.h: added
Date: Wed, 30 Jan 2008 19:58:49 +0100
Message-ID: <20080130190126.606028350@kruemel.intranet.astaro.de>
References: <20080130185847.693274384@kruemel.intranet.astaro.de>
Cc: holger@eitzenberger.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-28.dex002.intermedia.net ([64.78.21.113]:20892 "EHLO
	dhost002-28.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751880AbYA3TBk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:01:40 -0500
Content-Disposition: inline; filename=ulogd-add-common-code.diff
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: ulogd-netfilter/include/ulogd/common.h
===================================================================
--- /dev/null
+++ ulogd-netfilter/include/ulogd/common.h
@@ -0,0 +1,50 @@
+/*
+ * common.h
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
+ * Holger Eitzenberger <holger@eitzenberger.org>  Astaro AG 2008
+ */
+#ifndef COMMON_H
+#define COMMON_H
+
+#include <stdlib.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <string.h>
+#include <errno.h>
+#include <assert.h>
+
+#define min(x, y) ({ \
+        typeof(x) _x = (x);  typeof(y) _y = (y); \
+        _x < _y ? _x : _y; })
+#define max(x, y) ({ \
+        typeof(x) _x = (x);  typeof(y) _y = (y); \
+        _x > _y ? _x : _y; })
+
+#define SEC		* 1
+#define MIN		* 60 SEC
+#define HOUR	* 60 MIN
+#define DAY		* 24 HOUR
+
+#define __unused				__attribute__((unused))
+#define __fmt_printf(i, first)	__attribute__((format (printtf,(i),(f))))
+
+#ifdef DEBUG
+#define pr_debug(fmt, ...)		ulogd_log(ULOGD_DEBUG, fmt, ## __VA_ARGS__)
+#else
+#define pr_debug(fmt, ...)
+#endif /* DEBUG */
+
+#endif /* COMMON_H */

-- 
