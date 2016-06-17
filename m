From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH conntrack-tools] configure: Fix flex version check
Date: Sat, 18 Jun 2016 00:47:43 +0530
Message-ID: <1466191063-25552-1-git-send-email-shivanib134@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:33454 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbcFQTSC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Jun 2016 15:18:02 -0400
Received: by mail-pa0-f65.google.com with SMTP id ts6so6296140pac.0
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Jun 2016 12:18:01 -0700 (PDT)
Received: from localhost.localdomain ([116.202.34.104])
        by smtp.gmail.com with ESMTPSA id c189sm40634462pfg.19.2016.06.17.12.17.59
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 17 Jun 2016 12:18:00 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Following the fixes for version check in iptables and nftables, make
conntrack-tools avoid generating false warning for Flex version greater
than 2.5.x.

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index c541034..3bc5155 100644
--- a/configure.ac
+++ b/configure.ac
@@ -46,7 +46,7 @@ flex_major=`echo $flex_version| cut -d . -f 1`
 flex_minor=`echo $flex_version| cut -d . -f 2`
 flex_rev=`echo $flex_version| cut -d . -f 3`
  
-if test "$flex_major" -eq "2" && test "$flex_minor" -eq "5" && test "$flex_rev" -ge "33"; then
+if (test "$flex_major" -eq "2" && test "$flex_minor" -eq "5" && test "$flex_rev" -ge "33") || (test "$flex_major" -eq "2" && test "$flex_minor" -gt "5") || test "$flex_major" -gt "2"; then
 	AC_MSG_RESULT([$flex_version. OK])
 else
 	AC_MSG_WARN([flex version $flex_version found.
-- 
2.7.4

