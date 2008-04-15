From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 06/10] configure.ac: AC_SUBST must be separate
Date: Tue, 15 Apr 2008 12:33:24 +0200
Message-ID: <06a71a3b9f3b4381d1383ab7c0986ea6e1144746.1208255176.git.jengelh@computergmbh.de>
References: <1208255608-8044-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34601 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800AbYDOKda (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Apr 2008 06:33:30 -0400
In-Reply-To: <1208255608-8044-1-git-send-email-jengelh@computergmbh.de>
In-Reply-To: <0e1521015bea15f495f191fa5534eb65ad9bd43f.1208255176.git.jengelh@computergmbh.de>
References: <0e1521015bea15f495f191fa5534eb65ad9bd43f.1208255176.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 configure.ac |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/configure.ac b/configure.ac
index 42fb728..2d9862e 100644
--- a/configure.ac
+++ b/configure.ac
@@ -51,7 +51,8 @@ if [[ -n "$ksourcedir" ]]; then
 	kinclude_CFLAGS="$kinclude_CFLAGS -I $ksourcedir/include";
 fi;
 
-AC_SUBST([regular_CFLAGS kinclude_CFLAGS])
+AC_SUBST([regular_CFLAGS])
+AC_SUBST([kinclude_CFLAGS])
 AC_SUBST([kbuilddir])
 AC_SUBST([ksourcedir])
 AC_SUBST([xtlibdir])
-- 
1.5.5.rc3

