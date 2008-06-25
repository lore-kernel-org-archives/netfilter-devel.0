From: Jan Engelhardt <jengelh@medozas.de>
Subject: build: ip6.h is not required
Date: Wed, 25 Jun 2008 10:32:53 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0806251031480.31898@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38818 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbYFYIcy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Jun 2008 04:32:54 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 7dc7126ec9b9d56528f0e7625dae3c2c05ac947d
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Jun 25 10:23:54 2008 +0200

build: ip6.h is not required
    
Remove the check from configure.ac that errors out when ip6.h is not
found. The code does not actually depend on any structures from it.

Reported-by: anonymous
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/configure.ac b/configure.ac
index 22ebb7e..f4cfcc1 100644
--- a/configure.ac
+++ b/configure.ac
@@ -38,7 +38,6 @@ AC_ARG_ENABLE([devel],
 AC_ARG_ENABLE([libipq],
 	AS_HELP_STRING([--enable-libipq], [Build and install libipq]))
 
-AC_CHECK_HEADER([netinet/ip6.h], [], [AC_MSG_ERROR(but we need that for IPv6)])
 AC_CHECK_HEADER([linux/dccp.h])
 
 blacklist_modules="";

