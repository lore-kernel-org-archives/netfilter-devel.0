From: Eric Leblond <eric@inl.fr>
Subject: [libnetfilter_queue 3/4] Suppress double call of nfnl_subsys_close()
Date: Fri, 19 Dec 2008 22:36:30 +0100
Message-ID: <1229722591-7836-4-git-send-email-eric@inl.fr>
References: <1229722591-7836-1-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:57387 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751555AbYLSVgf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Dec 2008 16:36:35 -0500
In-Reply-To: <1229722591-7836-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nfnl_close() is calling nfnl_subsys_close() for all available
subsys. Thus it is not necessary to call it in the nfq_close()
function.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 src/libnetfilter_queue.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index e7fbfcc..f5611dd 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -252,7 +252,6 @@ int nfq_close(struct nfq_handle *h)
 {
 	int ret;
 	
-	nfnl_subsys_close(h->nfnlssh);
 	ret = nfnl_close(h->nfnlh);
 	if (ret == 0)
 		free(h);
-- 
1.5.6.3

