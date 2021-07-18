Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 453A6C636C8
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Jul 2021 03:47:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1589E61166
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Jul 2021 03:47:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbhGRDuZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 17 Jul 2021 23:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbhGRDuZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 17 Jul 2021 23:50:25 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3457C061762
        for <netfilter-devel@vger.kernel.org>; Sat, 17 Jul 2021 20:47:27 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id d9-20020a17090ae289b0290172f971883bso11852526pjz.1
        for <netfilter-devel@vger.kernel.org>; Sat, 17 Jul 2021 20:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5ICRFzkNGFmZ9NdBpy5T3fsJdPFsokk0QN4iqHAW4m8=;
        b=lcTSzP0rgQrZtzeJ9w8Q7CQJLICYCLpLIx6iyYFJBhYjkluNZoMLzFovvgaowXdJuJ
         xl/c1gak1oRtegOEe+Bn/Ixa51yeMrNDCUyGyNiDoQriM+NgciM4cfOzkQq0yibOVrb2
         PpYAIR5RfG39Ckcv33kyqjZhFMbeVLKjdmxmaiaC7t638fjKuXow43nL9IqpRUMTadRD
         o3OHa4kA4OVndWi9nWPrfAnD4qT7BuILJFjsSe7RX0YspjFTBayU4DCKHavR9fyfMUjn
         O9IhL3eyyC+wl4O/WliVNwj3MIeno5REfFe5dBQoWbd/baGV2+F49fXMtNJrZEqlqlOk
         Xlrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=5ICRFzkNGFmZ9NdBpy5T3fsJdPFsokk0QN4iqHAW4m8=;
        b=IbQhKGq9k37VZfOznhiL81K04+QWdFZjmddc5yyL8rjs4qypqAzN0RuuXLzgCeKUa3
         9SechuTrQDjmg0GVLy2gE203jPmigl1mrnUzrqWLOSj7hpIvj1vH6pG8LkdW+M/OJM1t
         2xFY5ZPrWuTi8JOxMQzVZRv0z04m5T6TPpYMf9Er/e5BU72QOf2QshuYcJpdU19F0Aib
         B057PJYY19672x2ExV781pNENXeYDR6pRlPDh/i3adJu1Jp1OvmyWcfkqJigTujxBQja
         spJZJgWiZwQJwyGCwGa9aq0AmsOIf2C3eRLRvRZqiEj0Hhrs1RV9M7vKTlSV6VlinQ3G
         cOAg==
X-Gm-Message-State: AOAM533bTnA3NMmHrdUTT+9jzj9TUHUd18q/ffJIwu1x/W7AML93DjKl
        /785nmpWLTxNe9aiajOiOwOni2vhslBXSA==
X-Google-Smtp-Source: ABdhPJzpx+DB/4g5zFESjdTl3YWGrbnDBP7gcqpEhouQo6+du3In7M0xcM1matwlZ49u3RXaiUC1Fw==
X-Received: by 2002:a17:90a:7a86:: with SMTP id q6mr23868549pjf.141.1626580047178;
        Sat, 17 Jul 2021 20:47:27 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id u16sm16918853pgh.53.2021.07.17.20.47.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jul 2021 20:47:26 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libmnl] build: doc: get rid of the need for manual updating of Makefile
Date:   Sun, 18 Jul 2021 13:47:22 +1000
Message-Id: <20210718034722.25321-1-duncan_roe@optusnet.com.au>
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
 doxygen/Makefile.am | 71 ++++++++++++++++++++-------------------------
 2 files changed, 32 insertions(+), 40 deletions(-)

diff --git a/doxygen.cfg.in b/doxygen.cfg.in
index 1e42e44..ae31dbe 100644
--- a/doxygen.cfg.in
+++ b/doxygen.cfg.in
@@ -18,5 +18,6 @@ SEARCHENGINE           = NO
 GENERATE_LATEX         = NO
 LATEX_CMD_NAME         = latex
 GENERATE_MAN           = YES
