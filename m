From: Ansis Atteka <aatteka@nicira.com>
Subject: [PATCH] conntrackd: claim lockfile ownership properly
Date: Tue, 11 Mar 2014 18:31:13 -0700
Message-ID: <1394587873-9821-1-git-send-email-aatteka@nicira.com>
Cc: Ansis Atteka <aatteka@nicira.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:45238 "HELO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756347AbaCLBiQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Mar 2014 21:38:16 -0400
Received: by mail-qc0-f169.google.com with SMTP id i17so10635700qcy.28
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Mar 2014 18:38:15 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Before this patch, if conntrackd died in an abrupt manner (either
by SIGKILL, SIGSEGV or abrupt shutdown), then it would have left
a stale lock file that would have prevented any new conntrackd
instances from running.

Contrary to abrupt termination, this same bug was not present when
conntrackd was terminated with a graceful signal (e.g. SIGTERM).
This was because then the lock file would have been removed from
the signal handler as expected.

This patch fixes this bug by using POSIX File Locking API instead
of opening file in O_EXCL mode. File Locking API ensures that file
lock will be released once the process holding it terminates (either
gracefully or abruptly).

One side effect of this patch is that daemonization has to happen
before the lock file is locked (due to the fact that child processes
do not inherit file locks from the parent process).  This means that
some error messages have to be logged in log file instead of STDOUT.

Signed-Off-By: Ansis Atteka <aatteka@nicira.com>
---
 include/Makefile.am  |  2 +-
 include/conntrackd.h |  1 +
 include/lock_file.h  |  7 ++++++
 src/Makefile.am      |  2 +-
 src/lock_file.c      | 42 ++++++++++++++++++++++++++++++++++
 src/main.c           | 64 ++++++++++++++++++++++++++--------------------------
 src/run.c            |  4 +++-
 7 files changed, 87 insertions(+), 35 deletions(-)
 create mode 100644 include/lock_file.h
 create mode 100644 src/lock_file.c

diff --git a/include/Makefile.am b/include/Makefile.am
index 6bd0f7f..7e5680c 100644
--- a/include/Makefile.am
+++ b/include/Makefile.am
@@ -1,7 +1,7 @@
 SUBDIRS = linux
 
 noinst_HEADERS = alarm.h jhash.h cache.h linux_list.h linux_rbtree.h \
-		 sync.h conntrackd.h local.h udp.h tcp.h \
+		 sync.h conntrackd.h local.h lock_file.h udp.h tcp.h \
 		 debug.h log.h hash.h mcast.h conntrack.h \
 		 network.h filter.h queue.h vector.h cidr.h \
 		 traffic_stats.h netlink.h fds.h event.h bitops.h channel.h \
