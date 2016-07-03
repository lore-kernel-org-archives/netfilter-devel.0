From: lists@inliniac.net
Subject: [PATCH libnetfilter_queue] src: check result of malloc when creating queue
Date: Sun,  3 Jul 2016 09:38:02 +0200
Message-ID: <1467531482-28941-1-git-send-email-lists@inliniac.net>
Cc: Victor Julien <victor@inliniac.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from static-27.netfusion.at ([83.215.238.27]:54890 "EHLO
	mail.inliniac.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbcGCHsm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Jul 2016 03:48:42 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Victor Julien <victor@inliniac.net>

Signed-off-by: Victor Julien <victor@inliniac.net>
---
 src/libnetfilter_queue.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index 5fbde5b..211a8ba 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -536,6 +536,8 @@ struct nfq_q_handle *nfq_create_queue(struct nfq_handle *h,
 		return NULL;
 
 	qh = malloc(sizeof(*qh));
+	if (!qh)
+		return NULL;
 
 	memset(qh, 0, sizeof(*qh));
 	qh->h = h;
-- 
2.7.4

