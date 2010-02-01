From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/7] libipq: build as shared library
Date: Mon,  1 Feb 2010 01:19:47 +0100
Message-ID: <1264983594-20871-2-git-send-email-jengelh@medozas.de>
References: <1264983594-20871-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49644 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754264Ab0BAAT6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 31 Jan 2010 19:19:58 -0500
In-Reply-To: <1264983594-20871-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Antique software (see link) built as shared library requires objects
compiled with -fPIC, so the standard archive won't do.

References: http://bugs.debian.org/527733
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 libipq/Makefile.am |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/libipq/Makefile.am b/libipq/Makefile.am
index f19950f..556a17b 100644
--- a/libipq/Makefile.am
+++ b/libipq/Makefile.am
@@ -2,8 +2,8 @@
 
 AM_CFLAGS = ${regular_CFLAGS} -I${top_builddir}/include -I${top_srcdir}/include
 
-libipq_a_SOURCES = libipq.c
-lib_LIBRARIES    = libipq.a
+libipq_la_SOURCES = libipq.c
+lib_LTLIBRARIES   = libipq.la
 man_MANS         = ipq_create_handle.3 ipq_destroy_handle.3 ipq_errstr.3 \
                    ipq_get_msgerr.3 ipq_get_packet.3 ipq_message_type.3 \
                    ipq_perror.3 ipq_read.3 ipq_set_mode.3 ipq_set_verdict.3 \
-- 
1.6.6.1

