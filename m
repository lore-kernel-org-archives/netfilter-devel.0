From: heitzenberger@astaro.com
Subject: [ULOGD RFC 10/30] Initial round to make plugins reconfigurable
Date: Wed, 30 Jan 2008 19:58:57 +0100
Message-ID: <20080130190127.690048966@kruemel.intranet.astaro.de>
References: <20080130185847.693274384@kruemel.intranet.astaro.de>
Cc: holger@eitzenberger.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-48.dex002.intermedia.net ([64.78.21.144]:9357 "EHLO
	dhost002-48.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754954AbYA3TBp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:01:45 -0500
Content-Disposition: inline; filename=ulogd-allow-plugins-to-be-reconfigurable.diff
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In order to make ulogd fully reconfigurable without restarting this
patch does some introductory work letting plugins be able to be
flagged as reconfigurable.

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: ulogd-netfilter/include/ulogd/ulogd.h
===================================================================
--- ulogd-netfilter.orig/include/ulogd/ulogd.h
+++ ulogd-netfilter/include/ulogd/ulogd.h
@@ -125,6 +125,10 @@ struct ulogd_keyset {
 
 struct ulogd_pluginstance_stack;
 struct ulogd_pluginstance;
+
+/* plugin flags */
+#define ULOGD_PF_RECONF			0x00000001
+
 struct ulogd_plugin {
 	/* global list of plugins */
 	struct llist_head list;
@@ -135,6 +139,8 @@ struct ulogd_plugin {
 	/* ID for this plugin (dynamically assigned) */
 	unsigned int id;
 
+	unsigned flags;
+
 	struct ulogd_keyset input;
 	struct ulogd_keyset output;
 
Index: ulogd-netfilter/src/ulogd.c
===================================================================
--- ulogd-netfilter.orig/src/ulogd.c
+++ ulogd-netfilter/src/ulogd.c
@@ -218,6 +218,23 @@ int ulogd_wildcard_inputkeys(struct ulog
 	return 0;
 }
 
+/*
+  ulogd_pluginstance_reset_cfg() - reset to default config
+*/
+int
+ulogd_pluginstance_reset_cfg(const struct ulogd_pluginstance *pi)
+{
+	size_t size;
+
+	assert(pi->plugin != NULL);
+
+	size = sizeof(struct config_keyset)
+		+ pi->plugin->config_kset->num_ces * sizeof(struct config_entry);
+
+	memcpy(pi->config_kset, pi->plugin->config_kset, size);
+
+	return 0;
+}
 
 /***********************************************************************
  * PLUGIN MANAGEMENT 
@@ -823,6 +840,69 @@ for_each_pluginstance(int (* cb)(struct 
 	return sum;
 }
 
+enum ReconfOp
+{
+	INVAL = 0,
+	STOP,
+	CONFIGURE,
+	START,
+};
+
+static int
+_do_reconf(struct ulogd_pluginstance *pi,
+		   struct ulogd_pluginstance_stack *stack, void *arg)
+{
+	enum ReconfOp op = (unsigned)arg;
+	int ret = 0;
+
+	assert(pi != NULL);
+
+	if ((pi->plugin->flags & ULOGD_PF_RECONF) == 0)
+		return 0;
+
+	switch (op) {
+	case STOP:
+		ret = pi->plugin->stop(pi);
+		break;
+
+	case CONFIGURE:
+		ulogd_pluginstance_reset_cfg(pi);
+		ret = pi->plugin->configure(pi, stack);
+		break;
+
+	case START:
+		ret = pi->plugin->start(pi);
+		break;
+
+	default:
+		return -1;
+	}
+
+	if (ret < 0) {
+		ulogd_log(ULOGD_FATAL, "reconfiguring '%s' failed\n", pi->id);
+		return -1;
+	}
+
+	return 1;
+}
+
+static int
+reconfigure_plugins(void)
+{
+	ulogd_log(ULOGD_INFO, "reconfiguring plugins\n");
+
+	if (for_each_pluginstance(_do_reconf, (void *)STOP) < 0)
+		abort();
+
+	if (for_each_pluginstance(_do_reconf, (void *)CONFIGURE) < 0)
+		abort();
+
+	if (for_each_pluginstance(_do_reconf, (void *)START) < 0)
+		abort();
+
+	return 0;
+}
+
 static int
 _do_signal(struct ulogd_pluginstance *pi,
 		   struct ulogd_pluginstance_stack *stack, void *arg)
@@ -845,6 +925,7 @@ sync_sig_handler(int signo)
 
 	switch (signo) {
 	case SIGHUP:
+		reconfigure_plugins();
 		break;
 
 	case SIGALRM:

-- 
