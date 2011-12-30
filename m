From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/3] libiptc: add symbol maps to libiptc
Date: Fri, 30 Dec 2011 02:46:33 +0100
Message-ID: <1325209595-23244-3-git-send-email-jengelh@medozas.de>
References: <1325209595-23244-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:58642 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754856Ab1L3Bqj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Dec 2011 20:46:39 -0500
In-Reply-To: <1325209595-23244-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is mostly cosmetic, as using a libxtables.so with a too old
libiptc should now say something about "version symbol LIBIP4TC_1.4.13
required" (or so) instead of just "unknown symbol: iptc_ops".

Reported-by: Pablo Neira Ayuso
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 libiptc/Makefile.am  |   10 +++++++-
 libiptc/libip4tc.map |   52 +++++++++++++++++++++++++++++++++++++++++++++++++
 libiptc/libip6tc.map |   53 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 113 insertions(+), 2 deletions(-)
 create mode 100644 libiptc/libip4tc.map
 create mode 100644 libiptc/libip6tc.map

diff --git a/libiptc/Makefile.am b/libiptc/Makefile.am
index 3803fe7..4c22812 100644
--- a/libiptc/Makefile.am
+++ b/libiptc/Makefile.am
@@ -6,7 +6,13 @@ AM_CPPFLAGS      = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_srcdir}
 pkgconfig_DATA      = libiptc.pc libip4tc.pc libip6tc.pc
 
 lib_LTLIBRARIES     = libip4tc.la libip6tc.la
+
 libip4tc_la_SOURCES = libip4tc.c
-libip4tc_la_LDFLAGS = -version-info 1:0:1
+libip4tc_la_LDFLAGS = -version-info 0:0:0 -Wl,--version-script -Wl,libip4tc.map
+libip4tc_la_DEPENDENCIES = libip4tc.map
+
 libip6tc_la_SOURCES = libip6tc.c
-libip6tc_la_LDFLAGS = -version-info 1:0:1
+libip6tc_la_LDFLAGS = -version-info 0:0:0 -Wl,--version-script -Wl,libip6tc.map
+libip6tc_la_DEPENDENCIES = libip6tc.map
+
+EXTRA_DIST = libip4tc.map libip6tc.map
diff --git a/libiptc/libip4tc.map b/libiptc/libip4tc.map
new file mode 100644
index 0000000..f978b50
--- /dev/null
+++ b/libiptc/libip4tc.map
@@ -0,0 +1,52 @@
+LIBIP4TC_1.0.0 {
+global:
+	iptc_builtin;
+	iptc_init;
+	iptc_is_chain;
+	iptc_strerror;
+local:
+	*;
+};
+
+LIBIP4TC_1.4.1 {
+global:
+	dump_entries;
+};
+
+LIBIP4TC_1.4.3 {
+global:
+	iptc_append_entry;
+	iptc_check_packet;
+	iptc_commit;
+	iptc_create_chain;
+	iptc_delete_chain;
+	iptc_delete_entry;
+	iptc_delete_num_entry;
+	iptc_first_chain;
+	iptc_first_rule;
+	iptc_flush_entries;
+	iptc_free;
+	iptc_get_policy;
+	iptc_get_references;
+	iptc_get_target;
+	iptc_insert_entry;
+	iptc_next_chain;
+	iptc_next_rule;
+	iptc_read_counter;
+	iptc_rename_chain;
+	iptc_replace_entry;
+	iptc_set_counter;
+	iptc_set_policy;
+	iptc_zero_counter;
+	iptc_zero_entries;
+} LIBIP4TC_1.4.1;
+
+LIBIP4TC_1.4.11 {
+global:
+	iptc_check_entry;
+} LIBIP4TC_1.4.3;
+
+LIBIP4TC_1.4.13 {
+global:
+	iptc_ops;
+} LIBIP4TC_1.4.11;
diff --git a/libiptc/libip6tc.map b/libiptc/libip6tc.map
new file mode 100644
index 0000000..e58695f
--- /dev/null
+++ b/libiptc/libip6tc.map
@@ -0,0 +1,53 @@
+LIBIP6TC_1.0.0 {
+global:
+	ip6tc_builtin;
+	ip6tc_init;
+	ip6tc_is_chain;
+	ip6tc_strerror;
+	ipv6_prefix_length;
+local:
+	*;
+};
+
+LIBIP6TC_1.4.1 {
+global:
+	dump_entries6;
+};
+
+LIBIP6TC_1.4.3 {
+global:
+	ip6tc_append_entry;
+	ip6tc_check_packet;
+	ip6tc_commit;
+	ip6tc_create_chain;
+	ip6tc_delete_chain;
+	ip6tc_delete_entry;
+	ip6tc_delete_num_entry;
+	ip6tc_first_chain;
+	ip6tc_first_rule;
+	ip6tc_flush_entries;
+	ip6tc_free;
+	ip6tc_get_policy;
+	ip6tc_get_references;
+	ip6tc_get_target;
+	ip6tc_insert_entry;
+	ip6tc_next_chain;
+	ip6tc_next_rule;
+	ip6tc_read_counter;
+	ip6tc_rename_chain;
+	ip6tc_replace_entry;
+	ip6tc_set_counter;
+	ip6tc_set_policy;
+	ip6tc_zero_counter;
+	ip6tc_zero_entries;
+} LIBIP6TC_1.4.1;
+
+LIBIP6TC_1.4.11 {
+global:
+	ip6tc_check_entry;
+} LIBIP6TC_1.4.3;
+
+LIBIP6TC_1.4.13 {
+global:
+	ip6tc_ops;
+} LIBIP6TC_1.4.11;
-- 
1.7.3.4

