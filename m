From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: [PATCH] conntrack-tools: Fix build for old automake. autoreconf fails with automake version smaller than 1.12, because of undefined macro AM_PROG_AR. So only expand it if it's actually defined.
Date: Mon,  4 Apr 2016 11:29:39 +0200
Message-ID: <1459762179-10041-2-git-send-email-mart.frauenlob@chello.at>
References: <1459762179-10041-1-git-send-email-mart.frauenlob@chello.at>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vie01a-dmta-at01-3.mx.upcmail.net ([62.179.121.147]:39156 "EHLO
	vie01a-dmta-at01-3.mx.upcmail.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751334AbcDDJ3y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Apr 2016 05:29:54 -0400
Received: from [172.31.216.43] (helo=vie01a-pemc-psmtp-pe01)
	by vie01a-dmta-at01.mx.upcmail.net with esmtp (Exim 4.72)
	(envelope-from <mart.frauenlob@chello.at>)
	id 1an0pT-0001IZ-HP
	for netfilter-devel@vger.kernel.org; Mon, 04 Apr 2016 11:29:51 +0200
In-Reply-To: <1459762179-10041-1-git-send-email-mart.frauenlob@chello.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 configure.ac |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/configure.ac b/configure.ac
index c541034..2c5913f 100644
--- a/configure.ac
+++ b/configure.ac
@@ -14,7 +14,7 @@ AC_SUBST([libdl_LIBS])
 
 AC_PROG_CC
 AC_DISABLE_STATIC
-AM_PROG_AR
+m4_ifdef([AM_PROG_AR], [AM_PROG_AR]) dnl Workaround for Automake 1.11
 AM_PROG_LIBTOOL
 AC_PROG_INSTALL
 AC_PROG_LN_S
-- 
1.7.2.5

