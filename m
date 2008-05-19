From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 1/9] Set timestamp in NFLOG for INPUT and OUTPUT.
Date: Tue, 20 May 2008 00:31:27 +0200
Message-ID: <1211236295-30207-2-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:38766 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756767AbYESWae (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 May 2008 18:30:34 -0400
In-Reply-To: <>
References: <>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 input/packet/ulogd_inppkt_NFLOG.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt_NFLOG.c
index f258473..8d08bd8 100644
--- a/input/packet/ulogd_inppkt_NFLOG.c
+++ b/input/packet/ulogd_inppkt_NFLOG.c
@@ -344,13 +344,14 @@ interp_packet(struct ulogd_pluginstance *upi, struct nflog_data *ldata)
 
 	/* god knows why timestamp_usec contains crap if timestamp_sec
 	 * == 0 if (pkt->timestamp_sec || pkt->timestamp_usec) { */
-	if (nflog_get_timestamp(ldata, &ts) == 0 && ts.tv_sec) {
-		/* FIXME: convert endianness */
-		ret[NFLOG_KEY_OOB_TIME_SEC].u.value.ui32 = ts.tv_sec & 0xffffffff;
-		ret[NFLOG_KEY_OOB_TIME_SEC].flags |= ULOGD_RETF_VALID;
-		ret[NFLOG_KEY_OOB_TIME_USEC].u.value.ui32 = ts.tv_usec & 0xffffffff;
-		ret[NFLOG_KEY_OOB_TIME_USEC].flags |= ULOGD_RETF_VALID;
-	}
+	if (! (nflog_get_timestamp(ldata, &ts) == 0 && ts.tv_sec))
+		gettimeofday(&ts, NULL);
+
+	/* FIXME: convert endianness */
+	ret[NFLOG_KEY_OOB_TIME_SEC].u.value.ui32 = ts.tv_sec & 0xffffffff;
+	ret[NFLOG_KEY_OOB_TIME_SEC].flags |= ULOGD_RETF_VALID;
+	ret[NFLOG_KEY_OOB_TIME_USEC].u.value.ui32 = ts.tv_usec & 0xffffffff;
+	ret[NFLOG_KEY_OOB_TIME_USEC].flags |= ULOGD_RETF_VALID;
 
 	ret[NFLOG_KEY_OOB_MARK].u.value.ui32 = mark;
 	ret[NFLOG_KEY_OOB_MARK].flags |= ULOGD_RETF_VALID;
-- 
1.5.4.3

