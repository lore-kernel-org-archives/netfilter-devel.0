From: Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH] Make_global.am: Don't include host headers
Date: Tue, 28 Oct 2014 21:21:34 +0200
Message-ID: <91631e0597af2d757e8f943c540aaa19cca30b89.1414524094.git.baruch@tkos.co.il>
Cc: netfilter-devel@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:40693 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbaJ1Tbo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Oct 2014 15:31:44 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is bad for cross compilation.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 Make_global.am | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/Make_global.am b/Make_global.am
index 7953451aeaa3..5922aeeb4fa8 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -71,8 +71,7 @@
 #            curr:rev:age
 LIBVERSION = 8:0:5
 
-AM_CPPFLAGS = $(kinclude_CFLAGS) $(all_includes) -I$(top_srcdir)/include \
-	-I/usr/local/include
+AM_CPPFLAGS = $(kinclude_CFLAGS) $(all_includes) -I$(top_srcdir)/include
 
 AM_CFLAGS = -std=gnu99
 
-- 
2.1.1

