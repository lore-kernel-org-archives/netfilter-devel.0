From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/9] build: avoid use of deprecated INCLUDES
Date: Sun, 31 Oct 2010 00:07:27 +0200
Message-ID: <1288476454-18451-4-git-send-email-jengelh@medozas.de>
References: <1288476454-18451-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46288 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857Ab0J3WHk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Oct 2010 18:07:40 -0400
In-Reply-To: <1288476454-18451-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Make_global.am:7: "INCLUDES" is the old name for "AM_CPPFLAGS" (or "*_CPPFLAGS")

Also remove unused $(all_includes).

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Make_global.am |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Make_global.am b/Make_global.am
index b62b712..8b406a9 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -4,4 +4,4 @@
 # http://sources.redhat.com/autobook/autobook/autobook_91.html
 LIBVERSION=2:0:2
 
-INCLUDES=$(all_includes) -I$(top_srcdir)/include
+AM_CPPFLAGS = -I$(top_srcdir)/include
-- 
1.7.1

