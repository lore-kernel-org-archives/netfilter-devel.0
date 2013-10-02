From: Eric Leblond <eric@regit.org>
Subject: [nftables PATCH 1/4] mnl: fix typo in comment
Date: Thu,  3 Oct 2013 01:08:05 +0200
Message-ID: <1380755288-17587-2-git-send-email-eric@regit.org>
References: <1380755288-17587-1-git-send-email-eric@regit.org>
Cc: eric@regit.org, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:50354 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab3JBXIh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Oct 2013 19:08:37 -0400
In-Reply-To: <1380755288-17587-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/mnl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/mnl.c b/src/mnl.c
index bec4218..27b181a 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -249,7 +249,7 @@ int mnl_batch_talk(struct mnl_socket *nl, struct list_head *err_list)
 			goto err;
 
 		ret = mnl_cb_run(rcv_buf, ret, 0, portid, NULL, NULL);
-		/* Continue on error, make sure we get all acknoledgments */
+		/* Continue on error, make sure we get all acknowledgments */
 		if (ret == -1)
 			mnl_err_list_node_add(err_list, errno, nlh->nlmsg_seq);
 
-- 
1.8.4.rc3

