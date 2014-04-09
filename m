From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH] utils: fix -Wcast-align warnings on sparc
Date: Wed,  9 Apr 2014 16:51:47 +0200
Message-ID: <1397055107-19594-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48398 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933057AbaDIOvz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2014 10:51:55 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The cast to char * in the container_of() marcro causes warnings for all
list iteration helpers on sparc:

warning: cast increases required alignment of target type [-Wcast-align]

Fix by using a void * for address calculations.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/utils.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/utils.h b/include/utils.h
index 854986f..88ee0c9 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -44,7 +44,7 @@
 
 #define container_of(ptr, type, member) ({			\
 	typeof( ((type *)0)->member ) *__mptr = (ptr);		\
-	(type *)( (char *)__mptr - offsetof(type,member) );})
+	(type *)( (void *)__mptr - offsetof(type,member) );})
 
 #define field_sizeof(t, f)	(sizeof(((t *)NULL)->f))
 #define array_size(arr)		(sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
-- 
1.9.0

