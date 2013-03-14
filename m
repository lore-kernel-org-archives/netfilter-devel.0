From: Eric Leblond <eric@regit.org>
Subject: [libmnl PATCH] doxygen: fix a variable name.
Date: Thu, 14 Mar 2013 12:05:27 +0100
Message-ID: <1363259128-9134-1-git-send-email-eric@regit.org>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:58507 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756200Ab3CNLGQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Mar 2013 07:06:16 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Variable name in doxygen description was not correct.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/nlmsg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/nlmsg.c b/src/nlmsg.c
index 000829e..fdb7af8 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -222,7 +222,7 @@ EXPORT_SYMBOL(mnl_nlmsg_seq_ok);
 /**
  * mnl_nlmsg_portid_ok - perform portID origin check
  * \param nlh current netlink message that we are handling
- * \param seq netlink portid that we want to check
+ * \param portid netlink portid that we want to check
  *
  * This functions returns true if the origin is fulfilled, otherwise
  * false is returned. We skip the tracking for netlink message whose portID
-- 
1.7.10.4

