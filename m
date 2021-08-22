Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0D9EC432BE
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Aug 2021 04:15:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B351F6126A
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Aug 2021 04:15:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbhHVEPl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 22 Aug 2021 00:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbhHVEPh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Aug 2021 00:15:37 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F5D5C061575
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Aug 2021 21:14:56 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id e15so8223198plh.8
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Aug 2021 21:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wUe/O/ny0gkmsGa9nOYuJiy2gWNAKVw/4dEFHahTmgE=;
        b=uR2pixvGzcxFOt7fTm1OieKIfds89sPLBS1LI28YmwuizExf5awRhsGl3aZtR6wq4g
         tM/uMcwsarD54xf9YDio0iC9LwM89XtJ7JSVjWsexYEMn8P7Y8+eQjJu6WMMUgNxzTUL
         4J+nsjJTms//cR78wWmv8cVYgbN1ATj5ppK5meIhEBCwnTe5cLv9yHAfQ5OMz/RuGDVj
         bI3TTQmgU74hyn8Mu/lIcQHjHtbl2Vbu7bc2X1X4e6ju/5y6qHoxdwpuKHu2smscs50i
         kWCIA1TbrMFn1avaUvHVxa+DRjbuYDRdkMqDqLCHVLXPlsyRAWDMEJTEsoIkqQET8EUR
         s/zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=wUe/O/ny0gkmsGa9nOYuJiy2gWNAKVw/4dEFHahTmgE=;
        b=ZMRmWQYQsVBHMgVVuyyygvq/8Io0Of7zfZ4wWcrK8iuL1+NrcgaefOZS3TU6q8ZV10
         anr2Prv0MQGkKnjDFn9/LYawlXihsE/AnFimdIr78tOXkO3AmQxu9glymbHq+LgtdqMf
         C6YydoHndMmm0rpRw2cHLB7c2jqWLUTYchNel2fS19P0k1Yl9mDFmLknLeuvStFnwufa
         22cePmOfwaaYFfzjjtNp6pmKcZ3jhcRFTPDTzV1ClitIc8n5nz2MaITBuhb9i03oVtJl
         CaCPnq8RgbO3hIEjmwO68BlEevhsss/h3H8gglvJM9GD15/XYuRDa/7WrrcyK1mWlqvh
         KF5g==
X-Gm-Message-State: AOAM531kSYlluoYZ9yRNj77IKxEdWn3yOn5pggW6Oty59qFq2N8GDqmw
        ed1kemCHtydG9AOq5WbIpC6Na3CcDNf9xg==
X-Google-Smtp-Source: ABdhPJxHcoOwiFPmNpWljm4/UxsiNGBKMHlMLTNYcUpFGR1MmcbcQPB45WRc7o2xLn24OupROYZsUw==
X-Received: by 2002:a17:902:8488:b029:129:97e8:16e7 with SMTP id c8-20020a1709028488b029012997e816e7mr23242302plo.39.1629605696149;
        Sat, 21 Aug 2021 21:14:56 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id lk17sm5777271pjb.44.2021.08.21.21.14.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Aug 2021 21:14:55 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v4 4/4] build: doc: split off shell script from within doxygen/Makefile.am
Date:   Sun, 22 Aug 2021 14:14:42 +1000
Message-Id: <20210822041442.8394-4-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210822041442.8394-1-duncan_roe@optusnet.com.au>
References: <20210822041442.8394-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This time, Makefile obeys the script via its absolute source pathname rather
than trying to force a copy into the build dir as we did previously.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doxygen/Makefile.am  | 198 +--------------------------------------
 doxygen/build_man.sh | 215 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 218 insertions(+), 195 deletions(-)
 create mode 100755 doxygen/build_man.sh

diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
index e788843..aa19c5a 100644
--- a/doxygen/Makefile.am
+++ b/doxygen/Makefile.am
@@ -25,201 +25,7 @@ doxyfile.stamp: $(doc_srcs) Makefile.am
 # but not blank lines
 
 if BUILD_MAN
