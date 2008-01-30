From: heitzenberger@astaro.com
Subject: [ULOGD RFC 11/30] NFCT: make reconfigurable
Date: Wed, 30 Jan 2008 19:58:58 +0100
Message-ID: <20080130190127.847510508@kruemel.intranet.astaro.de>
References: <20080130185847.693274384@kruemel.intranet.astaro.de>
Cc: holger@eitzenberger.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-15.dex002.intermedia.net ([64.78.21.81]:48828 "EHLO
	dhost002-15.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753771AbYA3TBl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:01:41 -0500
Content-Disposition: inline; filename=ulogd-NFCT-make-reconfigurable.diff
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: ulogd-netfilter/input/flow/ulogd_inpflow_NFCT.c
===================================================================
--- ulogd-netfilter.orig/input/flow/ulogd_inpflow_NFCT.c
+++ ulogd-netfilter/input/flow/ulogd_inpflow_NFCT.c
@@ -33,10 +33,10 @@
 
 #include <sys/time.h>
 #include <time.h>
-#include <ulogd/linuxlist.h>
 
 #include <ulogd/ulogd.h>
 #include <ulogd/common.h>
+#include <ulogd/linuxlist.h>
 #include <ulogd/ipfix_protocol.h>
 
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
@@ -464,6 +464,7 @@ htable_alloc(int htable_size)
 
 	htable->buckets = (void *)htable + sizeof(*htable);
 	htable->num_buckets = htable_size;
+	htable->curr_bucket = 0;
 	htable->used = 0;
 
 	for (i = 0; i < htable->num_buckets; i++)
@@ -735,7 +736,7 @@ read_cb_nfct(int fd, unsigned what, void
 #define STOP_HERE(h)	(((h)->curr_bucket + 16) % (h)->num_buckets)
 
 static void
-timer_cb(struct ulogd_timer *t)
+nfct_timer_cb(struct ulogd_timer *t)
 {
 	struct ulogd_pluginstance *pi = t->data;
 	struct nfct_pluginstance *priv = (void *)pi->private;
@@ -754,14 +755,19 @@ timer_cb(struct ulogd_timer *t)
 
 		ht->curr_bucket = (ht->curr_bucket + 1) % ht->num_buckets;
 	} while (ht->curr_bucket != end);
+
+	pr_debug("%s: now=%ld\n", __func__, t_now);
 }
 
-static int configure_nfct(struct ulogd_pluginstance *upi,
-			  struct ulogd_pluginstance_stack *stack)
+static int
+nfct_configure(struct ulogd_pluginstance *upi,
+			   struct ulogd_pluginstance_stack *stack)
 {
 	struct nfct_pluginstance *priv = (void *)upi->private;
 	int ret;
 
+	pr_debug("%s: pi=%p\n", __func__, upi);
+
 	memset(priv, 0, sizeof(struct nfct_pluginstance));
 	
 	ret = config_parse_file(upi->id, upi->config_kset);
@@ -772,68 +778,87 @@ static int configure_nfct(struct ulogd_p
 }
 
 
-static int constructor_nfct(struct ulogd_pluginstance *upi)
+static int
+nfct_start(struct ulogd_pluginstance *upi)
 {
-	struct nfct_pluginstance *cpi = (void *)upi->private;
+	struct nfct_pluginstance *priv = (void *)upi->private;
 
-	cpi->cth = nfct_open(NFNL_SUBSYS_CTNETLINK, CT_EVENTS);
-	if (!cpi->cth) {
-		ulogd_log(ULOGD_FATAL, "error opening ctnetlink\n");
+	pr_debug("%s: pi=%p\n", __func__, upi);
+
+	priv->htable = htable_alloc(buckets_ce(upi->config_kset).u.value);
+	if (priv->htable == NULL) {
+		ulogd_log(ULOGD_FATAL, "%s: out of memory\n", upi->id);
 		return -1;
 	}
 
-	cpi->nfct_fd.fd = nfct_fd(cpi->cth);
-	cpi->nfct_fd.cb = &read_cb_nfct;
-	cpi->nfct_fd.data = upi;
-	cpi->nfct_fd.when = ULOGD_FD_READ;
-
-	ulogd_register_fd(&cpi->nfct_fd);
-
-	cpi->htable = htable_alloc(buckets_ce(upi->config_kset).u.value);
-	if (cpi->htable == NULL) {
-		ulogd_log(ULOGD_FATAL, "htable_alloc: out of memory\n");
+	priv->cth = nfct_open(NFNL_SUBSYS_CTNETLINK, CT_EVENTS);
+	if (priv->cth == NULL) {
+		ulogd_log(ULOGD_FATAL, "error opening ctnetlink\n");
+		goto err_free;
+	}
 
-		nfct_close(cpi->cth);
-		cpi->cth = NULL;
+	priv->nfct_fd.fd = nfct_fd(priv->cth);
+	priv->nfct_fd.cb = &read_cb_nfct;
+	priv->nfct_fd.data = upi;
+	priv->nfct_fd.when = ULOGD_FD_READ;
 
-		return -1;
-	}
+	if (ulogd_register_fd(&priv->nfct_fd) < 0)
+		goto err_nfct_close;
 
-	cpi->timer.cb = timer_cb;
-	cpi->timer.ival = 1 SEC;
-	cpi->timer.flags = TIMER_F_PERIODIC;
-	cpi->timer.data = upi;
+	priv->timer.cb = nfct_timer_cb;
+	priv->timer.ival = 1 SEC;
+	priv->timer.flags = TIMER_F_PERIODIC;
+	priv->timer.data = upi;
 
-	ulogd_register_timer(&cpi->timer);
+	if (ulogd_register_timer(&priv->timer) < 0)
+		goto err_unreg_fd;
+
+	ulogd_log(ULOGD_INFO, "%s: started\n", upi->id);
 
-	ulogd_log(ULOGD_INFO, "%s: hashsize %u\n", upi->id,
-			  cpi->htable->num_buckets);
-	
 	return 0;
+
+ err_unreg_fd:
+	ulogd_unregister_fd(&priv->nfct_fd);
+ err_nfct_close:
+	nfct_close(priv->cth);
+	priv->cth = NULL;
+ err_free:
+	htable_free(priv->htable);
+	priv->htable = NULL;
+
+	return -1;
 }
 
-static int destructor_nfct(struct ulogd_pluginstance *pi)
+static int
+nfct_stop(struct ulogd_pluginstance *pi)
 {
-	struct nfct_pluginstance *cpi = (void *) pi;
-	
-	nfct_close(cpi->cth);
-	cpi->cth = NULL;
+	struct nfct_pluginstance *priv = (void *)pi->private;
 
-	htable_free(cpi->htable);
+	pr_debug("%s: pi=%p\n", __func__, pi);
 
-	return 0;
-}
+	if (priv->htable == NULL)
+		return 0;				/* already stopped */
 
-static void signal_nfct(struct ulogd_pluginstance *pi, int signal)
-{
-	switch (signal) {
-	case SIGUSR2:
-		break;
+	ulogd_unregister_timer(&priv->timer);
+
+	ulogd_unregister_fd(&priv->nfct_fd);
+
+	if (priv->cth != NULL) {
+		nfct_close(priv->cth);
+		priv->cth = NULL;
 	}
+
+	if (priv->htable != NULL) {
+		htable_free(priv->htable);
+		priv->htable = NULL;
+	}
+
+	return 0;
 }
 
 static struct ulogd_plugin nfct_plugin = {
 	.name = "NFCT",
+	.flags = ULOGD_PF_RECONF,
 	.input = {
 		.type = ULOGD_DTYPE_SOURCE,
 	},
@@ -844,17 +869,17 @@ static struct ulogd_plugin nfct_plugin =
 	},
 	.config_kset 	= &nfct_kset,
 	.interp 	= NULL,
-	.configure	= &configure_nfct,
-	.start		= &constructor_nfct,
-	.stop		= &destructor_nfct,
-	.signal		= &signal_nfct,
+	.configure	= nfct_configure,
+	.start		= nfct_start,
+	.stop		= nfct_stop,
 	.priv_size	= sizeof(struct nfct_pluginstance),
 	.version	= ULOGD_VERSION,
 };
 
 void __attribute__ ((constructor)) init(void);
 
-void init(void)
+void
+init(void)
 {
 	ulogd_register_plugin(&nfct_plugin);
 }

-- 
