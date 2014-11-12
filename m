From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH] build: add and use a symbol version map
Date: Wed, 12 Nov 2014 14:06:47 +0100
Message-ID: <1415797607-28793-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:51430 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455AbaKLNGt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Nov 2014 08:06:49 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It was possible to combine e.g. conntrackd-1.2.1 with
libnetfilter_conntrack-0.0.101, causing libc to issue an exit from
within conntrackd iff such a conntrackd was promoted to a master and
tried to call nfexp_send, due to lazy symbol resolution in libc.

Symbol versions enforce the checks at program startup, so add one.

$ ldd -r /usr/sbin/conntrackd
undefined symbol: nfexp_cmp     (/usr/sbin/conntrackd)
undefined symbol: nfexp_send    (/usr/sbin/conntrackd)
        libnetfilter_conntrack.so.3 => /usr/lib/libnetfilter_conntrack.so.3 (0x77fe7000)
        libnfnetlink.so.0 => /usr/lib/libnfnetlink.so.0 (0x77fdf000)
        libc.so.6 => /lib/libc.so.6 (0x77e7b000)
        libdl.so.2 => /lib/libdl.so.2 (0x77e76000)
        /lib/ld.so.1 (0x55555000)
$ dpkg-query -W conntrackd libnetfilter-conntrack3
conntrackd      1:1.2.1-1
libnetfilter-conntrack3 0.0.101-1

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 src/Makefile.am                |   4 +-
 src/libnetfilter_conntrack.map | 109 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 112 insertions(+), 1 deletion(-)
 create mode 100644 src/libnetfilter_conntrack.map

diff --git a/src/Makefile.am b/src/Makefile.am
index 7d6c905..918c2ba 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -12,5 +12,7 @@ libnetfilter_conntrack_la_LIBADD = conntrack/libnfconntrack.la \
 				   expect/libnfexpect.la \
 				   ${LIBNFNETLINK_LIBS} ${LIBMNL_LIBS}
 libnetfilter_conntrack_la_LDFLAGS = -Wc,-nostartfiles -lnfnetlink -ldl 	\
-				    -version-info $(LIBVERSION)
+				    -version-info $(LIBVERSION) \
+				    -Wl,--version-script=$(srcdir)/libnetfilter_conntrack.map
 libnetfilter_conntrack_la_SOURCES = main.c callback.c
+libnetfilter_conntrack_la_DEPENDENCIES = libnetfilter_conntrack.map
diff --git a/src/libnetfilter_conntrack.map b/src/libnetfilter_conntrack.map
new file mode 100644
index 0000000..c6404d5
--- /dev/null
+++ b/src/libnetfilter_conntrack.map
@@ -0,0 +1,109 @@
+V_1.0.5 {
+global:
+	nfct_attr_grp_is_set;
+	nfct_attr_grp_unset;
+	nfct_attr_is_set;
+	nfct_attr_is_set_array;
+	nfct_attr_unset;
+	nfct_bitmask_clear;
+	nfct_bitmask_clone;
+	nfct_bitmask_destroy;
+	nfct_bitmask_equal;
+	nfct_bitmask_maxbit;
+	nfct_bitmask_new;
+	nfct_bitmask_set_bit;
+	nfct_bitmask_test_bit;
+	nfct_bitmask_unset_bit;
+	nfct_build_conntrack;
+	nfct_build_query;
+	nfct_build_tuple;
+	nfct_callback_register;
+	nfct_callback_register2;
+	nfct_callback_unregister;
+	nfct_callback_unregister2;
+	nfct_catch;
+	nfct_clone;
+	nfct_close;
+	nfct_cmp;
+	nfct_compare;
+	nfct_copy;
+	nfct_copy_attr;
+	nfct_destroy;
+	nfct_fd;
+	nfct_filter_add_attr;
+	nfct_filter_add_attr_u32;
+	nfct_filter_attach;
+	nfct_filter_create;
+	nfct_filter_destroy;
+	nfct_filter_detach;
+	nfct_filter_dump_create;
+	nfct_filter_dump_destroy;
+	nfct_filter_dump_set_attr;
+	nfct_filter_dump_set_attr_u8;
+	nfct_filter_set_logic;
+	nfct_get_attr;
+	nfct_get_attr_grp;
+	nfct_get_attr_u16;
+	nfct_get_attr_u32;
+	nfct_get_attr_u64;
+	nfct_get_attr_u8;
+	nfct_getobjopt;
+	nfct_labelmap_destroy;
+	nfct_labelmap_get_bit;
+	nfct_labelmap_get_name;
+	nfct_labelmap_new;
+	nfct_maxsize;
+	nfct_new;
+	nfct_nfnlh;
+	nfct_nlmsg_build;
+	nfct_nlmsg_parse;
+	nfct_open;
+	nfct_open_nfnl;
+	nfct_parse_conntrack;
+	nfct_parse_tuple;
+	nfct_payload_parse;
+	nfct_query;
+	nfct_send;
+	nfct_set_attr;
+	nfct_set_attr_grp;
+	nfct_set_attr_l;
+	nfct_set_attr_u16;
+	nfct_set_attr_u32;
+	nfct_set_attr_u64;
+	nfct_set_attr_u8;
+	nfct_setobjopt;
+	nfct_sizeof;
+	nfct_snprintf;
+	nfct_snprintf_labels;
+	nfexp_attr_is_set;
+	nfexp_attr_unset;
+	nfexp_build_expect;
+	nfexp_build_query;
+	nfexp_callback_register;
+	nfexp_callback_register2;
+	nfexp_callback_unregister;
+	nfexp_callback_unregister2;
+	nfexp_catch;
+	nfexp_clone;
+	nfexp_cmp;
+	nfexp_destroy;
+	nfexp_get_attr;
+	nfexp_get_attr_u16;
+	nfexp_get_attr_u32;
+	nfexp_get_attr_u8;
+	nfexp_maxsize;
+	nfexp_new;
+	nfexp_nlmsg_build;
+	nfexp_nlmsg_parse;
+	nfexp_parse_expect;
+	nfexp_query;
+	nfexp_send;
+	nfexp_set_attr;
+	nfexp_set_attr_u16;
+	nfexp_set_attr_u32;
+	nfexp_set_attr_u8;
+	nfexp_sizeof;
+	nfexp_snprintf;
+local:
+	*;
+};
-- 
2.1.2

