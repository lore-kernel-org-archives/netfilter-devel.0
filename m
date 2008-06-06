From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 1/5] Fix logic of propagation trough the stack.
Date: Fri,  6 Jun 2008 15:13:51 +0200
Message-ID: <1212758035-19538-2-git-send-email-eric@inl.fr>
References: <>
 <1212758035-19538-1-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:43251 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754110AbYFFNME (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jun 2008 09:12:04 -0400
In-Reply-To: <1212758035-19538-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes the implementation of the propagation through the
stack. When a plugin returns ULOGD_IRET_STOP, the propagation should
stop. This was not the case as break was used to do so but it was called
inside a switch and thus apply to the switch instruction and not to
the llist iteration.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 src/ulogd.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/src/ulogd.c b/src/ulogd.c
index 8c8dc14..4e36984 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -477,6 +477,7 @@ static void ulogd_clean_results(struct ulogd_pluginstance *pi)
 void ulogd_propagate_results(struct ulogd_pluginstance *pi)
 {
 	struct ulogd_pluginstance *cur = pi;
+	int abort_stack = 0;
 	/* iterate over remaining plugin stack */
 	llist_for_each_entry_continue(cur, &pi->stack->list, list) {
 		int ret;
@@ -489,6 +490,7 @@ void ulogd_propagate_results(struct ulogd_pluginstance *pi)
 			/* fallthrough */
 		case ULOGD_IRET_STOP:
 			/* we shall abort further iteration of the stack */
+			abort_stack = 1;
 			break;
 		case ULOGD_IRET_OK:
 			/* we shall continue travelling down the stack */
@@ -497,8 +499,12 @@ void ulogd_propagate_results(struct ulogd_pluginstance *pi)
 			ulogd_log(ULOGD_NOTICE,
 				  "unknown return value `%d' from plugin %s\n",
 				  ret, cur->plugin->name);
+			abort_stack = 1;
 			break;
 		}
+
+		if (abort_stack)
+			break;
 	}
 
 	ulogd_clean_results(pi);
-- 
1.5.4.3

