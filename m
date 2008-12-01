From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 02/18] Modify usage of nflog_bind_pf function.
Date: Mon,  1 Dec 2008 22:36:00 +0100
Message-ID: <1228167376-22101-3-git-send-email-eric@inl.fr>
References: <1228167376-22101-1-git-send-email-eric@inl.fr>
Cc: pablo@netfilter.org, Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:39290 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751528AbYLAVgU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Dec 2008 16:36:20 -0500
In-Reply-To: <1228167376-22101-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The nflog_bind_pf function was called for each NFLOG instance. This patch
modifies the behaviour to have it call if and only if the nfgroup is set
to 0. As the kernel uses only the 0 group to output subsystem messages,
this change clarify the situation.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 input/packet/ulogd_inppkt_NFLOG.c |   52 ++++++++++++++++++++++--------------
 1 files changed, 32 insertions(+), 20 deletions(-)

diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt_NFLOG.c
index 5d25eec..647b61c 100644
--- a/input/packet/ulogd_inppkt_NFLOG.c
+++ b/input/packet/ulogd_inppkt_NFLOG.c
@@ -463,6 +463,33 @@ static int configure(struct ulogd_pluginstance *upi,
 	return 0;
 }
 
+static int become_system_logging(struct ulogd_pluginstance *upi)
+{
+	struct nflog_input *ui = (struct nflog_input *) upi->private;
+
+	if (unbind_ce(upi->config_kset).u.value > 0) {
+		ulogd_log(ULOGD_NOTICE, "forcing unbind of existing log "
+				"handler for protocol %d\n",
+				af_ce(upi->config_kset).u.value);
+		if (nflog_unbind_pf(ui->nful_h,
+					af_ce(upi->config_kset).u.value) < 0) {
+			ulogd_log(ULOGD_ERROR, "unable to force-unbind "
+					"existing log handler for protocol %d\n",
+					af_ce(upi->config_kset).u.value);
+			return -1;
+		}
+	}
+
+	ulogd_log(ULOGD_DEBUG, "binding to protocol family %d\n",
+			af_ce(upi->config_kset).u.value);
+	if (nflog_bind_pf(ui->nful_h, af_ce(upi->config_kset).u.value) < 0) {
+		ulogd_log(ULOGD_ERROR, "unable to bind to protocol family %d\n",
+				af_ce(upi->config_kset).u.value);
+		return -1;
+	}
+	return 0;
+}
+
 static int start(struct ulogd_pluginstance *upi)
 {
 	struct nflog_input *ui = (struct nflog_input *) upi->private;
@@ -477,25 +504,10 @@ static int start(struct ulogd_pluginstance *upi)
 	if (!ui->nful_h)
 		goto out_handle;
 
-	if (unbind_ce(upi->config_kset).u.value > 0) {
-		ulogd_log(ULOGD_NOTICE, "forcing unbind of existing log "
-			  "handler for protocol %d\n",
-			  af_ce(upi->config_kset).u.value);
-		if (nflog_unbind_pf(ui->nful_h,
-				    af_ce(upi->config_kset).u.value) < 0) {
-			ulogd_log(ULOGD_ERROR, "unable to force-unbind "
-				  "existing log handler for protocol %d\n",
-				  af_ce(upi->config_kset).u.value);
+	/* This is the system logging (conntrack, ...) facility */
+	if (group_ce(upi->config_kset).u.value == 0) {
+		if (become_system_logging(upi) == -1)
 			goto out_handle;
-		}
-	}
-
-	ulogd_log(ULOGD_DEBUG, "binding to protocol family %d\n",
-		  af_ce(upi->config_kset).u.value);
-	if (nflog_bind_pf(ui->nful_h, af_ce(upi->config_kset).u.value) < 0) {
-		ulogd_log(ULOGD_ERROR, "unable to bind to protocol family %d\n",
-			  af_ce(upi->config_kset).u.value);
-		goto out_bind_pf;
 	}
 
 	ulogd_log(ULOGD_DEBUG, "binding to log group %d\n",
@@ -542,8 +554,8 @@ static int start(struct ulogd_pluginstance *upi)
 
 out_bind:
 	nflog_close(ui->nful_h);
-out_bind_pf:
-	nflog_unbind_pf(ui->nful_h, af_ce(upi->config_kset).u.value);
+	if (group_ce(upi->config_kset).u.value == 0)
+		nflog_unbind_pf(ui->nful_h, af_ce(upi->config_kset).u.value);
 out_handle:
 	free(ui->nfulog_buf);
 out_buf:
-- 
1.5.6.3

