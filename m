From: =?UTF-8?q?Ville=20Skytt=C3=A4?= <ville.skytta@iki.fi>
Subject: [PATCH] configure: Make missing docbook2man an error if man build requested
Date: Wed,  7 Feb 2018 11:40:00 +0200
Message-ID: <20180207094000.11494-1-ville.skytta@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:34337 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753454AbeBGJkH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Feb 2018 04:40:07 -0500
Received: by mail-lf0-f68.google.com with SMTP id k19so413322lfj.1
        for <netfilter-devel@vger.kernel.org>; Wed, 07 Feb 2018 01:40:06 -0800 (PST)
Received: from localhost.localdomain (87-100-219-255.bb.dnainternet.fi. [87.100.219.255])
        by smtp.gmail.com with ESMTPSA id t73sm209485lje.16.2018.02.07.01.40.04
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Feb 2018 01:40:05 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Previously, if man page build was enabled but no suitable docbook2man or
the like tool was found, build failed at a later stage with
undescriptive error message. Fail early and explicitly at configure
stage instead.

Signed-off-by: Ville Skyttä <ville.skytta@iki.fi>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 3b8ff96..1a38653 100644
--- a/configure.ac
+++ b/configure.ac
@@ -73,7 +73,7 @@ AM_COND_IF([BUILD_MAN], [
 	      [AS_IF([test "$DOCBOOK2MAN" != "no"], [DB2MAN="$DOCBOOK2MAN"],
 		     [AS_IF([test "$DB2X_DOCBOOK2MAN" != "no"],
 			    [DB2MAN="$DB2X_DOCBOOK2MAN"],
-			    [AC_MSG_WARN([docbookx2-man/db2x_docbook2man not found, no manpages will be built])]
+			    [AC_MSG_ERROR([docbookx2-man/db2x_docbook2man not found, required for building man pages])]
 		     )]
 	     )]
 	)
-- 
2.14.1

