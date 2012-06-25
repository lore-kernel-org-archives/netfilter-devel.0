From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH] build: remove unnecessary pkgconfig->config.status dependency
Date: Mon, 25 Jun 2012 20:19:01 +0200
Message-ID: <1340648341-15979-2-git-send-email-jengelh@inai.de>
References: <1340648341-15979-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:48510 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755647Ab2FYSTJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Jun 2012 14:19:09 -0400
In-Reply-To: <1340648341-15979-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 Makefile.am |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index b3e4aea..499c5df 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -7,5 +7,3 @@ DIST_SUBDIRS = src include examples
 
 pkgconfigdir = $(libdir)/pkgconfig
 pkgconfig_DATA = libnetfilter_acct.pc
-
-${pkgconfig_DATA}: ${top_builddir}/config.status
-- 
1.7.7

