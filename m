From: heitzenberger@astaro.com
Subject: [ULOGD RFC 07/30] Renice to -1 on startup
Date: Wed, 30 Jan 2008 19:58:54 +0100
Message-ID: <20080130190127.273612103@kruemel.intranet.astaro.de>
References: <20080130185847.693274384@kruemel.intranet.astaro.de>
Cc: holger@eitzenberger.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-28.dex002.intermedia.net ([64.78.21.113]:20892 "EHLO
	dhost002-28.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754803AbYA3TBn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:01:43 -0500
Content-Disposition: inline; filename=ulogd-renice-on-startup.diff
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thus possibly preventing e.g. ctnetlink from overruns on busy sites.

TODO: make this conditional

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: ulogd-netfilter/src/ulogd.c
===================================================================
--- ulogd-netfilter.orig/src/ulogd.c
+++ ulogd-netfilter/src/ulogd.c
@@ -1004,6 +1004,8 @@ main(int argc, char* argv[])
 		}
 	}
 
+	nice(-1);
+
 	if (daemonize){
 		if (fork()) {
 			exit(0);

-- 
