Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30330C4338F
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Aug 2021 07:46:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1632A61053
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Aug 2021 07:46:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233514AbhHIHqp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Aug 2021 03:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233500AbhHIHqg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Aug 2021 03:46:36 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BEC4C0613CF
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Aug 2021 00:46:15 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id k2so15406503plk.13
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Aug 2021 00:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7YzDucKfn3OiE2W8qg5nAD5pI1xQk3Tf2YgQzTsAqMY=;
        b=iUiJ5PRfe6m3eDUbuiwAfmp2kzrwCtZhoFF7NXnzDn/C27B5dkzFkT8Kks3LqE8JTV
         ++AhdwHpogkNgJS68fn/hyC15XW7ooMJXhCIX1pNxtT1Wwpe71M9MnqAF/D0MLrpt2iu
         VWjyL88CmjYlOm4M0FhmCIg19b6n5Q1Ww0LKUW2LXyCH/1oTCl2dEE5exa62cTdJPy9y
         5ciS3edwbbloUiVFLolyXfE3/8UWY1uw+3z/VgijSbIf4aGQVlqcw2rd3hX9ajoh+2ED
         eusU1CuHHu+FK7M/iNA0icaQUwo96Z6KdobgzsWUxjpqz3ST0HtPAE+arKh6vlspJIQx
         h7eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=7YzDucKfn3OiE2W8qg5nAD5pI1xQk3Tf2YgQzTsAqMY=;
        b=Z3e50trbAEhmB6EXXLm8vPt0ZMOx66jJUDvf7RZXQtr5wyRa/9dbPu73b0n89pTWTs
         gRvKx8Au/xxGPGLsicDKTAOe83+3fl03TynX6cULZdQAv86wgkj/J1f0IR8sZpmH2Uiy
         GTX0A6hjidmxt5i8AD2iGo/AyuHdVFPmmDehjk8HMxjkYLaJlvtVT3LNvxWrV5Eff7TX
         jrYTvlXGhv5PNqDAtxyHFGUTnDPj+sW8pJb0Szn/J5LiXwg3DMFCsM7vq8vCtTMVMB+v
         P1ETDSYFrdsxO4jTciqZecOZM6+0HXEbU05i+kq68HOdK226Sy0D2MAav9NDn789G1pW
         fUTg==
X-Gm-Message-State: AOAM531EOYobgni2T9bLnJSsWCkrg6lwtkMzyat1OQ6P1vhBegiLTcLK
        fbR8eU85lF9vh/xmZmJgL1h86hWw8vjpGg==
X-Google-Smtp-Source: ABdhPJykovyy0K2l2BzW1fC5z6BneKsiud7+W2AVxQGh40jjO2ZYvX/5szHgFH20zQsc8feuFmQvkA==
X-Received: by 2002:a17:90a:f98f:: with SMTP id cq15mr8400146pjb.74.1628495174685;
        Mon, 09 Aug 2021 00:46:14 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id v63sm20319874pgv.59.2021.08.09.00.46.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 00:46:13 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] build: doc: Fix NAME entry in man pages
Date:   Mon,  9 Aug 2021 17:46:07 +1000
Message-Id: <20210809074607.11277-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Make the NAME line list the functions defined, like other man pages do.
Also:
- If there is a "Modules" section, delete it
- If "Detailed Description" is empty, delete "Detailed Description" line
- Reposition SYNOPSIS (with headers that we inserted) to start of page,
  integrating with defined functions to look like other man pages
- Delete all "Definition at line nnn" lines
- Insert spacers and comments so Makefile.am is more readable

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doxygen/Makefile.am | 157 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 157 insertions(+)

diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
index 29078de..b6de81a 100644
--- a/doxygen/Makefile.am
+++ b/doxygen/Makefile.am
@@ -21,19 +21,32 @@ doxyfile.stamp: $(doc_srcs) Makefile.am
 # The command has to be a single line so the functions work
 # and so `make` gives all lines to `bash -c`
 # (hence ";\" at the end of every line but the last).
