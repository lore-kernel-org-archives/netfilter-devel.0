From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/2] conntrackd: fix compiler warnings
Date: Mon,  3 Jun 2013 11:18:24 +0200
Message-ID: <1370251105-12450-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:59029 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751100Ab3FCJQX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Jun 2013 05:16:23 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

main.c:359:6: warning: ignoring return value of 'nice' [..]
main.c:395:7: warning: ignoring return value of 'chdir' [..]
run.c:43:17: warning: declaration of 'signal' shadows a global declaration

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/main.c |   22 ++++++++++++++++++++--
 src/run.c  |    4 ++--
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/src/main.c b/src/main.c
index 831a3c2..dafeaee 100644
--- a/src/main.c
+++ b/src/main.c
@@ -23,6 +23,7 @@
 
 #include <sys/types.h>
 #include <sys/stat.h>
+#include <errno.h>
 #include <fcntl.h>
 #include <sys/utsname.h>
 #include <string.h>
@@ -112,6 +113,23 @@ set_action_by_table(int i, int argc, char *argv[],
 	return i;
 }
 
+static void
+set_nice_value(int nv)
+{
+	errno = 0;
+	if (nice(nv) == -1 && errno) /* warn only */
+		fprintf(stderr, "Cannot set nice level %d: %s\n",
+			nv, strerror(errno));
+}
+
+static void
+do_chdir(const char *d)
+{
+	if (chdir(d))
+		fprintf(stderr, "Cannot change current directory to %s: %s\n",
+			d, strerror(errno));
+}
+
 int main(int argc, char *argv[])
 {
 	int ret, i, action = -1;
@@ -356,7 +374,7 @@ int main(int argc, char *argv[])
 	/*
 	 * Setting process priority and scheduler
 	 */
-	nice(CONFIG(nice));
+	set_nice_value(CONFIG(nice));
 
 	if (CONFIG(sched).type != SCHED_OTHER) {
 		struct sched_param schedparam = {
@@ -382,7 +400,7 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	chdir("/");
+	do_chdir("/");
 	close(STDIN_FILENO);
 
 	/* Daemonize conntrackd */
diff --git a/src/run.c b/src/run.c
index 44a179f..7fa6889 100644
--- a/src/run.c
+++ b/src/run.c
@@ -40,14 +40,14 @@
 #include <time.h>
 #include <fcntl.h>
 
-void killer(int signal)
+void killer(int signo)
 {
 	/* Signals are re-entrant, disable signal handling to avoid problems
 	 * in case we receive SIGINT and SIGTERM in a row. This function is
 	 * also called via -k from the unix socket context, we already disabled
 	 * signals in that path, so don't do it.
 	 */
-	if (signal)
+	if (signo)
 		sigprocmask(SIG_BLOCK, &STATE(block), NULL);
 
 	local_server_destroy(&STATE(local));
-- 
1.7.8.6

