From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 2/2] build: remove unused lines in Makefile.am
Date: Mon, 25 Jun 2012 20:34:45 +0200
Message-ID: <1340649285-20005-3-git-send-email-jengelh@inai.de>
References: <1340649285-20005-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:48680 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754092Ab2FYSer (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Jun 2012 14:34:47 -0400
In-Reply-To: <1340649285-20005-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 Makefile.am |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index b758e56..9a1cbcb 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,6 +1,4 @@
-AM_CPPFLAGS = -I$(top_srcdir)/include
 SUBDIRS	= include src utils
-LINKOPTS = -lnfnetlink
 
 ACLOCAL_AMFLAGS = -I m4
 
-- 
1.7.7

