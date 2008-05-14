From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 3/4] Partially fill connection timestamp when hash is not used.
Date: Thu, 15 May 2008 00:54:38 +0200
Message-ID: <1210805679-11813-4-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:33857 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752951AbYENWy3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 May 2008 18:54:29 -0400
In-Reply-To: <>
References: <>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ulogd2 maintain a hash table containing timestamp information on a connection.

This patch computes START or STOP timestamp depending on the type of
the received message even if the has is not used.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 input/flow/ulogd_inpflow_NFCT.c |   30 ++++++++++++++++++++++--------
 1 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index 5e5af87..cce06aa 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -576,14 +576,18 @@ static int propagate_ct(struct ulogd_pluginstance *upi,
 	ret[NFCT_CT_ID].flags |= ULOGD_RETF_VALID;
 
 	if (ts) {
-		ret[NFCT_FLOW_START_SEC].u.value.ui32 = ts->time[START].tv_sec;
-		ret[NFCT_FLOW_START_SEC].flags |= ULOGD_RETF_VALID;
-		ret[NFCT_FLOW_START_USEC].u.value.ui32 = ts->time[START].tv_usec;
-		ret[NFCT_FLOW_START_USEC].flags |= ULOGD_RETF_VALID;
-		ret[NFCT_FLOW_END_SEC].u.value.ui32 = ts->time[STOP].tv_sec;
-		ret[NFCT_FLOW_END_SEC].flags |= ULOGD_RETF_VALID;
-		ret[NFCT_FLOW_END_USEC].u.value.ui32 = ts->time[STOP].tv_usec;
-		ret[NFCT_FLOW_END_USEC].flags |= ULOGD_RETF_VALID;
+		if (ts->time[START].tv_sec) {
+			ret[NFCT_FLOW_START_SEC].u.value.ui32 = ts->time[START].tv_sec;
+			ret[NFCT_FLOW_START_SEC].flags |= ULOGD_RETF_VALID;
+			ret[NFCT_FLOW_START_USEC].u.value.ui32 = ts->time[START].tv_usec;
+			ret[NFCT_FLOW_START_USEC].flags |= ULOGD_RETF_VALID;
+		}
+		if (ts->time[STOP].tv_sec) {
+			ret[NFCT_FLOW_END_SEC].u.value.ui32 = ts->time[STOP].tv_sec;
+			ret[NFCT_FLOW_END_SEC].flags |= ULOGD_RETF_VALID;
+			ret[NFCT_FLOW_END_USEC].u.value.ui32 = ts->time[STOP].tv_usec;
+			ret[NFCT_FLOW_END_USEC].flags |= ULOGD_RETF_VALID;
+		}
 	}
 
 	ulogd_propagate_results(upi);
@@ -600,6 +604,7 @@ static int event_handler(enum nf_conntrack_msg_type type,
 	struct nfct_pluginstance *cpi = 
 				(struct nfct_pluginstance *) upi->private;
 	struct ct_timestamp *ts = NULL;
+	struct ct_timestamp lts;
 	struct ulogd_pluginstance *npi = NULL;
 	int ret = 0;
 
@@ -607,10 +612,19 @@ static int event_handler(enum nf_conntrack_msg_type type,
 		if (usehash_ce(upi->config_kset).u.value != 0) {
 			ct_hash_add(cpi->ct_active, nfct_get_attr_u32(ct, ATTR_ID));
 			return 0;
+		} else {
+			ts = &lts;
+			gettimeofday(&ts->time[START], NULL);
+			ts->time[STOP].tv_sec = 0;
 		}
 	} else if (type == NFCT_MSG_DESTROY) {
 		if (usehash_ce(upi->config_kset).u.value != 0)
 			ts = ct_hash_get(cpi->ct_active, nfct_get_attr_u32(ct, ATTR_ID));
+		else {
+			ts = &lts;
+			gettimeofday(&ts->time[STOP], NULL);
+			ts->time[START].tv_sec = 0;
+		}
 	}
 
 	/* since we support the re-use of one instance in
-- 
1.5.4.3

