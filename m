From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/3 nft] configure: fix --enable-debug
Date: Wed,  8 Jul 2015 11:18:08 +0200
Message-ID: <1436347088-9687-3-git-send-email-pablo@netfilter.org>
References: <1436347088-9687-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42273 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933144AbbGHJMg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jul 2015 05:12:36 -0400
In-Reply-To: <1436347088-9687-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

As the documentation indicates "The most common mistake for this macro is to
consider the two actions as action-if-enabled and action-if-disabled."

Use AS_IF in the action-if-present to check the real argument that we're
getting from the user.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 configure.ac |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index d8f949a..931dbe1 100644
--- a/configure.ac
+++ b/configure.ac
@@ -23,8 +23,8 @@ AC_DEFINE([_GNU_SOURCE], [], [Enable various GNU extensions])
 AC_DEFINE([_STDC_FORMAT_MACROS], [], [printf-style format macros])
 
 AC_ARG_ENABLE([debug],
-	      AS_HELP_STRING([--enable-debug], [Enable debugging]),
-	      [with_debug=no],
+	      AS_HELP_STRING([--enable-debug], [Disable debugging]),
+	      AS_IF([test "x$enable_debug" = "xno"], [with_debug=no], [with_debug=yes]),
 	      [with_debug=yes])
 AC_SUBST(with_debug)
 AM_CONDITIONAL([BUILD_DEBUG], [test "x$with_debug" != xno])
-- 
1.7.10.4

