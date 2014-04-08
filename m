From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [ulogd PATCH 3/3] add mark dump filter
Date: Tue, 8 Apr 2014 19:34:22 +0900
Message-ID: <20140408103420.GD29462@gmail.com>
References: <20140408102614.GA29462@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48433 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576AbaDHKe2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Apr 2014 06:34:28 -0400
Received: by mail-pa0-f46.google.com with SMTP id kx10so851478pab.19
        for <netfilter-devel@vger.kernel.org>; Tue, 08 Apr 2014 03:34:28 -0700 (PDT)
Received: from gmail.com (softbank220009032009.bbtec.net. [220.9.32.9])
        by mx.google.com with ESMTPSA id i10sm8335605pat.36.2014.04.08.03.34.25
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Tue, 08 Apr 2014 03:34:26 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140408102614.GA29462@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch makes enable to filter dump by mark.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 input/flow/ulogd_inpflow_NFCT.c | 63 +++++++++++++++++++++++++++--------------
 1 file changed, 42 insertions(+), 21 deletions(-)

diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index a5cf854..37b45e8 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -71,6 +71,7 @@ struct nfct_pluginstance {
 	struct ulogd_timer ov_timer;	/* overrun retry timer */
 	struct hashtable *ct_active;
 	int nlbufsiz;			/* current netlink buffer size */
+	struct nfct_filter_dump *filter_dump;
 	struct nf_conntrack *ct;
 };
 
