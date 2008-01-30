From: heitzenberger@astaro.com
Subject: [ULOGD RFC 30/30] SQLITE3: move timer initialization to start handler
Date: Wed, 30 Jan 2008 19:59:17 +0100
Message-ID: <20080130190130.480406269@kruemel.intranet.astaro.de>
References: <20080130185847.693274384@kruemel.intranet.astaro.de>
Cc: holger@eitzenberger.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-91.dex002.intermedia.net ([64.78.21.115]:23297 "EHLO
	dhost002-91.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755036AbYA3TBp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:01:45 -0500
Content-Disposition: inline; filename=ulogd-SQLITE3-move-timer-initialization.diff
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: ulogd-netfilter/output/sqlite3/ulogd_output_SQLITE3.c
===================================================================
--- ulogd-netfilter.orig/output/sqlite3/ulogd_output_SQLITE3.c
+++ ulogd-netfilter/output/sqlite3/ulogd_output_SQLITE3.c
@@ -719,14 +719,6 @@ sqlite3_configure(struct ulogd_pluginsta
 	pr_debug("%s: db='%s' table='%s' timer=%d max-backlog=%d\n", pi->id,
 			 db_ce(pi), table_ce(pi), timer_ce(pi), max_backlog_ce(pi));
 
-	/* init timer */
-	priv->timer.cb = sqlite_timer_cb;
-	priv->timer.ival = timer_ce(pi);
-	priv->timer.flags = TIMER_F_PERIODIC;
-	priv->timer.data = pi;
-
-	ulogd_register_timer(&priv->timer);
-
 	return 0;
 }
 
@@ -749,6 +741,15 @@ sqlite3_start(struct ulogd_pluginstance 
 	if (db_start(pi) < 0)
 		return -1;
 
+	/* init timer */
+	priv->timer.cb = sqlite_timer_cb;
+	priv->timer.ival = timer_ce(pi);
+	priv->timer.flags = TIMER_F_PERIODIC;
+	priv->timer.data = pi;
+
+	if (ulogd_register_timer(&priv->timer) < 0)
+		return -1;
+
 	ulogd_log(ULOGD_INFO, "%s: started\n", pi->id);
 
 	return 0;

-- 