-	/bin/bash -p -c 'declare -A renamed_page;\
-##
-main(){ set -e; cd man/man3; rm -f _*;\
-  count_real_pages;\
-  rename_real_pages;\
-  make_symlinks;\
-  post_process;\
-};\
-##
-count_real_pages(){ page_count=0;\
-  ##
-  ## Count "real" man pages (i.e. not generated by MAN_LINKS)
-  ## MAN_LINKS pages are 1-liners starting .so
-  ## Method: list files in descending order of size,
-  ## looking for the first 1-liner
-  ##
-  for i in $$(ls -S);\
-  do head -n1 $$i | grep -E -q '^\.so' && break;\
-    page_count=$$(($$page_count + 1));\
-  done;\
-  first_link=$$(($$page_count + 1));\
-};\
-##
-rename_real_pages(){ for i in $$(ls -S | head -n$$page_count);\
-  do for j in $$(ls -S | tail -n+$$first_link);\
-    do grep -E -q $$i$$ $$j && break;\
-    done;\
-    mv -f $$i $$j;\
-    renamed_page[$$i]=$$j;\
-  done;\
-};\
-##
-make_symlinks(){ for j in $$(ls -S | tail -n+$$first_link);\
-  do ln -sf $${renamed_page[$$(cat $$j | cut -f2 -d/)]} $$j;\
-  done;\
-};\
-##
-post_process(){ make_temp_files;\
-  ##
-  ## DIAGNOSTIC / DEVELOPMENT CODE
-  ## set -x and restrict processing to keep_me: un-comment to activate
-  ## Change keep_me as required
-  ##
-  ##keep_me=nfq_icmp_get_hdr.3;\
-  ##do_diagnostics;\
-  ##
-  ## Work through the "real" man pages
-  for target in $$(ls -S | head -n$$page_count);\
-  do mygrep "^\\.SH \"Function Documentation" $$target;\
-    ## Next file if this isn't a function page
-    [ $$linnum -ne 0 ] || continue;\
-    ##
-    del_modules;\
-    del_bogus_synopsis;\
-    fix_name_line;\
-    move_synopsis;\
-    del_empty_det_desc;\
-    del_def_at_lines;\
-    fix_double_blanks;\
-  done;\
-  ##
-  remove_temp_files;\
-};\
-##
-fix_double_blanks(){ linnum=1;\
-  ##
-  ## Older versions of man display a blank line on encountering "\fB\fP";
-  ## newer versions of man do not.
-  ## doxygen emits "\fB\fP" on seeing "\par" on a line by itself.
-  ## "\par" gives us double-spacing in the web doc, which we want, but double-
-  ## spacing looks odd in a man page so remove "\fB\fP".
-  ##
-  while [ $$linnum -ne 0 ];\
-  do mygrep \\\\fB\\\\fP $$target;\
-    [ $$linnum -eq 0 ] || delete_lines $$linnum $$linnum;\
-  done;\
-};\
-##
-del_def_at_lines(){ linnum=1;\
-  while [ $$linnum -ne 0 ];\
-  do mygrep "^Definition at line [[:digit:]]* of file" $$target;\
-    [ $$linnum -eq 0 ] || delete_lines $$(($$linnum - 1)) $$linnum;\
-  done;\
-};\
-##
-## Only invoked if you un-comment the 2 diagnostic / development lines above
-do_diagnostics(){ mv $$keep_me xxx;\
-  rm *.3;\
-  mv xxx $$keep_me;\
-  page_count=1;\
-  set -x;\
-};\
-##
-del_empty_det_desc(){ mygrep "^\\.SH \"Function Documentation" $$target;\
-  i=$$linnum;\
-  mygrep "^\\.SH \"Detailed Description" $$target;\
-  [ $$linnum -ne 0  ] || return 0;\
-  [ $$(($$i - $$linnum)) -eq 3 ] || return 0;\
-  delete_lines $$linnum $$(($$i -1));\
-};\
-##
-move_synopsis(){ mygrep "SH SYNOPSIS" $$target;\
-  [ $$linnum -ne 0  ] || return 0;\
-  i=$$linnum;\
-  ## If this is a doxygen-created synopsis, leave it.
-  ## (We haven't inserted our own one in the source yet)
-  mygrep "^\\.SS \"Functions" $$target;\
-  [ $$i -gt $$linnum ] || return 0;\
-  ##
-  mygrep "^\\.SH \"Function Documentation" $$target;\
-  j=$$(($$linnum - 1));\
-  head -n$$(($$j - 1)) $$target | tail -n$$(($$linnum - $$i - 1)) >$$fileC;\
-  delete_lines $$i $$j;\
-  mygrep "^\\.SS \"Functions" $$target;\
-  head -n$$(($$linnum - 1)) $$target >$$fileA;\
-  tail -n+$$(($$linnum + 1)) $$target >$$fileB;\
-  cat $$fileA $$fileC $$fileB >$$target;\
-};\
-##
-fix_name_line(){ all_funcs="";\
-  ##
-  ## Search a shortened version of the page in case there are .RI lines later
-  mygrep "^\\.SH \"Function Documentation" $$target;\
-  head -n$$linnum $$target >$$fileC;\
-  ##
-  while :;\
-  do mygrep ^\\.RI $$fileC;\
-    [ $$linnum -ne 0 ] || break;\
-    ## Discard this entry
-    tail -n+$$(($$linnum + 1)) $$fileC >$$fileB;\
-    cp $$fileB $$fileC;\
-    ##
-    func=$$(cat $$fileG | cut -f2 -d\\ | cut -c3-);\
-    [ -z "$$all_funcs" ] && all_funcs=$$func ||\
-      all_funcs="$$all_funcs, $$func";\
-  done;\
-  ## For now, assume name is at line 5
-  head -n4 $$target >$$fileA;\
-  desc=$$(head -n5 $$target | tail -n1 | cut -f3- -d" ");\
-  tail -n+6 $$target >$$fileB;\
-  cat $$fileA >$$target;\
-  echo "$$all_funcs \\- $$desc" >>$$target;\
-  cat $$fileB >>$$target;\
-};\
-##
-del_modules(){ mygrep "^\.SS \"Modules" $$target;\
-  [ $$linnum -ne 0  ] || return 0;\
-  i=$$linnum;\
-  mygrep "^\\.SS \"Functions" $$target;\
-  delete_lines $$i $$(($$linnum - 1));\
-};\
-##
-del_bogus_synopsis(){ mygrep "SH SYNOPSIS" $$target;\
-  ##
-  ## doxygen 1.8.20 inserts its own SYNOPSIS line but there is no mention
-  ## in the documentation or git log what to do with it.
-  ## So get rid of it
-  ##
-  [ $$linnum -ne 0  ] || return 0;\
-  i=$$linnum;\
-  ## Look for the next one
-  tail -n+$$(($$i + 1)) $$target >$$fileC;\
-  mygrep "SH SYNOPSIS" $$fileC;\
-  [ $$linnum -ne 0  ] || return 0;\
-  ##
-  mygrep "^\\.SS \"Functions" $$target;\
-  delete_lines $$i $$(($$linnum - 1));\
-};\
-##
-## Delete lines $1 through $2 from $target
-delete_lines(){ head -n$$(($$1 - 1)) $$target >$$fileA;\
-  tail -n+$$(($$2 +1)) $$target >$$fileB;\
-  cat $$fileA $$fileB >$$target;\
-};\
-##
-mygrep(){ set +e;\
-  grep -En "$$1" $$2 2>/dev/null >$$fileH;\
-  [ $$? -ne 0 ] && linnum=0 ||\
-    { head -n1 $$fileH >$$fileG; linnum=$$(cat $$fileG | cut -f1 -d:); };\
-  set -e;\
-};\
-##
-make_temp_files(){ temps="A B C G H";\
-  for i in $$temps;\
-  do declare -g file$$i=$$(mktemp);\
-  done;\
-};\
-##
-remove_temp_files(){ for i in $$temps;\
-  do j=file$$i;\
-    rm $${!j};\
-  done;\
-};\
-##
-main'
+	$(abs_top_srcdir)/doxygen/build_man.sh
 endif
 
 	touch doxyfile.stamp
