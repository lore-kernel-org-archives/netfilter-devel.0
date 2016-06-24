From: Jordan Yelloz <jordan@yelloz.me>
Subject: [PATCH 1/1] extensions: added AR substitution
Date: Fri, 24 Jun 2016 12:18:45 -0700
Message-ID: <20160624191845.4660-1-jordan@yelloz.me>
Cc: Jordan Yelloz <jordan@yelloz.me>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from node1.ec2.jordan.yelloz.me ([54.210.29.28]:35449 "EHLO
	node1.ec2.jordan.yelloz.me" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751437AbcFXTYt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Jun 2016 15:24:49 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is to ensure that the correct AR is run in cross-compile jobs.
Often a cross-compile build will succeed without this change but it
fails on my Gentoo Linux system when I have binutils installed with the
"multitarget" USE flag.
This change substitues AR with the autotools-supplied AR for the
extensions subdirectory.

Signed-off-by: Jordan Yelloz <jordan@yelloz.me>
---
 extensions/GNUmakefile.in | 1 +
 1 file changed, 1 insertion(+)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 53be2cdd0ebd..33b06efd15c2 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -11,6 +11,7 @@ libdir       = @libdir@
 libexecdir   = @libexecdir@
 xtlibdir     = @xtlibdir@
 
+AR                 = @AR@
 CC                 = @CC@
 CCLD               = ${CC}
 CFLAGS             = @CFLAGS@
-- 
2.9.0

