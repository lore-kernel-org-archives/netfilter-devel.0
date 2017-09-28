From: Juergen Borleis <jbe@pengutronix.de>
Subject: [PATCH] iptables: change large file support handling
Date: Thu, 28 Sep 2017 10:59:44 +0200
Message-ID: <201709281059.45061.jbe@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:56211 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751917AbdI1I7r (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Sep 2017 04:59:47 -0400
Received: from ginster.hi.pengutronix.de ([2001:67c:670:100:2e4d:54ff:fe67:bfa5] helo=ginster)
        by metis.ext.pengutronix.de with esmtp (Exim 4.84_2)
        (envelope-from <jbe@pengutronix.de>)
        id 1dxUfZ-00043p-Av
        for netfilter-devel@vger.kernel.org; Thu, 28 Sep 2017 10:59:45 +0200
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The configure script handles the "--*-largefile" parameter badly. It
defaults to large file support if not given and always disables largefile
support if given (and it doesn't matter if 'enable' or 'disable' was used)

Signed-off-by: Juergen Borleis <jbe@pengutronix.de>

---
 configure.ac | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index eda7871405b3..30445d7deda8 100644
--- a/configure.ac
+++ b/configure.ac
@@ -42,8 +42,9 @@ AC_ARG_ENABLE([ipv6],
 AC_ARG_ENABLE([largefile],
 	AS_HELP_STRING([--disable-largefile], [Do not build largefile support]),
 	[enable_largefile="$enableval"],
-	[enable_largefile="yes";
-	largefile_cppflags='-D_LARGEFILE_SOURCE=1 -D_LARGE_FILES -D_FILE_OFFSET_BITS=64'])
+	[enable_largefile="yes"])
+AS_IF([test "$enable_largefile" = "yes"], [largefile_cppflags='-D_LARGEFILE_SOURCE=1 -D_LARGE_FILES -D_FILE_OFFSET_BITS=64'])
+
 AC_ARG_ENABLE([devel],
 	AS_HELP_STRING([--enable-devel],
 	[Install Xtables development headers]),

