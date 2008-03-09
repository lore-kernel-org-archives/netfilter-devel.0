From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 5/8] Add a list of used plugininstance.
Date: Sun,  9 Mar 2008 23:36:26 +0100
Message-ID: <12051021893531-git-send-email-eric@inl.fr>
References: <12051021893015-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:57601 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751525AbYCIWgc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Mar 2008 18:36:32 -0400
In-Reply-To: <12051021893015-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds plist a linked list to the pluginstance
structure. It can be used by input modules to duplicate an
entry. This solves the issue of not being able to use the same
plugin instance twice.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 include/ulogd/ulogd.h |    2 ++
 src/ulogd.c           |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/ulogd/ulogd.h b/include/ulogd/ulogd.h
index 39ac464..73a1711 100644
--- a/include/ulogd/ulogd.h
+++ b/include/ulogd/ulogd.h
@@ -168,6 +168,8 @@ struct ulogd_plugin {
 struct ulogd_pluginstance {
 	/* local list of plugins in this stack */
 	struct llist_head list;
+	/* local list of plugininstance in other stacks */
+	struct llist_head plist;
 	/* plugin */
 	struct ulogd_plugin *plugin;
 	/* stack that we're part of */
diff --git a/src/ulogd.c b/src/ulogd.c
index b69d25d..a6356f2 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -529,6 +529,7 @@ pluginstance_alloc_init(struct ulogd_plugin *pl, char *pi_id,
 	/* initialize */
 	memset(pi, 0, size);
 	INIT_LLIST_HEAD(&pi->list);
+	INIT_LLIST_HEAD(&pi->plist);
 	pi->plugin = pl;
 	pi->stack = stack;
 	memcpy(pi->id, pi_id, sizeof(pi->id));
@@ -722,6 +723,7 @@ static int pluginstance_started(struct ulogd_pluginstance *npi)
 			/* OK, pluginstance already exists in stack list */
 			if (! strcmp(pi->id, npi->id)) {
 				ulogd_log(ULOGD_INFO, "%s instance already loaded\n", pi->id);
+				llist_add(&pi->plist, &npi->plist);
 				return 1;
 			}
 		}
-- 
1.5.4.3

