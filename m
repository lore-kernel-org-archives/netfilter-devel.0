From: Peter Warasin <peter@endian.com>
Subject: [PATCH 3/5] Logs also ipulog_strerror() and strerror() within ULOG plugin
Date: Fri, 11 Jan 2008 16:09:13 +0100
Message-ID: <20080111152824.583966000@andrew.endian.com>
References: <20080111150910.582899000@andrew.endian.com>
Cc: Peter Warasin <peter@endian.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from solaria.endian.it ([80.190.199.145]:34007 "EHLO
	solaria.endian.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760596AbYAKQAR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Jan 2008 11:00:17 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by solaria.endian.it (Postfix) with ESMTP id 98423598339
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Jan 2008 16:28:31 +0100 (CET)
Content-Disposition: inline; filename=ulogd_inppkt_ULOG_strerror.patch
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch logs also the string representations ipulog:_strerror()
and strerror() when an error occurred during receivement of packets
within the ULOG plugin

Signed-off-by: Peter Warasin <peter@endian.com>

---
 input/packet/ulogd_inppkt_ULOG.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: ulogd-2.0.0beta1/input/packet/ulogd_inppkt_ULOG.c
===================================================================
--- ulogd-2.0.0beta1.orig/input/packet/ulogd_inppkt_ULOG.c	2008-01-11 12:58:50.000000000 +0100
+++ ulogd-2.0.0beta1/input/packet/ulogd_inppkt_ULOG.c	2008-01-11 13:10:44.000000000 +0100
@@ -227,8 +227,11 @@
 		if (len <= 0) {
 			/* this is not supposed to happen */
 			ulogd_log(ULOGD_ERROR, "ipulog_read = %d! "
-				  "ipulog_errno = %d, errno = %d\n",
-				  len, ipulog_errno, errno);
+				  "ipulog_errno = %d (%s), "
+				  "errno = %d (%s)\n",
+				  len, ipulog_errno,
+				  ipulog_strerror(ipulog_errno),
+				  errno, strerror(errno));
 			break;
 		}
 		while ((upkt = ipulog_get_packet(u->libulog_h,

--
