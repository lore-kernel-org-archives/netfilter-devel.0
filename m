From: Eric Leblond <eric@inl.fr>
Subject: [libnetfilter_log patch] Fix minor memory leak.
Date: Sun, 30 Nov 2008 15:34:03 +0100
Message-ID: <1228055643-21565-1-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:57827 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751273AbYK3OeH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Nov 2008 09:34:07 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The nflog_handle is allocated in nflog_open(). This patch adds the missing
free in nlog_close().

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 src/libnetfilter_log.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/src/libnetfilter_log.c b/src/libnetfilter_log.c
index 6c0936e..216cdb8 100644
--- a/src/libnetfilter_log.c
+++ b/src/libnetfilter_log.c
@@ -237,7 +237,9 @@ int nflog_handle_packet(struct nflog_handle *h, char *buf, int len)
 
 int nflog_close(struct nflog_handle *h)
 {
-	return nfnl_close(h->nfnlh);
+	int ret = nfnl_close(h->nfnlh);
+	free(h);
+	return ret;
 }
 
 /* bind nf_queue from a specific protocol family */
-- 
1.5.6.3