@@ -1003,8 +1004,9 @@ dump_reset_handler(enum nf_conntrack_msg_type type,
 
 static void get_ctr_zero(struct ulogd_pluginstance *upi)
 {
+	struct nfct_pluginstance *cpi =
+			(struct nfct_pluginstance *)upi->private;
 	struct nfct_handle *h;
-	int family = AF_UNSPEC;
 
 	h = nfct_open(CONNTRACK, 0);
 	if (h == NULL) {
@@ -1012,7 +1014,7 @@ static void get_ctr_zero(struct ulogd_pluginstance *upi)
 		return;
 	}
 	nfct_callback_register(h, NFCT_T_ALL, &dump_reset_handler, upi);
-	if (nfct_query(h, NFCT_Q_DUMP_RESET, &family) == -1)
+	if (nfct_query(h, NFCT_Q_DUMP_FILTER_RESET, cpi->filter_dump) == -1)
 		ulogd_log(ULOGD_FATAL, "Cannot dump and reset counters\n");
 
 	nfct_close(h);
@@ -1023,9 +1025,8 @@ static void polling_timer_cb(struct ulogd_timer *t, void *data)
 	struct ulogd_pluginstance *upi = data;
 	struct nfct_pluginstance *cpi =
 			(struct nfct_pluginstance *)upi->private;
-	int family = AF_UNSPEC;
 
-	nfct_query(cpi->pgh, NFCT_Q_DUMP, &family);
+	nfct_query(cpi->pgh, NFCT_Q_DUMP_FILTER, cpi->filter_dump);
 	hashtable_iterate(cpi->ct_active, upi, do_purge);
 	ulogd_add_timer(&cpi->timer, pollint_ce(upi->config_kset).u.value);
 }
@@ -1044,12 +1045,11 @@ static int configure_nfct(struct ulogd_pluginstance *upi,
 
 static void overrun_timeout(struct ulogd_timer *a, void *data)
 {
-	int family = AF_UNSPEC;
 	struct ulogd_pluginstance *upi = data;
 	struct nfct_pluginstance *cpi =
 			(struct nfct_pluginstance *)upi->private;
 
-	nfct_send(cpi->ovh, NFCT_Q_DUMP, &family);
+	nfct_send(cpi->ovh, NFCT_Q_DUMP_FILTER, cpi->filter_dump);
 }
 
 
@@ -1228,8 +1228,8 @@ static int build_nfct_filter_proto(struct nfct_filter *filter, char* filter_stri
 	return 0;
 }
 
-#if defined HAVE_NFCT_FILTER_MARK
-static int build_nfct_filter_mark(struct nfct_filter *filter, char* filter_string)
+static int build_nfct_filter_mark(struct nfct_filter *filter, char* filter_string,
+				struct nfct_filter_dump *filter_dump)
 {
 	char *p, *endptr;
 	uintmax_t v;
@@ -1264,24 +1264,27 @@ static int build_nfct_filter_mark(struct nfct_filter *filter, char* filter_strin
 		filter_mark.mask = UINT32_MAX;
 	}
 
-	ulogd_log(ULOGD_NOTICE, "adding mark to filter: \"%u/%u\"\n",
+	if (filter != NULL) {
+#if defined HAVE_NFCT_FILTER_MARK
+		nfct_filter_add_attr(filter, NFCT_FILTER_MARK, &filter_mark);
+		ulogd_log(ULOGD_NOTICE, "adding mark to event filter: \"%u/%u\"\n",
+			  filter_mark.val, filter_mark.mask);
+#else
+		ulogd_log(ULOGD_FATAL, "mark event filter is not supported\n");
+		return -1;
+#endif
+	}
+	nfct_filter_dump_set_attr(filter_dump, NFCT_FILTER_DUMP_MARK,
+					&filter_mark);
+	ulogd_log(ULOGD_NOTICE, "adding mark to dump filter: \"%u/%u\"\n",
 		  filter_mark.val, filter_mark.mask);
-	nfct_filter_add_attr(filter, NFCT_FILTER_MARK, &filter_mark);
 
 	return 0;
 
 invalid_error:
 	ulogd_log(ULOGD_FATAL, "invalid val/mask %s\n", filter_string);
 	return -1;
-
-}
-#else
-static int build_nfct_filter_mark(struct nfct_filter *filter, char* filter_string)
-{
-	ulogd_log(ULOGD_FATAL, "mark filter is not supported\n");
-	return -1;
 }
-#endif /* HAVE_NFCT_FILTER_MARK */
 
 static int build_nfct_filter(struct ulogd_pluginstance *upi)
 {
@@ -1327,7 +1330,7 @@ static int build_nfct_filter(struct ulogd_pluginstance *upi)
 
 	if (strlen(mark_filter_ce(upi->config_kset).u.string) != 0) {
 		char *filter_string = mark_filter_ce(upi->config_kset).u.string;
-		if (build_nfct_filter_mark(filter, filter_string) != 0) {
+		if (build_nfct_filter_mark(filter, filter_string, cpi->filter_dump) != 0) {
 			ulogd_log(ULOGD_FATAL,
 					"Unable to create mark filter\n");
 			goto err_filter;
@@ -1412,7 +1415,6 @@ static int constructor_nfct_events(struct ulogd_pluginstance *upi)
 		goto err_nfctobj;
 
 	if (usehash_ce(upi->config_kset).u.value != 0) {
-		int family = AF_UNSPEC;
 		struct nfct_handle *h;
 
 		/* we use a hashtable to cache entries in userspace. */
@@ -1436,7 +1438,7 @@ static int constructor_nfct_events(struct ulogd_pluginstance *upi)
 		}
 		nfct_callback_register(h, NFCT_T_ALL,
 				       &event_handler_hashtable, upi);
-		nfct_query(h, NFCT_Q_DUMP, &family);
+		nfct_query(h, NFCT_Q_DUMP_FILTER, cpi->filter_dump);
 		nfct_close(h);
 
 		/* the overrun handler only make sense with the hashtable,
@@ -1500,6 +1502,14 @@ static int constructor_nfct_polling(struct ulogd_pluginstance *upi)
 		ulogd_log(ULOGD_FATAL, "error opening ctnetlink\n");
 		goto err;
 	}
+	if (strlen(mark_filter_ce(upi->config_kset).u.string) != 0) {
+		char *filter_string = mark_filter_ce(upi->config_kset).u.string;
+		if (build_nfct_filter_mark(NULL, filter_string,
+					   cpi->filter_dump) != 0) {
+			ulogd_log(ULOGD_FATAL, "error creating NFCT mark filter\n");
+			goto err_hashtable;
+		}
+	}
 	nfct_callback_register(cpi->pgh, NFCT_T_ALL, &polling_handler, upi);
 
 	cpi->ct_active =
@@ -1534,6 +1544,15 @@ err:
 
 static int constructor_nfct(struct ulogd_pluginstance *upi)
 {
+	struct nfct_pluginstance *cpi =
+			(struct nfct_pluginstance *) upi->private;
+
+	cpi->filter_dump = nfct_filter_dump_create();
+	if (cpi->filter_dump == NULL) {
+		ulogd_log(ULOGD_FATAL, "could not create filter_dump\n");
+		return -1;
+	}
+
 	if (pollint_ce(upi->config_kset).u.value == 0) {
 		/* listen to ctnetlink events. */
 		return constructor_nfct_events(upi);
@@ -1553,6 +1572,8 @@ static int destructor_nfct_events(struct ulogd_pluginstance *upi)
 
 	ulogd_unregister_fd(&cpi->nfct_fd);
 
+	nfct_filter_dump_destroy(cpi->filter_dump);
+
 	rc = nfct_close(cpi->cth);
 	if (rc < 0)
 		return rc;
-- 
1.8.5.3

