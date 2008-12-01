From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 12/18] Call pluginstance stop function when exiting
Date: Mon,  1 Dec 2008 22:36:10 +0100
Message-ID: <1228167376-22101-13-git-send-email-eric@inl.fr>
References: <1228167376-22101-1-git-send-email-eric@inl.fr>
Cc: pablo@netfilter.org, Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:39306 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752473AbYLAVgV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Dec 2008 16:36:21 -0500
In-Reply-To: <1228167376-22101-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The stop function of plugin was not called when ulogd2 was
preparing to quit. This patch adds a call to stop for all
plugins in each stack and free pluginstance.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 src/ulogd.c |   26 +++++++++++++++++++++++++-
 1 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/src/ulogd.c b/src/ulogd.c
index ead35b5..d193b26 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -958,18 +958,42 @@ static void deliver_signal_pluginstances(int signal)
 	}
 }
 
+static void stop_pluginstances()
+{
+	struct ulogd_pluginstance_stack *stack;
+	struct ulogd_pluginstance *pi, *npi;
+
+	llist_for_each_entry(stack, &ulogd_pi_stacks, stack_list) {
+		llist_for_each_entry_safe(pi, npi, &stack->list, list) {
+			if (((pi->plugin->priv_size == 0) || pi->private[0])
+					&& *pi->plugin->stop) {
+				ulogd_log(ULOGD_DEBUG, "calling stop for %s\n",
+					  pi->plugin->name);
+				(*pi->plugin->stop)(pi);
+				pi->private[0] = 0;
+			}
+			free(pi);
+		}
+	}
+}
+
 static void sigterm_handler(int signal)
 {
-	
+
 	ulogd_log(ULOGD_NOTICE, "sigterm received, exiting\n");
 
 	deliver_signal_pluginstances(signal);
 
+	stop_pluginstances();
+
 	if (logfile != NULL  && logfile != stdout) {
 		fclose(logfile);
 		logfile = NULL;
 	}
 
+	if (ulogd_logfile)
+		free(ulogd_logfile);
+
 	exit(0);
 }
 
-- 
1.5.6.3

