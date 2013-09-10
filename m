From: Gustavo Zacarias <gustavo@zacarias.com.ar>
Subject: [libnetfilter_conntrack PATCH] configure: uclinux is also linux
Date: Tue, 10 Sep 2013 16:23:30 -0300
Message-ID: <1378841015-23295-5-git-send-email-gustavo@zacarias.com.ar>
References: <1378841015-23295-1-git-send-email-gustavo@zacarias.com.ar>
Cc: Gustavo Zacarias <gustavo@zacarias.com.ar>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from loknar.toptech.com.ar ([78.46.79.162]:38522 "EHLO
	loknar.toptech.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab3IJTZA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Sep 2013 15:25:00 -0400
In-Reply-To: <1378841015-23295-1-git-send-email-gustavo@zacarias.com.ar>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Gustavo Zacarias <gustavo@zacarias.com.ar>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 12e1d16..1edfd66 100644
--- a/configure.ac
+++ b/configure.ac
@@ -19,7 +19,7 @@ AC_PROG_INSTALL
 AC_PROG_LN_S
 
 case "$host" in 
-*-*-linux*) ;;
+*-*-linux* | *-*-uclinux*) ;;
 *) AC_MSG_ERROR([Linux only, dude!]);;
 esac
 
-- 
1.8.1.5

