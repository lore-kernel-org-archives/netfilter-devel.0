From: Peter Warasin <peter@endian.com>
Subject: [PATCH 4/5] Workaround of recvfrom() EAGAIN bug
Date: Fri, 11 Jan 2008 16:09:14 +0100
Message-ID: <20080111152824.849353000@andrew.endian.com>
References: <20080111150910.582899000@andrew.endian.com>
Cc: Peter Warasin <peter@endian.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from solaria.endian.it ([80.190.199.145]:34005 "EHLO
	solaria.endian.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760363AbYAKQAR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Jan 2008 11:00:17 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by solaria.endian.it (Postfix) with ESMTP id 31AD3598338
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Jan 2008 16:28:32 +0100 (CET)
Content-Disposition: inline; filename=ulogd_inppkt_ULOG_recvfrom_EAGAIN_workaround.patch
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a workaround which prevents ulogd from logging each
time when recvfrom() returns error because of EAGAIN.
Since the netlink socket is now O_NONBLOCK, we probably run
into the following bug:

http://bugzilla.kernel.org/show_bug.cgi?id=5498

which causes recvfrom() get an error when select() had a good
return, whenever select() receives a packet with a bad checksum.

ipulog_read() always has this problem once after every successful
ipulog_read().

Signed-off-by: Peter Warasin <peter@endian.com>

---
 input/packet/ulogd_inppkt_ULOG.c |    2 ++
 1 file changed, 2 insertions(+)

Index: ulogd-2.0.0beta1/input/packet/ulogd_inppkt_ULOG.c
===================================================================
--- ulogd-2.0.0beta1.orig/input/packet/ulogd_inppkt_ULOG.c	2008-01-11 13:11:20.000000000 +0100
+++ ulogd-2.0.0beta1/input/packet/ulogd_inppkt_ULOG.c	2008-01-11 13:11:54.000000000 +0100
@@ -225,6 +225,8 @@
 	while ((len = ipulog_read(u->libulog_h, u->libulog_buf,
 				 upi->config_kset->ces[0].u.value, 1))) {
 		if (len <= 0) {
+			if (errno == EAGAIN)
+				break;
 			/* this is not supposed to happen */
 			ulogd_log(ULOGD_ERROR, "ipulog_read = %d! "
 				  "ipulog_errno = %d (%s), "

--
