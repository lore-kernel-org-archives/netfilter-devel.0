Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 952E2C433ED
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Apr 2021 09:36:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61D0761422
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Apr 2021 09:36:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235528AbhDVJgf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Apr 2021 05:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235551AbhDVJgf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Apr 2021 05:36:35 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A2D1C06174A
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Apr 2021 02:36:01 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id u15so14681934plf.10
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Apr 2021 02:36:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dnExj6ZFO8zhUtV03mpPSoUb37zI2zCqsyluG57ndR4=;
        b=mvMjsya/9E1ErjUfyIJMlo6Z/y05ruW0Kk8Iff5uMu1GAGrXrqM7a6+jIeX6/mH+mY
         QQ92YiHihccQFRRk1Rvf0K+XfnDggChFlWTdZvHh6HfSB6Cb6k67NVGQVaFoP6mD2HVj
         FYe5g0GwqRyh4Zcg7DDSCQeYzAcHymneIUBOfl9ruHyl2VWke3Zh9WOqJMM5FEiUcqDn
         OeI9RGaiePxNjnTieK8pfrQlWnQKnOPs3b+UbIQXd9AxYpPODslInixPowODMg0MthYf
         ED0L9jgXcPBKbA1gVOx1RBujsDW6fb/3Ot5g6xolF+Vpw/jnnTpLTbrbQFK5R682vBcW
         0sMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dnExj6ZFO8zhUtV03mpPSoUb37zI2zCqsyluG57ndR4=;
        b=ogwh6A9YZ3vmPXs2G5g04hFBqj2nGeAqJe2nhSnjw+l201q95kP4g8XeUqBM/Og7Zz
         ck8WkDevy6C0kHRypnDB57LgMAluE6WW7lkbCMkO3Jl9y/0jT5nByz5v+oYeVQR78Gu0
         PeSzrC+JGe4bU9CNJFKL7GkafuzvrMssVwRk5MVsrCrLmtBYtDbvdxiJrX8AqSRhtBJq
         hJcbULeAr4kgjEaNXToqQpRy/eg0+dugC5nPNm7IVa0h9yDin/RXiDPqkyP2nbeYSrhY
         N5DhcqvA5diMwFLjQmKOt6UxI3HduSW154iFBwyGs4mg603sWPGbVWguQ/m1hQqZsQfR
         SFeQ==
X-Gm-Message-State: AOAM5323XnOVeFhJ63RjV7JliEEPtG75rV/9kXXl9hHj11GoRLlFTpsN
        +P+Dpx+LrurNxHxnv0Fe1Vnlp4eXVMbe3w==
X-Google-Smtp-Source: ABdhPJz3/IQeSauIb538cGOkc8ohlQe7UyR+GAf3GArMuznMW6hosCXiO2uRrYvQ3OtCeIDIhgP+aw==
X-Received: by 2002:a17:90a:f2d7:: with SMTP id gt23mr16321529pjb.199.1619084160562;
        Thu, 22 Apr 2021 02:36:00 -0700 (PDT)
Received: from slk1.local.net (n49-192-36-100.sun3.vic.optusnet.com.au. [49.192.36.100])
        by smtp.gmail.com with ESMTPSA id c11sm1743324pgk.83.2021.04.22.02.35.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 02:35:59 -0700 (PDT)
From:   Duncan Roe <duncan.roe2@gmail.com>
X-Google-Original-From: Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, jengelh@inai.de,
        duncan_roe@optusnet.com.au
Subject: [PATCH libnetfilter_queue v2] build: doc: `make distcheck` passes with doxygen enabled
Date:   Thu, 22 Apr 2021 19:35:44 +1000
Message-Id: <20210422093544.5460-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <s6o3s8n-8486-r468-728s-4384736oqq@vanv.qr>
References: <s6o3s8n-8486-r468-728s-4384736oqq@vanv.qr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The main fix is to move fixmanpages.sh to inside doxygen/Makefile.am.

