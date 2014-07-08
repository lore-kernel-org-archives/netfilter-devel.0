From: Yanchuan Nian <ycnian@gmail.com>
Subject: [nftables PATCH] Fix memory leak in batch operation
Date: Tue,  8 Jul 2014 09:01:07 +0800
Message-ID: <1404781267-17200-1-git-send-email-ycnian@gmail.com>
Cc: netfilter-devel@vger.kernel.org, Yanchuan Nian <ycnian@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:36856 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaGHA57 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jul 2014 20:57:59 -0400
Received: by mail-pd0-f172.google.com with SMTP id w10so6250327pde.31
        for <netfilter-devel@vger.kernel.org>; Mon, 07 Jul 2014 17:57:58 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The real buffers used by batch operation are forgotten to release.
Just release them. To test this patch, an other patch[1]
must be applied first. If not, the bug described in that patch
will be reproduced.

[1] [nftables PATCH] Fix segmentation fault in batch operation

Signed-off-by: Yanchuan Nian <ycnian@gmail.com>
---
 src/mnl.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/src/mnl.c b/src/mnl.c
index a816106..5e950db 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -219,6 +219,7 @@ static ssize_t mnl_nft_socket_sendmsg(const struct mnl_socket *nl)
 	};
 	struct batch_page *batch_page, *next;
 	int i = 0;
+	ssize_t ret = 0;
 
 	mnl_set_sndbuffer(nl);
 
@@ -240,7 +241,11 @@ static ssize_t mnl_nft_socket_sendmsg(const struct mnl_socket *nl)
 		batch_num_pages--;
 	}
 
-	return sendmsg(mnl_socket_get_fd(nl), &msg, 0);
+	ret = sendmsg(mnl_socket_get_fd(nl), &msg, 0);
+	for (i = 0; (size_t)i < msg.msg_iovlen; i++)
+		xfree(iov[i].iov_base);
+
+	return ret;
 }
 
 int mnl_batch_talk(struct mnl_socket *nl, struct list_head *err_list)
-- 
1.9.3

