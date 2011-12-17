From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/6] Update .gitignore
Date: Sat, 17 Dec 2011 16:35:03 +0100
Message-ID: <1324136109-31504-2-git-send-email-jengelh@medozas.de>
References: <1324136109-31504-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:59367 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502Ab1LQPfQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Dec 2011 10:35:16 -0500
In-Reply-To: <1324136109-31504-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Only ignore these paths if they are a directory.
---
 .gitignore |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/.gitignore b/.gitignore
index 6992cc9..07b1ff5 100644
--- a/.gitignore
+++ b/.gitignore
@@ -2,8 +2,8 @@
 *.la
 *.lo
 *.o
-.deps
-.libs
+.deps/
+.libs/
 Makefile
 Makefile.in
 
@@ -17,7 +17,7 @@ Module.symvers
 modules.order
 
 /aclocal.m4
-/autom4te.cache
+/autom4te.cache/
 /compile
 /config.*
 /configure
-- 
1.7.3.4

