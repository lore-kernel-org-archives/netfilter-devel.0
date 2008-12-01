From: Pierre Chifflier <chifflier@inl.fr>
Subject: [PATCH 1/4] Link ulogd2 with libpthread
Date: Mon,  1 Dec 2008 13:41:53 +0100
Message-ID: <1228135316-12578-2-git-send-email-chifflier@inl.fr>
References: <1228135316-12578-1-git-send-email-chifflier@inl.fr>
Cc: Pierre Chifflier <chifflier@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 78-210-144-213.altitudetelecom.fr ([213.144.210.78]:55869 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbYLANYr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Dec 2008 08:24:47 -0500
In-Reply-To: <1228135316-12578-1-git-send-email-chifflier@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Explicitly link with libpthread. This allows to run ulogd within gdb,
else it fails with message: Cannot find new threads: generic error

Signed-off-by: Pierre Chifflier <chifflier@inl.fr>
---
 src/Makefile.am |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/src/Makefile.am b/src/Makefile.am
index aa9a3fa..343cdcc 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -6,4 +6,4 @@ AM_CPPFLAGS = $(all_includes) -I$(top_srcdir)/include \
 sbin_PROGRAMS = ulogd
 
 ulogd_SOURCES = ulogd.c select.c timer.c rbtree.c conffile.c hash.c
-ulogd_LDFLAGS = -export-dynamic
+ulogd_LDFLAGS = -lpthread -export-dynamic
-- 
1.5.6.5

