From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6/6] NFCT: fix reset counters via SIGUSR2 signal
Date: Wed, 13 Jan 2010 12:44:24 +0100
Message-ID: <20100113114424.12994.6470.stgit@decadence>
References: <20100113114009.12994.26386.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37459 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376Ab0AMLtU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jan 2010 06:49:20 -0500
In-Reply-To: <20100113114009.12994.26386.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes a feature that allows to force the logging of
the existing entries and reset the counters.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 input/flow/ulogd_inpflow_NFCT.c |   55 +++++++++++++++++++++++++++++++++++++--
 1 files changed, 52 insertions(+), 3 deletions(-)

diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index 8e01feb..b52c5b6 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -874,13 +874,62 @@ static int read_cb_ovh(int fd, unsigned int what, void *param)
 	return 0;
 }
 
-static int get_ctr_zero(struct ulogd_pluginstance *upi)
+static int
+dump_reset_handler(enum nf_conntrack_msg_type type,
+		   struct nf_conntrack *ct, void *data)
 {
-	int family = 0; /* any */
+	struct ulogd_pluginstance *upi = data;
 	struct nfct_pluginstance *cpi =
 			(struct nfct_pluginstance *)upi->private;
+	int ret = NFCT_CB_CONTINUE, rc, id;
+	struct ct_timestamp *ts;
+
+	switch(type) {
+	case NFCT_T_UPDATE:
+		id = hashtable_hash(cpi->ct_active, ct);
+		ts = (struct ct_timestamp *)
+			hashtable_find(cpi->ct_active, ct, id);
+		if (ts)
+			nfct_copy(ts->ct, ct, NFCT_CP_META);
+		else {
+			ts = calloc(sizeof(struct ct_timestamp), 1);
+			if (ts == NULL)
+				return NFCT_CB_CONTINUE;
+
+			ts->ct = ct;
+			gettimeofday(&ts->time[START], NULL);
+
+			rc = hashtable_add(cpi->ct_active, &ts->hashnode, id);
+			if (rc < 0) {
+				free(ts);
+				return NFCT_CB_CONTINUE;
+			}
+			ret = NFCT_CB_STOLEN;
+		}
+		do_propagate_ct(upi, ct, type, ts);
+		break;
+	default:
+		ulogd_log(ULOGD_NOTICE, "unknown netlink message type\n");
+		break;
+	}
+	return ret;
+}
+
+static void get_ctr_zero(struct ulogd_pluginstance *upi)
+{
+	struct nfct_handle *h;
+	int family = AF_UNSPEC;
+
+	h = nfct_open(CONNTRACK, 0);
+	if (h == NULL) {
+		ulogd_log(ULOGD_FATAL, "Cannot dump and reset counters\n");
+		return;
+	}
+	nfct_callback_register(h, NFCT_T_ALL, &dump_reset_handler, upi);
+	if (nfct_query(h, NFCT_Q_DUMP_RESET, &family) == -1)
+		ulogd_log(ULOGD_FATAL, "Cannot dump and reset counters\n");
 
-	return nfct_query(cpi->cth, NFCT_Q_DUMP_RESET, &family);
+	nfct_close(h);
 }
 
 static void polling_timer_cb(struct ulogd_timer *t, void *data)

