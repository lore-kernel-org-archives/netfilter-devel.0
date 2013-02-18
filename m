From: Eric Leblond <eric@regit.org>
Subject: [PATCH 2/7] Suppress dead FIXME.
Date: Mon, 18 Feb 2013 09:37:43 +0100
Message-ID: <1361176668-22661-3-git-send-email-eric@regit.org>
References: <1361176668-22661-1-git-send-email-eric@regit.org>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:48540 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab3BRIid (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Feb 2013 03:38:33 -0500
In-Reply-To: <1361176668-22661-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Eric Leblond <eric@regit.org>
---
 input/packet/ulogd_inppkt_NFLOG.c |    2 --
 src/ulogd.c                       |    1 -
 2 files changed, 3 deletions(-)

diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt_NFLOG.c
index 7870c31..cc0c2d4 100644
--- a/input/packet/ulogd_inppkt_NFLOG.c
+++ b/input/packet/ulogd_inppkt_NFLOG.c
@@ -339,7 +339,6 @@ interp_packet(struct ulogd_pluginstance *upi, u_int8_t pf_family,
 		    label_ce(upi->config_kset).u.value);
 
 	if (ph) {
-		/* FIXME */
 		okey_set_u8(&ret[NFLOG_KEY_OOB_HOOK], ph->hook);
 		okey_set_u16(&ret[NFLOG_KEY_OOB_PROTOCOL],
 			     ntohs(ph->hw_protocol));
@@ -376,7 +375,6 @@ interp_packet(struct ulogd_pluginstance *upi, u_int8_t pf_family,
 	if (! (nflog_get_timestamp(ldata, &ts) == 0 && ts.tv_sec))
 		gettimeofday(&ts, NULL);
 
-	/* FIXME: convert endianness */
 	okey_set_u32(&ret[NFLOG_KEY_OOB_TIME_SEC], ts.tv_sec & 0xffffffff);
 	okey_set_u32(&ret[NFLOG_KEY_OOB_TIME_USEC], ts.tv_usec & 0xffffffff);
 
diff --git a/src/ulogd.c b/src/ulogd.c
index d0fdcc5..c7617d9 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -1102,7 +1102,6 @@ static void signal_handler(int signal)
 
 static void print_usage(void)
 {
-	/* FIXME */
 	printf("ulogd Version %s\n", VERSION);
 	printf(COPYRIGHT);
 	printf("This is free software with ABSOLUTELY NO WARRANTY.\n\n");
-- 
1.7.10.4

