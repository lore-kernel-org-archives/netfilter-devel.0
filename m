From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/6] NFCT: cleanup constructor and destructor functions
Date: Wed, 13 Jan 2010 12:42:24 +0100
Message-ID: <20100113114224.12994.79855.stgit@decadence>
References: <20100113114009.12994.26386.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39640 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752556Ab0AMLzH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jan 2010 06:55:07 -0500
In-Reply-To: <20100113114009.12994.26386.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch cleans up the destructor and the destructor functions
in the NFCT plugin. I know, this patch isn't easy to review
because it includes too many changes in one.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 input/flow/ulogd_inpflow_NFCT.c |   97 +++++++++++++++++++++++----------------
 1 files changed, 56 insertions(+), 41 deletions(-)

diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index 8d6347f..9ef4eae 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -3,7 +3,7 @@
  * ulogd input plugin for ctnetlink
  *
  * (C) 2005 by Harald Welte <laforge@netfilter.org>
- * (C) 2008 by Pablo Neira Ayuso <pablo@netfilter.org>
+ * (C) 2008-2010 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2
@@ -852,7 +852,7 @@ static int constructor_nfct(struct ulogd_pluginstance *upi)
 			     eventmask_ce(upi->config_kset).u.value);
 	if (!cpi->cth) {
 		ulogd_log(ULOGD_FATAL, "error opening ctnetlink\n");
-		return -1;
+		goto err_cth;
 	}
 
 	nfct_callback_register(cpi->cth, NFCT_T_ALL, &event_handler, upi);
@@ -863,25 +863,6 @@ static int constructor_nfct(struct ulogd_pluginstance *upi)
 					"set to %d\n", cpi->nlbufsiz);
 	}
 
-	if (usehash_ce(upi->config_kset).u.value != 0) {
-		cpi->ovh = nfct_open(NFNL_SUBSYS_CTNETLINK, 0);
-		if (!cpi->ovh) {
-			ulogd_log(ULOGD_FATAL, "error opening ctnetlink\n");
-			return -1;
-		}
-
-		nfct_callback_register(cpi->ovh, NFCT_T_ALL,
-				       &overrun_handler, upi);
-	}
-
-	cpi->pgh = nfct_open(NFNL_SUBSYS_CTNETLINK, 0);
-	if (!cpi->pgh) {
-		ulogd_log(ULOGD_FATAL, "error opening ctnetlink\n");
-		return -1;
-	}
-
-	ulogd_init_timer(&cpi->ov_timer, upi, overrun_timeout);
-
 	cpi->nfct_fd.fd = nfct_fd(cpi->cth);
 	cpi->nfct_fd.cb = &read_cb_nfct;
 	cpi->nfct_fd.data = cpi;
@@ -890,13 +871,9 @@ static int constructor_nfct(struct ulogd_pluginstance *upi)
 	ulogd_register_fd(&cpi->nfct_fd);
 
 	if (usehash_ce(upi->config_kset).u.value != 0) {
-		cpi->nfct_ov.fd = nfct_fd(cpi->ovh);
-		cpi->nfct_ov.cb = &read_cb_ovh;
-		cpi->nfct_ov.data = cpi;
-		cpi->nfct_ov.when = ULOGD_FD_READ;
-
-		ulogd_register_fd(&cpi->nfct_ov);
+		int family = AF_UNSPEC;
 
+		/* we use a hashtable to cache entries in userspace. */
 		cpi->ct_active =
 		     hashtable_create(buckets_ce(upi->config_kset).u.value,
 				      maxentries_ce(upi->config_kset).u.value,
@@ -905,14 +882,52 @@ static int constructor_nfct(struct ulogd_pluginstance *upi)
 				      compare);
 		if (!cpi->ct_active) {
 			ulogd_log(ULOGD_FATAL, "error allocating hash\n");
-			nfct_close(cpi->cth);
-			nfct_close(cpi->ovh);
-			nfct_close(cpi->pgh);
-			return -1;
+			goto err_hashtable;
+		}
+
+		/* populate the hashtable. */
+		nfct_query(cpi->cth, NFCT_Q_DUMP, &family);
+
+		/* the overrun handler only make sense with the hashtable,
+		 * if we hit overrun, we resync with ther kernel table. */
+		cpi->ovh = nfct_open(NFNL_SUBSYS_CTNETLINK, 0);
+		if (!cpi->ovh) {
+			ulogd_log(ULOGD_FATAL, "error opening ctnetlink\n");
+			goto err_ovh;
+		}
+
+		nfct_callback_register(cpi->ovh, NFCT_T_ALL,
+				       &overrun_handler, upi);
+
+		ulogd_init_timer(&cpi->ov_timer, upi, overrun_timeout);
+
+		cpi->nfct_ov.fd = nfct_fd(cpi->ovh);
+		cpi->nfct_ov.cb = &read_cb_ovh;
+		cpi->nfct_ov.data = cpi;
+		cpi->nfct_ov.when = ULOGD_FD_READ;
+
+		ulogd_register_fd(&cpi->nfct_ov);
+
+		/* we use this to purge old entries during overruns.*/
+		cpi->pgh = nfct_open(NFNL_SUBSYS_CTNETLINK, 0);
+		if (!cpi->pgh) {
+			ulogd_log(ULOGD_FATAL, "error opening ctnetlink\n");
+			goto err_pgh;
 		}
 	}
 
 	return 0;
+
+err_pgh:
+	ulogd_unregister_fd(&cpi->nfct_ov);
+	nfct_close(cpi->ovh);
+err_ovh:
+	hashtable_destroy(cpi->ct_active);
+err_hashtable:
+	ulogd_unregister_fd(&cpi->nfct_fd);
+	nfct_close(cpi->cth);
+err_cth:
+	return -1;
 }
 
 static int destructor_nfct(struct ulogd_pluginstance *pi)
@@ -920,12 +935,7 @@ static int destructor_nfct(struct ulogd_pluginstance *pi)
 	struct nfct_pluginstance *cpi = (void *) pi->private;
 	int rc;
 
-	/* free existent entries */
-	hashtable_iterate(cpi->ct_active, NULL, do_free);
-
-	hashtable_destroy(cpi->ct_active);
-
-	ulogd_del_timer(&cpi->ov_timer);
+	ulogd_unregister_fd(&cpi->nfct_fd);
 
 	rc = nfct_close(cpi->cth);
 	if (rc < 0)
@@ -933,15 +943,20 @@ static int destructor_nfct(struct ulogd_pluginstance *pi)
 
 
 	if (usehash_ce(pi->config_kset).u.value != 0) {
+		ulogd_del_timer(&cpi->ov_timer);
+		ulogd_unregister_fd(&cpi->nfct_ov);
+
 		rc = nfct_close(cpi->ovh);
 		if (rc < 0)
 			return rc;
-	}
 
-	rc = nfct_close(cpi->pgh);
-	if (rc < 0)
-		return rc;
+		rc = nfct_close(cpi->pgh);
+		if (rc < 0)
+			return rc;
 
+		hashtable_iterate(cpi->ct_active, NULL, do_free);
+		hashtable_destroy(cpi->ct_active);
+	}
 	return 0;
 }
 

