From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/5] Update .gitignore
Date: Thu, 29 Dec 2011 22:24:48 +0100
Message-ID: <1325193891-20905-4-git-send-email-jengelh@medozas.de>
References: <1325193891-20905-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:59715 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753986Ab1L2VY4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Dec 2011 16:24:56 -0500
In-Reply-To: <1325193891-20905-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Only ignore these paths if they are a directory.
---
 .gitignore |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/.gitignore b/.gitignore
index 1c00b39..ddc214f 100644
--- a/.gitignore
+++ b/.gitignore
@@ -2,13 +2,13 @@
 *.la
 *.lo
 *.o
-.deps
-.libs
+.deps/
+.libs/
 Makefile
 Makefile.in
 
 /aclocal.m4
-/autom4te.cache
+/autom4te.cache/
 /build-aux/
 /config.*
 /configure
-- 
1.7.3.4

