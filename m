From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/5] build: use AM_YFLAGS instead of overriding YACC
Date: Fri,  5 Nov 2010 18:56:52 +0100
Message-ID: <1288979814-18512-5-git-send-email-jengelh@medozas.de>
References: <1288979814-18512-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55382 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753332Ab0KER5B (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Nov 2010 13:57:01 -0400
In-Reply-To: <1288979814-18512-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 src/Makefile.am |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/src/Makefile.am b/src/Makefile.am
index 10b3467..70e496d 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -1,6 +1,6 @@
 include $(top_srcdir)/Make_global.am
 
-YACC=@YACC@ -d
+AM_YFLAGS = -d
 
 CLEANFILES = read_config_yy.c read_config_lex.c
 
-- 
1.7.1

