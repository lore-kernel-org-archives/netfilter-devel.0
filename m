From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/6] Update .gitignore
Date: Fri, 30 Dec 2011 02:34:56 +0100
Message-ID: <1325208902-2014-2-git-send-email-jengelh@medozas.de>
References: <1325208902-2014-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:40845 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221Ab1L3BfH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Dec 2011 20:35:07 -0500
In-Reply-To: <1325208902-2014-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Only ignore these paths if they are a directory.
---
 .gitignore |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/.gitignore b/.gitignore
index 3e7def5..deed221 100644
--- a/.gitignore
+++ b/.gitignore
@@ -6,9 +6,9 @@
 *.oo
 *.so
 *.o
-.deps
+.deps/
 .dirstamp
-.libs
+.libs/
 Makefile
 Makefile.in
 
@@ -22,7 +22,7 @@ Makefile.in
 /include/iptables/internal.h
 
 /aclocal.m4
-/autom4te*.cache
+/autom4te.cache/
 /compile
 /config.guess
 /config.h*
-- 
1.7.3.4

