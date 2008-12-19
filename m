From: Eric Leblond <eric@inl.fr>
Subject: [libnetfilter_queue 2/4] Use nfq_fd function instead of call to nfnetlink function.
Date: Fri, 19 Dec 2008 22:36:29 +0100
Message-ID: <1229722591-7836-3-git-send-email-eric@inl.fr>
References: <1229722591-7836-1-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:57382 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751391AbYLSVge (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Dec 2008 16:36:34 -0500
In-Reply-To: <1229722591-7836-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch modifies the example program to use nfq_fd function
instead of call to nfnetlink function.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 utils/nfqnl_test.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/utils/nfqnl_test.c b/utils/nfqnl_test.c
index 7e4edab..7cf27f0 100644
--- a/utils/nfqnl_test.c
+++ b/utils/nfqnl_test.c
@@ -95,8 +95,7 @@ int main(int argc, char **argv)
 		exit(1);
 	}
 
-	nh = nfq_nfnlh(h);
-	fd = nfnl_fd(nh);
+	fd = nfq_fd(h);
 
 	while ((rv = recv(fd, buf, sizeof(buf), 0)) && rv >= 0) {
 		printf("pkt received\n");
-- 
1.5.6.3

