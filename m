From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/7] build: drop unused $(all_includes)
Date: Sun, 31 Oct 2010 00:49:37 +0200
Message-ID: <1288478982-6758-4-git-send-email-jengelh@medozas.de>
References: <1288478982-6758-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44513 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888Ab0J3Wts (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Oct 2010 18:49:48 -0400
In-Reply-To: <1288478982-6758-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Make_global.am |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Make_global.am b/Make_global.am
index 810253a..4e9794e 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -1,4 +1,4 @@
-AM_CPPFLAGS=$(all_includes) -I$(top_srcdir)/include
+AM_CPPFLAGS = -I$(top_srcdir)/include
 
 AM_CFLAGS = -std=gnu99 -W -Wall \
 	-Wmissing-prototypes -Wwrite-strings -Wcast-qual -Wfloat-equal -Wshadow -Wpointer-arith -Wbad-function-cast -Wsign-compare -Waggregate-return -Wmissing-declarations -Wredundant-decls -Wnested-externs -Winline -Wstrict-prototypes -Wundef \
-- 
1.7.1

