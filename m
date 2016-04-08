From: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: [PATCH iptables] xtables: use exponential delay when waiting for xtables lock
Date: Thu,  7 Apr 2016 21:07:25 -0600
Message-ID: <1460084845-28057-1-git-send-email-subashab@codeaurora.org>
Cc: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57792 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbcDHDIQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Apr 2016 23:08:16 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ip[6]tables currently waits for 1 second for the xtables lock to
be freed if the -w option is used. We have seen that the lock is
held much less than that resulting in unnecessary delay when
trying to acquire the lock. This problem is even severe in case
of latency sensitive applications.

Introduce an exponential delay starting from 10ms (experimentally
determined) up to a second.

Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
---
 iptables/xshared.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/iptables/xshared.c b/iptables/xshared.c
index 81c2581..d90ac13 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -247,6 +247,7 @@ void xs_init_match(struct xtables_match *match)
 bool xtables_lock(int wait)
 {
 	int fd, waited = 0, i = 0;
+	useconds_t base_delay = 10000;
 
 	fd = open(XT_LOCK_NAME, O_CREAT, 0600);
 	if (fd < 0)
@@ -257,10 +258,15 @@ bool xtables_lock(int wait)
 			return true;
 		else if (wait >= 0 && waited >= wait)
 			return false;
-		if (++i % 2 == 0)
+		if ((++i % 2 == 0) && (base_delay >= 200000))
 			fprintf(stderr, "Another app is currently holding the xtables lock; "
 				"waiting (%ds) for it to exit...\n", waited);
 		waited++;
-		sleep(1);
+		if (base_delay > 1000000) {
+			sleep(1);
+		} else {
+			usleep(base_delay);
+			base_delay *= 2;
+		}
 	}
 }
-- 
1.8.2.1

