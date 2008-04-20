From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH] Fix multiple usage of DB output plugin.
Date: Mon, 21 Apr 2008 00:45:22 +0200
Message-ID: <12087315222557-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:40398 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752674AbYDTWpY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Apr 2008 18:45:24 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

Due to the modifications done to be able to use multiple time the SOURCE
plugin, a single instance of database output plugin could not anymore be
used in separate stack. This patch fixes this by limiting the effect of
the previous modification on SOURCE plugin.

BR,

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 src/ulogd.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/src/ulogd.c b/src/ulogd.c
index 249bde3..3a1e3d9 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -717,13 +717,17 @@ static int pluginstance_started(struct ulogd_pluginstance *npi)
 	struct ulogd_pluginstance_stack *stack;
 	struct ulogd_pluginstance *pi;
 
-	llist_for_each_entry(stack, &ulogd_pi_stacks, stack_list) {
-		llist_for_each_entry(pi, &stack->list, list) {
-			if (!strcmp(pi->id, npi->id)) {
-				ulogd_log(ULOGD_INFO, "%s instance already "
-						      "loaded\n", pi->id);
-				llist_add(&pi->plist, &npi->plist);
-				return 1;
+	/* Only SOURCE plugin need to be started once */
+	if (npi->plugin->input.type == ULOGD_DTYPE_SOURCE) {
+		llist_for_each_entry(stack, &ulogd_pi_stacks, stack_list) {
+			llist_for_each_entry(pi, &stack->list, list) {
+				if (!strcmp(pi->id, npi->id)) {
+					ulogd_log(ULOGD_INFO,
+							"%s instance already "
+							"loaded\n", pi->id);
+					llist_add(&pi->plist, &npi->plist);
+					return 1;
+				}
 			}
 		}
 	}
-- 
1.5.2.5
