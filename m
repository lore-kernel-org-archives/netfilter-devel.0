From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 8/9] Only use overrun handling if local hash is used.
Date: Tue, 20 May 2008 00:31:34 +0200
Message-ID: <1211236295-30207-9-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:38780 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757310AbYESWai (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 May 2008 18:30:38 -0400
In-Reply-To: <>
References: <>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Overrun handling work by dumping the whole connection tracking table after an
overrun. This is correct if the local hash is used but could be really bad if
it is not the case. All entries would be flushed through the stack and arrive
to the output module. In the case of a syslog or logemu module this will cause
massive and useless message printing.

This patch modify the code by activating overrun handling if and only if the
local hash is used (hash_enable=1 which is the default).

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 input/flow/ulogd_inpflow_NFCT.c |   47 +++++++++++++++++++++++---------------
 1 files changed, 28 insertions(+), 19 deletions(-)

diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index e99f41a..aae7970 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
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

