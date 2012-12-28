From: Eric Leblond <eric@regit.org>
Subject: [PATCH 1/4] nfct: call register callback on opened handler
Date: Fri, 28 Dec 2012 18:29:58 +0100
Message-ID: <1356715802-11572-2-git-send-email-eric@regit.org>
References: <1356715802-11572-1-git-send-email-eric@regit.org>
Cc: Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:57963 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693Ab2L1RaT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Dec 2012 12:30:19 -0500
In-Reply-To: <1356715802-11572-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nfctp_callback_register was called on the regular handler instead
of begin called on the newly opened handler dedicated to the dump.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 input/flow/ulogd_inpflow_NFCT.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index 0946b4c..489c9e0 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -1063,7 +1063,7 @@ static int constructor_nfct_events(struct ulogd_pluginstance *upi)
 			ulogd_log(ULOGD_FATAL, "error opening ctnetlink\n");
 			goto err_ovh;
 		}
-		nfct_callback_register(cpi->cth, NFCT_T_ALL,
+		nfct_callback_register(h, NFCT_T_ALL,
 				       &event_handler_hashtable, upi);
 		nfct_query(h, NFCT_Q_DUMP, &family);
 		nfct_close(h);
-- 
1.7.10.4

