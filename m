From: Vincent Bernat <bernat@luffy.cx>
Subject: [PATCH] conntrackd: don't resync expectations if such sync has been disabled
Date: Thu,  2 Aug 2012 17:33:56 +0200
Message-ID: <1343921636-6527-1-git-send-email-bernat@luffy.cx>
Cc: Vincent Bernat <bernat@luffy.cx>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ftmxout01ba.infra.b2.fti.net ([193.252.121.124]:50576 "EHLO
	ftmxout01ba.infra.b2.fti.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752181Ab2HBP6N (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Aug 2012 11:58:13 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

conntrackd was segfaulting with `ExpectationSync` set to `Off`.

Signed-off-by: Vincent Bernat <bernat@luffy.cx>
---
 src/ctnl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/ctnl.c b/src/ctnl.c
index 107cd5d..154b612 100644
--- a/src/ctnl.c
+++ b/src/ctnl.c
@@ -164,7 +164,7 @@ static void do_polling_alarm(struct alarm_block *a, void *data)
 		STATE(mode)->internal->exp.purge();
 
 	nl_send_resync(STATE(resync));
-	nl_send_expect_resync(STATE(resync));
+	if (CONFIG(flags) & CTD_EXPECT) nl_send_expect_resync(STATE(resync));
 	add_alarm(&STATE(polling_alarm), CONFIG(poll_kernel_secs), 0);
 }
 
-- 
1.7.10.4

