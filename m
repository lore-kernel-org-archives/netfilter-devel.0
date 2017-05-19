From: Lorenzo Colitti <lorenzo@google.com>
Subject: [PATCH] iptables: insist that the lock is held.
Date: Fri, 19 May 2017 16:08:59 +0900
Message-ID: <20170519070859.75808-1-lorenzo@google.com>
Cc: pablo@netfilter.org, jscherpelz@google.com,
        subashab@codeaurora.org, dcbw@redhat.com, aconole@bytheb.org,
        Lorenzo Colitti <lorenzo@google.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:35488 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751225AbdESHJM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 May 2017 03:09:12 -0400
Received: by mail-pg0-f51.google.com with SMTP id q125so34091124pgq.2
        for <netfilter-devel@vger.kernel.org>; Fri, 19 May 2017 00:09:12 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently, iptables programs will exit with an error if the
iptables lock cannot be acquired, but will silently continue if
the lock cannot be opened at all. This can cause unexpected
failures (with unhelpful error messages) in the presence of
concurrent updates, which can be very difficult to find in a
complex or multi-administrator system.

Instead, refuse to do anything if the lock cannot be acquired.
The behaviour is not affected by command-line flags because:

1. In order to reliably avoid concurrent modification, all
   invocations of iptables commands must follow this behaviour.
2. Whether or not the lock can be opened is typically not
   a run-time condition but is likely to be a configuration
   error.

Existing systems that depended on things working mostly correctly
even if there was no lock might be affected by this change.
However, that is arguably a configuration error, and now that the
iptables lock is configurable, it is trivial to provide a lock
file that is always accessible: if nothing else, the iptables
binary itself can be used. The lock does not have to be writable,
only readable.

Tested by configuring the system to use an xtables.lock file in
a non-existent directory and observing that all commands failed.

Signed-off-by: Lorenzo Colitti <lorenzo@google.com>
---
 iptables/ip6tables-restore.c |  7 +------
 iptables/ip6tables.c         | 11 ++---------
 iptables/iptables-restore.c  |  7 +------
 iptables/iptables.c          | 11 ++---------
 iptables/xshared.c           | 31 ++++++++++++++++++++++++++++---
 iptables/xshared.h           |  7 +++----
 6 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/iptables/ip6tables-restore.c b/iptables/ip6tables-restore.c
