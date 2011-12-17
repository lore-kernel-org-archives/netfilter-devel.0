From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/3] Update .gitignore
Date: Sat, 17 Dec 2011 16:35:41 +0100
Message-ID: <1324136144-12845-2-git-send-email-jengelh@medozas.de>
References: <1324136144-12845-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:59401 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850Ab1LQPft (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Dec 2011 10:35:49 -0500
In-Reply-To: <1324136144-12845-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Only ignore these paths if they are a directory.
---
 .gitignore |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/.gitignore b/.gitignore
index c9550f5..e683edb 100644
--- a/.gitignore
+++ b/.gitignore
@@ -1,5 +1,5 @@
-.deps
-.libs
+.deps/
+.libs/
 Makefile
 Makefile.in
 *.o
@@ -7,7 +7,7 @@ Makefile.in
 *.lo
 
 /aclocal.m4
-/autom4te.cache
+/autom4te.cache/
 /config.*
 /configure
 /depcomp
-- 
1.7.3.4