diff --git a/include/conntrackd.h b/include/conntrackd.h
index d338fc4..5c938ab 100644
--- a/include/conntrackd.h
+++ b/include/conntrackd.h
@@ -149,6 +149,7 @@ struct ct_general_state {
 	struct ct_mode 			*mode;
 	struct ct_filter		*us_filter;
 	struct exp_filter		*exp_filter;
+	int				lockfile_fd;
 
 	struct nfct_handle		*event;         /* event handler */
 	struct nfct_filter		*filter;	/* event filter */
diff --git a/include/lock_file.h b/include/lock_file.h
new file mode 100644
index 0000000..4a7038d
--- /dev/null
+++ b/include/lock_file.h
@@ -0,0 +1,7 @@
+#ifndef _LOCK_FILE_H_
+#define _LOCK_FILE_H_
+
+int lock_file_lock(const char *lock_file);
+void lock_file_unlock(const char *lock_file, int fd);
+
+#endif
diff --git a/src/Makefile.am b/src/Makefile.am
index 1bc3622..cb6110d 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -39,7 +39,7 @@ endif
 nfct_LDFLAGS = -export-dynamic
 
 conntrackd_SOURCES = alarm.c main.c run.c hash.c queue.c rbtree.c \
-		    local.c log.c mcast.c udp.c netlink.c vector.c \
+		    local.c lock_file.c log.c mcast.c udp.c netlink.c vector.c \
 		    filter.c fds.c event.c process.c origin.c date.c \
 		    cache.c cache-ct.c cache-exp.c \
 		    cache_timer.c \
diff --git a/src/lock_file.c b/src/lock_file.c
new file mode 100644
index 0000000..a15fa54
--- /dev/null
+++ b/src/lock_file.c
@@ -0,0 +1,42 @@
+#include "lock_file.h"
+
+#include <fcntl.h>
+#include <unistd.h>
+
+
+static int
+lock_bytes(int fd, int type, int whence, int start, int len)
+{
+	struct flock lock;
+
+	lock.l_type = type;
+	lock.l_whence = whence;
+	lock.l_start = start;
+	lock.l_len = len;
+
+	return fcntl(fd, F_SETLK, &lock);
+}
+
+int
+lock_file_lock(const char *lock_file)
+{
+	int fd;
+
+	fd = open(lock_file, O_CREAT | O_RDWR, S_IRUSR | S_IWUSR);
+	if (fd == -1)
+		return -1;
+
+	if (lock_bytes(fd, F_WRLCK, SEEK_SET, 0, 0)) {
+		close(fd);
+		return -1;
+	}
+
+	return fd;
+}
+
+void
+lock_file_unlock(const char *lock_file, int fd)
+{
+	close(fd);
+	unlink(lock_file);
+}
diff --git a/src/main.c b/src/main.c
index dafeaee..ed3fb8d 100644
--- a/src/main.c
+++ b/src/main.c
@@ -18,6 +18,7 @@
  */
 
 #include "conntrackd.h"
+#include "lock_file.h"
 #include "log.h"
 #include "helper.h"
 
@@ -118,16 +119,16 @@ set_nice_value(int nv)
 {
 	errno = 0;
 	if (nice(nv) == -1 && errno) /* warn only */
-		fprintf(stderr, "Cannot set nice level %d: %s\n",
-			nv, strerror(errno));
+		dlog(LOG_ERR, "Cannot set nice level %d: %s",
+		     nv, strerror(errno));
 }
 
 static void
 do_chdir(const char *d)
 {
 	if (chdir(d))
-		fprintf(stderr, "Cannot change current directory to %s: %s\n",
-			d, strerror(errno));
+		dlog(LOG_ERR, "Cannot change current directory to %s: %s",
+		     d, strerror(errno));
 }
 
 int main(int argc, char *argv[])
@@ -360,16 +361,34 @@ int main(int argc, char *argv[])
 	if (init_log() == -1)
 		exit(EXIT_FAILURE);
 
+	/* Daemonize conntrackd */
+	if (type == DAEMON) {
+		pid_t pid;
+
+		if ((pid = fork()) == -1) {
+			perror("fork has failed: ");
+			exit(EXIT_FAILURE);
+		} else if (pid)
+			exit(EXIT_SUCCESS);
+
+		setsid();
+
+		close(STDOUT_FILENO);
+		close(STDERR_FILENO);
+
+		dlog(LOG_NOTICE, "-- starting in daemon mode --");
+	} else
+		dlog(LOG_NOTICE, "-- starting in console mode --");
+
 	/*
-	 * lock file
+	 * After daemonizing, conntrackd has to grab its lock file
 	 */
-	ret = open(CONFIG(lockfile), O_CREAT | O_EXCL | O_TRUNC, 0600);
-	if (ret == -1) {
-		fprintf(stderr, "lockfile `%s' exists, perhaps conntrackd "
-			        "already running?\n", CONFIG(lockfile));
+	STATE(lockfile_fd) = lock_file_lock(CONFIG(lockfile));
+	if (STATE(lockfile_fd) == -1) {
+		dlog(LOG_ERR, "could not claim lockfile %s",
+		     CONFIG(lockfile));
 		exit(EXIT_FAILURE);
 	}
-	close(ret);
 
 	/*
 	 * Setting process priority and scheduler
@@ -383,7 +402,7 @@ int main(int argc, char *argv[])
 
 		ret = sched_setscheduler(0, CONFIG(sched).type, &schedparam);
 		if (ret == -1) {
-			perror("sched");
+			dlog(LOG_ERR, "sched: %s", strerror(errno));
 			exit(EXIT_FAILURE);
 		}
 	}
@@ -393,9 +412,9 @@ int main(int argc, char *argv[])
 	 */
 
 	if (init() == -1) {
+		dlog(LOG_ERR, "ERROR: conntrackd cannot start, please "
+			      "check the logfile for more info");
 		close_log();
-		fprintf(stderr, "ERROR: conntrackd cannot start, please "
-				"check the logfile for more info\n");
 		unlink(CONFIG(lockfile));
 		exit(EXIT_FAILURE);
 	}
@@ -403,25 +422,6 @@ int main(int argc, char *argv[])
 	do_chdir("/");
 	close(STDIN_FILENO);
 
-	/* Daemonize conntrackd */
-	if (type == DAEMON) {
-		pid_t pid;
-
-		if ((pid = fork()) == -1) {
-			perror("fork has failed: ");
-			exit(EXIT_FAILURE);
-		} else if (pid)
-			exit(EXIT_SUCCESS);
-
-		setsid();
-
-		close(STDOUT_FILENO);
-		close(STDERR_FILENO);
-
-		dlog(LOG_NOTICE, "-- starting in daemon mode --");
-	} else
-		dlog(LOG_NOTICE, "-- starting in console mode --");
-
 	/*
 	 * run main process
 	 */
diff --git a/src/run.c b/src/run.c
index a9d4862..02e847e 100644
--- a/src/run.c
+++ b/src/run.c
@@ -22,6 +22,7 @@
 #include "conntrackd.h"
 #include "netlink.h"
 #include "filter.h"
+#include "lock_file.h"
 #include "log.h"
 #include "alarm.h"
 #include "fds.h"
@@ -60,7 +61,8 @@ void killer(int signo)
 		cthelper_kill();
 #endif
 	destroy_fds(STATE(fds));
-	unlink(CONFIG(lockfile));
+	if (STATE(lockfile_fd) != -1)
+		lock_file_unlock(CONFIG(lockfile), STATE(lockfile_fd));
 	dlog(LOG_NOTICE, "---- shutdown received ----");
 	close_log();
 
-- 
1.8.1.2

