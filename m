From: Max Kellermann <max@duempel.org>
Subject: [conntrack-tools PATCH r7363 2/5] use "for" loop instead of "while"
Date: Wed, 13 Feb 2008 18:13:27 +0100
Message-ID: <20080213171327.29912.85768.stgit@woodpecker.roonstrasse.net>
References: <20080213171046.29912.41091.stgit@woodpecker.roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from duempel.org ([78.31.71.42]:47587 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752298AbYBMRWZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Feb 2008 12:22:25 -0500
In-Reply-To: <20080213171046.29912.41091.stgit@woodpecker.roonstrasse.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


---

 src/alarm.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)


diff --git a/src/alarm.c b/src/alarm.c
index 470efdd..a3bdbe2 100644
--- a/src/alarm.c
+++ b/src/alarm.c
@@ -128,15 +128,12 @@ do_alarm_run(struct timeval *next_run)
 
 	gettimeofday(&tv, NULL);
 
-	node = rb_first(&alarm_root);
-	while (node) {
+	for (node = rb_first(&alarm_root); node; node = rb_next(node)) {
 		this = container_of(node, struct alarm_block, node);
 
 		if (timercmp(&this->tv, &tv, >))
 			break;
 
-		node = rb_next(node);
-
 		list_add(&this->list, &alarm_run_queue);
 	}
 


