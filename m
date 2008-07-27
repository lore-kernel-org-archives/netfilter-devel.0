From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 02/11] Cleanly stop SYSLOG module.
Date: Sun, 27 Jul 2008 15:51:17 +0200
Message-ID: <1217166686-28508-3-git-send-email-eric@inl.fr>
References: <20080723162746.GB31572@bayen.regit.org>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:43795 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751858AbYG0Nv2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Jul 2008 09:51:28 -0400
In-Reply-To: <20080723162746.GB31572@bayen.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a stop function to the module which closes the connection to
the log system.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 output/ulogd_output_SYSLOG.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/output/ulogd_output_SYSLOG.c b/output/ulogd_output_SYSLOG.c
index 8982e7e..8dd93f3 100644
--- a/output/ulogd_output_SYSLOG.c
+++ b/output/ulogd_output_SYSLOG.c
@@ -151,10 +151,13 @@ static int syslog_configure(struct ulogd_pluginstance *pi,
 	return 0;
 }
 
-static void syslog_fini(void)
+static int syslog_fini(struct ulogd_pluginstance *pi)
 {
 	closelog();
+
+	return 0;
 }
+
 static int syslog_start(struct ulogd_pluginstance *pi)
 {
 	openlog("ulogd", LOG_NDELAY|LOG_PID, LOG_DAEMON);
@@ -177,6 +180,7 @@ static struct ulogd_plugin syslog_plugin = {
 	
 	.configure	= &syslog_configure,
 	.start		= &syslog_start,
+	.stop		= &syslog_fini,
 	.interp		= &_output_syslog,
 	.version	= ULOGD_VERSION,
 };
-- 
1.5.4.3

