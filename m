From: heitzenberger@astaro.com
Subject: [ULOGD RFC 24/30] NFCT: increase socket buffers
Date: Wed, 30 Jan 2008 19:59:11 +0100
Message-ID: <20080130190129.605898415@kruemel.intranet.astaro.de>
References: <20080130185847.693274384@kruemel.intranet.astaro.de>
Cc: holger@eitzenberger.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-64.dex002.intermedia.net ([64.78.20.13]:4031 "EHLO
	dhost002-64.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756252AbYA3TBr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:01:47 -0500
Content-Disposition: inline; filename=ulogd-NFCT-inc-sockbuf.diff
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Might reduce number of ENOBUFS.

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: ulogd-netfilter/input/flow/ulogd_inpflow_NFCT.c
===================================================================
--- ulogd-netfilter.orig/input/flow/ulogd_inpflow_NFCT.c
+++ ulogd-netfilter/input/flow/ulogd_inpflow_NFCT.c
@@ -1074,6 +1074,9 @@ nfct_start(struct ulogd_pluginstance *up
 
 	ulogd_log(ULOGD_DEBUG, "%s: ctnetlink connection opened\n", upi->id);
 
+    if (set_sockbuf_len(nfct_fd(priv->cth), RCVBUF_LEN, SNDBUF_LEN) < 0)
+	        goto err_free;
+
 	priv->nfct_fd.fd = nfct_fd(priv->cth);
 	priv->nfct_fd.cb = &read_cb_nfct;
 	priv->nfct_fd.data = upi;

-- 
