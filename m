From: Eric Leblond <eric@regit.org>
Subject: [nftables 3/3] mnl: improve select timeout logic
Date: Wed, 24 Jun 2015 09:51:51 +0200
Message-ID: <1435132311-31452-4-git-send-email-eric@regit.org>
References: <1435132311-31452-1-git-send-email-eric@regit.org>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:47466 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbbFXHw0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Jun 2015 03:52:26 -0400
In-Reply-To: <1435132311-31452-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch explicitely set timeout for select in mnl_batch_talk.
Timeout used at the second call was the time spend on first select
and this was not looking correct. Instead this patch set a short
timeout as we are supposed to dequeue waiting kernel messages.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/mnl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/mnl.c b/src/mnl.c
index 76a9714..2da1074 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -246,7 +246,7 @@ int mnl_batch_talk(struct mnl_socket *nl, struct list_head *err_list)
 	char rcv_buf[MNL_SOCKET_BUFFER_SIZE];
 	fd_set readfds;
 	struct timeval tv = {
-		.tv_sec		= 0,
+		.tv_sec		= 10,
 		.tv_usec	= 0
 	};
 
@@ -274,6 +274,8 @@ int mnl_batch_talk(struct mnl_socket *nl, struct list_head *err_list)
 		if (ret == -1)
 			mnl_err_list_node_add(err_list, errno, nlh->nlmsg_seq);
 
+		tv.tv_sec = 0;
+		tv.tv_usec = 1000;
 		ret = select(fd+1, &readfds, NULL, NULL, &tv);
 		if (ret == -1)
 			return -1;
-- 
2.1.4

