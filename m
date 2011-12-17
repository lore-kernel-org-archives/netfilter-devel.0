From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/3] Update .gitignore
Date: Sat, 17 Dec 2011 04:04:43 +0100
Message-ID: <1324091086-6074-2-git-send-email-jengelh@medozas.de>
References: <1324091086-6074-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:51279 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835Ab1LQDEw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Dec 2011 22:04:52 -0500
In-Reply-To: <1324091086-6074-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Only ignore these paths if they are a directory.
---
 .gitignore |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/.gitignore b/.gitignore
index c7acff2..b899b3b 100644
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
 /compile
 /config.*
 /configure
-- 
1.7.3.4

