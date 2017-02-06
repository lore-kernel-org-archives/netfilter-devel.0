From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH iptables V2 2/2] xshared: using the blocking file lock request when we wait indefinitely
Date: Mon,  6 Feb 2017 19:47:47 +0800
Message-ID: <1486381667-32577-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-15.163.com ([220.181.12.15]:44606 "EHLO m12-15.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751775AbdBFLsc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Feb 2017 06:48:32 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

When using "-w" to avoid concurrent instances, we try to do flock() every
one second until it success. But one second maybe too long in some
situations, and it's hard to select a suitable interval time. So when
using "iptables -w" to wait indefinitely, it's better to block until
it become success.

Now do some performance tests. First, flush all the iptables rules in
filter table, and run "iptables -w -S" endlessly:
  # iptables -F
  # iptables -X
  # while : ; do
  iptables -w -S >&- &
  done

Second, after adding and deleting the iptables rules 100 times, measure
the time cost:
  # time for i in $(seq 100); do
  iptables -w -A INPUT
  iptables -w -D INPUT
  done

Before this patch:
  real  1m15.962s
  user  0m0.224s
  sys   0m1.475s

Apply this patch:
  real  0m1.830s
  user  0m0.168s
  sys   0m1.130s

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 V2: use flock() instead of fcntl(). It is more clean.
 (This patch is based on http://patchwork.ozlabs.org/patch/724242/)

 iptables/xshared.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/iptables/xshared.c b/iptables/xshared.c
index 055acf2..f0a5ddd 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -1,4 +1,5 @@
 #include <getopt.h>
+#include <errno.h>
 #include <libgen.h>
 #include <netdb.h>
 #include <stdbool.h>
@@ -258,27 +259,29 @@ bool xtables_lock(int wait, struct timeval *wait_interval)
 	if (fd < 0)
 		return true;
 
+	if (wait == -1) {
+		if (flock(fd, LOCK_EX) == 0)
+			return true;
+
+		fprintf(stderr, "Can't lock %s: %s\n", XT_LOCK_NAME,
+			strerror(errno));
+		return false;
+	}
+
 	while (1) {
 		if (flock(fd, LOCK_EX | LOCK_NB) == 0)
 			return true;
-		else if (wait >= 0 && timercmp(&time_left, wait_interval, <))
+		else if (timercmp(&time_left, wait_interval, <))
 			return false;
 
 		if (++i % 10 == 0) {
-			if (wait != -1)
-				fprintf(stderr, "Another app is currently holding the xtables lock; "
-					"still %lds %ldus time ahead to have a chance to grab the lock...\n",
-					time_left.tv_sec, time_left.tv_usec);
-			else
-				fprintf(stderr, "Another app is currently holding the xtables lock; "
-						"waiting for it to exit...\n");
+			fprintf(stderr, "Another app is currently holding the xtables lock; "
+				"still %lds %ldus time ahead to have a chance to grab the lock...\n",
+				time_left.tv_sec, time_left.tv_usec);
 		}
 
 		wait_time = *wait_interval;
 		select(0, NULL, NULL, NULL, &wait_time);
-		if (wait == -1)
-			continue;
-
 		timersub(&time_left, wait_interval, &time_left);
 	}
 }
-- 
2.5.5


