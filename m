From: Arif Hossain <aftnix@gmail.com>
Subject: [PATCH] fixed configure.ac. Now autogen.sh will work
Date: Thu, 02 Aug 2012 21:35:55 +0600
Message-ID: <1343921755.12174.2.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44569 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533Ab2HBPqq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Aug 2012 11:46:46 -0400
Received: by yenl2 with SMTP id l2so8861252yen.19
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Aug 2012 08:46:46 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 20158d2..4c2a6ac 100644
--- a/configure.ac
+++ b/configure.ac
@@ -31,7 +31,7 @@ xtlibdir="$(pkg-config --variable=xtlibdir xtables)"
 
 AC_ARG_WITH([xtlibdir],
 	AS_HELP_STRING([--with-xtlibdir=PATH],
-	[Path where to install Xtables extensions [[autodetect]]]]),
+	[Path where to install Xtables extensions [[autodetect]]]),
 	[xtlibdir="$withval"])
 AC_MSG_CHECKING([Xtables module directory])
 AC_MSG_RESULT([$xtlibdir])
-- 
1.7.11.1


