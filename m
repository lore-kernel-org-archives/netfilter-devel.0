From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4/6] NFCT: split event handler if hashtable is used or not
Date: Wed, 13 Jan 2010 12:43:37 +0100
Message-ID: <20100113114337.12994.72666.stgit@decadence>
References: <20100113114009.12994.26386.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35962 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755945Ab0AMLoG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jan 2010 06:44:06 -0500
In-Reply-To: <20100113114009.12994.26386.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch splits event_handler into two functions:
event_handler_hashtable and event_handler_no_hashtable.
Thus, we register the appropriate handler during the
initialization time. This patch is a cleanup.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 input/flow/ulogd_inpflow_NFCT.c |   65 +++++++++++++++++++++++----------------
 1 files changed, 38 insertions(+), 27 deletions(-)

diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index 96aa8ea..da23ada 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -570,9 +570,9 @@ do_propagate_ct(struct ulogd_pluginstance *upi,
 	propagate_ct(upi, ct, type, ts);
 }
 
-static int event_handler(enum nf_conntrack_msg_type type,
-			 struct nf_conntrack *ct,
-			 void *data)
+static int
+event_handler_hashtable(enum nf_conntrack_msg_type type,
+			struct nf_conntrack *ct, void *data)
 {
 	struct ulogd_pluginstance *upi = data;
 	struct nfct_pluginstance *cpi =
@@ -580,29 +580,6 @@ static int event_handler(enum nf_conntrack_msg_type type,
 	struct ct_timestamp *ts;
 	int ret, id;
 
-	if (!usehash_ce(upi->config_kset).u.value) {
-		struct ct_timestamp tmp = {
-			.ct = ct,
-		};
-		switch(type) {
-		case NFCT_T_NEW:
-			gettimeofday(&tmp.time[START], NULL);
-			tmp.time[STOP].tv_sec = 0;
-			tmp.time[STOP].tv_usec = 0;
-			break;
-		case NFCT_T_DESTROY:
-			gettimeofday(&tmp.time[STOP], NULL);
-			tmp.time[START].tv_sec = 0;
-			tmp.time[START].tv_usec = 0;
-			break;
-		default:
-			ulogd_log(ULOGD_NOTICE, "unsupported message type\n");
-			break;
-		}
-		do_propagate_ct(upi, ct, type, &tmp);
-		return NFCT_CB_CONTINUE;
-	}
-
 	switch(type) {
 	case NFCT_T_NEW:
 		ts = calloc(sizeof(struct ct_timestamp), 1);
@@ -670,6 +647,34 @@ static int event_handler(enum nf_conntrack_msg_type type,
 }
 
 static int
+event_handler_no_hashtable(enum nf_conntrack_msg_type type,
+			   struct nf_conntrack *ct, void *data)
+{
+	struct ulogd_pluginstance *upi = data;
+	struct ct_timestamp tmp = {
+		.ct = ct,
+	};
+
+	switch(type) {
+	case NFCT_T_NEW:
+		gettimeofday(&tmp.time[START], NULL);
+		tmp.time[STOP].tv_sec = 0;
+		tmp.time[STOP].tv_usec = 0;
+		break;
+	case NFCT_T_DESTROY:
+		gettimeofday(&tmp.time[STOP], NULL);
+		tmp.time[START].tv_sec = 0;
+		tmp.time[START].tv_usec = 0;
+		break;
+	default:
+		ulogd_log(ULOGD_NOTICE, "unsupported message type\n");
+		break;
+	}
+	do_propagate_ct(upi, ct, type, &tmp);
+	return NFCT_CB_CONTINUE;
+}
+
+static int
 polling_handler(enum nf_conntrack_msg_type type,
 		struct nf_conntrack *ct, void *data)
 {
@@ -931,7 +936,13 @@ static int constructor_nfct_events(struct ulogd_pluginstance *upi)
 		goto err_cth;
 	}
 
-	nfct_callback_register(cpi->cth, NFCT_T_ALL, &event_handler, upi);
+	if (usehash_ce(upi->config_kset).u.value != 0) {
+		nfct_callback_register(cpi->cth, NFCT_T_ALL,
+				       &event_handler_hashtable, upi);
+	} else {
+		nfct_callback_register(cpi->cth, NFCT_T_ALL,
+				       &event_handler_no_hashtable, upi);
+	}
 
 	if (nlsockbufsize_ce(upi->config_kset).u.value) {
 		setnlbufsiz(upi, nlsockbufsize_ce(upi->config_kset).u.value);

