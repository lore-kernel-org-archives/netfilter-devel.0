From: heitzenberger@astaro.com
Subject: [ULOGD 07/15] Renice to -1 on startup
Date: Sat, 02 Feb 2008 21:48:33 +0100
Message-ID: <20080202205108.158529737@astaro.com>
References: <20080202204826.267107164@astaro.com>
Cc: holger@eitzenberger.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-25.dex002.intermedia.net ([64.78.21.107]:51418 "EHLO
	dhost002-25.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932153AbYBBUvY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 15:51:24 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
Content-Disposition: inline; filename=ulogd-renice-on-startup.diff

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
