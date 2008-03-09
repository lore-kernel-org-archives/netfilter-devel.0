From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 4/8] Don't call start function multiple time for a single plugin instance.
Date: Sun,  9 Mar 2008 23:36:25 +0100
Message-ID: <12051021893106-git-send-email-eric@inl.fr>
References: <12051021893015-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:57591 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753283AbYCIWgb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Mar 2008 18:36:31 -0400
In-Reply-To: <12051021893015-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When a plugin instance is used in multiple stack it is not necessary to
call the start function for each stack.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 src/ulogd.c |   33 ++++++++++++++++++++++++++++-----
 1 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/src/ulogd.c b/src/ulogd.c
index da821ee..b69d25d 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -710,6 +710,25 @@ create_stack_resolve_keys(struct ulogd_pluginstance_stack *stack)
 	return 0;
 }
 
+/* iterate on already defined stack to find if a plugininstance
+ * has already been instance (matching is on id) */
+static int pluginstance_started(struct ulogd_pluginstance *npi)
+{
+	struct ulogd_pluginstance_stack *stack;
+	struct ulogd_pluginstance *pi;
+
+	llist_for_each_entry(stack, &ulogd_pi_stacks, stack_list) {
+		llist_for_each_entry(pi, &stack->list, list) {
+			/* OK, pluginstance already exists in stack list */
+			if (! strcmp(pi->id, npi->id)) {
+				ulogd_log(ULOGD_INFO, "%s instance already loaded\n", pi->id);
+				return 1;
+			}
+		}
+	}
+	return 0;
+}
+
 static int create_stack_start_instances(struct ulogd_pluginstance_stack *stack)
 {
 	int ret;
@@ -720,11 +739,15 @@ static int create_stack_start_instances(struct ulogd_pluginstance_stack *stack)
 		if (!pi->plugin->start)
 			continue;
 
-		ret = pi->plugin->start(pi);
-		if (ret < 0) {
-			ulogd_log(ULOGD_ERROR, "error during start of `%s'\n",
-				  pi->id);
-			return ret;
+		/* we only call start if a plugin with same ID has not yet be
+		 * started */
+		if (! pluginstance_started(pi)) {
+			ret = pi->plugin->start(pi);
+			if (ret < 0) {
+				ulogd_log(ULOGD_ERROR, "error during start of `%s'\n",
+						pi->id);
+				return ret;
+			}
 		}
 	}
 	return 0;
-- 
1.5.4.3

