From: Max Kellermann <max@duempel.org>
Subject: [PATCH 4/4] call __run() after do_alarm_run()
Date: Mon, 21 Jan 2008 09:29:58 +0100
Message-ID: <20080121082958.27612.90493.stgit@rabbit.intern.cm-ag>
References: <20080121082752.27612.82519.stgit@rabbit.intern.cm-ag>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from duempel.org ([78.31.71.42]:43873 "HELO duempel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759138AbYAUMGe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jan 2008 07:06:34 -0500
In-Reply-To: <20080121082752.27612.82519.stgit@rabbit.intern.cm-ag>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

this saves us the initialization.  this patch is re-sent, it was first
submitted on january 18th.
---

 src/run.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)


diff --git a/src/run.c b/src/run.c
index b24cd9b..718e63c 100644
--- a/src/run.c
+++ b/src/run.c
@@ -233,19 +233,16 @@ void __attribute__((noreturn))
 run(void)
 {
 	struct timeval next_alarm; 
-	struct timeval *next;
-
-	/* initialization: get the next alarm available */
-	next = get_next_alarm_run(&next_alarm);
+	struct timeval *next = NULL;
 
 	while(1) {
-		__run(next);
-
 		sigprocmask(SIG_BLOCK, &STATE(block), NULL);
 		if (next != NULL && timerisset(next))
 			next = do_alarm_run(&next_alarm);
 		else
 			next = get_next_alarm_run(&next_alarm);
 		sigprocmask(SIG_UNBLOCK, &STATE(block), NULL);
+
+		__run(next);
 	}
 }


