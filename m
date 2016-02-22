From: Loganaden Velvindron <logan@hackers.mu>
Subject: [PATCH] Fix musl compatibility
Date: Mon, 22 Feb 2016 03:51:15 -0800
Message-ID: <20160222115115.GA17349@mx.elandsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ns1.qubic.net ([208.69.177.116]:59413 "EHLO mx.elandsys.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754649AbcBVMBi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Feb 2016 07:01:38 -0500
Received: from mx.elandsys.com (IDENT:logan@localhost [127.0.0.1])
	by mx.elandsys.com (8.14.5/8.14.5) with ESMTP id u1MBpFQ0008363
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Mon, 22 Feb 2016 03:51:16 -0800 (PST)
Received: (from logan@localhost)
	by mx.elandsys.com (8.14.5/8.14.5/Submit) id u1MBpFZL026108
	for netfilter-devel@vger.kernel.org; Mon, 22 Feb 2016 03:51:15 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add missing constants for libxt_TCPOPTSTRIP.c, in case they are not defined.

(Original patch from VoidLinux)

Signed-off-by: Loganaden Velvindron <logan@hackers.mu>
---
 extensions/libxt_TCPOPTSTRIP.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/extensions/libxt_TCPOPTSTRIP.c b/extensions/libxt_TCPOPTSTRIP.c
index 6897857..828b593 100644
--- a/extensions/libxt_TCPOPTSTRIP.c
+++ b/extensions/libxt_TCPOPTSTRIP.c
@@ -12,6 +12,22 @@
 #ifndef TCPOPT_MD5SIG
 #	define TCPOPT_MD5SIG 19
 #endif
+#ifndef TCPOPT_MAXSEG
+#     define TCPOPT_MAXSEG 2
+#endif
+#ifndef TCPOPT_WINDOW
+#     define TCPOPT_WINDOW 3
+#endif
+#ifndef TCPOPT_SACK_PERMITTED
+#     define TCPOPT_SACK_PERMITTED 4
+#endif
+#ifndef TCPOPT_SACK
+#     define TCPOPT_SACK 5
+#endif
+#ifndef TCPOPT_TIMESTAMP
+#     define TCPOPT_TIMESTAMP 8
+#endif
+
 
 enum {
 	O_STRIP_OPTION = 0,
-- 
2.7.0
