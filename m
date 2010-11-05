From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 6/9] build: default to not building static libraries
Date: Fri,  5 Nov 2010 19:36:20 +0100
Message-ID: <1288982184-23584-7-git-send-email-jengelh@medozas.de>
References: <1288982184-23584-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44406 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284Ab0KESgc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Nov 2010 14:36:32 -0400
In-Reply-To: <1288982184-23584-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/configure.ac b/configure.ac
index 370b4b3..2447574 100644
--- a/configure.ac
+++ b/configure.ac
@@ -10,6 +10,7 @@ dnl Checks for programs.
 AC_PROG_MAKE_SET
 AC_PROG_CC
 AC_PROG_INSTALL
+AC_DISABLE_STATIC
 AC_PROG_LIBTOOL
 
 dnl Checks for libraries.
-- 
1.7.1