index 39a881dfce..1e50bf0db2 100644
--- a/iptables/ip6tables-restore.c
+++ b/iptables/ip6tables-restore.c
@@ -301,12 +301,7 @@ int ip6tables_restore_main(int argc, char *argv[])
 			in_table = 0;
 		} else if ((buffer[0] == '*') && (!in_table)) {
 			/* Acquire a lock before we create a new table handle */
-			lock = xtables_lock(wait, &wait_interval);
-			if (lock == XT_LOCK_BUSY) {
-				fprintf(stderr, "Another app is currently holding the xtables lock. "
-					"Perhaps you want to use the -w option?\n");
-				exit(RESOURCE_PROBLEM);
-			}
+			lock = xtables_lock_or_exit(wait, &wait_interval);
 
 			/* New table */
 			char *table;
diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 579d347b09..49bd006fb2 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -1779,15 +1779,8 @@ int do_command6(int argc, char *argv[], char **table,
 	generic_opt_check(command, cs.options);
 
 	/* Attempt to acquire the xtables lock */
-	if (!restore && xtables_lock(wait, &wait_interval) == XT_LOCK_BUSY) {
-		fprintf(stderr, "Another app is currently holding the xtables lock. ");
-		if (wait == 0)
-			fprintf(stderr, "Perhaps you want to use the -w option?\n");
-		else
-			fprintf(stderr, "Stopped waiting after %ds.\n", wait);
-		xtables_free_opts(1);
-		exit(RESOURCE_PROBLEM);
-	}
+	if (!restore)
+		xtables_lock_or_exit(wait, &wait_interval);
 
 	/* only allocate handle if we weren't called with a handle */
 	if (!*handle)
diff --git a/iptables/iptables-restore.c b/iptables/iptables-restore.c
index 876fe06d7f..d79fe328cc 100644
--- a/iptables/iptables-restore.c
+++ b/iptables/iptables-restore.c
@@ -299,12 +299,7 @@ iptables_restore_main(int argc, char *argv[])
 			in_table = 0;
 		} else if ((buffer[0] == '*') && (!in_table)) {
 			/* Acquire a lock before we create a new table handle */
-			lock = xtables_lock(wait, &wait_interval);
-			if (lock == XT_LOCK_BUSY) {
-				fprintf(stderr, "Another app is currently holding the xtables lock. "
-					"Perhaps you want to use the -w option?\n");
-				exit(RESOURCE_PROBLEM);
-			}
+			lock = xtables_lock_or_exit(wait, &wait_interval);
 
 			/* New table */
 			char *table;
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 97cbda91cf..69d19feca1 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -1765,15 +1765,8 @@ int do_command4(int argc, char *argv[], char **table,
 	generic_opt_check(command, cs.options);
 
 	/* Attempt to acquire the xtables lock */
-	if (!restore && xtables_lock(wait, &wait_interval) == XT_LOCK_BUSY) {
-		fprintf(stderr, "Another app is currently holding the xtables lock. ");
-		if (wait == 0)
-			fprintf(stderr, "Perhaps you want to use the -w option?\n");
-		else
-			fprintf(stderr, "Stopped waiting after %ds.\n", wait);
-		xtables_free_opts(1);
-		exit(RESOURCE_PROBLEM);
-	}
+	if (!restore)
+		xtables_lock_or_exit(wait, &wait_interval);
 
 	/* only allocate handle if we weren't called with a handle */
 	if (!*handle)
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 3fbe3b1a99..825479c338 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -246,7 +246,7 @@ void xs_init_match(struct xtables_match *match)
 		match->init(match->m);
 }
 
-int xtables_lock(int wait, struct timeval *wait_interval)
+static int xtables_lock(int wait, struct timeval *wait_interval)
 {
 	struct timeval time_left, wait_time;
 	int fd, i = 0;
@@ -255,8 +255,11 @@ int xtables_lock(int wait, struct timeval *wait_interval)
 	time_left.tv_usec = 0;
 
 	fd = open(XT_LOCK_NAME, O_CREAT, 0600);
-	if (fd < 0)
-		return XT_LOCK_UNSUPPORTED;
+	if (fd < 0) {
+		fprintf(stderr, "Fatal: can't open lock file %s: %s\n",
+			XT_LOCK_NAME, strerror(errno));
+		return XT_LOCK_FAILED;
+	}
 
 	if (wait == -1) {
 		if (flock(fd, LOCK_EX) == 0)
@@ -291,6 +294,28 @@ void xtables_unlock(int lock)
 		close(lock);
 }
 
+int xtables_lock_or_exit(int wait, struct timeval *wait_interval)
+{
+	int lock = xtables_lock(wait, wait_interval);
+
+	if (lock == XT_LOCK_FAILED) {
+		xtables_free_opts(1);
+		exit(RESOURCE_PROBLEM);
+	}
+
+	if (lock == XT_LOCK_BUSY) {
+		fprintf(stderr, "Another app is currently holding the xtables lock. ");
+		if (wait == 0)
+			fprintf(stderr, "Perhaps you want to use the -w option?\n");
+		else
+			fprintf(stderr, "Stopped waiting after %ds.\n", wait);
+		xtables_free_opts(1);
+		exit(RESOURCE_PROBLEM);
+	}
+
+	return lock;
+}
+
 int parse_wait_time(int argc, char *argv[])
 {
 	int wait = -1;
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 539e6c243b..7e6d085931 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -92,8 +92,7 @@ extern void xs_init_match(struct xtables_match *);
  *
  * A value >= 0 indicates the lock filedescriptor. Other values are:
  *
- * XT_LOCK_UNSUPPORTED : The system does not support locking, execution will
- * proceed lockless.
+ * XT_LOCK_FAILED : The lock could not be acquired.
  *
  * XT_LOCK_BUSY : The lock was held by another process. xtables_lock only
  * returns this value when |wait| == false. If |wait| == true, xtables_lock
@@ -103,11 +102,11 @@ extern void xs_init_match(struct xtables_match *);
  */
 enum {
 	XT_LOCK_BUSY = -1,
-	XT_LOCK_UNSUPPORTED  = -2,
+	XT_LOCK_FAILED = -2,
 	XT_LOCK_NOT_ACQUIRED  = -3,
 };
-extern int xtables_lock(int wait, struct timeval *tv);
 extern void xtables_unlock(int lock);
+extern int xtables_lock_or_exit(int wait, struct timeval *tv);
 
 int parse_wait_time(int argc, char *argv[]);
 void parse_wait_interval(int argc, char *argv[], struct timeval *wait_interval);
-- 
2.13.0.303.g4ebf302169-goog

