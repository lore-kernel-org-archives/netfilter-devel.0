From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [iptables PATCH] configure: make libmnl and libnftnl hard
 requirements
Date: Tue, 26 Apr 2016 23:20:19 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1604262318470.24999@nerf40.vanv.qr>
References: <1461698878-4459-1-git-send-email-giuseppe@glongo.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:40318 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409AbcDZVUW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Apr 2016 17:20:22 -0400
In-Reply-To: <1461698878-4459-1-git-send-email-giuseppe@glongo.it>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2016-04-26 21:27, Giuseppe Longo wrote:
>index 12bffa9..b170add 100644
>--- a/configure.ac
>+++ b/configure.ac
>@@ -122,8 +122,26 @@ AM_CONDITIONAL([HAVE_LIBNFNETLINK], [test "$nfnetlink" = 1])
> if test "x$enable_nftables" = "xyes"; then
> 	PKG_CHECK_MODULES([libmnl], [libmnl >= 1.0], [mnl=1], [mnl=0])
> 
>+	if test "$mnl" = 0;
>+	then
>+		echo "*** Error: No suitable libmnl found. ***"
>+		echo "    Please install the 'libmnl' package"
>+		echo "    Or consider --disable-nftables to skip"
>+		echo "    iptables-compat over nftables support."
>+		exit 1
>+	fi

As told you before, I find this unnecessary large.
Consider this instead.


>From afcbd592265af0c3a65c21e8f23e1c2f5a348396 Mon Sep 17 00:00:00 2001
From: Jan Engelhardt <jengelh@inai.de>
Date: Tue, 26 Apr 2016 23:18:26 +0200
Subject: [PATCH] build: hard-require libmnl, libnftnl for iptables-nft

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 configure.ac | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/configure.ac b/configure.ac
index 12bffa9..e4eafc6 100644
--- a/configure.ac
+++ b/configure.ac
@@ -120,9 +120,10 @@ PKG_CHECK_MODULES([libnfnetlink], [libnfnetlink >= 1.0],
 AM_CONDITIONAL([HAVE_LIBNFNETLINK], [test "$nfnetlink" = 1])
 
 if test "x$enable_nftables" = "xyes"; then
-	PKG_CHECK_MODULES([libmnl], [libmnl >= 1.0], [mnl=1], [mnl=0])
-
-	PKG_CHECK_MODULES([libnftnl], [libnftnl >= 1.0.5], [nftables=1], [nftables=0])
+	PKG_CHECK_MODULES([libmnl], [libmnl >= 1.0])
+	PKG_CHECK_MODULES([libnftnl], [libnftnl >= 1.0.5])
+	mnl=1
+	nftables=1
 
 	AM_PROG_LEX
 	AC_PROG_YACC
-- 
2.6.6

