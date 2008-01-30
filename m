From: heitzenberger@astaro.com
Subject: [ULOGD RFC 28/30] NFCT: fix start/stop handling
Date: Wed, 30 Jan 2008 19:59:15 +0100
Message-ID: <20080130190130.209186514@kruemel.intranet.astaro.de>
References: <20080130185847.693274384@kruemel.intranet.astaro.de>
Cc: holger@eitzenberger.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-91.dex002.intermedia.net ([64.78.21.115]:23297 "EHLO
	dhost002-91.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754563AbYA3TBs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:01:48 -0500
Content-Disposition: inline; filename=ulogd-NFCT-start-stop-cleanup.diff
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Free sequence cache too.

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: ulogd-netfilter/input/flow/ulogd_inpflow_NFCT.c
===================================================================
--- ulogd-netfilter.orig/input/flow/ulogd_inpflow_NFCT.c
+++ ulogd-netfilter/input/flow/ulogd_inpflow_NFCT.c
@@ -526,6 +526,9 @@ cache_free(struct cache *c)
 {
 	int i;
 
+	if (c == NULL)
+		return;
+
 	for (i = 0; i < c->c_num_heads; i++) {
 		struct llist_head *ptr, *ptr2;
 
@@ -1079,7 +1082,7 @@ nfct_start(struct ulogd_pluginstance *up
 	ulogd_log(ULOGD_DEBUG, "%s: ctnetlink connection opened\n", upi->id);
 
     if (set_sockbuf_len(nfct_fd(priv->cth), RCVBUF_LEN, SNDBUF_LEN) < 0)
-	        goto err_free;
+	        goto err_nfct_close;
 
 	priv->nfct_fd.fd = nfct_fd(priv->cth);
 	priv->nfct_fd.cb = &read_cb_nfct;
@@ -1110,6 +1113,8 @@ nfct_start(struct ulogd_pluginstance *up
  err_free:
 	cache_free(priv->tcache);
 	priv->tcache = NULL;
+	cache_free(priv->scache);
+	priv->tcache = NULL;
 
 	return -1;
 }
@@ -1138,10 +1143,10 @@ nfct_stop(struct ulogd_pluginstance *pi)
 
 	ulogd_log(ULOGD_DEBUG, "%s: ctnetlink connection closed\n", pi->id);
 
-	if (priv->tcache != NULL) {
-		cache_free(priv->tcache);
-		priv->tcache = NULL;
-	}
+	cache_free(priv->tcache);
+	priv->tcache = NULL;
+	cache_free(priv->scache);
+	priv->scache = NULL;
 
 	return 0;
 }

-- 
