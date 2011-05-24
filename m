From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 20/24] libxt_NFQUEUE: avoid double attempt at parsing
Date: Wed, 25 May 2011 01:08:21 +0200
Message-ID: <1306278506-11463-21-git-send-email-jengelh@medozas.de>
References: <1306278506-11463-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:40993 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757382Ab1EXXIu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 19:08:50 -0400
In-Reply-To: <1306278506-11463-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fixes this error:

NFQUEUE: option "--queue-num" can only be used once.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_NFQUEUE.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/extensions/libxt_NFQUEUE.c b/extensions/libxt_NFQUEUE.c
index a86c88a..71ead8d 100644
--- a/extensions/libxt_NFQUEUE.c
+++ b/extensions/libxt_NFQUEUE.c
@@ -81,14 +81,11 @@ static void NFQUEUE_parse_v2(struct xt_option_call *cb)
 {
 	struct xt_NFQ_info_v2 *info = cb->data;
 
-	xtables_option_parse(cb);
+	NFQUEUE_parse_v1(cb);
 	switch (cb->entry->id) {
 	case O_QUEUE_BYPASS:
 		info->bypass = 1;
 		break;
-	default:
-		NFQUEUE_parse_v1(cb);
-		break;
 	}
 }
 
-- 
1.7.3.4

