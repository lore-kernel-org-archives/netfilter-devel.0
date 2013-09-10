From: Gustavo Zacarias <gustavo@zacarias.com.ar>
Subject: [libmnl PATCH] configure: uclinux is also linux
Date: Tue, 10 Sep 2013 16:23:26 -0300
Message-ID: <1378841015-23295-1-git-send-email-gustavo@zacarias.com.ar>
Cc: Gustavo Zacarias <gustavo@zacarias.com.ar>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from loknar.toptech.com.ar ([78.46.79.162]:38494 "EHLO
	loknar.toptech.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab3IJTXy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Sep 2013 15:23:54 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Gustavo Zacarias <gustavo@zacarias.com.ar>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index dcd3cf8..313a015 100644
--- a/configure.ac
+++ b/configure.ac
@@ -17,7 +17,7 @@ AC_DISABLE_STATIC
 LT_INIT
 CHECK_GCC_FVISIBILITY
 case "$host" in
-*-*-linux*) ;;
+*-*-linux* | *-*-uclinux*) ;;
 *) AC_MSG_ERROR([Linux only, dude!]);;
 esac
 
-- 
1.8.1.5

