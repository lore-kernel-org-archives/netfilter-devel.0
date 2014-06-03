From: Gustavo Zacarias <gustavo@zacarias.com.ar>
Subject: [libnftnl PATCH] configure: uclinux is also linux (nommu)
Date: Tue,  3 Jun 2014 17:10:19 -0300
Message-ID: <1401826219-8753-1-git-send-email-gustavo@zacarias.com.ar>
Cc: Gustavo Zacarias <gustavo@zacarias.com.ar>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from loknar.toptech.com.ar ([78.46.79.162]:38925 "EHLO
	loknar.toptech.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaFCUYH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Jun 2014 16:24:07 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Gustavo Zacarias <gustavo@zacarias.com.ar>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 255e457..35287f9 100644
--- a/configure.ac
+++ b/configure.ac
@@ -35,7 +35,7 @@ AC_DISABLE_STATIC
 LT_INIT
 CHECK_GCC_FVISIBILITY
 case "$host" in
-*-*-linux*) ;;
+*-*-linux* | *-*-uclinux*) ;;
 *) AC_MSG_ERROR([Linux only, dude!]);;
 esac
 
-- 
1.8.5.5

