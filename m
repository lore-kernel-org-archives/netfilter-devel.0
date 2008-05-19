From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 2/9] Fill the maximum of timestamp.
Date: Tue, 20 May 2008 00:31:28 +0200
Message-ID: <1211236295-30207-3-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:38764 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756000AbYESWad (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 May 2008 18:30:33 -0400
In-Reply-To: <>
References: <>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

THis patch try to fill every possible timestamp. It fills START timestamp for
NEW packet and STOP timestamp for DESTROY packet.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 input/flow/ulogd_inpflow_NFCT.c |   57 ++++++++++++++++++++++++++++----------
 1 files changed, 42 insertions(+), 15 deletions(-)

diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index a03905d..20d0da1 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -568,17 +568,24 @@ static int propagate_ct(struct ulogd_pluginstance *upi,
 	ret[NFCT_CT_ID].flags |= ULOGD_RETF_VALID;
 
 	if (ts) {
-		ret[NFCT_FLOW_START_SEC].u.value.ui32 = ts->time[START].tv_sec;
-		ret[NFCT_FLOW_START_SEC].flags |= ULOGD_RETF_VALID;
-
-		ret[NFCT_FLOW_START_USEC].u.value.ui32 = ts->time[START].tv_usec;
-		ret[NFCT_FLOW_START_USEC].flags |= ULOGD_RETF_VALID;
-
-		ret[NFCT_FLOW_END_SEC].u.value.ui32 = ts->time[STOP].tv_sec;
-		ret[NFCT_FLOW_END_SEC].flags |= ULOGD_RETF_VALID;
-
-		ret[NFCT_FLOW_END_USEC].u.value.ui32 = ts->time[STOP].tv_usec;
-		ret[NFCT_FLOW_END_USEC].flags |= ULOGD_RETF_VALID;
+		if (ts->time[START].tv_sec) {
+			ret[NFCT_FLOW_START_SEC].u.value.ui32 = 
+				ts->time[START].tv_sec;
+			ret[NFCT_FLOW_START_SEC].flags |= ULOGD_RETF_VALID;
+
+			ret[NFCT_FLOW_START_USEC].u.value.ui32 =
+				ts->time[START].tv_usec;
+			ret[NFCT_FLOW_START_USEC].flags |= ULOGD_RETF_VALID;
+		}
+		if (ts->time[STOP].tv_sec) {
+			ret[NFCT_FLOW_END_SEC].u.value.ui32 =
+				ts->time[STOP].tv_sec;
+			ret[NFCT_FLOW_END_SEC].flags |= ULOGD_RETF_VALID;
+
+			ret[NFCT_FLOW_END_USEC].u.value.ui32 =
+				ts->time[STOP].tv_usec;
+			ret[NFCT_FLOW_END_USEC].flags |= ULOGD_RETF_VALID;
+		}
 	}
 
 	ulogd_propagate_results(upi);
@@ -619,7 +626,22 @@ static int event_handler(enum nf_conntrack_msg_type type,
 	};
 
 	if (!usehash_ce(upi->config_kset).u.value && type == NFCT_T_DESTROY) {
-		do_propagate_ct(upi, ct, type, ts);
+		switch(type) {
+		case NFCT_T_NEW:
+			gettimeofday(&tmp.time[START], NULL);
+			tmp.time[STOP].tv_sec = 0;
+			tmp.time[STOP].tv_usec = 0;
+			break;
+		case NFCT_T_DESTROY:
+			gettimeofday(&tmp.time[STOP], NULL);
+			tmp.time[START].tv_sec = 0;
+			tmp.time[START].tv_usec = 0;
+			break;
+		default:
+			ulogd_log(ULOGD_NOTICE, "unsupported message type\n");
+			break;
+		}
+		do_propagate_ct(upi, ct, type, &tmp);
 		return NFCT_CB_CONTINUE;
 	}
 
@@ -640,10 +662,15 @@ static int event_handler(enum nf_conntrack_msg_type type,
 		break;
 	case NFCT_T_DESTROY:
 		ts = hashtable_get(cpi->ct_active, &tmp);
-		if (ts)
+		if (ts) {
 			gettimeofday(&ts->time[STOP], NULL);
-
-		do_propagate_ct(upi, ct, type, ts);
+			do_propagate_ct(upi, ct, type, ts);
+		} else {
+			gettimeofday(&tmp.time[STOP], NULL);
+			tmp.time[START].tv_sec = 0;
+			tmp.time[START].tv_usec = 0;
+			do_propagate_ct(upi, ct, type, &tmp);
+		}
 
 		if (ts) {
 			hashtable_del(cpi->ct_active, ts);
-- 
1.5.4.3

