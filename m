From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/5] src: remove redundant cast near msg_name
Date: Fri, 31 Dec 2010 00:40:10 +0100
Message-ID: <1293752411-12923-6-git-send-email-jengelh@medozas.de>
References: <1293752411-12923-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:50228 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383Ab0L3XkU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Dec 2010 18:40:20 -0500
In-Reply-To: <1293752411-12923-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 src/libnfnetlink.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/src/libnfnetlink.c b/src/libnfnetlink.c
index fdd7d01..bf511f8 100644
--- a/src/libnfnetlink.c
+++ b/src/libnfnetlink.c
@@ -416,7 +416,7 @@ nfnl_sendiov(const struct nfnl_handle *nfnlh, const struct iovec *iov,
 
 	assert(nfnlh);
 
-	msg.msg_name = (struct sockaddr *) &nfnlh->peer;
+	msg.msg_name = &nfnlh->peer;
 	msg.msg_namelen = sizeof(nfnlh->peer);
 	msg.msg_iov = (struct iovec *) iov;
 	msg.msg_iovlen = num;
-- 
1.7.1

