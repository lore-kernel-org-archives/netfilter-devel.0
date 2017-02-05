From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH iptables 2/2] xshared: using the blocking file lock request when we wait indefinitely
Date: Sun,  5 Feb 2017 21:57:35 +0800
Message-ID: <1486303055-11891-2-git-send-email-zlpnobody@163.com>
References: <1486303055-11891-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, subashab@codeaurora.org,
        Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-18.163.com ([220.181.12.18]:38784 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751101AbdBEN62 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Feb 2017 08:58:28 -0500
In-Reply-To: <1486303055-11891-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

When using "-w" to avoid concurrent instances, we try to do flock() every
one second until it success. But one second maybe too long in some
situations, and it's hard to select a suitable interval time.

So when using "iptables -w", use the F_SETLKW to obtain the file lock, it
will block until it success. And when using "iptables -w second", use the
F_SETLK, so we will not wait too long if the concurrency is very serious.

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
  real  0m2.081s
  user  0m0.163s
  sys   0m1.169s

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 iptables/xshared.c | 35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff --git a/iptables/xshared.c b/iptables/xshared.c
index 055acf2..e36c475 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -1,4 +1,5 @@
 #include <getopt.h>
+#include <errno.h>
 #include <libgen.h>
 #include <netdb.h>
 #include <stdbool.h>
@@ -249,36 +250,44 @@ void xs_init_match(struct xtables_match *match)
 bool xtables_lock(int wait, struct timeval *wait_interval)
 {
 	struct timeval time_left, wait_time;
+	struct flock lock = {
+		.l_type		= F_WRLCK,
+		.l_start	= 0,
+		.l_whence	= SEEK_SET,
+		.l_len		= 0,
+	};
 	int fd, i = 0;
 
 	time_left.tv_sec = wait;
 	time_left.tv_usec = 0;
 
-	fd = open(XT_LOCK_NAME, O_CREAT, 0600);
+	fd = open(XT_LOCK_NAME, O_RDWR | O_CREAT, 0600);
 	if (fd < 0)
 		return true;
 
+	if (wait == -1) {
+		if (fcntl(fd, F_SETLKW, &lock) == 0)
+			return true;
+
+		fprintf(stderr, "Can't lock %s: %s\n", XT_LOCK_NAME,
+			strerror(errno));
+		return false;
+	}
+
 	while (1) {
-		if (flock(fd, LOCK_EX | LOCK_NB) == 0)
+		if (fcntl(fd, F_SETLK, &lock) == 0)
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