+# automake (run by autogen.sh) allows comments starting ## after continuations
+# but not blank lines
+
 	/bin/bash -p -c 'declare -A renamed_page;\
+##
 main(){ set -e; cd man/man3; rm -f _*;\
   count_real_pages;\
   rename_real_pages;\
   make_symlinks;\
+  post_process;\
 };\
+##
 count_real_pages(){ page_count=0;\
+  ##
+  ## Count "real" man pages (i.e. not generated by MAN_LINKS)
+  ## MAN_LINKS pages are 1-liners starting .so
+  ## Method: list files in descending order of size,
+  ## looking for the first 1-liner
+  ##
   for i in $$(ls -S);\
   do head -n1 $$i | grep -E -q '^\.so' && break;\
     page_count=$$(($$page_count + 1));\
   done;\
   first_link=$$(($$page_count + 1));\
 };\
+##
 rename_real_pages(){ for i in $$(ls -S | head -n$$page_count);\
   do for j in $$(ls -S | tail -n+$$first_link);\
     do grep -E -q $$i$$ $$j && break;\
@@ -42,10 +55,154 @@ rename_real_pages(){ for i in $$(ls -S | head -n$$page_count);\
     renamed_page[$$i]=$$j;\
   done;\
 };\
+##
 make_symlinks(){ for j in $$(ls -S | tail -n+$$first_link);\
   do ln -sf $${renamed_page[$$(cat $$j | cut -f2 -d/)]} $$j;\
   done;\
 };\
+##
+post_process(){ make_temp_files;\
+  ##
+  ## DIAGNOSTIC / DEVELOPMENT CODE
+  ## set -x and restrict processing to keep_me: un-comment to activate
+  ## Change keep_me as required
+  ##
+  ##keep_me=nfq_icmp_get_hdr.3;\
+  ##do_diagnostics;\
+  ##
+  ## Work through the "real" man pages
+  for target in $$(ls -S | head -n$$page_count);\
+  do mygrep "^\\.SH \"Function Documentation" $$target;\
+    ## Next file if this isn't a function page
+    [ $$linnum -ne 0 ] || continue;\
+    ##
+    del_modules;\
+    del_bogus_synopsis;\
+    fix_name_line;\
+    move_synopsis;\
+    del_empty_det_desc;\
+    del_def_at_lines;\
+  done;\
+  ##
+  remove_temp_files;\
+};\
+##
+del_def_at_lines(){ linnum=1;\
+  while [ $$linnum -ne 0 ];\
+  do mygrep "^Definition at line [[:digit:]]* of file" $$target;\
+    [ $$linnum -eq 0 ] || delete_lines $$(($$linnum - 1)) $$linnum;\
+  done;\
+};\
+##
+## Only invoked if you un-comment the 2 diagnostic / development lines above
+do_diagnostics(){ mv $$keep_me xxx;\
+  rm *.3;\
+  mv xxx $$keep_me;\
+  page_count=1;\
+  set -x;\
+};\
+##
+del_empty_det_desc(){ mygrep "^\\.SH \"Function Documentation" $$target;\
+  i=$$linnum;\
+  mygrep "^\\.SH \"Detailed Description" $$target;\
+  [ $$linnum -ne 0  ] || return 0;\
+  [ $$(($$i - $$linnum)) -eq 3 ] || return 0;\
+  delete_lines $$linnum $$(($$i -1));\
+};\
+##
+move_synopsis(){ mygrep "SH SYNOPSIS" $$target;\
+  [ $$linnum -ne 0  ] || return 0;\
+  i=$$linnum;\
+  ## If this is a doxygen-created synopsis, leave it.
+  ## (We haven't inserted our own one in the source yet)
+  mygrep "^\\.SS \"Functions" $$target;\
+  [ $$i -gt $$linnum ] || return 0;\
+  ##
+  mygrep "^\\.SH \"Function Documentation" $$target;\
+  j=$$(($$linnum - 1));\
+  head -n$$(($$j - 1)) $$target | tail -n$$(($$linnum - $$i - 1)) >$$fileC;\
+  delete_lines $$i $$j;\
+  mygrep "^\\.SS \"Functions" $$target;\
+  head -n$$(($$linnum - 1)) $$target >$$fileA;\
+  tail -n+$$(($$linnum + 1)) $$target >$$fileB;\
+  cat $$fileA $$fileC $$fileB >$$target;\
+};\
+##
+fix_name_line(){ all_funcs="";\
+  ##
+  ## Search a shortened version of the page in case there are .RI lines later
+  mygrep "^\\.SH \"Function Documentation" $$target;\
+  head -n$$linnum $$target >$$fileC;\
+  ##
+  while :;\
+  do mygrep ^\\.RI $$fileC;\
+    [ $$linnum -ne 0 ] || break;\
+    ## Discard this entry
+    tail -n+$$(($$linnum + 1)) $$fileC >$$fileB;\
+    cp $$fileB $$fileC;\
+    ##
+    func=$$(cat $$fileG | cut -f2 -d\\ | cut -c3-);\
+    [ -z "$$all_funcs" ] && all_funcs=$$func ||\
+      all_funcs="$$all_funcs, $$func";\
+  done;\
+  ## For now, assume name is at line 5
+  head -n4 $$target >$$fileA;\
+  desc=$$(head -n5 $$target | tail -n1 | cut -f3- -d" ");\
+  tail -n+6 $$target >$$fileB;\
+  cat $$fileA >$$target;\
+  echo "$$all_funcs \\- $$desc" >>$$target;\
+  cat $$fileB >>$$target;\
+};\
+##
+del_modules(){ mygrep "^\.SS \"Modules" $$target;\
+  [ $$linnum -ne 0  ] || return 0;\
+  i=$$linnum;\
+  mygrep "^\\.SS \"Functions" $$target;\
+  delete_lines $$i $$(($$linnum - 1));\
+};\
+##
+del_bogus_synopsis(){ mygrep "SH SYNOPSIS" $$target;\
+  ##
+  ## doxygen 1.8.20 inserts its own SYNOPSIS line but there is no mention
+  ## in the documentation or git log what to do with it.
+  ## So get rid of it
+  ##
+  [ $$linnum -ne 0  ] || return 0;\
+  i=$$linnum;\
+  ## Look for the next one
+  tail -n+$$(($$i + 1)) $$target >$$fileC;\
+  mygrep "SH SYNOPSIS" $$fileC;\
+  [ $$linnum -ne 0  ] || return 0;\
+  ##
+  mygrep "^\\.SS \"Functions" $$target;\
+  delete_lines $$i $$(($$linnum - 1));\
+};\
+##
+## Delete lines $1 through $2 from $target
+delete_lines(){ head -n$$(($$1 - 1)) $$target >$$fileA;\
+  tail -n+$$(($$2 +1)) $$target >$$fileB;\
+  cat $$fileA $$fileB >$$target;\
+};\
+##
+mygrep(){ set +e;\
+  grep -En "$$1" $$2 2>/dev/null >$$fileH;\
+  [ $$? -ne 0 ] && linnum=0 ||\
+    { head -n1 $$fileH >$$fileG; linnum=$$(cat $$fileG | cut -f1 -d:); };\
+  set -e;\
+};\
+##
+make_temp_files(){ temps="A B C G H";\
+  for i in $$temps;\
+  do declare -g file$$i=$$(mktemp);\
+  done;\
+};\
+##
+remove_temp_files(){ for i in $$temps;\
+  do j=file$$i;\
+    rm $${!j};\
+  done;\
+};\
+##
 main'
 
 	touch doxyfile.stamp
-- 
2.17.5

