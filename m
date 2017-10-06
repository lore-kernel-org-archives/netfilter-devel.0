From: Phil Sutter <phil@nwl.cc>
Subject: [ebtables PATCH] Use flock() for --concurrent option
Date: Fri,  6 Oct 2017 12:48:50 +0200
Message-ID: <20171006104850.20933-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:57014 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751807AbdJFKtC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Oct 2017 06:49:02 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The previous locking mechanism was not atomic, hence it was possible
that a killed ebtables process would leave the lock file in place which
in turn made future ebtables processes wait indefinitely for the lock to
become free.

Fix this by using flock(). This also simplifies code quite a bit because
there is no need for a custom signal handler or an __exit routine
anymore.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 ebtables.c |  8 --------
 libebtc.c  | 49 +++++--------------------------------------------
 2 files changed, 5 insertions(+), 52 deletions(-)

diff --git a/ebtables.c b/ebtables.c
index 62f1ba80063d8..f7dfccf4b2f31 100644
--- a/ebtables.c
+++ b/ebtables.c
@@ -528,12 +528,6 @@ void ebt_early_init_once()
 	ebt_iterate_targets(merge_target);
 }
 
-/* signal handler, installed when the option --concurrent is specified. */
-static void sighandler(int signum)
-{
-	exit(-1);
-}
-
 /* We use exec_style instead of #ifdef's because ebtables.so is a shared object. */
 int do_command(int argc, char *argv[], int exec_style,
                struct ebt_u_replace *replace_)
@@ -1047,8 +1041,6 @@ big_iface_length:
 			strcpy(replace->filename, optarg);
 			break;
 		case 13 : /* concurrent */
-			signal(SIGINT, sighandler);
-			signal(SIGTERM, sighandler);
 			use_lockfd = 1;
 			break;
 		case 1 :
diff --git a/libebtc.c b/libebtc.c
index 74830ecf2e91b..c0ff8ccfa66db 100644
--- a/libebtc.c
+++ b/libebtc.c
@@ -31,6 +31,7 @@
 #include "include/ethernetdb.h"
 #include <unistd.h>
 #include <fcntl.h>
+#include <sys/file.h>
 #include <sys/wait.h>
 #include <sys/stat.h>
 #include <sys/types.h>
@@ -137,58 +138,18 @@ void ebt_list_extensions()
 #define LOCKDIR "/var/lib/ebtables"
 #define LOCKFILE LOCKDIR"/lock"
 #endif
-static int lockfd = -1, locked;
 int use_lockfd;
 /* Returns 0 on success, -1 when the file is locked by another process
  * or -2 on any other error. */
 static int lock_file()
 {
-	int try = 0;
-	int ret = 0;
-	sigset_t sigset;
-
-tryagain:
-	/* the SIGINT handler will call unlock_file. To make sure the state
-	 * of the variable locked is correct, we need to temporarily mask the
-	 * SIGINT interrupt. */
-	sigemptyset(&sigset);
-	sigaddset(&sigset, SIGINT);
-	sigprocmask(SIG_BLOCK, &sigset, NULL);
-	lockfd = open(LOCKFILE, O_CREAT | O_EXCL | O_WRONLY, 00600);
-	if (lockfd < 0) {
-		if (errno == EEXIST)
-			ret = -1;
-		else if (try == 1)
-			ret = -2;
-		else {
-			if (mkdir(LOCKDIR, 00700))
-				ret = -2;
-			else {
-				try = 1;
-				goto tryagain;
-			}
-		}
-	} else {
-		close(lockfd);
-		locked = 1;
-	}
-	sigprocmask(SIG_UNBLOCK, &sigset, NULL);
-	return ret;
-}
+	int fd = open(LOCKFILE, O_CREAT, 00600);
 
-void unlock_file()
-{
-	if (locked) {
-		remove(LOCKFILE);
-		locked = 0;
-	}
+	if (fd < 0)
+		return -2;
+	return flock(fd, LOCK_EX);
 }
 
-void __attribute__ ((destructor)) onexit()
-{
-	if (use_lockfd)
-		unlock_file();
-}
 /* Get the table from the kernel or from a binary file
  * init: 1 = ask the kernel for the initial contents of a table, i.e. the
  *           way it looks when the table is insmod'ed
-- 
2.13.1

