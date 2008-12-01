From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 14/18] Unload plugins when quitting.
Date: Mon,  1 Dec 2008 22:36:12 +0100
Message-ID: <1228167376-22101-15-git-send-email-eric@inl.fr>
References: <1228167376-22101-1-git-send-email-eric@inl.fr>
Cc: pablo@netfilter.org, Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:39312 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752550AbYLAVgV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Dec 2008 16:36:21 -0500
In-Reply-To: <1228167376-22101-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds unloading of plugins (call dlclose()) in ulogd2. This
make valgrind happy and will be useful for daemon live reconfiguration.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 include/ulogd/ulogd.h |    8 ++++++++
 src/ulogd.c           |   21 ++++++++++++++++++++-
 2 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/include/ulogd/ulogd.h b/include/ulogd/ulogd.h
index 3f6d784..f55d5f1 100644
--- a/include/ulogd/ulogd.h
+++ b/include/ulogd/ulogd.h
@@ -187,6 +187,14 @@ static inline void *ikey_get_ptr(struct ulogd_key *key)
 
 struct ulogd_pluginstance_stack;
 struct ulogd_pluginstance;
+
+struct ulogd_plugin_handle {
+	/* global list of plugins */
+	struct llist_head list;
+	void *handle;
+};
+
+
 struct ulogd_plugin {
 	/* global list of plugins */
 	struct llist_head list;
diff --git a/src/ulogd.c b/src/ulogd.c
index 2f80913..ae57a38 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -83,6 +83,8 @@ static int info_mode = 0;
 
 /* linked list for all registered plugins */
 static LLIST_HEAD(ulogd_plugins);
+/* linked list for all plugins handle */
+static LLIST_HEAD(ulogd_plugins_handle);
 static LLIST_HEAD(ulogd_pi_stacks);
 
 
@@ -580,11 +582,17 @@ pluginstance_alloc_init(struct ulogd_plugin *pl, char *pi_id,
 /* plugin loader to dlopen() a plugins */
 static int load_plugin(const char *file)
 {
-	if (!dlopen(file, RTLD_NOW)) {
+	void * handle;
+	struct ulogd_plugin_handle *ph;
+	if ((handle = dlopen(file, RTLD_NOW)) == NULL) {
 		ulogd_log(ULOGD_ERROR, "load_plugin: '%s': %s\n", file,
 			  dlerror());
 		return -1;
 	}
+
+	ph = (struct ulogd_plugin_handle *) calloc(1, sizeof(*ph));
+	ph->handle = handle;
+	llist_add(&ph->list, &ulogd_plugins_handle);
 	return 0;
 }
 
@@ -977,6 +985,15 @@ static void stop_pluginstances()
 	}
 }
 
+static void unload_plugins()
+{
+	struct ulogd_plugin_handle *ph, *nph;
+	llist_for_each_entry_safe(ph, nph, &ulogd_plugins_handle, list) {
+		dlclose(ph->handle);
+		free(ph);
+	}
+}
+
 static void sigterm_handler(int signal)
 {
 
@@ -986,6 +1003,8 @@ static void sigterm_handler(int signal)
 
 	stop_pluginstances();
 
+	unload_plugins();
+
 	if (logfile != NULL  && logfile != stdout) {
 		fclose(logfile);
 		logfile = NULL;
-- 
1.5.6.3

