From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/2] build: default to not building static libraries
Date: Fri,  5 Nov 2010 18:56:12 +0100
Message-ID: <1288979774-18386-2-git-send-email-jengelh@medozas.de>
References: <1288979774-18386-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55356 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753205Ab0KER4S (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Nov 2010 13:56:18 -0400
In-Reply-To: <1288979774-18386-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/configure.ac b/configure.ac
index c4cc36e..f73f323 100644
--- a/configure.ac
+++ b/configure.ac
@@ -8,6 +8,7 @@ AM_INIT_AUTOMAKE([-Wall foreign subdir-objects dist-bzip2 1.6])
 
 AC_PROG_CC
 AC_EXEEXT
+AC_DISABLE_STATIC
 AM_PROG_LIBTOOL
 AC_PROG_INSTALL
 
-- 
1.7.1

