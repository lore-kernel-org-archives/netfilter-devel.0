From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH] FIX only use overrun handling if local hash is used.
Date: Fri, 23 May 2008 22:10:39 +0200
Message-ID: <1211573439-12356-1-git-send-email-eric@inl.fr>
References: <1211236295-30207-9-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:37018 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758745AbYEWUJU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 May 2008 16:09:20 -0400
In-Reply-To: <1211236295-30207-9-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a fix over my previous patch. It correct a problem when hash_enable
is set to 0.

Overrun handling work by dumping the whole connection tracking table after an
overrun. This is correct if the local hash is used but could be really bad if
it is not the case. All entries would be flushed through the stack and arrive
to the output module. In the case of a syslog or logemu module this will cause
massive and useless message printing.

This patch modify the code by activating overrun handling if and only if the
local hash is used (hash_enable=1 which is the default).

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 input/flow/ulogd_inpflow_NFCT.c |   49 +++++++++++++++++++++++----------------
 1 files changed, 29 insertions(+), 20 deletions(-)

diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index e99f41a..8e8254a 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -625,7 +625,7 @@ static int event_handler(enum nf_conntrack_msg_type type,
 		.ct = ct,
 	};
 
-	if (!usehash_ce(upi->config_kset).u.value && type == NFCT_T_DESTROY) {
+	if (!usehash_ce(upi->config_kset).u.value) {
 		switch(type) {
 		case NFCT_T_NEW:
 			gettimeofday(&tmp.time[START], NULL);
@@ -732,10 +732,13 @@ static int read_cb_nfct(int fd, unsigned int what, void *param)
 					  "`netlink_socket_buffer_size' and "
 					  "`netlink_socket_buffer_maxsize'\n");
 			}
-
-			nfct_send(cpi->ovh, NFCT_Q_DUMP, &family);
-			/* TODO: configurable retry timer */
-			ulogd_add_timer(&cpi->ov_timer, 2);
+			
+			/* internal hash can deal with refresh */
+			if (usehash_ce(upi->config_kset).u.value != 0) {
+				nfct_send(cpi->ovh, NFCT_Q_DUMP, &family);
+				/* TODO: configurable retry timer */
+				ulogd_add_timer(&cpi->ov_timer, 2);
+			}
 		}
 	}
 
@@ -880,13 +883,16 @@ static int constructor_nfct(struct ulogd_pluginstance *upi)
 					"set to %d\n", cpi->nlbufsiz);
 	}
 
-	cpi->ovh = nfct_open(NFNL_SUBSYS_CTNETLINK, 0);
-	if (!cpi->ovh) {
-		ulogd_log(ULOGD_FATAL, "error opening ctnetlink\n");
-		return -1;
-	}
+	if (usehash_ce(upi->config_kset).u.value != 0) {
+		cpi->ovh = nfct_open(NFNL_SUBSYS_CTNETLINK, 0);
+		if (!cpi->ovh) {
+			ulogd_log(ULOGD_FATAL, "error opening ctnetlink\n");
+			return -1;
+		}
 
-	nfct_callback_register(cpi->ovh, NFCT_T_ALL, &overrun_handler, upi);
+		nfct_callback_register(cpi->ovh, NFCT_T_ALL,
+				       &overrun_handler, upi);
+	}
 
 	cpi->pgh = nfct_open(NFNL_SUBSYS_CTNETLINK, 0);
 	if (!cpi->pgh) {
@@ -903,14 +909,14 @@ static int constructor_nfct(struct ulogd_pluginstance *upi)
 
 	ulogd_register_fd(&cpi->nfct_fd);
 
-	cpi->nfct_ov.fd = nfct_fd(cpi->ovh);
-	cpi->nfct_ov.cb = &read_cb_ovh;
-	cpi->nfct_ov.data = cpi;
-	cpi->nfct_ov.when = ULOGD_FD_READ;
+	if (usehash_ce(upi->config_kset).u.value != 0) {
+		cpi->nfct_ov.fd = nfct_fd(cpi->ovh);
+		cpi->nfct_ov.cb = &read_cb_ovh;
+		cpi->nfct_ov.data = cpi;
+		cpi->nfct_ov.when = ULOGD_FD_READ;
 
-	ulogd_register_fd(&cpi->nfct_ov);
+		ulogd_register_fd(&cpi->nfct_ov);
 
-	if (usehash_ce(upi->config_kset).u.value != 0) {
 		cpi->ct_active =
 		     hashtable_create(buckets_ce(upi->config_kset).u.value,
 		     		      maxentries_ce(upi->config_kset).u.value,
@@ -940,9 +946,12 @@ static int destructor_nfct(struct ulogd_pluginstance *pi)
 	if (rc < 0)
 		return rc;
 
-	rc = nfct_close(cpi->ovh);
-	if (rc < 0)
-		return rc;
+
+	if (usehash_ce(pi->config_kset).u.value != 0) {
+		rc = nfct_close(cpi->ovh);
+		if (rc < 0)
+			return rc;
+	}
 
 	rc = nfct_close(cpi->pgh);
 	if (rc < 0)
-- 
1.5.4.3

