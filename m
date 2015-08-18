From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH conntrackd 4/8] conntrackd: fix descriptor leak in do_local_request()
Date: Tue, 18 Aug 2015 19:28:35 +0200
Message-ID: <1439918919-6937-5-git-send-email-pablo@netfilter.org>
References: <1439918919-6937-1-git-send-email-pablo@netfilter.org>
Cc: pwouters@redhat.com, fweimer@redhat.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37602 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624AbbHRRWg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Aug 2015 13:22:36 -0400
In-Reply-To: <1439918919-6937-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/local.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/src/local.c b/src/local.c
index 453799a..85e5180 100644
--- a/src/local.c
+++ b/src/local.c
@@ -147,11 +147,14 @@ int do_local_request(int request,
 
 	ret = send(fd, &request, sizeof(int), 0);
 	if (ret == -1)
-		return -1;
+		goto err1;
 
 	do_local_client_step(fd, step);
 
 	local_client_destroy(fd);
-	
+
 	return 0;
+err1:
+	local_client_destroy(fd);
+	return -1;
 }
-- 
1.7.10.4

