From: Max Kellermann <max@duempel.org>
Subject: [conntrack-tools PATCH r7363 4/5] use list_for_each_entry()
Date: Wed, 13 Feb 2008 18:13:28 +0100
Message-ID: <20080213171327.29912.91893.stgit@woodpecker.roonstrasse.net>
References: <20080213171046.29912.41091.stgit@woodpecker.roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from duempel.org ([78.31.71.42]:33659 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755542AbYBMRYZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Feb 2008 12:24:25 -0500
In-Reply-To: <20080213171046.29912.41091.stgit@woodpecker.roonstrasse.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

since alarm_run_queue is now a local variable, we can use the faster
list_for_each_entry() instead of list_for_each_entry_safe() /
list_del().
---

 src/alarm.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)


diff --git a/src/alarm.c b/src/alarm.c
index c86ce44..8056ee6 100644
--- a/src/alarm.c
+++ b/src/alarm.c
@@ -123,7 +123,7 @@ do_alarm_run(struct timeval *next_run)
 {
 	struct list_head alarm_run_queue;
 	struct rb_node *node;
-	struct alarm_block *this, *tmp;
+	struct alarm_block *this;
 	struct timeval tv;
 
 	gettimeofday(&tv, NULL);
@@ -138,8 +138,7 @@ do_alarm_run(struct timeval *next_run)
 		list_add(&this->list, &alarm_run_queue);
 	}
 
-	list_for_each_entry_safe(this, tmp, &alarm_run_queue, list) {
-		list_del(&this->list);
+	list_for_each_entry(this, &alarm_run_queue, list) {
 		rb_erase(&this->node, &alarm_root);
 		RB_CLEAR_NODE(&this->node);
 		this->function(this, this->data);


