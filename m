From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/4] configure: rename --disable-xtables to --disable-nftables
Date: Tue,  4 Feb 2014 16:32:23 +0100
Message-ID: <1391527946-19077-2-git-send-email-pablo@netfilter.org>
References: <1391527946-19077-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38406 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502AbaBDPcl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Feb 2014 10:32:41 -0500
In-Reply-To: <1391527946-19077-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The compat utility name is xtables, the name used for the
compatibility binary. Better explicitly refer to the compatibility
later as nftables-compat.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 configure.ac |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 3012df4..54f1fd5 100644
--- a/configure.ac
+++ b/configure.ac
@@ -61,7 +61,7 @@ AC_ARG_WITH([pkgconfigdir], AS_HELP_STRING([--with-pkgconfigdir=PATH],
 	[Path to the pkgconfig directory [[LIBDIR/pkgconfig]]]),
 	[pkgconfigdir="$withval"], [pkgconfigdir='${libdir}/pkgconfig'])
 AC_ARG_ENABLE([nftables],
-	AS_HELP_STRING([--disable-xtables], [Do not build xtables]),
+	AS_HELP_STRING([--disable-nftables], [Do not build nftables compat]),
 	[enable_nftables="$enableval"], [enable_nftables="yes"])
 
 libiptc_LDFLAGS2="";
-- 
1.7.10.4

