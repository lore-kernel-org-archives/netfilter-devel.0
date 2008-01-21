From: Max Kellermann <max@duempel.org>
Subject: [PATCH 2/4] don't ignore fd events when an alarm is due
Date: Mon, 21 Jan 2008 09:29:58 +0100
Message-ID: <20080121082958.27612.37473.stgit@rabbit.intern.cm-ag>
References: <20080121082752.27612.82519.stgit@rabbit.intern.cm-ag>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from duempel.org ([78.31.71.42]:36435 "HELO duempel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759089AbYAUMEd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jan 2008 07:04:33 -0500
In-Reply-To: <20080121082752.27612.82519.stgit@rabbit.intern.cm-ag>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

also, pass &next_alarm to __run() only if there is an alarm; eliminate
the "timeout" parameter; the alarm functions get_next_alarm_run() and
do_alarm_run() return an timeval pointer instead of a boolean.
---

 include/alarm.h |    6 ++++--
 src/alarm.c     |   12 +++++++-----
 src/run.c       |   38 ++++++++++++--------------------------
 3 files changed, 23 insertions(+), 33 deletions(-)


diff --git a/include/alarm.h b/include/alarm.h
index f0bbb95..3569025 100644
--- a/include/alarm.h
+++ b/include/alarm.h
@@ -26,8 +26,10 @@ void add_alarm(struct alarm_list *alarm, unsigned long sc, unsigned long usc);
 
 void del_alarm(struct alarm_list *alarm);
 
-int get_next_alarm_run(struct timeval *next_alarm);
+struct timeval *
+get_next_alarm_run(struct timeval *next_alarm);
 
-int do_alarm_run(struct timeval *next_alarm);
+struct timeval *
+do_alarm_run(struct timeval *next_alarm);
 
 #endif
diff --git a/src/alarm.c b/src/alarm.c
index 2190bb6..883a42c 100644
--- a/src/alarm.c
+++ b/src/alarm.c
@@ -74,7 +74,7 @@ void del_alarm(struct alarm_list *alarm)
 	}
 }
 
-static int 
+static struct timeval *
 calculate_next_run(struct timeval *cand,
 		   struct timeval *tv, 
 		   struct timeval *next_run)
@@ -87,12 +87,13 @@ calculate_next_run(struct timeval *cand,
 			next_run->tv_sec = 0;
 			next_run->tv_usec = 0;
 		}
-		return 1;
+		return next_run;
 	}
-	return 0;
+	return NULL;
 }
 
-int get_next_alarm_run(struct timeval *next_run)
+struct timeval *
+get_next_alarm_run(struct timeval *next_run)
 {
 	int i;
 	struct alarm_list *t;
@@ -133,7 +134,8 @@ tv_compare(struct alarm_list *a, struct timeval *cur, struct timeval *cand)
 	return 0;
 }
 
-int do_alarm_run(struct timeval *next_run)
+struct timeval *
+do_alarm_run(struct timeval *next_run)
 {
 	int i;
 	struct alarm_list *t, *next, *prev;
diff --git a/src/run.c b/src/run.c
index efeda5a..2d51ca1 100644
--- a/src/run.c
+++ b/src/run.c
@@ -158,15 +158,10 @@ init(void)
 	return 0;
 }
 
-static int __run(struct timeval *next_alarm, int *timeout)
+static int __run(struct timeval *next_alarm)
 {
 	int max, ret;
 	fd_set readfds;
-	struct timeval *tmp = next_alarm;
-
-	/* No alarms, select must block */
-	if (*timeout == 0)
-		tmp = NULL;
 
 	FD_ZERO(&readfds);
 	FD_SET(STATE(local), &readfds);
@@ -177,7 +172,7 @@ static int __run(struct timeval *next_alarm, int *timeout)
 	if (STATE(mode)->add_fds_to_set)
 		max = MAX(max, STATE(mode)->add_fds_to_set(&readfds));
 
-	ret = select(max+1, &readfds, NULL, NULL, tmp);
+	ret = select(max+1, &readfds, NULL, NULL, next_alarm);
 	if (ret == -1) {
 		/* interrupted syscall, retry */
 		if (errno == EINTR)
@@ -188,10 +183,6 @@ static int __run(struct timeval *next_alarm, int *timeout)
 		return 0;
 	}
 
-	/* timeout expired, run the alarm list */
-	if (tmp != NULL && !timerisset(tmp))
-		return 1;
-
 	/* signals are racy */
 	sigprocmask(SIG_BLOCK, &STATE(block), NULL);		
 
@@ -235,14 +226,6 @@ static int __run(struct timeval *next_alarm, int *timeout)
 	if (STATE(mode)->run)
 		STATE(mode)->run(&readfds);
 
-	/* check if we have introduced any new alarms */
-	if (*timeout == 0 && alarm_counter > 0) {
-		*timeout = 1;
-		if (!get_next_alarm_run(next_alarm))
-			dlog(LOG_ERR, "Bug in alarm?");
-		return 0;
-	}
-
 	sigprocmask(SIG_UNBLOCK, &STATE(block), NULL);
 
 	return 0;
@@ -251,17 +234,20 @@ static int __run(struct timeval *next_alarm, int *timeout)
 void __attribute__((noreturn))
 run(void)
 {
-	int timeout;
 	struct timeval next_alarm; 
+	struct timeval *next;
 
 	/* initialization: get the next alarm available */
-	timeout = get_next_alarm_run(&next_alarm);
+	next = get_next_alarm_run(&next_alarm);
 
 	while(1) {
-		if (__run(&next_alarm, &timeout)) {
-			sigprocmask(SIG_BLOCK, &STATE(block), NULL);
-			timeout = do_alarm_run(&next_alarm);
-			sigprocmask(SIG_UNBLOCK, &STATE(block), NULL);
-		}
+		__run(next);
+
+		sigprocmask(SIG_BLOCK, &STATE(block), NULL);
+		if (next != NULL && timerisset(next))
+			next = do_alarm_run(&next_alarm);
+		else
+			next = get_next_alarm_run(&next_alarm);
+		sigprocmask(SIG_UNBLOCK, &STATE(block), NULL);
 	}
 }


