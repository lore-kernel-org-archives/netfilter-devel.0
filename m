From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] configure: Fix logic for flex version check
Date: Fri, 17 Jun 2016 03:36:14 +0530
Message-ID: <1466114774-1831-1-git-send-email-shivanib134@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:35743 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbcFPWGZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jun 2016 18:06:25 -0400
Received: by mail-pa0-f67.google.com with SMTP id hf6so4389580pac.2
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jun 2016 15:06:25 -0700 (PDT)
Received: from localhost.localdomain ([116.202.36.218])
        by smtp.gmail.com with ESMTPSA id h6sm50587069pac.46.2016.06.16.15.06.23
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 16 Jun 2016 15:06:24 -0700 (PDT)
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

