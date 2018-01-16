From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 1/2] configure: Fix help text regarding --enable-debug
Date: Tue, 16 Jan 2018 17:38:06 +0100
Message-ID: <20180116163807.13276-2-phil@nwl.cc>
References: <20180116163807.13276-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:47262 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750790AbeAPQiS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jan 2018 11:38:18 -0500
In-Reply-To: <20180116163807.13276-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Debugging symbols are enabled by default, so list '--disable-debug' in
help output rather than '--enable-debug'. This way it is also consistent
with the parameter's description.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 60c8c08bff2a1..22fb293c47035 100644
--- a/configure.ac
+++ b/configure.ac
@@ -23,7 +23,7 @@ AC_DEFINE([_GNU_SOURCE], [], [Enable various GNU extensions])
 AC_DEFINE([_STDC_FORMAT_MACROS], [], [printf-style format macros])
 
 AC_ARG_ENABLE([debug],
-	      AS_HELP_STRING([--enable-debug], [Disable debugging symbols]),
+	      AS_HELP_STRING([--disable-debug], [Disable debugging symbols]),
 	      AS_IF([test "x$enable_debug" = "xno"], [with_debug=no], [with_debug=yes]),
 	      [with_debug=yes])
 AC_SUBST(with_debug)
-- 
2.15.1

