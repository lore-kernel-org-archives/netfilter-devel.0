From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 8/8] libxtables: symbol versioning
Date: Fri,  4 Feb 2011 14:08:54 +0100
Message-ID: <1296824935-4606-9-git-send-email-jengelh@medozas.de>
References: <1296824935-4606-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36781 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350Ab1BDNJF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Feb 2011 08:09:05 -0500
In-Reply-To: <1296824935-4606-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am    |    2 +-
 configure.ac   |    2 +-
 libxtables.map |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 57 insertions(+), 2 deletions(-)
 create mode 100644 libxtables.map

diff --git a/Makefile.am b/Makefile.am
index a560113..4406435 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -28,7 +28,7 @@ libiptc_libip6tc_la_LDFLAGS = -version-info 0:0:0 ${libiptc_LDFLAGS2}
 
 lib_LTLIBRARIES      += libxtables.la
 libxtables_la_SOURCES = xtables.c
-libxtables_la_LDFLAGS = -version-info ${libxtables_vcurrent}:0:${libxtables_vage}
+libxtables_la_LDFLAGS = -version-info ${libxtables_vcurrent}:0:${libxtables_vage} -Wl,--version-script=${srcdir}/libxtables.map
 libxtables_la_CFLAGS  = ${AM_CFLAGS} ${GCC_FVISIBILITY_HIDDEN}
 if ENABLE_SHARED
 libxtables_la_LIBADD  = -ldl
diff --git a/configure.ac b/configure.ac
index cba1dc5..ec44c3a 100644
--- a/configure.ac
+++ b/configure.ac
@@ -2,7 +2,7 @@
 AC_INIT([iptables], [1.4.10])
 
 # See libtool.info "Libtool's versioning system"
-libxtables_vcurrent=5
+libxtables_vcurrent=6
 libxtables_vage=0
 
 AC_CONFIG_HEADERS([config.h])
diff --git a/libxtables.map b/libxtables.map
new file mode 100644
index 0000000..54fd64c
--- /dev/null
+++ b/libxtables.map
@@ -0,0 +1,55 @@
+XTABLES_1.4.2 {
+global:
+	xtables_matches;
+	xtables_targets;
+	xtables_register_match;
+	xtables_register_target;
+local:
+	*;
+};
+
+XTABLES_1.4.3 {
+	xt_params;
+	xtables_free_opts;
+	xtables_modprobe_program;
+	xtables_set_params;
+	xtables_init_all;
+	xtables_calloc;
+	xtables_malloc;
+	xtables_load_ko;
+	xtables_strtoui;
+	xtables_service_to_port;
+	xtables_parse_port;
+	xtables_parse_interface;
+	xtables_find_match;
+	xtables_find_target;
+	xtables_param_act;
+	xtables_ipaddr_to_numeric;
+	xtables_ipaddr_to_anyname;
+	xtables_ipmask_to_numeric;
+	xtables_numeric_to_ipaddr;
+	xtables_numeric_to_ipmask;
+	xtables_ipparse_any;
+	xtables_ip6addr_to_numeric;
+	xtables_ip6addr_to_anyname;
+	xtables_ip6mask_to_numeric;
+	xtables_numeric_to_ip6addr;
+	xtables_ip6parse_any;
+	xtables_save_string;
+	xtables_check_inverse;
+	xtables_chain_protos;
+	xtables_parse_protocol;
+} XTABLES_1.4.2;
+
+XTABLES_1.4.5 {
+global:
+	xtables_register_matches;
+	xtables_register_targets;
+	xtables_ipparse_multiple;
+	xtables_ip6parse_multiple;
+} XTABLES_1.4.3;
+
+XTABLES_1.4.11 {
+global:
+	xtables_merge_options;
+} XTABLES_1.4.5;
-- 
1.7.1

