From: Peter Warasin <peter@endian.com>
Subject: [PATCH 1/5] openlog() to syslog for global ulogd log messages
Date: Fri, 11 Jan 2008 16:09:11 +0100
Message-ID: <20080111152824.041585000@andrew.endian.com>
References: <20080111150910.582899000@andrew.endian.com>
Cc: Peter Warasin <peter@endian.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from solaria.endian.it ([80.190.199.145]:34004 "EHLO
	solaria.endian.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760383AbYAKQAR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Jan 2008 11:00:17 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by solaria.endian.it (Postfix) with ESMTP id 0A84D598335
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Jan 2008 16:28:26 +0100 (CET)
Content-Disposition: inline; filename=ulogd_general_syslog_fix.patch
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When [global]'s logfile is syslog, ulogd should log it's own
mesasages (not the firewall log lines) to syslog, which it
does'nt because openlog() is missing. This patch adds openlog()

Signed-off-by: Peter Warasin <peter@endian.com>

---
 src/ulogd.c |    1 +
 1 file changed, 1 insertion(+)

Index: ulogd-2.0.0beta1/src/ulogd.c
===================================================================
--- ulogd-2.0.0beta1.orig/src/ulogd.c	2008-01-11 12:44:53.000000000 +0100
+++ ulogd-2.0.0beta1/src/ulogd.c	2008-01-11 12:44:56.000000000 +0100
@@ -738,6 +738,7 @@
 	if (!strcmp(name, "stdout")) {
 		logfile = stdout;
 	} else if (!strcmp(name, "syslog")) {
+                openlog("ulogd", LOG_PID, LOG_DAEMON);
 		logfile = &syslog_dummy;
 	} else {
 		logfile = fopen(ulogd_logfile, "a");

--
