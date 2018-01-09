From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] build: Bump version to v0.8.1
Date: Tue,  9 Jan 2018 16:26:39 +0100
Message-ID: <20180109152639.6751-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54174 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932205AbeAIP0t (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Jan 2018 10:26:49 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AC4F9114801
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Jan 2018 16:26:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9E719DA84B
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Jan 2018 16:26:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 25AC9DA84E
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Jan 2018 16:26:43 +0100 (CET)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E51634265A31
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Jan 2018 16:26:42 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

A release including incremental fixes since last release. Still it needs
libnftnl 1.0.9 because of nftnl_expr_fprint().

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 configure.ac | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index a97d9e73270d..6ed3edca1fe5 100644
--- a/configure.ac
+++ b/configure.ac
@@ -4,7 +4,7 @@
 AC_PREREQ(2.61)
 
 AC_COPYRIGHT([Copyright (c) 2008 Patrick McHardy <kaber@trash.net>, (c) 2013-2016 Pablo Neira Ayuso <pablo@netfilter.org>])
-AC_INIT([nftables], [0.8], [netfilter-devel@vger.kernel.org])
+AC_INIT([nftables], [0.8.1], [netfilter-devel@vger.kernel.org])
 AC_DEFINE([RELEASE_NAME], ["Joe Btfsplk"], [Release name])
 
 AC_CONFIG_AUX_DIR([build-aux])
@@ -80,7 +80,7 @@ AM_COND_IF([BUILD_PDF], [
 
 # Checks for libraries.
 PKG_CHECK_MODULES([LIBMNL], [libmnl >= 1.0.3])
-PKG_CHECK_MODULES([LIBNFTNL], [libnftnl >= 1.0.8])
+PKG_CHECK_MODULES([LIBNFTNL], [libnftnl >= 1.0.9])
 
 AC_ARG_WITH([mini-gmp], [AS_HELP_STRING([--with-mini-gmp],
             [Use builtin mini-gmp (for embedded builds)])], [],
-- 
2.11.0

