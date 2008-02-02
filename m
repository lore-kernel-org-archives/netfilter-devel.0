From: heitzenberger@astaro.com
Subject: [ULOGD 02/15] common.h: added
Date: Sat, 02 Feb 2008 21:48:28 +0100
Message-ID: <20080202205107.439397977@astaro.com>
References: <20080202204826.267107164@astaro.com>
Cc: holger@eitzenberger.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-39.dex002.intermedia.net ([64.78.21.124]:46505 "EHLO
	dhost002-39.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765775AbYBBUvY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 15:51:24 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
Content-Disposition: inline; filename=ulogd-add-common-code.diff

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
