From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH nft] configure: Show flex version check
Date: Sat, 18 Jun 2016 00:31:39 +0530
Message-ID: <1466190099-21848-1-git-send-email-shivanib134@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:33581 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbcFQTBw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Jun 2016 15:01:52 -0400
Received: by mail-pa0-f67.google.com with SMTP id ts6so6279442pac.0
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Jun 2016 12:01:51 -0700 (PDT)
Received: from localhost.localdomain ([116.202.34.104])
        by smtp.gmail.com with ESMTPSA id ql1sm70254703pac.2.2016.06.17.12.01.49
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 17 Jun 2016 12:01:50 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Before this patch, no check on the version of flex was done because of
which configure script did not show any warning messages for
inappropriate version of flex. Following iptables, show the version of
flex in the output of configure script, also show warning if necessary.

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 configure.ac | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/configure.ac b/configure.ac
index 0e7edcf..b3b6c0b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -50,6 +50,21 @@ then
         exit 1
 fi
 
+AC_MSG_CHECKING(flex version)
+        flex_version=`$ac_cv_prog_LEX --version | sed 's/version//g' | awk '/flex/ {print $2}'`
+        flex_major=`echo $flex_version| cut -d . -f 1`
+        flex_minor=`echo $flex_version| cut -d . -f 2`
+        flex_rev=`echo $flex_version| cut -d . -f 3`
+
+        if (test "$flex_major" -eq "2" && test "$flex_minor" -eq "5" && test "$flex_rev" -ge "33") || (test "$flex_major" -eq "2" && test "$flex_minor" -gt "5") || test "$flex_major" -gt "2"; then
+                AC_MSG_RESULT([$flex_version. OK])
+        else
+                AC_MSG_WARN([flex version $flex_version found.
+                Version 2.5.33 or greater is required. You may experience problems
+                while compilating the nftables compatibility layer for iptables.
+                Please, consider to upgrade flex.])
+        fi
+
 AC_CHECK_PROG(DOCBOOK2X_MAN, [docbook2x-man], [docbook2x-man], [no])
 AC_CHECK_PROG(DOCBOOK2MAN, [docbook2man], [docbook2man], [no])
 AC_CHECK_PROG(DB2X_DOCBOOK2MAN, [db2x_docbook2man], [db2x_docbook2man], [no])
-- 
2.7.4

