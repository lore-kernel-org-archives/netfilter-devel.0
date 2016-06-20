From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH conntrack-tools] configure: Remove flex check warning
Date: Mon, 20 Jun 2016 23:12:32 +0530
Message-ID: <1466444552-8834-1-git-send-email-shivanib134@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:35325 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701AbcFTRmp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jun 2016 13:42:45 -0400
Received: by mail-pa0-f68.google.com with SMTP id hf6so11401480pac.2
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Jun 2016 10:42:45 -0700 (PDT)
Received: from localhost.localdomain ([116.202.32.122])
        by smtp.gmail.com with ESMTPSA id n10sm89889793pax.18.2016.06.20.10.42.42
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 20 Jun 2016 10:42:44 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove the warning about outdated version of flex as it is not needed
anymore.

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 configure.ac | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/configure.ac b/configure.ac
index c541034..b6c5439 100644
--- a/configure.ac
+++ b/configure.ac
@@ -40,21 +40,6 @@ then
 	exit 1
 fi
 
-AC_MSG_CHECKING(flex version)
-flex_version=`$ac_cv_prog_LEX --version | sed 's/version//g' | awk '/flex/ {print $2}'`
-flex_major=`echo $flex_version| cut -d . -f 1`
-flex_minor=`echo $flex_version| cut -d . -f 2`
-flex_rev=`echo $flex_version| cut -d . -f 3`
- 
-if test "$flex_major" -eq "2" && test "$flex_minor" -eq "5" && test "$flex_rev" -ge "33"; then
-	AC_MSG_RESULT([$flex_version. OK])
-else
-	AC_MSG_WARN([flex version $flex_version found.
-	Version 2.5.33 or greater is required. You may experience problems
-	while compilating the conntrack-tools. Please, consider to upgrade 
-	flex.])
-fi
-
 AC_ARG_ENABLE([cthelper],
         AS_HELP_STRING([--disable-cthelper], [Do not build userspace helper support]),
         [enable_cthelper="$enableval"], [enable_cthelper="yes"])
-- 
2.7.4

