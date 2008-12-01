From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 16/18] Free stacks when exiting.
Date: Mon,  1 Dec 2008 22:36:14 +0100
Message-ID: <1228167376-22101-17-git-send-email-eric@inl.fr>
References: <1228167376-22101-1-git-send-email-eric@inl.fr>
Cc: pablo@netfilter.org, Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:39322 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752685AbYLAVgW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Dec 2008 16:36:22 -0500
In-Reply-To: <1228167376-22101-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch modifies ulogd2 to have it free the stacks when leaving.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 src/ulogd.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/src/ulogd.c b/src/ulogd.c
index b079fd2..1a1f6af 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -994,6 +994,16 @@ static void unload_plugins()
 	}
 }
 
+static void stop_stack()
+{
+	struct ulogd_pluginstance_stack *stack, *nstack;
+
+	llist_for_each_entry_safe(stack, nstack, &ulogd_pi_stacks, stack_list) {
+		free(stack);
+	}
+}
+
+
 static void sigterm_handler(int signal)
 {
 
@@ -1003,6 +1013,8 @@ static void sigterm_handler(int signal)
 
 	stop_pluginstances();
 
+	stop_stack();
+
 	unload_plugins();
 
 	if (logfile != NULL  && logfile != stdout) {
-- 
1.5.6.3

