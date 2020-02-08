Return-Path: <SRS0=ODwG=34=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8141BC2BA83
	for <netfilter-devel@archiver.kernel.org>; Sat,  8 Feb 2020 01:29:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5764320720
	for <netfilter-devel@archiver.kernel.org>; Sat,  8 Feb 2020 01:29:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbgBHB27 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 Feb 2020 20:28:59 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:58098 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726995AbgBHB27 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Feb 2020 20:28:59 -0500
Received: from dimstar.local.net (n175-34-107-236.sun1.vic.optusnet.com.au [175.34.107.236])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id C007C3A2070
        for <netfilter-devel@vger.kernel.org>; Sat,  8 Feb 2020 12:28:45 +1100 (AEDT)
Received: (qmail 30523 invoked by uid 501); 8 Feb 2020 01:28:44 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] build: doc: "make" builds & installs a full set of man pages
Date:   Sat,  8 Feb 2020 12:28:44 +1100
Message-Id: <20200208012844.30481-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=HhxO2xtGR2hgo/TglJkeQA==:117 a=HhxO2xtGR2hgo/TglJkeQA==:17
        a=l697ptgUJYAA:10 a=RSmzAf-M6YYA:10 a=PO7r1zJSAAAA:8
        a=Fi3n4qMARjyx1FuMom0A:9
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This enables one to enter "man <any nfq function>" and get the appropriate
group man page created by doxygen.

 - New makefile in doxygen directory. Rebuilds documentation if any sources
   change that contain doxygen comments, or if fixmanpages.sh changes
 - New shell script fixmanpages.sh which
   - Renames each group man page to the first function listed therein
   - Creates symlinks for subsequently listed functions (if any)
   - Deletes _* temp files
 - Update top-level makefile to visit new subdir doxygen
 - Update top-level configure to only build documentation if doxygen installed

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 Makefile.am         |  2 +-
 configure.ac        | 10 +++++++++
 doxygen/Makefile.am | 23 ++++++++++++++++++++
 fixmanpages.sh      | 62 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 96 insertions(+), 1 deletion(-)
 create mode 100644 doxygen/Makefile.am
 create mode 100755 fixmanpages.sh

diff --git a/Makefile.am b/Makefile.am
index 6b4ef77..a5b347b 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -2,7 +2,7 @@ ACLOCAL_AMFLAGS = -I m4
 
 EXTRA_DIST = $(man_MANS) include/linux
 
-SUBDIRS = src utils include examples
+SUBDIRS = src utils include examples doxygen
 
 man_MANS = #nfnetlink_queue.3 nfnetlink_queue.7
 
diff --git a/configure.ac b/configure.ac
index 0c08459..e99b07a 100644
--- a/configure.ac
+++ b/configure.ac
@@ -33,5 +33,15 @@ dnl Output the makefiles
 AC_CONFIG_FILES([Makefile src/Makefile utils/Makefile examples/Makefile
         libnetfilter_queue.pc doxygen.cfg
 	include/Makefile include/libnetfilter_queue/Makefile
+	doxygen/Makefile
 	include/linux/Makefile include/linux/netfilter/Makefile])
 AC_OUTPUT