+MAN_LINKS              = YES
 HAVE_DOT               = @HAVE_DOT@
 DOT_TRANSPARENT        = YES
diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
index e0598ab..29078de 100644
--- a/doxygen/Makefile.am
+++ b/doxygen/Makefile.am
@@ -1,10 +1,6 @@
 if HAVE_DOXYGEN
 
-# Be sure to add new source files to this table
-doc_srcs = $(top_srcdir)/src/attr.c     \
-           $(top_srcdir)/src/callback.c \
-           $(top_srcdir)/src/nlmsg.c    \
-           $(top_srcdir)/src/socket.c
+doc_srcs = $(shell find $(top_srcdir)/src -name '*.c')
 
 doxyfile.stamp: $(doc_srcs) Makefile.am
 	rm -rf html man
@@ -20,43 +16,37 @@ doxyfile.stamp: $(doc_srcs) Makefile.am
 	[ ! -d ../src.distcheck ] || \
 { set -x; cd ..; rm src; mv src.distcheck src; }
 
-# Keep this command up to date after adding new functions and source files.
+# We need to use bash for its associative array facility
+# (`bash -p` prevents import of functions from the environment).
 # The command has to be a single line so the functions work
+# and so `make` gives all lines to `bash -c`
 # (hence ";\" at the end of every line but the last).
-	main() { set -e; cd man/man3; rm -f _*;\
-setgroup attr mnl_attr_get_type;\
-  add2group mnl_attr_get_len mnl_attr_get_payload_len mnl_attr_get_payload;\
-  add2group mnl_attr_ok mnl_attr_next mnl_attr_type_valid mnl_attr_validate;\
-  add2group mnl_attr_validate2 mnl_attr_parse mnl_attr_parse_nested;\
-  add2group mnl_attr_parse_payload mnl_attr_get_u8 mnl_attr_get_u16;\
-  add2group mnl_attr_get_u32 mnl_attr_get_u64 mnl_attr_get_str mnl_attr_put;\
-  add2group mnl_attr_put_u8 mnl_attr_put_u16 mnl_attr_put_u32 mnl_attr_put_u64;\
-  add2group mnl_attr_put_str mnl_attr_put_strz mnl_attr_nest_start;\
-  add2group mnl_attr_put_check mnl_attr_put_u8_check mnl_attr_put_u16_check;\
-  add2group mnl_attr_put_u32_check mnl_attr_put_u64_check;\
-  add2group mnl_attr_put_str_check mnl_attr_put_strz_check;\
-  add2group mnl_attr_nest_start_check mnl_attr_nest_end mnl_attr_nest_cancel;\
-setgroup batch mnl_nlmsg_batch_start;\
-  add2group mnl_nlmsg_batch_stop mnl_nlmsg_batch_next mnl_nlmsg_batch_reset;\
-  add2group mnl_nlmsg_batch_size mnl_nlmsg_batch_head mnl_nlmsg_batch_current;\
-  add2group mnl_nlmsg_batch_is_empty;\
-setgroup callback mnl_cb_run;\
-  add2group mnl_cb_run2;\
-setgroup nlmsg mnl_nlmsg_size;\
-  add2group mnl_nlmsg_get_payload_len mnl_nlmsg_put_header;\
-  add2group mnl_nlmsg_put_extra_header mnl_nlmsg_get_payload;\
-  add2group mnl_nlmsg_get_payload_offset mnl_nlmsg_ok mnl_nlmsg_next;\
-  add2group mnl_nlmsg_get_payload_tail mnl_nlmsg_seq_ok mnl_nlmsg_portid_ok;\
-  add2group mnl_nlmsg_fprintf;\
-setgroup socket mnl_socket_get_fd;\
-  add2group mnl_socket_get_portid mnl_socket_open mnl_socket_open2;\
-  add2group mnl_socket_fdopen mnl_socket_bind mnl_socket_sendto;\
-  add2group mnl_socket_recvfrom mnl_socket_close mnl_socket_setsockopt;\
-  add2group mnl_socket_getsockopt;\
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
 
@@ -67,7 +57,8 @@ clean-local:
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

