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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A8ACC433B4
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Apr 2021 04:24:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C4E861002
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Apr 2021 04:24:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbhDTEZP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Apr 2021 00:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhDTEZO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Apr 2021 00:25:14 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B32EC06174A
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Apr 2021 21:24:43 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id lr7so2999336pjb.2
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Apr 2021 21:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ARfAes66Iy80u83eJL04ljfPkeqkr/mSMxcSrVUIsZM=;
        b=Gmx3deSHUxair6UYO1kRnVA4aeHllGyL+Zhb4xhV9zMIwArJIvRQTXnrETchtIhLp5
         U5bXj4GyAfyWGedpWZSJS1LFSe4VMfHTQgwOD10AaC0AdnNrKHEJpkWtUhC4ZeIVcMZ1
         cqkXwmdZ+nnny5HZFY7C/7AHddsJFPFcyrpLQVHhnZ6+OuVb+Dm5kbQK2N/HyXi5RXyo
         nIh6JFu3hY+RpX2tzrf201LWN+zq8oN+1VXeZh1GTWAYOgPzkcZJLOP9VpSMQ+l3Ug1t
         gZ8HvJQqQkGfF1t1y2ouC6KQpMXpk+LOTv3EPW6a5IsgwA9bjgTHn+a6HAjf0BonZTlY
         M0yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ARfAes66Iy80u83eJL04ljfPkeqkr/mSMxcSrVUIsZM=;
        b=BONcfkzCJC9uNrbQykNottNtxg8D8ODvUV0+z1WUNj1G9K+OSF+G3yqmocyORK9Bnv
         acZjNxI/4+1loXh9OBIEeA5bvZHigaj9DqtvJXRRqAYICMM7ZvA6WpZriWbhds7tsxop
         CT6M5VGcxU8u6G6sA7doII9OKY7OWB/Qtdv1uiiAT5C4rnQplKx77B4U1bdvWd0pQDPO
         4qBaGIgtt0aBfkiRnEd/LVk9sJll9ZpMrhIRYkFq2fvqtHNU9u7SoUq+dZ5ZZels54f+
         YArc/Ikq5b1utFJPle9MprMe8UzT+Y35klUhooS5P6D6oAQ/k6agEPABs58kPD6rFdEA
         GoYA==
X-Gm-Message-State: AOAM533dovnwSc5iD6rRq9pD3Sh1ltpQ6NIYCBF7lpFLASAv0VzbpZbO
        lY5ZqfRttRCTmEiLOEBu2KF07/Qb7JAOEQ==
X-Google-Smtp-Source: ABdhPJxnaJJynE0gIr2nBGv+yJaSRDhOUatFhjWCaJY7uNVL0Ipno40LdaakRrRT/5CGLHlFXVAMuA==
X-Received: by 2002:a17:903:30c3:b029:ea:afe2:56f5 with SMTP id s3-20020a17090330c3b02900eaafe256f5mr27055427plc.64.1618892681749;
        Mon, 19 Apr 2021 21:24:41 -0700 (PDT)
Received: from slk1.local.net (n49-192-36-100.sun3.vic.optusnet.com.au. [49.192.36.100])
        by smtp.gmail.com with ESMTPSA id 71sm8557510pfu.19.2021.04.19.21.24.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 21:24:41 -0700 (PDT)
From:   Duncan Roe <duncan.roe2@gmail.com>
X-Google-Original-From: Duncan Roe <duncan_roe@optusnet.com.au>
To:     netfilter-devel@vger.kernel.org
Cc:     duncan_roe@optusnet.com.au
Subject: [PATCH libnetfilter_queue 1/1] build: doc: `make distcheck` passes with doxygen enabled
Date:   Tue, 20 Apr 2021 14:23:58 +1000
Message-Id: <20210420042358.2829-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210420042358.2829-1-duncan_roe@optusnet.com.au>
References: <20210420042358.2829-1-duncan_roe@optusnet.com.au>
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
index 32e4990..3f4a082 100644
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
+if test -z "$DOXYGEN"; then
+	dnl Only run doxygen Makefile if doxygen installed
+	AC_MSG_WARN([Doxygen not found - continuing without Doxygen support])
+fi
 AC_OUTPUT
 
 echo "
diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
index 0f99feb..1b217d3 100644
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
+	cd ..; [ $$(ls src | wc -l) -gt 8 ] ||\
+{ set -x; mv src src.distcheck; ln -s $(top_srcdir)/src; }
+
+	cd ..; doxygen doxygen.cfg >/dev/null
+
+	[ ! -d ../src.distcheck ] || \
+{ set -x; cd ..; rm src; mv src.distcheck src; }
+
+# Keep this command up to date after adding new functions and source files.
+# The command has to be a single line so the functions work
+# (hence ";\" at the end of every line but the last).
+	function main { set -e; cd man/man3; rm -f _*;\
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
+function setgroup { mv $$1.3 $$2.3; BASE=$$2; };\
+function add2group { for i in $$@; do ln -sf $$BASE.3 $$i.3; done; };\
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

