From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH] build: fix file list warning with automake-1.9
Date: Wed,  3 Aug 2011 17:10:16 +0200
Message-ID: <1312384217-26670-2-git-send-email-jengelh@medozas.de>
References: <1312384217-26670-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:59536 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754859Ab1HCPKU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Aug 2011 11:10:20 -0400
In-Reply-To: <1312384217-26670-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Makefile.am:12: EXTRA_DIST multiply defined in condition TRUE ...
Makefile.am:3: ... "EXTRA_DIST" previously defined here

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index d7c825d..bc2f61c 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -9,4 +9,4 @@ man_MANS = #nfnetlink_queue.3 nfnetlink_queue.7
 pkgconfigdir = $(libdir)/pkgconfig
 pkgconfig_DATA = libnetfilter_queue.pc
 
-EXTRA_DIST = Make_global.am
+EXTRA_DIST += Make_global.am
-- 
1.7.3.4

