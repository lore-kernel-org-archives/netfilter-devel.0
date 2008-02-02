From: heitzenberger@astaro.com
Subject: [ULOGD 12/15] Introduce global state, skip some stacks during reconfiguration
Date: Sat, 02 Feb 2008 21:48:38 +0100
Message-ID: <20080202205108.901054239@astaro.com>
References: <20080202204826.267107164@astaro.com>
Cc: holger@eitzenberger.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-1.dex002.intermedia.net ([64.78.21.6]:39951 "EHLO
	dhost002-1.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933754AbYBBUv1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 15:51:27 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
Content-Disposition: inline; filename=ulogd-fix-races-during-reconf.diff

Some plugins are not reconfigurable, therefore skips entire stacks if
there is at least one plugin which is not reconfigurable.

Also introduce a global state to counter some pathological
reconfiguration issues.

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: ulogd-netfilter/src/ulogd.c
===================================================================
--- ulogd-netfilter.orig/src/ulogd.c
+++ ulogd-netfilter/src/ulogd.c
@@ -83,6 +83,7 @@ static FILE *logfile = NULL;		/* logfile
 static char *ulogd_configfile = ULOGD_CONFIGFILE;
 static char *ulogd_logfile = ULOGD_LOGFILE_DEFAULT;
 static FILE syslog_dummy;
+static enum GlobalState state;
 
 /* linked list for all registered plugins */
 static LLIST_HEAD(ulogd_plugins);
@@ -129,6 +130,19 @@ static struct config_keyset ulogd_kset =
 #define loglevel_ce	ulogd_kset.ces[2]
 #define stack_ce	ulogd_kset.ces[3]
 
+
+void
+ulogd_set_state(enum GlobalState s)
+{
+	state = s;
+}
+
+enum GlobalState
+ulogd_get_state(void)
+{
+	return state;
+}
+
 /***********************************************************************
  * UTILITY FUNCTIONS FOR PLUGINS
  ***********************************************************************/
@@ -195,8 +209,8 @@ int ulogd_wildcard_inputkeys(struct ulog
 
 	/* first pass: count keys */
 	llist_for_each_entry(pi_cur, &stack->list, list) {
-		ulogd_log(ULOGD_DEBUG, "iterating over pluginstance '%s'\n",
-			  pi_cur->id);
+		ulogd_log(ULOGD_DEBUG, "%s: iterating over pluginstance '%s'\n",
+				  upi->id, pi_cur->id);
 		num_keys += pi_cur->plugin->output.num_keys;
 	}
 
@@ -209,8 +223,12 @@ int ulogd_wildcard_inputkeys(struct ulog
 	llist_for_each_entry(pi_cur, &stack->list, list) {
 		int i;
 
-		for (i = 0; i < pi_cur->plugin->output.num_keys; i++)
+		for (i = 0; i < pi_cur->plugin->output.num_keys; i++) {
+			pr_debug("%s: copy key '%s' from plugin '%s'\n", upi->id,
+					 pi_cur->plugin->output.keys[i].name, pi_cur->id);
+
 			upi->input.keys[index++] = pi_cur->output.keys[i];
+		}
 	}
 
 	upi->input.num_keys = num_keys;
@@ -650,6 +668,10 @@ static int create_stack(const char *opti
 	}
 	INIT_LLIST_HEAD(&stack->list);
 
+	/* By default a stack is reconfigurable unless there is a plugin
+	   which is not reconfigurable */
+	stack->flags = ULOGD_SF_RECONF;
+
 	ulogd_log(ULOGD_DEBUG, "building new pluginstance stack (%s):\n",
 		  option);
 
@@ -698,6 +720,9 @@ static int create_stack(const char *opti
 			
 		ulogd_log(ULOGD_DEBUG, "pushing `%s' on stack\n", pl->name);
 		llist_add_tail(&pi->list, &stack->list);
+
+		if ((pi->plugin->flags & ULOGD_PF_RECONF) == 0)
+			stack->flags &= ~ULOGD_SF_RECONF;
 	}
 
 	/* PASS 2: resolve key connections from bottom to top of stack */
@@ -788,10 +813,20 @@ static int parse_conffile(const char *se
 	return 1;
 }
 
+/**
+ * Call callback on each ulogd_pluginstance.
+ * @arg cb      Callback to call for each ulogd_pluginstance.
+ * @arg arg     Argument to pass to each call to argument.
+ *
+ * Call callback on each ulogd_pluginstance, skipping stacks which are
+ * not reconfigurable.
+ *
+ * @return Number of calls.
+ */
 static int
 for_each_pluginstance(int (* cb)(struct ulogd_pluginstance *,
 								 struct ulogd_pluginstance_stack *,
-								 void *), void *arg)
+								 unsigned long), unsigned long arg)
 {
 	struct ulogd_pluginstance_stack *stack;
 	int sum = 0;
@@ -801,6 +836,9 @@ for_each_pluginstance(int (* cb)(struct 
 	llist_for_each_entry(stack, &ulogd_pi_stacks, stack_list) {
 		struct ulogd_pluginstance *pi;
 
+		if ((stack->flags & ULOGD_SF_RECONF) == 0)
+			continue;
+
 		llist_for_each_entry(pi, &stack->list, list) {
 			int ret;
 
@@ -824,14 +862,15 @@ enum ReconfOp
 
 static int
 _do_reconf(struct ulogd_pluginstance *pi,
-		   struct ulogd_pluginstance_stack *stack, void *arg)
+		   struct ulogd_pluginstance_stack *stack, unsigned long arg)
 {
-	enum ReconfOp op = (unsigned)arg;
+	enum ReconfOp op = arg;
 	int ret = 0;
 
 	assert(pi != NULL);
 
-	if ((pi->plugin->flags & ULOGD_PF_RECONF) == 0)
+	/* check whether stack is reconfigurable */
+	if ((stack->flags & ULOGD_SF_RECONF) == 0)
 		return 0;
 
 	switch (op) {
@@ -839,16 +878,12 @@ _do_reconf(struct ulogd_pluginstance *pi
 		ret = pi->plugin->stop(pi);
 		break;
 
-	case CONFIGURE:
-		ulogd_pluginstance_reset_cfg(pi);
-		ret = pi->plugin->configure(pi, stack);
-		break;
-
 	case START:
 		ret = pi->plugin->start(pi);
 		break;
 
 	default:
+		ulogd_log(ULOGD_ERROR, "%s: invalid op '%d'\n", __func__, op);
 		return -1;
 	}
 
@@ -863,25 +898,43 @@ _do_reconf(struct ulogd_pluginstance *pi
 static int
 reconfigure_plugins(void)
 {
+	struct ulogd_pluginstance_stack *stack;
+
 	ulogd_log(ULOGD_INFO, "reconfiguring plugins\n");
 
-	if (for_each_pluginstance(_do_reconf, (void *)STOP) < 0)
-		abort();
+	ulogd_set_state(GS_INITIALIZING);
 
-	if (for_each_pluginstance(_do_reconf, (void *)CONFIGURE) < 0)
-		abort();
+	/* Skip stacks which contain at least one plugin which is not
+	   reconfigurable.  This a workaround until all plugins are
+	   reconfigurable. */
+	if (for_each_pluginstance(_do_reconf, STOP) < 0)
+		goto err;
 
-	if (for_each_pluginstance(_do_reconf, (void *)START) < 0)
-		abort();
+	llist_for_each_entry(stack, &ulogd_pi_stacks, stack_list) {
+		if ((stack->flags & ULOGD_SF_RECONF) == 0)
+			continue;
+
+		if (create_stack_resolve_keys(stack) < 0)
+			goto err;
+	}
+
+	if (for_each_pluginstance(_do_reconf, START) < 0)
+		goto err;
+
+	ulogd_set_state(GS_RUNNING);
 
 	return 0;
+
+ err:
+ 	ulogd_log(ULOGD_FATAL, "failed to reconfigure\n");
+ 	return -1;
 }
 
 static int
 _do_signal(struct ulogd_pluginstance *pi,
-		   struct ulogd_pluginstance_stack *stack, void *arg)
+		   struct ulogd_pluginstance_stack *stack, unsigned long arg)
 {
-	int signo = (int) arg;
+	int signo = (int)arg;
 
 	if (pi->plugin->signal) {
 		pi->plugin->signal(pi, signo);
@@ -897,6 +950,9 @@ sync_sig_handler(int signo)
 {
 	pr_debug("%s: signal '%d' received\n", __func__, signo);
 
+	if (ulogd_get_state() != GS_RUNNING)
+		return;
+
 	switch (signo) {
 	case SIGHUP:
 		reconfigure_plugins();
@@ -913,7 +969,7 @@ sync_sig_handler(int signo)
 		break;
 	}
 
-	for_each_pluginstance(_do_signal, (void *) signo);
+	for_each_pluginstance(_do_signal, (unsigned long)signo);
 }
 
 static void
@@ -965,6 +1021,7 @@ main(int argc, char* argv[])
 	uid_t uid = 0;
 	gid_t gid = 0;
 
+	ulogd_set_state(GS_INITIALIZING);
 
 	while ((argch = getopt_long(argc, argv, "c:dh::Vu:", opts, NULL)) != -1) {
 		switch (argch) {
@@ -1086,6 +1143,8 @@ main(int argc, char* argv[])
 
 	ulogd_log(ULOGD_INFO, "entering main loop\n");
 
+	ulogd_set_state(GS_RUNNING);
+
 	ulogd_dispatch();
 
 	return 0;
Index: ulogd-netfilter/include/ulogd/ulogd.h
===================================================================
--- ulogd-netfilter.orig/include/ulogd/ulogd.h
+++ ulogd-netfilter/include/ulogd/ulogd.h
@@ -189,17 +189,29 @@ struct ulogd_pluginstance {
 	char private[0];
 };
 
+/* stack flags */
+#define ULOGD_SF_RECONF			0x00000001 /* stack is reconfigurable */
+
 struct ulogd_pluginstance_stack {
 	/* global list of pluginstance stacks */
 	struct llist_head stack_list;
 	/* list of plugins in this stack */
 	struct llist_head list;
 	char *name;
+	unsigned flags;
 };
 
 /***********************************************************************
  * PUBLIC INTERFACE 
  ***********************************************************************/
+enum GlobalState {
+	GS_INVAL = 0,
+	GS_INITIALIZING,			/* also reconfiguration */
+	GS_RUNNING,
+};
+
+void ulogd_set_state(enum GlobalState);
+enum GlobalState ulogd_get_state(void);
 
 void ulogd_propagate_results(struct ulogd_pluginstance *pi);
 

-- 
