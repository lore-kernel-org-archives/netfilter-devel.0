Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10F9FC4338F
	for <netfilter-devel@archiver.kernel.org>; Sat, 21 Aug 2021 05:38:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D132D611CA
	for <netfilter-devel@archiver.kernel.org>; Sat, 21 Aug 2021 05:38:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbhHUFiw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 21 Aug 2021 01:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbhHUFiv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 21 Aug 2021 01:38:51 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 113CBC061575
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Aug 2021 22:38:13 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id c17so11336959pgc.0
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Aug 2021 22:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n58DrGtfZhSKcgZhQCVh2+Zr1zsMpIimH1Q1qLFreLY=;
        b=txQXfOZ5/aZ65OKll3++eDWZQDUVpjWu7ASmKS4ePMA4TOtkJBzMu0O4222HEC306z
         +c8lk457Gfw6oTry4pI+C9S80qsGpkkk6fdRrNPbRMM+/I219mWj/WExN9M8A3MxbHUN
         t0DRmL0XWjdSrtGaEayjKSd6/255S704pb7hYaPKsaPytUThAAf2DND6T7WR/qlPW6ia
         2WGl7xa1r0Np7NozJwOzbIAdmMksTZO2IbZnM6pNnt9vrK/zLeUluosvjsC/1IaqtaBR
         bRJofl9svkGJwGd8IO6syRz/VAwq21Zm7Y1czPU2RoqktJRF3cQriJlb04FkCH0jeZtH
         kIcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=n58DrGtfZhSKcgZhQCVh2+Zr1zsMpIimH1Q1qLFreLY=;
        b=Tn9BjFHpwoHsvCTY75PZyOstQrHxnlFIhpo9cG5MQoqoqSjAqektMISwTWwEewthpl
         Q08hAuc6wfyel2fjQZ1l19NhJAPsNarBiXfiifuCmXvujtR9zqpF6JdsfrDsbhrC/c/Y
         A/zSPKQsXCyzLtFV10SJEwxeASlyhRyMsQBWP4dHY+i/UUf9cXjdXIk5p78A75KTMojr
         xPMLMEEQGUVYJvkwZ9dB7ETrqJBLgPrm4lz0gdL0XOq3Up2yT0V43MLoUT7BVgoXRdpL
         KwVzdL6p0uJvdZVP33USU2pml8p4zZev+Fau2CkXcebnjM7b5iPsKwBQNQkTO7G0Ptza
         hAtA==
X-Gm-Message-State: AOAM532NoklnpJmEJp+tSAPN35yVfVkq39RTCr2hHDGjN5bE726nUjEr
        06tNp0LWrhmsnjQkSeUqxRFIBXwIfr+biA==
X-Google-Smtp-Source: ABdhPJxtVGM0FvR0tZ+RdAMhJuLGvnz+c6bjsu/LaWXSEFdk08g1D5Y0IJH/8neSKeXculmvS+PDvg==
X-Received: by 2002:a63:1c66:: with SMTP id c38mr22019401pgm.286.1629524292456;
        Fri, 20 Aug 2021 22:38:12 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id n30sm8905913pfv.87.2021.08.20.22.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 22:38:11 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v3 1/3] build: doc: Fix NAME entry in man pages
Date:   Sat, 21 Aug 2021 15:38:03 +1000
Message-Id: <20210821053805.6371-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a post_process() function to the big shell script inside doxygen/Makefile.am
to make the NAME line in a man page list the functions defined, like other man
pages do.
This function does a number of other things:
- If there is a "Modules" section, delete it
- If "Detailed Description" is empty, delete "Detailed Description" line
- Reposition SYNOPSIS (with headers that we inserted) to start of page,
  integrating with defined functions to look like other man pages
- Delete all "Definition at line nnn" lines
- Delete lines that make older versions of man o/p an unwanted blank line
- Insert spacers and comments so Makefile.am is more readable
- Delete lines that make older versions of man o/p an unwanted blank line

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
v2: Delete lines that make older versions of man o/p an unwanted blank line
v3: same as v2 but there are now 2 more patches
 doxygen/Makefile.am | 172 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 172 insertions(+)

diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
index 29078de..5bcef61 100644
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
@@ -42,10 +55,169 @@ rename_real_pages(){ for i in $$(ls -S | head -n$$page_count);\
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
+    fix_double_blanks;\
+  done;\
+  ##
+  remove_temp_files;\
+};\
+##
+fix_double_blanks(){ linnum=1;\
+  ##
+  ## Older versions of man display a blank line on encountering "\fB\fP";
+  ## newer versions of man do not.
+  ## doxygen emits "\fB\fP" on seeing "\par" on a line by itself.
+  ## "\par" gives us double-spacing in the web doc, which we want, but double-
+  ## spacing looks odd in a man page so remove "\fB\fP".
+  ##
+  while [ $$linnum -ne 0 ];\
+  do mygrep \\\\fB\\\\fP $$target;\
+    [ $$linnum -eq 0 ] || delete_lines $$linnum $$linnum;\
+  done;\
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

