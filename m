From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/6] NFCT: change `pollinterval' behaviour
Date: Wed, 13 Jan 2010 12:42:47 +0100
Message-ID: <20100113114247.12994.59847.stgit@decadence>
References: <20100113114009.12994.26386.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35814 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259Ab0AMLnd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jan 2010 06:43:33 -0500
In-Reply-To: <20100113114009.12994.26386.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds support for poll-based logging. Basically,
ulogd polls from the kernel periodically to log entries. You
can use the `pollinterval' option in the configuration file to
set the polling period.

This patch changes the current behaviour of `pollinterval'
that allowed to mix both the event-driven logging with
polling periodically from the kernel. I have tried to look
for anyone in google (and asking Eric Leblond) using this
feature but I found noone.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 input/flow/ulogd_inpflow_NFCT.c |  128 +++++++++++++++++++++++++++++++++++++--
 ulogd.conf.in                   |    1 
 2 files changed, 121 insertions(+), 8 deletions(-)

diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index 9ef4eae..d76649e 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -567,7 +567,6 @@ do_propagate_ct(struct ulogd_pluginstance *upi,
 	propagate_ct(upi, ct, type, ts);
 }
 
-/* XXX: pollinterval needs a different handler */
 static int event_handler(enum nf_conntrack_msg_type type,
 			 struct nf_conntrack *ct,
 			 void *data)
@@ -646,6 +645,40 @@ static int event_handler(enum nf_conntrack_msg_type type,
 	return NFCT_CB_CONTINUE;
 }
 
+static int
+polling_handler(enum nf_conntrack_msg_type type,
+		struct nf_conntrack *ct, void *data)
+{
+	struct ulogd_pluginstance *upi = data;
+	struct nfct_pluginstance *cpi =
+				(struct nfct_pluginstance *) upi->private;
+	struct ct_timestamp *ts = NULL;
+	struct ct_timestamp tmp = {
+		.ct = ct,
+	};
+
+	switch(type) {
+	case NFCT_T_UPDATE:
+		ts = hashtable_get(cpi->ct_active, &tmp);
+		if (ts)
+			nfct_copy(ts->ct, ct, NFCT_CP_META);
+		else {
+			ts = hashtable_add(cpi->ct_active, &tmp);
+			if (ts == NULL)
+				return NFCT_CB_CONTINUE;
+
+			gettimeofday(&ts->time[START], NULL);
+			return NFCT_CB_STOLEN;
+		}
+		break;
+	default:
+		ulogd_log(ULOGD_NOTICE, "unknown netlink message type\n");
+		break;
+	}
+
+	return NFCT_CB_CONTINUE;
+}
+
 static int setnlbufsiz(struct ulogd_pluginstance *upi, int size)
 {
 	struct nfct_pluginstance *cpi =
@@ -804,13 +837,15 @@ static int get_ctr_zero(struct ulogd_pluginstance *upi)
 	return nfct_query(cpi->cth, NFCT_Q_DUMP_RESET, &family);
 }
 
-static void getctr_timer_cb(struct ulogd_timer *t, void *data)
+static void polling_timer_cb(struct ulogd_timer *t, void *data)
 {
 	struct ulogd_pluginstance *upi = data;
 	struct nfct_pluginstance *cpi =
 			(struct nfct_pluginstance *)upi->private;
+	int family = AF_UNSPEC;
 
-	get_ctr_zero(upi);
+	nfct_query(cpi->pgh, NFCT_Q_DUMP, &family);
+	hashtable_iterate(cpi->ct_active, upi, do_purge);
 	ulogd_add_timer(&cpi->timer, pollint_ce(upi->config_kset).u.value);
 }
 
@@ -825,7 +860,7 @@ static int configure_nfct(struct ulogd_pluginstance *upi,
 	if (ret < 0)
 		return ret;
 
-	ulogd_init_timer(&cpi->timer, upi, getctr_timer_cb);
+	ulogd_init_timer(&cpi->timer, upi, polling_timer_cb);
 	if (pollint_ce(upi->config_kset).u.value != 0)
 		ulogd_add_timer(&cpi->timer,
 				pollint_ce(upi->config_kset).u.value);
@@ -843,7 +878,7 @@ static void overrun_timeout(struct ulogd_timer *a, void *data)
 	nfct_send(cpi->ovh, NFCT_Q_DUMP, &family);
 }
 
-static int constructor_nfct(struct ulogd_pluginstance *upi)
+static int constructor_nfct_events(struct ulogd_pluginstance *upi)
 {
 	struct nfct_pluginstance *cpi =
 			(struct nfct_pluginstance *)upi->private;
@@ -916,6 +951,7 @@ static int constructor_nfct(struct ulogd_pluginstance *upi)
 		}
 	}
 
+	ulogd_log(ULOGD_NOTICE, "NFCT plugin working in event mode\n");
 	return 0;
 
 err_pgh:
@@ -930,9 +966,61 @@ err_cth:
 	return -1;
 }
 
-static int destructor_nfct(struct ulogd_pluginstance *pi)
+static int constructor_nfct_polling(struct ulogd_pluginstance *upi)
 {
-	struct nfct_pluginstance *cpi = (void *) pi->private;
+	struct nfct_pluginstance *cpi =
+			(struct nfct_pluginstance *)upi->private;
+
+	if (usehash_ce(upi->config_kset).u.value == 0) {
+		ulogd_log(ULOGD_FATAL, "NFCT polling mode requires "
+				       "the hashtable\n");
+		goto err;
+	}
+
+	cpi->pgh = nfct_open(NFNL_SUBSYS_CTNETLINK, 0);
+	if (!cpi->pgh) {
+		ulogd_log(ULOGD_FATAL, "error opening ctnetlink\n");
+		goto err;
+	}
+	nfct_callback_register(cpi->pgh, NFCT_T_ALL, &polling_handler, upi);
+
+	cpi->ct_active =
+	     hashtable_create(buckets_ce(upi->config_kset).u.value,
+			      maxentries_ce(upi->config_kset).u.value,
+			      sizeof(struct ct_timestamp),
+			      hash,
+			      compare);
+	if (!cpi->ct_active) {
+		ulogd_log(ULOGD_FATAL, "error allocating hash\n");
+		goto err_hashtable;
+	}
+
+	ulogd_log(ULOGD_NOTICE, "NFCT working in polling mode\n");
+	return 0;
+
+err_hashtable:
+	nfct_close(cpi->pgh);
+err:
+	return -1;
+}
+
+static int constructor_nfct(struct ulogd_pluginstance *upi)
+{
+	if (pollint_ce(upi->config_kset).u.value == 0) {
+		/* listen to ctnetlink events. */
+		return constructor_nfct_events(upi);
+	} else {
+		/* poll from ctnetlink periodically. */
+		return constructor_nfct_polling(upi);
+	}
+	/* should not ever happen. */
+	ulogd_log(ULOGD_FATAL, "invalid NFCT configuration\n");
+	return -1;
+}
+
+static int destructor_nfct_events(struct ulogd_pluginstance *upi)
+{
+	struct nfct_pluginstance *cpi = (void *) upi->private;
 	int rc;
 
 	ulogd_unregister_fd(&cpi->nfct_fd);
@@ -942,7 +1030,7 @@ static int destructor_nfct(struct ulogd_pluginstance *pi)
 		return rc;
 
 
-	if (usehash_ce(pi->config_kset).u.value != 0) {
+	if (usehash_ce(upi->config_kset).u.value != 0) {
 		ulogd_del_timer(&cpi->ov_timer);
 		ulogd_unregister_fd(&cpi->nfct_ov);
 
@@ -960,6 +1048,30 @@ static int destructor_nfct(struct ulogd_pluginstance *pi)
 	return 0;
 }
 
+static int destructor_nfct_polling(struct ulogd_pluginstance *upi)
+{
+	int rc;
+	struct nfct_pluginstance *cpi = (void *)upi->private;
+
+	rc = nfct_close(cpi->pgh);
+	if (rc < 0)
+		return rc;
+
+	return 0;
+}
+
+static int destructor_nfct(struct ulogd_pluginstance *upi)
+{
+	if (pollint_ce(upi->config_kset).u.value == 0) {
+		return destructor_nfct_events(upi);
+	} else {
+		return destructor_nfct_polling(upi);
+	}
+	/* should not ever happen. */
+	ulogd_log(ULOGD_FATAL, "invalid NFCT configuration\n");
+	return -1;
+}
+
 static void signal_nfct(struct ulogd_pluginstance *pi, int signal)
 {
 	switch (signal) {
diff --git a/ulogd.conf.in b/ulogd.conf.in
index 4542fc4..b77d726 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -92,6 +92,7 @@ plugin="@libdir@/ulogd/ulogd_raw2packet_BASE.so"
 #netlink_socket_buffer_size=217088
 #netlink_socket_buffer_maxsize=1085440
 #netlink_resync_timeout=60 # seconds to wait to perform resynchronization
+#pollinterval=10 # use poll-based logging instead of event-driven
 
 [ct2]
 #netlink_socket_buffer_size=217088

