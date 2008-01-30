From: heitzenberger@astaro.com
Subject: [ULOGD RFC 13/30] NFCT: add disable switch
Date: Wed, 30 Jan 2008 19:59:00 +0100
Message-ID: <20080130190128.114223376@kruemel.intranet.astaro.de>
References: <20080130185847.693274384@kruemel.intranet.astaro.de>
Cc: holger@eitzenberger.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-15.dex002.intermedia.net ([64.78.21.81]:48828 "EHLO
	dhost002-15.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751880AbYA3TBo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:01:44 -0500
Content-Disposition: inline; filename=ulogd-NFCT-add-disable-switch.diff
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: ulogd-netfilter/input/flow/ulogd_inpflow_NFCT.c
===================================================================
--- ulogd-netfilter.orig/input/flow/ulogd_inpflow_NFCT.c
+++ ulogd-netfilter/input/flow/ulogd_inpflow_NFCT.c
@@ -73,6 +73,7 @@ struct nfct_pluginstance {
 	struct ulogd_fd nfct_fd;
 	struct ct_htable *htable;
 	struct ulogd_timer timer;
+	unsigned disable : 1;
 	struct {
 		unsigned nl_err;
 		unsigned nl_ovr;
@@ -82,7 +83,7 @@ struct nfct_pluginstance {
 #define HTABLE_SIZE	(512)
 
 static struct config_keyset nfct_kset = {
-	.num_ces = 3,
+	.num_ces = 4,
 	.ces = {
 		{
 			.key	 = "pollinterval",
@@ -102,10 +103,18 @@ static struct config_keyset nfct_kset = 
 			.options = CONFIG_OPT_NONE,
 			.u.value = 0,
 		},
+		{
+			.key	 = "disable",
+			.type	 = CONFIG_TYPE_INT,
+			.options = CONFIG_OPT_NONE,
+			.u.value = 0,
+		},
 	},
 };
 #define pollint_ce(x)	(x->ces[0])
 #define buckets_ce(x)	(x->ces[1])
+#define hash_max_entries(x)		((x)->ces[2])
+#define disable_ce(x)	(x->ces[3])
 
 enum {
 	O_IP_SADDR = 0,
@@ -774,6 +783,8 @@ nfct_configure(struct ulogd_pluginstance
 	if (ret < 0)
 		return ret;
 
+	priv->disable = disable_ce(upi->config_kset).u.value;
+
 	return 0;
 }
 
@@ -785,6 +796,11 @@ nfct_start(struct ulogd_pluginstance *up
 
 	pr_debug("%s: pi=%p\n", __func__, upi);
 
+	if (priv->disable) {
+		ulogd_log(ULOGD_INFO, "%s: disabled\n", upi->id);
+		return 0;
+	}
+
 	priv->htable = htable_alloc(buckets_ce(upi->config_kset).u.value);
 	if (priv->htable == NULL) {
 		ulogd_log(ULOGD_FATAL, "%s: out of memory\n", upi->id);
@@ -797,6 +813,8 @@ nfct_start(struct ulogd_pluginstance *up
 		goto err_free;
 	}
 
+	ulogd_log(ULOGD_DEBUG, "%s: ctnetlink connection opened\n", upi->id);
+
 	priv->nfct_fd.fd = nfct_fd(priv->cth);
 	priv->nfct_fd.cb = &read_cb_nfct;
 	priv->nfct_fd.data = upi;
@@ -836,6 +854,9 @@ nfct_stop(struct ulogd_pluginstance *pi)
 
 	pr_debug("%s: pi=%p\n", __func__, pi);
 
+	if (priv->disable)
+		return 0;				/* wasn't started */
+
 	if (priv->htable == NULL)
 		return 0;				/* already stopped */
 
@@ -848,6 +869,8 @@ nfct_stop(struct ulogd_pluginstance *pi)
 		priv->cth = NULL;
 	}
 
+	ulogd_log(ULOGD_DEBUG, "%s: ctnetlink connection closed\n", pi->id);
+
 	if (priv->htable != NULL) {
 		htable_free(priv->htable);
 		priv->htable = NULL;

-- 
