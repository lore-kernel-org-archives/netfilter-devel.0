From: Eric Leblond <eric@inl.fr>
Subject: [libnetfilter_queue 1/4] Change variable name to have an homogeneous naming
Date: Fri, 19 Dec 2008 22:36:28 +0100
Message-ID: <1229722591-7836-2-git-send-email-eric@inl.fr>
References: <1229722591-7836-1-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:57385 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751359AbYLSVge (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Dec 2008 16:36:34 -0500
In-Reply-To: <1229722591-7836-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch modifies a function to have through the file. Data length
variable was named data_len everywhere but in this function.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 src/libnetfilter_queue.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index 5db6fd1..e7fbfcc 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -529,9 +529,9 @@ int nfq_set_verdict(struct nfq_q_handle *qh, u_int32_t id,
  */
 int nfq_set_verdict_mark(struct nfq_q_handle *qh, u_int32_t id,
 		u_int32_t verdict, u_int32_t mark,
-		u_int32_t datalen, unsigned char *buf)
+		u_int32_t data_len, unsigned char *buf)
 {
-	return __set_verdict(qh, id, verdict, mark, 1, datalen, buf);
+	return __set_verdict(qh, id, verdict, mark, 1, data_len, buf);
 }
 
 /*************************************************************
-- 
1.5.6.3

