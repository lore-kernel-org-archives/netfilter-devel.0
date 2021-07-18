Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 737DDC636CA
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Jul 2021 03:52:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4ABE361166
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Jul 2021 03:52:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233156AbhGRDzq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 17 Jul 2021 23:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbhGRDzp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 17 Jul 2021 23:55:45 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6141C061762
        for <netfilter-devel@vger.kernel.org>; Sat, 17 Jul 2021 20:52:47 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 62so15130807pgf.1
        for <netfilter-devel@vger.kernel.org>; Sat, 17 Jul 2021 20:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EK+k39SuCgZEHFRVqLY3TEsYPVsJDUaKVZeg3PIUXfE=;
        b=fgZaFo27a12rOrPzt8EvEl43XHmhugCEaLfXtGQ9JRl/UZ8PoFaQyLskMIxiSEOUW6
         0zBpoqr7nTCED/kwWhvaz+hVEDErZqKu0Un9vOpEvpmvxnA7SOmWwEIP5fgq+IUaypwl
         IXamIlbowhGWyHTuJGpTwwXW5sUNm8u+nLPofoZiG0AGaW9zDxv1sfLmLpGZ6jcoFP8z
         IAPizx66GUS9Wb4EAB0PHvSLdBrTgooUj1DCuGJA7E3L84185C8U0O9ejy0wCHDrlhv8
         1EjefyYeSpZhKTpHjOpU6ecxw42I/D3nphHLMl8+eO9X3Cmjf2aVGqenJggiAW8S//YQ
         Jcug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=EK+k39SuCgZEHFRVqLY3TEsYPVsJDUaKVZeg3PIUXfE=;
        b=TuuV50jgG7SOXng4jsu6pvyd57cpXr6ujNqfLhez21MdfvbvmwXWYyIouK0jm3eTx0
         42P4jd1Qw1ZN/4lK03sSAWRmXxh7IBWhAwW8tnfYppPDv7OOAUcpXfP5o5t+lC5mriMP
         Gf9elNajnORyUR26VX6kWbK3QUITx9mVNdAX+icahJ1BhJ80zMh7KU6zfFkd8KGPU2Ws
         J9uolk0ayAoGVdKvyseDVnoGwwoFT2kLGJH98rj6l6LyPsQH7HRepZOW9977n2E2eWbK
         1G4skmQ4bloYbjqBuRDaJ2d8mg6e5/BP/ewpC1SjFDJzHqCobJTtCxWkMVKvnzJ5TIoX
         MfLw==
X-Gm-Message-State: AOAM530oefxDW2sBKj9rcjtQaj4+8X1QhijsNCWP4503tPUqwawrTJQD
        SRdjqb63ilNw1+4rY2u42uHSYBdzt+5hiA==
X-Google-Smtp-Source: ABdhPJyMz6xk0eHren2gvZNOrTbeTqglVAcClQhYZhMyfjPYo60Xs5iY3YBlj84KM3zNdmCzrXYlsA==
X-Received: by 2002:a05:6a00:a88:b029:31a:c2ef:d347 with SMTP id b8-20020a056a000a88b029031ac2efd347mr18829676pfl.20.1626580367259;
        Sat, 17 Jul 2021 20:52:47 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id w10sm16424508pgl.46.2021.07.17.20.52.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jul 2021 20:52:46 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] build: doc: get rid of the need for manual updating of Makefile
Date:   Sun, 18 Jul 2021 13:52:42 +1000
Message-Id: <20210718035242.25370-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There used to be 3 things in doxygen/Makefile.am that developers had to update:

1. The dependency list (i.e. all C sources)

2. The setgroup lines, which renamed each module man page to be the page for the
   first described function. setgroup also set the target for:

3. The add2group lines, which symlinked pages for other documented functions
   in the group.

The new system eliminates all of the above.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doxygen.cfg.in      |  1 +
 doxygen/Makefile.am | 92 +++++++++++++++------------------------------
 2 files changed, 32 insertions(+), 61 deletions(-)

diff --git a/doxygen.cfg.in b/doxygen.cfg.in
index 4c16e3e..266782e 100644
--- a/doxygen.cfg.in
+++ b/doxygen.cfg.in
@@ -23,5 +23,6 @@ SEARCHENGINE           = NO
 GENERATE_LATEX         = NO
 LATEX_CMD_NAME         = latex
 GENERATE_MAN           = YES
+MAN_LINKS              = YES
 HAVE_DOT               = @HAVE_DOT@
 DOT_TRANSPARENT        = YES
diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
index b4268a5..29078de 100644
--- a/doxygen/Makefile.am
+++ b/doxygen/Makefile.am
@@ -1,15 +1,6 @@
 if HAVE_DOXYGEN
 
-# Be sure to add new source files to this table
-doc_srcs = $(top_srcdir)/src/libnetfilter_queue.c  \
-           $(top_srcdir)/src/nlmsg.c               \
-           $(top_srcdir)/src/extra/checksum.c      \
-           $(top_srcdir)/src/extra/ipv6.c          \
-           $(top_srcdir)/src/extra/ipv4.c          \
-           $(top_srcdir)/src/extra/tcp.c           \
-           $(top_srcdir)/src/extra/udp.c           \
-           $(top_srcdir)/src/extra/icmp.c          \
-           $(top_srcdir)/src/extra/pktbuff.c
+doc_srcs = $(shell find $(top_srcdir)/src -name '*.c')
 
 doxyfile.stamp: $(doc_srcs) Makefile.am
 	rm -rf html man
@@ -25,59 +16,37 @@ doxyfile.stamp: $(doc_srcs) Makefile.am
 	[ ! -d ../src.distcheck ] || \
 { set -x; cd ..; rm src; mv src.distcheck src; }
 
