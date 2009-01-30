From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 2/2] netfilter: fix nflog timeout handling
Date: Fri, 30 Jan 2009 23:31:48 +0100
Message-ID: <1233354708-22009-4-git-send-email-eric@inl.fr>
References: <1233354708-22009-1-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:51956 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754130AbZA3Wbw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Jan 2009 17:31:52 -0500
In-Reply-To: <1233354708-22009-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

NFLOG timeout was computed in timer by doing:
 flushtimeout*HZ/100
Default value of flushtimeout was HZ (for 1 second delay). This was
wrong for non 100HZ computer.

This patch modifies the delay computation by using:
 flushtimeout*HZ/1000
delay and set default value of flushtimeout to 1000 (as 1/100 sec is not
a common unit).

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 net/netfilter/nfnetlink_log.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 88b455e..b5086fa 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -39,7 +39,7 @@
 #endif
 
 #define NFULNL_NLBUFSIZ_DEFAULT	NLMSG_GOODSIZE
-#define NFULNL_TIMEOUT_DEFAULT 	HZ	/* every second */
+#define NFULNL_TIMEOUT_DEFAULT 	1000	/* every second */
 #define NFULNL_QTHRESH_DEFAULT 	100	/* 100 packets */
 #define NFULNL_COPY_RANGE_MAX	0xFFFF	/* max packet size is limited by 16-bit struct nfattr nfa_len field */
 
@@ -639,7 +639,7 @@ nfulnl_log_packet(u_int8_t pf,
 	 * is no chance of a race here */
 	else if (!timer_pending(&inst->timer)) {
 		instance_get(inst);
-		inst->timer.expires = jiffies + (inst->flushtimeout*HZ/100);
+		inst->timer.expires = jiffies + (inst->flushtimeout*HZ/1000);
 		add_timer(&inst->timer);
 	}
 
-- 
1.6.1

