From: Max Kellermann <max@duempel.org>
Subject: [PATCH 3/4] __run() returns void
Date: Mon, 21 Jan 2008 09:29:58 +0100
Message-ID: <20080121082958.27612.59754.stgit@rabbit.intern.cm-ag>
References: <20080121082752.27612.82519.stgit@rabbit.intern.cm-ag>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from duempel.org ([78.31.71.42]:43866 "HELO duempel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758944AbYAUMFd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jan 2008 07:05:33 -0500
In-Reply-To: <20080121082752.27612.82519.stgit@rabbit.intern.cm-ag>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


---

 src/run.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)


diff --git a/src/run.c b/src/run.c
index 2d51ca1..b24cd9b 100644
--- a/src/run.c
+++ b/src/run.c
@@ -158,7 +158,7 @@ init(void)
 	return 0;
 }
 
-static int __run(struct timeval *next_alarm)
+static void __run(struct timeval *next_alarm)
 {
 	int max, ret;
 	fd_set readfds;
@@ -176,11 +176,11 @@ static int __run(struct timeval *next_alarm)
 	if (ret == -1) {
 		/* interrupted syscall, retry */
 		if (errno == EINTR)
-			return 0;
+			return;
 
 		dlog(LOG_WARNING, 
 		     "select failed: %s", strerror(errno));
-		return 0;
+		return;
 	}
 
 	/* signals are racy */
@@ -227,8 +227,6 @@ static int __run(struct timeval *next_alarm)
 		STATE(mode)->run(&readfds);
 
 	sigprocmask(SIG_UNBLOCK, &STATE(block), NULL);
-
-	return 0;
 }
 
 void __attribute__((noreturn))


