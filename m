From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/7] build: avoid use of deprecated INCLUDES
Date: Thu,  9 Sep 2010 01:32:38 +0200
Message-ID: <1283988763-1577-4-git-send-email-jengelh@medozas.de>
References: <1283988763-1577-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:48412 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756674Ab0IHXcs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Sep 2010 19:32:48 -0400
In-Reply-To: <1283988763-1577-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Make_global.am:7: "INCLUDES" is the old name for "AM_CPPFLAGS" (or "*_CPPFLAGS")
qa/Makefile.am:1:   "Make_global.am" included from here

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Make_global.am |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Make_global.am b/Make_global.am
index a4636ba..0ef055e 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -4,4 +4,4 @@
 # http://sources.redhat.com/autobook/autobook/autobook_91.html
 LIBVERSION=3:2:0
 
-INCLUDES=$(all_includes) -I$(top_srcdir)/include
+AM_CPPFLAGS = $(all_includes) -I$(top_srcdir)/include
-- 
1.7.1

