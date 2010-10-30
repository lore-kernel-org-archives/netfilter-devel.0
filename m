From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/7] build: remove unused $(all_includes)
Date: Sun, 31 Oct 2010 00:08:18 +0200
Message-ID: <1288476502-18721-5-git-send-email-jengelh@medozas.de>
References: <1288476502-18721-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46350 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753707Ab0J3WJG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Oct 2010 18:09:06 -0400
In-Reply-To: <1288476502-18721-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Make_global.am |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Make_global.am b/Make_global.am
index 0ef055e..955a626 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -4,4 +4,4 @@
 # http://sources.redhat.com/autobook/autobook/autobook_91.html
 LIBVERSION=3:2:0
 
-AM_CPPFLAGS = $(all_includes) -I$(top_srcdir)/include
+AM_CPPFLAGS = -I$(top_srcdir)/include
-- 
1.7.1

