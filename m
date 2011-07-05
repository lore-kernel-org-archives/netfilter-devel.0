From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/4] build: install modules in arch-dependent location
Date: Tue,  5 Jul 2011 15:14:38 +0200
Message-ID: <1309871682-27307-2-git-send-email-jengelh@medozas.de>
References: <1309871682-27307-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:42316 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754739Ab1GENOt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jul 2011 09:14:49 -0400
In-Reply-To: <1309871682-27307-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Make it possible to have multiple types of ELF classes for the
extension modules by putting them in an arch-dependent path.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 INSTALL      |    2 +-
 configure.ac |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/INSTALL b/INSTALL
index acb56cd..e17e844 100644
--- a/INSTALL
+++ b/INSTALL
@@ -31,7 +31,7 @@ Configuring and compiling
 --with-xtlibdir=
 
 	The path to where Xtables extensions should be installed to. It
-	defaults to ${prefix}/libexec/xtables.
+	defaults to ${libdir}/xtables.
 
 --enable-devel (or --disable-devel)
 
diff --git a/configure.ac b/configure.ac
index 6c90caa..5cb1b1b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -30,7 +30,7 @@ AC_ARG_WITH([xtlibdir],
 	AS_HELP_STRING([--with-xtlibdir=PATH],
 	[Path where to install Xtables extensions [[LIBEXECDIR/xtables]]]),
 	[xtlibdir="$withval"],
-	[xtlibdir="${libexecdir}/xtables"])
+	[xtlibdir="${libdir}/xtables"])
 AC_ARG_ENABLE([ipv4],
 	AS_HELP_STRING([--disable-ipv4], [Do not build iptables]),
 	[enable_ipv4="$enableval"], [enable_ipv4="yes"])
-- 
1.7.3.4

