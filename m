From: Max Kellermann <max@duempel.org>
Subject: [conntrack-tools PATCH r7363 3/5] make alarm_run_queue a local
	variable
Date: Wed, 13 Feb 2008 18:13:27 +0100
Message-ID: <20080213171327.29912.56705.stgit@woodpecker.roonstrasse.net>
References: <20080213171046.29912.41091.stgit@woodpecker.roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from duempel.org ([78.31.71.42]:33650 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755252AbYBMRXZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Feb 2008 12:23:25 -0500
In-Reply-To: <20080213171046.29912.41091.stgit@woodpecker.roonstrasse.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


---

 src/alarm.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)


diff --git a/src/alarm.c b/src/alarm.c
index a3bdbe2..c86ce44 100644
--- a/src/alarm.c
+++ b/src/alarm.c
@@ -21,7 +21,6 @@
 #include <limits.h>
 
 static struct rb_root alarm_root = RB_ROOT;
-static LIST_HEAD(alarm_run_queue);
 
 void init_alarm(struct alarm_block *t,
 		void *data,
@@ -122,12 +121,14 @@ get_next_alarm_run(struct timeval *next_run)
 struct timeval *
 do_alarm_run(struct timeval *next_run)
 {
+	struct list_head alarm_run_queue;
 	struct rb_node *node;
 	struct alarm_block *this, *tmp;
 	struct timeval tv;
 
 	gettimeofday(&tv, NULL);
 
+	INIT_LIST_HEAD(&alarm_run_queue);
 	for (node = rb_first(&alarm_root); node; node = rb_next(node)) {
 		this = container_of(node, struct alarm_block, node);
 


