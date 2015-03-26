From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH libnftnl] list: fix prefetch dummy
Date: Thu, 26 Mar 2015 12:51:48 +0000
Message-ID: <1427374308-20037-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58273 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbbCZMvv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Mar 2015 08:51:51 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

../include/linux_list.h:385:59: warning: right-hand operand of comma expression has no effect [-Wunused-value]
  for (pos = list_entry((head)->next, typeof(*pos), member), \
                                                           ^
set.c:266:2: note: in expansion of macro 'list_for_each_entry'
  list_for_each_entry(elem, &set->element_list, head) {

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/linux_list.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux_list.h b/include/linux_list.h
index de182a4..efffb91 100644
--- a/include/linux_list.h
+++ b/include/linux_list.h
@@ -29,7 +29,7 @@
 	1; \
 })
 
-#define prefetch(x)		1
+#define prefetch(x)		((void)0)
 
 /* empty define to make this work in userspace -HW */
 #ifndef smp_wmb
-- 
2.1.0