@@ -245,3 +51,5 @@ endif
 uninstall-local:
 	rm -rf $(DESTDIR)$(htmldir) $(DESTDIR)$(mandir) man html doxyfile.stamp
 endif
+
+EXTRA_DIST = build_man.sh
diff --git a/doxygen/build_man.sh b/doxygen/build_man.sh
new file mode 100755
index 0000000..da8c84e
--- /dev/null
+++ b/doxygen/build_man.sh
@@ -0,0 +1,215 @@
+#!/bin/bash -p
+
+declare -A renamed_page
+
+main(){
+  set -e
+  cd man/man3; rm -f _*
+  count_real_pages
+  rename_real_pages
+  make_symlinks
+  post_process
+}
+
+count_real_pages(){
+  page_count=0
+  #
+  # Count "real" man pages (i.e. not generated by MAN_LINKS)
+  # MAN_LINKS pages are 1-liners starting .so
+  # Method: list files in descending order of size,
+  # looking for the first 1-liner
+  #
+  for i in $(ls -S)
+  do head -n1 $i | grep -E -q '^\.so' && break
+    page_count=$(($page_count + 1))
+  done
+  first_link=$(($page_count + 1))
+}
+
+rename_real_pages(){
+  for i in $(ls -S | head -n$page_count)
+  do for j in $(ls -S | tail -n+$first_link)
+    do grep -E -q $i$ $j && break
+    done
+    mv -f $i $j
+    renamed_page[$i]=$j
+  done
+}
+
+make_symlinks(){
+  for j in $(ls -S | tail -n+$first_link)
+  do ln -sf ${renamed_page[$(cat $j | cut -f2 -d/)]} $j
+  done
+}
+
+post_process(){
+  make_temp_files
+  #
+  # DIAGNOSTIC / DEVELOPMENT CODE
+  # set -x and restrict processing to keep_me: un-comment to activate
+  # Change keep_me as required
+  #
+  #keep_me=nfq_icmp_get_hdr.3;\
+  #do_diagnostics;\
+  #
+  # Work through the "real" man pages
+  for target in $(ls -S | head -n$page_count)
+  do mygrep "^\\.SH \"Function Documentation" $target
+    # Next file if this isn't a function page
+    [ $linnum -ne 0 ] || continue
+
+    del_modules
+    del_bogus_synopsis
+    fix_name_line
+    move_synopsis
+    del_empty_det_desc
+    del_def_at_lines
+    fix_double_blanks
+  done
+
+  remove_temp_files
+}
+
+fix_double_blanks(){
+  linnum=1
+  #
+  # Older versions of man display a blank line on encountering "\fB\fP";
+  # newer versions of man do not.
+  # doxygen emits "\fB\fP" on seeing "\par" on a line by itself.
+  # "\par" gives us double-spacing in the web doc, which we want, but double-
+  # spacing looks odd in a man page so remove "\fB\fP".
+  #
+  while [ $linnum -ne 0 ]
+  do mygrep \\\\fB\\\\fP $target
+    [ $linnum -eq 0 ] || delete_lines $linnum $linnum
+  done
+}
+
+del_def_at_lines(){
+  linnum=1
+  while [ $linnum -ne 0 ]
+  do mygrep "^Definition at line [[:digit:]]* of file" $target
+    [ $linnum -eq 0 ] || delete_lines $(($linnum - 1)) $linnum
+  done
+}
+
+# Only invoked if you un-comment the 2 diagnostic / development lines above
+do_diagnostics(){
+  mv $keep_me xxx
+  rm *.3
+  mv xxx $keep_me
+  page_count=1
+  set -x
+}
+
+del_empty_det_desc(){
+  mygrep "^\\.SH \"Function Documentation" $target
+  i=$linnum
+  mygrep "^\\.SH \"Detailed Description" $target
+  [ $linnum -ne 0  ] || return 0
+  [ $(($i - $linnum)) -eq 3 ] || return 0
+  delete_lines $linnum $(($i -1))
+}
+
+move_synopsis(){
+  mygrep "SH SYNOPSIS" $target
+  [ $linnum -ne 0  ] || return 0
+  i=$linnum
+  # If this is a doxygen-created synopsis, leave it.
+  # (We haven't inserted our own one in the source yet)
+  mygrep "^\\.SS \"Functions" $target
+  [ $i -gt $linnum ] || return 0
+
+  mygrep "^\\.SH \"Function Documentation" $target
+  j=$(($linnum - 1))
+  head -n$(($j - 1)) $target | tail -n$(($linnum - $i - 1)) >$fileC
+  delete_lines $i $j
+  mygrep "^\\.SS \"Functions" $target
+  head -n$(($linnum - 1)) $target >$fileA
+  tail -n+$(($linnum + 1)) $target >$fileB
+  cat $fileA $fileC $fileB >$target
+}
+
+fix_name_line(){
+  all_funcs=""
+
+  # Search a shortened version of the page in case there are .RI lines later
+  mygrep "^\\.SH \"Function Documentation" $target
+  head -n$linnum $target >$fileC
+
+  while :
+  do mygrep ^\\.RI $fileC
+    [ $linnum -ne 0 ] || break
+    # Discard this entry
+    tail -n+$(($linnum + 1)) $fileC >$fileB
+    cp $fileB $fileC
+
+    func=$(cat $fileG | cut -f2 -d\\ | cut -c3-)
+    [ -z "$all_funcs" ] && all_funcs=$func ||\
+      all_funcs="$all_funcs, $func"
+  done
+  # For now, assume name is at line 5
+  head -n4 $target >$fileA
+  desc=$(head -n5 $target | tail -n1 | cut -f3- -d" ")
+  tail -n+6 $target >$fileB
+  cat $fileA >$target
+  echo "$all_funcs \\- $desc" >>$target
+  cat $fileB >>$target
+}
+
+del_modules(){
+  mygrep "^\.SS \"Modules" $target
+  [ $linnum -ne 0  ] || return 0
+  i=$linnum
+  mygrep "^\\.SS \"Functions" $target
+  delete_lines $i $(($linnum - 1))
+}
+
+del_bogus_synopsis(){
+  mygrep "SH SYNOPSIS" $target
+  #
+  # doxygen 1.8.20 inserts its own SYNOPSIS line but there is no mention
+  # in the documentation or git log what to do with it.
+  # So get rid of it
+  #
+  [ $linnum -ne 0  ] || return 0
+  i=$linnum
+  # Look for the next one
+  tail -n+$(($i + 1)) $target >$fileC;\
+  mygrep "SH SYNOPSIS" $fileC
+  [ $linnum -ne 0  ] || return 0
+
+  mygrep "^\\.SS \"Functions" $target
+  delete_lines $i $(($linnum - 1))
+}
+
+# Delete lines $1 through $2 from $target
+delete_lines(){
+  head -n$(($1 - 1)) $target >$fileA
+  tail -n+$(($2 +1)) $target >$fileB
+  cat $fileA $fileB >$target
+}
+
+mygrep(){
+  set +e
+  grep -En "$1" $2 2>/dev/null >$fileH
+  [ $? -ne 0 ] && linnum=0 ||\
+    { head -n1 $fileH >$fileG; linnum=$(cat $fileG | cut -f1 -d:); }
+  set -e
+}
+
+make_temp_files(){
+  temps="A B C G H"
+  for i in $temps
+  do declare -g file$i=$(mktemp)
+  done
+}
+
+remove_temp_files(){
+  for i in $temps
+  do j=file$i
+    rm ${!j}
+  done
+}
+
+main
-- 
2.17.5