+
+dnl Only run doxygen Makefile if doxygen installed
+
+AC_CHECK_PROGS([DOXYGEN], [doxygen])
+if test -z "$DOXYGEN";
+	then AC_MSG_WARN([Doxygen not found - continuing without Doxygen support])
+fi
+
+ AM_CONDITIONAL([HAVE_DOXYGEN], [test -n "$DOXYGEN"])
diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
new file mode 100644
index 0000000..ef468e0
--- /dev/null
+++ b/doxygen/Makefile.am
@@ -0,0 +1,23 @@
+if HAVE_DOXYGEN
+doc_srcs = $(top_srcdir)/src/libnetfilter_queue.c  \
+           $(top_srcdir)/src/nlmsg.c               \
+           $(top_srcdir)/src/extra/checksum.c      \
+           $(top_srcdir)/src/extra/ipv6.c          \
+           $(top_srcdir)/src/extra/ipv4.c          \
+           $(top_srcdir)/src/extra/tcp.c           \
+           $(top_srcdir)/src/extra/udp.c           \
+           $(top_srcdir)/src/extra/pktbuff.c
+
+doxyfile.stamp: $(doc_srcs) $(top_srcdir)/fixmanpages.sh
+	rm -rf html man && cd .. && doxygen doxygen.cfg && ./fixmanpages.sh
+	touch doxyfile.stamp
+
+CLEANFILES = doxyfile.stamp
+
+all-local: doxyfile.stamp
+clean-local:
+	rm -rf $(top_srcdir)/doxygen/man $(top_srcdir)/doxygen/html
+install-data-local:
+	mkdir -p $(DESTDIR)$(mandir)/man3
+	cp --no-dereference --preserve=links,mode,timestamps man/man3/*.3 $(DESTDIR)$(mandir)/man3/
+endif
diff --git a/fixmanpages.sh b/fixmanpages.sh
new file mode 100755
index 0000000..897086b
--- /dev/null
+++ b/fixmanpages.sh
@@ -0,0 +1,62 @@
+#!/bin/bash -p
+#set -x
+function main
+{
+  set -e
+  cd doxygen/man/man3
+  rm -f _*
+  setgroup LibrarySetup nfq_open
+    add2group nfq_close nfq_bind_pf nfq_unbind_pf
+  setgroup Parsing nfq_get_msg_packet_hdr
+    add2group nfq_get_nfmark nfq_get_timestamp nfq_get_indev nfq_get_physindev
+    add2group nfq_get_outdev nfq_get_physoutdev nfq_get_indev_name
+    add2group nfq_get_physindev_name nfq_get_outdev_name
+    add2group nfq_get_physoutdev_name nfq_get_packet_hw nfq_get_uid
+    add2group nfq_get_gid nfq_get_secctx nfq_get_payload
+  setgroup Queue nfq_fd
+    add2group nfq_create_queue nfq_destroy_queue nfq_handle_packet nfq_set_mode
+    add2group nfq_set_queue_flags nfq_set_queue_maxlen nfq_set_verdict
+    add2group nfq_set_verdict2 nfq_set_verdict_batch
+    add2group nfq_set_verdict_batch2 nfq_set_verdict_mark
+  setgroup ipv4 nfq_ip_get_hdr
+    add2group nfq_ip_set_transport_header nfq_ip_mangle nfq_ip_snprintf
+    setgroup ip_internals nfq_ip_set_checksum
+  setgroup ipv6 nfq_ip6_get_hdr
+    add2group nfq_ip6_set_transport_header nfq_ip6_mangle nfq_ip6_snprintf
+  setgroup nfq_cfg nfq_nlmsg_cfg_put_cmd
+    add2group nfq_nlmsg_cfg_put_params nfq_nlmsg_cfg_put_qmaxlen
+  setgroup nfq_verd nfq_nlmsg_verdict_put
+    add2group nfq_nlmsg_verdict_put_mark nfq_nlmsg_verdict_put_pkt
+  setgroup nlmsg nfq_nlmsg_parse
+  setgroup pktbuff pktb_alloc
+    add2group pktb_data pktb_len pktb_mangle pktb_mangled
+    add2group pktb_free
+    setgroup otherfns pktb_tailroom
+      add2group pktb_mac_header pktb_network_header pktb_transport_header
+      setgroup uselessfns pktb_push
+        add2group pktb_pull pktb_put pktb_trim
+  setgroup tcp nfq_tcp_get_hdr
+    add2group nfq_tcp_get_payload nfq_tcp_get_payload_len
+    add2group nfq_tcp_snprintf nfq_tcp_mangle_ipv4 nfq_tcp_mangle_ipv6
+    setgroup tcp_internals nfq_tcp_compute_checksum_ipv4
+      add2group nfq_tcp_compute_checksum_ipv6
+  setgroup udp nfq_udp_get_hdr
+    add2group nfq_udp_get_payload nfq_udp_get_payload_len
+    add2group nfq_udp_mangle_ipv4 nfq_udp_mangle_ipv6 nfq_udp_snprintf
+    setgroup udp_internals nfq_udp_compute_checksum_ipv4
+      add2group nfq_udp_compute_checksum_ipv6
+  setgroup Printing nfq_snprintf_xml
+}
+function setgroup
+{
+  mv $1.3 $2.3
+  BASE=$2
+}
+function   add2group
+{
+  for i in $@
+  do
+    ln -sf $BASE.3 $i.3
+  done
+}
+main
-- 
2.14.5

