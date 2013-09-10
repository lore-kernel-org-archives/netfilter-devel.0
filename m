From: Gustavo Zacarias <gustavo@zacarias.com.ar>
Subject: [ipset PATCH] configure: uclinux is also linux
Date: Tue, 10 Sep 2013 16:23:27 -0300
Message-ID: <1378841015-23295-2-git-send-email-gustavo@zacarias.com.ar>
References: <1378841015-23295-1-git-send-email-gustavo@zacarias.com.ar>
Cc: Gustavo Zacarias <gustavo@zacarias.com.ar>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from loknar.toptech.com.ar ([78.46.79.162]:38505 "EHLO
	loknar.toptech.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab3IJTYO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Sep 2013 15:24:14 -0400
In-Reply-To: <1378841015-23295-1-git-send-email-gustavo@zacarias.com.ar>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Gustavo Zacarias <gustavo@zacarias.com.ar>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 6b64576..6d06ef5 100644
--- a/configure.ac
+++ b/configure.ac
@@ -14,7 +14,7 @@ LTDL_INIT([nonrecursive])
 
 dnl Shortcut: Linux supported alone
 case "$host" in
-*-*-linux*) ;;
+*-*-linux* | *-*-uclinux*) ;;
 *) AC_MSG_ERROR([Linux systems supported exclusively!]);;
 esac
 
-- 
1.8.1.5

