From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH iptables] configure: Fix logic for flex version check
Date: Sat, 18 Jun 2016 00:01:19 +0530
Message-ID: <1466188279-4677-1-git-send-email-shivanib134@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:34541 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbcFQSbd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Jun 2016 14:31:33 -0400
Received: by mail-pa0-f66.google.com with SMTP id us13so6246505pab.1
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Jun 2016 11:31:33 -0700 (PDT)
Received: from localhost.localdomain ([116.202.34.104])
        by smtp.gmail.com with ESMTPSA id 4sm7523459pfi.24.2016.06.17.11.31.31
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 17 Jun 2016 11:31:32 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

According to the previous logic of version check for flex, anything
greater than 2.5.33 but within 2.5.x was acceptable. The issue was
observed when a false warning generated for flex version 2.6.0.
New logic works for basically everything greater than 2.5.33.

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index b170add..0040f0b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -164,7 +164,7 @@ if test "x$enable_nftables" = "xyes"; then
 	flex_minor=`echo $flex_version| cut -d . -f 2`
 	flex_rev=`echo $flex_version| cut -d . -f 3`
 
-	if test "$flex_major" -eq "2" && test "$flex_minor" -eq "5" && test "$flex_rev" -ge "33"; then
+	if (test "$flex_major" -eq "2" && test "$flex_minor" -eq "5" && test "$flex_rev" -ge "33") || (test "$flex_major" -eq "2" && test "$flex_minor" -gt "5") || test "$flex_major" -gt "2"; then
 		AC_MSG_RESULT([$flex_version. OK])
 	else
 		AC_MSG_WARN([flex version $flex_version found.
-- 
2.7.4

