From: Max Kellermann <max@duempel.org>
Subject: [conntrack-tools PATCH r7363 1/5] eliminate duplicate initialization
Date: Wed, 13 Feb 2008 18:13:27 +0100
Message-ID: <20080213171327.29912.84352.stgit@woodpecker.roonstrasse.net>
References: <20080213171046.29912.41091.stgit@woodpecker.roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from duempel.org ([78.31.71.42]:47581 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757586AbYBMRVY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Feb 2008 12:21:24 -0500
In-Reply-To: <20080213171046.29912.41091.stgit@woodpecker.roonstrasse.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


---

 src/alarm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/src/alarm.c b/src/alarm.c
index 5013735..470efdd 100644
--- a/src/alarm.c
+++ b/src/alarm.c
@@ -105,7 +105,7 @@ calculate_next_run(struct timeval *cand,
 struct timeval *
 get_next_alarm_run(struct timeval *next_run)
 {
-	struct rb_node *node = alarm_root.rb_node;
+	struct rb_node *node;
 	struct timeval tv;
 
 	gettimeofday(&tv, NULL);
@@ -122,7 +122,7 @@ get_next_alarm_run(struct timeval *next_run)
 struct timeval *
 do_alarm_run(struct timeval *next_run)
 {
-	struct rb_node *node = alarm_root.rb_node;
+	struct rb_node *node;
 	struct alarm_block *this, *tmp;
 	struct timeval tv;
 


