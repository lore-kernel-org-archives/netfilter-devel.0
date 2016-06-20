From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH iptables] configure: Remove flex check warning
Date: Mon, 20 Jun 2016 23:06:34 +0530
Message-ID: <1466444194-7055-1-git-send-email-shivanib134@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34820 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118AbcFTSgY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jun 2016 14:36:24 -0400
Received: by mail-pf0-f194.google.com with SMTP id t190so12093944pfb.2
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Jun 2016 11:36:17 -0700 (PDT)
Received: from localhost.localdomain ([116.202.32.122])
        by smtp.gmail.com with ESMTPSA id k9sm89722452pao.19.2016.06.20.10.36.43
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 20 Jun 2016 10:36:44 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove the warning about outdated version of flex as it is not needed
anymore.

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 configure.ac | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/configure.ac b/configure.ac
index b170add..c91e9e7 100644
--- a/configure.ac
+++ b/configure.ac
@@ -157,21 +157,6 @@ if test "x$enable_nftables" = "xyes"; then
 	        echo "    Please install the 'flex' package."
 	        exit 1
 	fi
-
-	AC_MSG_CHECKING(flex version)
-	flex_version=`$ac_cv_prog_LEX --version | sed 's/version//g' | awk '/flex/ {print $2}'`
-	flex_major=`echo $flex_version| cut -d . -f 1`
-	flex_minor=`echo $flex_version| cut -d . -f 2`
-	flex_rev=`echo $flex_version| cut -d . -f 3`
-
-	if test "$flex_major" -eq "2" && test "$flex_minor" -eq "5" && test "$flex_rev" -ge "33"; then
-		AC_MSG_RESULT([$flex_version. OK])
-	else
-		AC_MSG_WARN([flex version $flex_version found.
-		Version 2.5.33 or greater is required. You may experience problems
-		while compilating the nftables compatibility layer for iptables.
-		Please, consider to upgrade flex.])
-	fi
 fi
 
 AM_CONDITIONAL([HAVE_LIBMNL], [test "$mnl" = 1])
-- 
2.7.4

