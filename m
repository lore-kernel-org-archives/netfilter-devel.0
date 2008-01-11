From: Peter Warasin <peter@endian.com>
Subject: [PATCH 2/5] Dont ntohs() mac_len of ULOG, since it is not in network byte order
Date: Fri, 11 Jan 2008 16:09:12 +0100
Message-ID: <20080111152824.287682000@andrew.endian.com>
References: <20080111150910.582899000@andrew.endian.com>
Cc: Peter Warasin <peter@endian.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from solaria.endian.it ([80.190.199.145]:34006 "EHLO
	solaria.endian.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760440AbYAKQAR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Jan 2008 11:00:17 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by solaria.endian.it (Postfix) with ESMTP id A70E6598330
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Jan 2008 16:28:26 +0100 (CET)
Content-Disposition: inline; filename=ulogd_inppkt_ULOG_fix.patch
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Stores mac_len correctly, since within ULOG structire it is not stored
in network byte order.

Signed-off-by: Peter Warasin <peter@endian.com>

---
 input/packet/ulogd_inppkt_ULOG.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: ulogd-2.0.0beta1/input/packet/ulogd_inppkt_ULOG.c
===================================================================
--- ulogd-2.0.0beta1.orig/input/packet/ulogd_inppkt_ULOG.c	2008-01-11 12:43:49.000000000 +0100
+++ ulogd-2.0.0beta1/input/packet/ulogd_inppkt_ULOG.c	2008-01-11 12:58:50.000000000 +0100
@@ -167,7 +167,7 @@
 	if (pkt->mac_len) {
 		ret[ULOG_KEY_RAW_MAC].u.value.ptr = pkt->mac;
 		ret[ULOG_KEY_RAW_MAC].flags |= ULOGD_RETF_VALID;
-		ret[ULOG_KEY_RAW_MAC_LEN].u.value.ui16 = ntohs(pkt->mac_len);
+		ret[ULOG_KEY_RAW_MAC_LEN].u.value.ui16 = pkt->mac_len;
 		ret[ULOG_KEY_RAW_MAC_LEN].flags |= ULOGD_RETF_VALID;
 	}
 

--
