From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/3] libipq: add symbol map to libipq
Date: Fri, 30 Dec 2011 02:46:34 +0100
Message-ID: <1325209595-23244-4-git-send-email-jengelh@medozas.de>
References: <1325209595-23244-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:58643 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754856Ab1L3Bqj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Dec 2011 20:46:39 -0500
In-Reply-To: <1325209595-23244-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 libipq/Makefile.am |    8 +++++++-
 libipq/libipq.map  |   28 ++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 1 deletions(-)
 create mode 100644 libipq/libipq.map

diff --git a/libipq/Makefile.am b/libipq/Makefile.am
index 9e3a2ca..116ba9a 100644
--- a/libipq/Makefile.am
+++ b/libipq/Makefile.am
@@ -3,11 +3,17 @@
 AM_CFLAGS = ${regular_CFLAGS}
 AM_CPPFLAGS = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_srcdir}/include
 
-libipq_la_SOURCES = libipq.c
 lib_LTLIBRARIES   = libipq.la
+
+libipq_la_SOURCES = libipq.c
+libipq_la_LDFLAGS = -version-info 0:0:0 -Wl,--version-script -Wl,libipq.map
+libipq_la_DEPENDENCIES = libipq.map
+
 man_MANS         = ipq_create_handle.3 ipq_destroy_handle.3 ipq_errstr.3 \
                    ipq_get_msgerr.3 ipq_get_packet.3 ipq_message_type.3 \
                    ipq_perror.3 ipq_read.3 ipq_set_mode.3 ipq_set_verdict.3 \
                    libipq.3
 
 pkgconfig_DATA = libipq.pc
+
+EXTRA_DIST = libipq.map
diff --git a/libipq/libipq.map b/libipq/libipq.map
new file mode 100644
index 0000000..3ac82bd
--- /dev/null
+++ b/libipq/libipq.map
@@ -0,0 +1,28 @@
+LIBIPQ_1.0.0 {
+global:
+	ipq_destroy_handle;
+	ipq_read;
+	ipq_set_mode;
+	ipq_get_packet;
+	ipq_message_type;
+	ipq_get_msgerr;
+	ipq_ctl;
+	ipq_perror;
+local:
+	*;
+};
+
+LIBIPQ_1.2.1 {
+global:
+	ipq_errstr;
+} LIBIPQ_1.0.0;
+
+LIBIPQ_1.2.5 {
+global:
+	ipq_create_handle;
+} LIBIPQ_1.2.1;
+
+LIBIPQ_1.2.9 {
+global:
+	ipq_set_verdict;
+} LIBIPQ_1.2.5;
-- 
1.7.3.4