-# Keep this command up to date after adding new functions and source files.
+# We need to use bash for its associative array facility
+# (`bash -p` prevents import of functions from the environment).
 # The command has to be a single line so the functions work
+# and so `make` gives all lines to `bash -c`
 # (hence ";\" at the end of every line but the last).
-	main() { set -e; cd man/man3; rm -f _*;\
-setgroup LibrarySetup nfq_open;\
-  add2group nfq_close nfq_bind_pf nfq_unbind_pf;\
-setgroup Parsing nfq_get_msg_packet_hdr;\
-  add2group nfq_get_nfmark nfq_get_timestamp nfq_get_indev nfq_get_physindev;\
-  add2group nfq_get_outdev nfq_get_physoutdev nfq_get_indev_name;\
-  add2group nfq_get_physindev_name nfq_get_outdev_name;\
-  add2group nfq_get_physoutdev_name nfq_get_packet_hw;\
-  add2group nfq_get_skbinfo;\
-  add2group nfq_get_uid nfq_get_gid;\
-  add2group nfq_get_secctx nfq_get_payload;\
-setgroup Queue nfq_fd;\
-  add2group nfq_create_queue nfq_destroy_queue nfq_handle_packet nfq_set_mode;\
-  add2group nfq_set_queue_flags nfq_set_queue_maxlen nfq_set_verdict;\
-  add2group nfq_set_verdict2 nfq_set_verdict_batch;\
-  add2group nfq_set_verdict_batch2 nfq_set_verdict_mark;\
-setgroup ipv4 nfq_ip_get_hdr;\
-  add2group nfq_ip_set_transport_header nfq_ip_mangle nfq_ip_snprintf;\
-  setgroup ip_internals nfq_ip_set_checksum;\
-setgroup ipv6 nfq_ip6_get_hdr;\
-  add2group nfq_ip6_set_transport_header nfq_ip6_mangle nfq_ip6_snprintf;\
-setgroup nfq_cfg nfq_nlmsg_cfg_put_cmd;\
-  add2group nfq_nlmsg_cfg_put_params nfq_nlmsg_cfg_put_qmaxlen;\
-setgroup nfq_verd nfq_nlmsg_verdict_put;\
-  add2group nfq_nlmsg_verdict_put_mark nfq_nlmsg_verdict_put_pkt;\
-setgroup nlmsg nfq_nlmsg_parse;\
-  add2group nfq_nlmsg_put;\
-setgroup pktbuff pktb_alloc;\
-  add2group pktb_data pktb_len pktb_mangle pktb_mangled;\
-  add2group pktb_free;\
-  setgroup otherfns pktb_tailroom;\
-    add2group pktb_mac_header pktb_network_header pktb_transport_header;\
-    setgroup uselessfns pktb_push;\
-      add2group pktb_pull pktb_put pktb_trim;\
-setgroup tcp nfq_tcp_get_hdr;\
-  add2group nfq_tcp_get_payload nfq_tcp_get_payload_len;\
-  add2group nfq_tcp_snprintf nfq_tcp_mangle_ipv4 nfq_tcp_mangle_ipv6;\
-  setgroup tcp_internals nfq_tcp_compute_checksum_ipv4;\
-    add2group nfq_tcp_compute_checksum_ipv6;\
-setgroup udp nfq_udp_get_hdr;\
-  add2group nfq_udp_get_payload nfq_udp_get_payload_len;\
-  add2group nfq_udp_mangle_ipv4 nfq_udp_mangle_ipv6 nfq_udp_snprintf;\
-  setgroup udp_internals nfq_udp_compute_checksum_ipv4;\
-    add2group nfq_udp_compute_checksum_ipv6;\
-setgroup Printing nfq_snprintf_xml;\
-setgroup icmp nfq_icmp_get_hdr;\
+	/bin/bash -p -c 'declare -A renamed_page;\
+main(){ set -e; cd man/man3; rm -f _*;\
+  count_real_pages;\
+  rename_real_pages;\
+  make_symlinks;\
 };\
-setgroup() { mv $$1.3 $$2.3; BASE=$$2; };\
-add2group() { for i in $$@; do ln -sf $$BASE.3 $$i.3; done; };\
-main
+count_real_pages(){ page_count=0;\
+  for i in $$(ls -S);\
+  do head -n1 $$i | grep -E -q '^\.so' && break;\
+    page_count=$$(($$page_count + 1));\
+  done;\
+  first_link=$$(($$page_count + 1));\
+};\
+rename_real_pages(){ for i in $$(ls -S | head -n$$page_count);\
+  do for j in $$(ls -S | tail -n+$$first_link);\
+    do grep -E -q $$i$$ $$j && break;\
+    done;\
+    mv -f $$i $$j;\
+    renamed_page[$$i]=$$j;\
+  done;\
+};\
+make_symlinks(){ for j in $$(ls -S | tail -n+$$first_link);\
+  do ln -sf $${renamed_page[$$(cat $$j | cut -f2 -d/)]} $$j;\
+  done;\
+};\
+main'
 
 	touch doxyfile.stamp
 
@@ -88,7 +57,8 @@ clean-local:
 	rm -rf $(top_srcdir)/doxygen/man $(top_srcdir)/doxygen/html
 install-data-local:
 	mkdir -p $(DESTDIR)$(mandir)/man3
-	cp --no-dereference --preserve=links,mode,timestamps man/man3/*.3 $(DESTDIR)$(mandir)/man3/
+	cp --no-dereference --preserve=links,mode,timestamps man/man3/*.3\
+	  $(DESTDIR)$(mandir)/man3/
 
 # make distcheck needs uninstall-local
 uninstall-local:
-- 
2.17.5

