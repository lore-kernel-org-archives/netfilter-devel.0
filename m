From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: [patch] fix compile error in libxt_condition
Date: Thu, 23 Oct 2008 12:32:16 +0200
Message-ID: <200810231232.17331.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_xKFAJgLvnkWm/rT"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rs02.intra2net.com ([81.169.173.116]:55343 "EHLO
	rs02.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbYJWKjQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Oct 2008 06:39:16 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--Boundary-00=_xKFAJgLvnkWm/rT
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello Jan,

attached is a small patch to fix the compilation
of libxt_condition in xtables_addons using gcc 4.3.2.

Cheers,
Thomas


--Boundary-00=_xKFAJgLvnkWm/rT
Content-Type: text/x-patch;
  charset="iso-8859-1";
  name="libxt_condition-compile-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="libxt_condition-compile-fix.patch"

Fix compile error in libxt_condition

libxt_condition.c:95: error: static declaration of 'libxt_condition_init' follows non-static declaration
../include/xtables/internal.h:64: error: previous declaration of 'libxt_condition_init' was here  

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>

--- extensions.old/xt_condition.c/libxt_condition.c	Thu Oct 23 12:22:38 2008
+++ extensions/xt_condition.c/libxt_condition.c	Thu Oct 23 12:24:27 2008
@@ -92,7 +92,7 @@
 	.extra_opts 	= condition_opts,
 };
 
-static void _init(void)
+void _init(void)
 {
 	xtables_register_match(&condition_mt_reg);
 }

--Boundary-00=_xKFAJgLvnkWm/rT--
