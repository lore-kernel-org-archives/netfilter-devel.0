From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 2/4] qa: change an if to elseif
Date: Sun, 20 May 2012 00:08:10 +0200
Message-ID: <1337465292-28924-3-git-send-email-jengelh@inai.de>
References: <1337465292-28924-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:38045 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754804Ab2ESWIT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 May 2012 18:08:19 -0400
In-Reply-To: <1337465292-28924-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jan Engelhardt <jengelh@medozas.de>

The compiler is probably smart enough to see that the type cannot
change, but make an "else" out of it, just for fun.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 qa/ct_events_reliable.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/qa/ct_events_reliable.c b/qa/ct_events_reliable.c
index 1c8e194..b51d0e5 100644
--- a/qa/ct_events_reliable.c
+++ b/qa/ct_events_reliable.c
@@ -15,7 +15,7 @@ static int event_cb(enum nf_conntrack_msg_type type,
 {
 	if (type == NFCT_T_NEW)
 		new++;
-	if (type == NFCT_T_UPDATE)
+	else if (type == NFCT_T_UPDATE)
 		update++;
 	else if (type == NFCT_T_DESTROY)
 		destroy++;
-- 
1.7.7