This means that in future, developers need to update doxygen/Makefile.am
when they add new functions and source files, since fixmanpages.sh is deleted.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
v2: Implement suggestions from Jan Engelhardt <jengelh@inai.de>

 Makefile.am         |  1 -
 configure.ac        | 11 +++++--
 doxygen/Makefile.am | 76 +++++++++++++++++++++++++++++++++++++++++++--
 fixmanpages.sh      | 66 ---------------------------------------
 4 files changed, 82 insertions(+), 72 deletions(-)
 delete mode 100755 fixmanpages.sh

diff --git a/Makefile.am b/Makefile.am
index 796f0d0..a5b347b 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -10,4 +10,3 @@ pkgconfigdir = $(libdir)/pkgconfig
 pkgconfig_DATA = libnetfilter_queue.pc
 
 EXTRA_DIST += Make_global.am
-EXTRA_DIST += fixmanpages.sh
diff --git a/configure.ac b/configure.ac
index 32e4990..bdbee98 100644
--- a/configure.ac
+++ b/configure.ac
@@ -37,9 +37,10 @@ AC_CONFIG_FILES([Makefile src/Makefile utils/Makefile examples/Makefile
 	include/linux/Makefile include/linux/netfilter/Makefile])
 
 AC_ARG_WITH([doxygen], [AS_HELP_STRING([--with-doxygen],
-	    [create doxygen documentation [default=no]])],
-	    [], [with_doxygen=no])
-AS_IF([test "x$with_doxygen" = xyes], [
+	    [create doxygen documentation])],
+	    [with_doxygen="$withval"], [with_doxygen=yes])
+
+AS_IF([test "x$with_doxygen" != xno], [
 	AC_CHECK_PROGS([DOXYGEN], [doxygen])
 	AC_CHECK_PROGS([DOT], [dot], [""])
 	AS_IF([test "x$DOT" != "x"],
@@ -48,6 +49,10 @@ AS_IF([test "x$with_doxygen" = xyes], [
 ])
 
 AM_CONDITIONAL([HAVE_DOXYGEN], [test -n "$DOXYGEN"])
+AS_IF([test "x$DOXYGEN" = x], [
+	dnl Only run doxygen Makefile if doxygen installed
+	AC_MSG_WARN([Doxygen not found - continuing without Doxygen support])
+])
 AC_OUTPUT
 
 echo "
diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
index 0f99feb..b4268a5 100644
--- a/doxygen/Makefile.am
+++ b/doxygen/Makefile.am
@@ -1,4 +1,6 @@
 if HAVE_DOXYGEN
+
+# Be sure to add new source files to this table
 doc_srcs = $(top_srcdir)/src/libnetfilter_queue.c  \
            $(top_srcdir)/src/nlmsg.c               \
            $(top_srcdir)/src/extra/checksum.c      \
@@ -9,8 +11,74 @@ doc_srcs = $(top_srcdir)/src/libnetfilter_queue.c  \
            $(top_srcdir)/src/extra/icmp.c          \
            $(top_srcdir)/src/extra/pktbuff.c
 
-doxyfile.stamp: $(doc_srcs) $(top_srcdir)/fixmanpages.sh
-	rm -rf html man && cd .. && doxygen doxygen.cfg >/dev/null && ./fixmanpages.sh
+doxyfile.stamp: $(doc_srcs) Makefile.am
+	rm -rf html man
+
+# Test for running under make distcheck.
+# If so, sibling src directory will be empty:
+# move it out of the way and symlink the real one while we run doxygen.
+	[ -f ../src/Makefile.in ] || \
+{ set -x; cd ..; mv src src.distcheck; ln -s $(top_srcdir)/src; }
+
+	cd ..; doxygen doxygen.cfg >/dev/null
+
+	[ ! -d ../src.distcheck ] || \
+{ set -x; cd ..; rm src; mv src.distcheck src; }
+
+# Keep this command up to date after adding new functions and source files.
+# The command has to be a single line so the functions work
+# (hence ";\" at the end of every line but the last).
+	main() { set -e; cd man/man3; rm -f _*;\
+setgroup LibrarySetup nfq_open;\
+  add2group nfq_close nfq_bind_pf nfq_unbind_pf;\
+setgroup Parsing nfq_get_msg_packet_hdr;\
+  add2group nfq_get_nfmark nfq_get_timestamp nfq_get_indev nfq_get_physindev;\
+  add2group nfq_get_outdev nfq_get_physoutdev nfq_get_indev_name;\
+  add2group nfq_get_physindev_name nfq_get_outdev_name;\
+  add2group nfq_get_physoutdev_name nfq_get_packet_hw;\
+  add2group nfq_get_skbinfo;\
+  add2group nfq_get_uid nfq_get_gid;\
+  add2group nfq_get_secctx nfq_get_payload;\
+setgroup Queue nfq_fd;\
+  add2group nfq_create_queue nfq_destroy_queue nfq_handle_packet nfq_set_mode;\
+  add2group nfq_set_queue_flags nfq_set_queue_maxlen nfq_set_verdict;\
+  add2group nfq_set_verdict2 nfq_set_verdict_batch;\
+  add2group nfq_set_verdict_batch2 nfq_set_verdict_mark;\
+setgroup ipv4 nfq_ip_get_hdr;\
+  add2group nfq_ip_set_transport_header nfq_ip_mangle nfq_ip_snprintf;\
+  setgroup ip_internals nfq_ip_set_checksum;\
+setgroup ipv6 nfq_ip6_get_hdr;\
+  add2group nfq_ip6_set_transport_header nfq_ip6_mangle nfq_ip6_snprintf;\
+setgroup nfq_cfg nfq_nlmsg_cfg_put_cmd;\
+  add2group nfq_nlmsg_cfg_put_params nfq_nlmsg_cfg_put_qmaxlen;\
+setgroup nfq_verd nfq_nlmsg_verdict_put;\
+  add2group nfq_nlmsg_verdict_put_mark nfq_nlmsg_verdict_put_pkt;\
+setgroup nlmsg nfq_nlmsg_parse;\
+  add2group nfq_nlmsg_put;\
+setgroup pktbuff pktb_alloc;\
+  add2group pktb_data pktb_len pktb_mangle pktb_mangled;\
+  add2group pktb_free;\
+  setgroup otherfns pktb_tailroom;\
+    add2group pktb_mac_header pktb_network_header pktb_transport_header;\
+    setgroup uselessfns pktb_push;\
+      add2group pktb_pull pktb_put pktb_trim;\
+setgroup tcp nfq_tcp_get_hdr;\
+  add2group nfq_tcp_get_payload nfq_tcp_get_payload_len;\
+  add2group nfq_tcp_snprintf nfq_tcp_mangle_ipv4 nfq_tcp_mangle_ipv6;\
+  setgroup tcp_internals nfq_tcp_compute_checksum_ipv4;\
+    add2group nfq_tcp_compute_checksum_ipv6;\
+setgroup udp nfq_udp_get_hdr;\
+  add2group nfq_udp_get_payload nfq_udp_get_payload_len;\
+  add2group nfq_udp_mangle_ipv4 nfq_udp_mangle_ipv6 nfq_udp_snprintf;\
+  setgroup udp_internals nfq_udp_compute_checksum_ipv4;\
+    add2group nfq_udp_compute_checksum_ipv6;\
+setgroup Printing nfq_snprintf_xml;\
+setgroup icmp nfq_icmp_get_hdr;\
+};\
+setgroup() { mv $$1.3 $$2.3; BASE=$$2; };\
+add2group() { for i in $$@; do ln -sf $$BASE.3 $$i.3; done; };\
+main
+
 	touch doxyfile.stamp
 
 CLEANFILES = doxyfile.stamp
@@ -21,4 +89,8 @@ clean-local:
 install-data-local:
 	mkdir -p $(DESTDIR)$(mandir)/man3
 	cp --no-dereference --preserve=links,mode,timestamps man/man3/*.3 $(DESTDIR)$(mandir)/man3/
+
+# make distcheck needs uninstall-local
+uninstall-local:
+	rm -r $(DESTDIR)$(mandir) man html doxyfile.stamp
 endif
diff --git a/fixmanpages.sh b/fixmanpages.sh
deleted file mode 100755
index 02064ab..0000000
--- a/fixmanpages.sh
+++ /dev/null
@@ -1,66 +0,0 @@
-#!/bin/bash -p
-#set -x
-function main
-{
-  set -e
-  cd doxygen/man/man3
-  rm -f _*
-  setgroup LibrarySetup nfq_open
-    add2group nfq_close nfq_bind_pf nfq_unbind_pf
-  setgroup Parsing nfq_get_msg_packet_hdr
-    add2group nfq_get_nfmark nfq_get_timestamp nfq_get_indev nfq_get_physindev
-    add2group nfq_get_outdev nfq_get_physoutdev nfq_get_indev_name
-    add2group nfq_get_physindev_name nfq_get_outdev_name
-    add2group nfq_get_physoutdev_name nfq_get_packet_hw
-    add2group nfq_get_skbinfo
-    add2group nfq_get_uid nfq_get_gid
-    add2group nfq_get_secctx nfq_get_payload
-  setgroup Queue nfq_fd
-    add2group nfq_create_queue nfq_destroy_queue nfq_handle_packet nfq_set_mode
-    add2group nfq_set_queue_flags nfq_set_queue_maxlen nfq_set_verdict
-    add2group nfq_set_verdict2 nfq_set_verdict_batch
-    add2group nfq_set_verdict_batch2 nfq_set_verdict_mark
-  setgroup ipv4 nfq_ip_get_hdr
-    add2group nfq_ip_set_transport_header nfq_ip_mangle nfq_ip_snprintf
-    setgroup ip_internals nfq_ip_set_checksum
-  setgroup ipv6 nfq_ip6_get_hdr
-    add2group nfq_ip6_set_transport_header nfq_ip6_mangle nfq_ip6_snprintf
-  setgroup nfq_cfg nfq_nlmsg_cfg_put_cmd
-    add2group nfq_nlmsg_cfg_put_params nfq_nlmsg_cfg_put_qmaxlen
-  setgroup nfq_verd nfq_nlmsg_verdict_put
-    add2group nfq_nlmsg_verdict_put_mark nfq_nlmsg_verdict_put_pkt
-  setgroup nlmsg nfq_nlmsg_parse
-    add2group nfq_nlmsg_put
-  setgroup pktbuff pktb_alloc
-    add2group pktb_data pktb_len pktb_mangle pktb_mangled
-    add2group pktb_free
-    setgroup otherfns pktb_tailroom
-      add2group pktb_mac_header pktb_network_header pktb_transport_header
-      setgroup uselessfns pktb_push
-        add2group pktb_pull pktb_put pktb_trim
-  setgroup tcp nfq_tcp_get_hdr
-    add2group nfq_tcp_get_payload nfq_tcp_get_payload_len
-    add2group nfq_tcp_snprintf nfq_tcp_mangle_ipv4 nfq_tcp_mangle_ipv6
-    setgroup tcp_internals nfq_tcp_compute_checksum_ipv4
-      add2group nfq_tcp_compute_checksum_ipv6
-  setgroup udp nfq_udp_get_hdr
-    add2group nfq_udp_get_payload nfq_udp_get_payload_len
-    add2group nfq_udp_mangle_ipv4 nfq_udp_mangle_ipv6 nfq_udp_snprintf
-    setgroup udp_internals nfq_udp_compute_checksum_ipv4
-      add2group nfq_udp_compute_checksum_ipv6
-  setgroup Printing nfq_snprintf_xml
-  setgroup icmp nfq_icmp_get_hdr
-}
-function setgroup
-{
-  mv $1.3 $2.3
-  BASE=$2
-}
-function add2group
-{
-  for i in $@
-  do
-    ln -sf $BASE.3 $i.3
-  done
-}
-main
-- 
2.17.5

