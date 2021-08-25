Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ED5BC4338F
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Aug 2021 05:00:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B68B6128A
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Aug 2021 05:00:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbhHYFAw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Aug 2021 01:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbhHYFAs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Aug 2021 01:00:48 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C93EC061757
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Aug 2021 22:00:03 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id g184so3397563pgc.6
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Aug 2021 22:00:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NKAt1VCneD4nOZ6fp0YohCpgWMWibkZdp9Mz8L61SX4=;
        b=dQ/DOW3Q3sC0qU088T+iyun9pPBea2tXWpqA/GxMkIm4WyBvww5Q6Mntx7RxYXdKL8
         bnGGF5x90cRsFFZB/+6OFy0U8FdBodp843f+ixd4AlwA+r2UmUeCH3L2UEPLVyt+/ZbN
         J29EYg6GiJnGqK2YG66tk15jC4i6bqGCIecpNR3OssK/vx91JEgZhybXbk71ozi/d2cD
         3LwqU3b9aHWWLtSid8GxFuTrp25Ndh1JBV7UjUPOf9FWAxovT0tMVMj7cET9k9OEq4zS
         TTHjNQCADM2zCUAauFVU82I9jGsukFPml8QUefjNRf0CT1q0TVWzQDUcNIgcGtUPktto
         Kqbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=NKAt1VCneD4nOZ6fp0YohCpgWMWibkZdp9Mz8L61SX4=;
        b=O6jq6FmgJHKXhf5IyU0i3uE4qEogo8tEBj1Dl1GuPd3jp3/p8ToVl8cfE9DXnBhRqR
         cczccmwClM/NnvYphkUjOf6qL5KsJ6IGfgTX4OM3EtMQ/hQk/yKyeE2CUWiehVwJ4FEe
         976zb9QTDwU6WCI+4/aYD5zDByLqlPJgL3VWWBqZqKQv7CyDGFZ3lBqqHbha1tqyuX62
         y2t2m79xs865vvTyJ0W5bA/c4G3d7rT+tYdqxx1qLdvMick3jEZkhvZ8r4YI75ZudUb+
         /s8IDnhxEIc6lGO8W+D61DUMeJi0FO++1694qa1L6duA1/LS/iG2So1CjV+S29u/MDsE
         eJYA==
X-Gm-Message-State: AOAM530b9SVOTA8dwXToF5saknWfM6vgR1CFgN+fAMHRpW+DMBjxf5MG
        dvModoJeVu6LZ9G7cvNRQic=
X-Google-Smtp-Source: ABdhPJyMb6oqhNZUh06b9eZZRuGz2ClyZ27cVMAxafcoo/IA0DxWez8RDa2abKzxif5ISzyyptlCpw==
X-Received: by 2002:a63:2bc5:: with SMTP id r188mr7029237pgr.179.1629867602852;
        Tue, 24 Aug 2021 22:00:02 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id u21sm24499677pgk.57.2021.08.24.22.00.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 22:00:02 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] build: doc: Fix man pages
Date:   Wed, 25 Aug 2021 14:59:56 +1000
Message-Id: <20210825045956.12029-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

- Split off and expand shell script from within doxygen/Makefile.am
  The addition is a man page post-processor. It does the following:
  - If there is a "Modules" section, delete it
  - If "Detailed Description" is empty, delete "Detailed Description" line
  - Reposition SYNOPSIS (with headers that we inserted) to start of page,
    integrating with defined functions to look like other man pages
  - Delete all "Definition at line nnn" lines
  - Delete lines that make older versions of man o/p an unwanted blank line
  For better readability, shell function definitions are separated by blank
  lines, and there is a bit of annotation.
- Avoid having to special-case `make distcheck` in doxygen/Makefile.am:
  - Move doxygen.cfg.in to doxygen/
  - Tell doxygen.cfg.in where the sources are
  - Let doxygen.cfg.in default its output to CWD
  - In Makefile, `doxygen doxygen.cfg` "just works"
- Fix VPATH builds (e.g. mkdir build; cd build; ../configure; make). Also
  ensure `make distcleancheck` passes (VPATH builds only).
- Allow to specify whether to produce man pages, html, neither or both.
  - configure --help lists non-default documentation options.
    Looking around the web, this seemed to me to be what most projects do.
    Listed options are --without-doxygen, --enable-html-doc &
    --disable-man-pages.
  - configure warns on inconsistent options e.g. --without-doxygen by itself
    warns man pages will not be built.
  - configure.ac re-ordered so --without-doxygen overrides --enable-any-doc.
  If html is requested, `make install` installs it in htmldir.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 configure.ac                             |  45 ++++-
 doxygen/Makefile.am                      |  59 ++----
 doxygen/build_man.sh                     | 219 +++++++++++++++++++++++
 doxygen.cfg.in => doxygen/doxygen.cfg.in |   6 +-
 4 files changed, 275 insertions(+), 54 deletions(-)
 create mode 100755 doxygen/build_man.sh
 rename doxygen.cfg.in => doxygen/doxygen.cfg.in (87%)

diff --git a/configure.ac b/configure.ac
index 0fe754c..a4fb629 100644
--- a/configure.ac
+++ b/configure.ac
@@ -13,6 +13,35 @@ m4_ifdef([AM_PROG_AR], [AM_PROG_AR])
 dnl kernel style compile messages
 m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
 
+dnl Must check for --without-doxygen before  checking --enable-*
+AC_ARG_WITH([doxygen], [AS_HELP_STRING([--without-doxygen],
+	    [Don't run doxygen (to create documentation)])],
+	    [with_doxygen="$withval"], [with_doxygen=yes])
+
+AC_ARG_ENABLE([html-doc],
+	      AS_HELP_STRING([--enable-html-doc], [Enable html documentation]),
+	      [], [enable_html_doc=no])
+AS_IF([test "$with_doxygen" = no -a "$enable_html_doc" = yes], [
+	AC_MSG_WARN([Doxygen disabled - html documentation will not be built])
+	enable_html_doc=no
+])
+AM_CONDITIONAL([BUILD_HTML], [test "$enable_html_doc" = yes])
+AS_IF([test "$enable_html_doc" = yes],
+	[AC_SUBST(GEN_HTML, YES)],
+	[AC_SUBST(GEN_HTML, NO)])
+
+AC_ARG_ENABLE([man-pages],
+	      AS_HELP_STRING([--disable-man-pages], [Disable man page documentation]),
+	      [], [enable_man_pages=yes])
+AS_IF([test "$with_doxygen" = no -a "$enable_man_pages" = yes], [
+	AC_MSG_WARN([Doxygen disabled - man pages will not be built])
+	enable_man_pages=no
+])
+AM_CONDITIONAL([BUILD_MAN], [test "$enable_man_pages" = yes])
+AS_IF([test "$enable_man_pages" = yes],
+	[AC_SUBST(GEN_MAN, YES)],
+	[AC_SUBST(GEN_MAN, NO)])
+
 AC_PROG_CC
 AM_PROG_CC_C_O
 AC_DISABLE_STATIC
@@ -31,14 +60,12 @@ PKG_CHECK_MODULES([LIBMNL], [libmnl >= 1.0.3])
 
 dnl Output the makefiles
 AC_CONFIG_FILES([Makefile src/Makefile utils/Makefile examples/Makefile
-        libnetfilter_queue.pc doxygen.cfg
+	libnetfilter_queue.pc
 	include/Makefile include/libnetfilter_queue/Makefile
-	doxygen/Makefile
+	doxygen/Makefile doxygen/doxygen.cfg
 	include/linux/Makefile include/linux/netfilter/Makefile])
 
-AC_ARG_WITH([doxygen], [AS_HELP_STRING([--with-doxygen],
-	    [create doxygen documentation])],
-	    [with_doxygen="$withval"], [with_doxygen=yes])
+AS_IF([test "$enable_man_pages" = no -a "$enable_html_doc" = no], [with_doxygen=no])
 
 AS_IF([test "x$with_doxygen" != xno], [
 	AC_CHECK_PROGS([DOXYGEN], [doxygen])
@@ -52,12 +79,16 @@ AM_CONDITIONAL([HAVE_DOXYGEN], [test -n "$DOXYGEN"])
 AS_IF([test "x$DOXYGEN" = x], [
 	AS_IF([test "x$with_doxygen" != xno], [
 		dnl Only run doxygen Makefile if doxygen installed
-		AC_MSG_WARN([Doxygen not found - continuing without Doxygen support])
+		AC_MSG_WARN([Doxygen not found - no documentation will be built])
 		with_doxygen=no
+		enable_html_doc=no
+		enable_man_pages=no
 	])
 ])
 AC_OUTPUT
 
 echo "
 libnetfilter_queue configuration:
-  doxygen:                      ${with_doxygen}"
+  doxygen:                      ${with_doxygen}
+man pages:                      ${enable_man_pages}
+html docs:                      ${enable_html_doc}"
diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
index 29078de..5235f78 100644
--- a/doxygen/Makefile.am
+++ b/doxygen/Makefile.am
@@ -4,49 +4,11 @@ doc_srcs = $(shell find $(top_srcdir)/src -name '*.c')
 
 doxyfile.stamp: $(doc_srcs) Makefile.am
 	rm -rf html man
+	doxygen doxygen.cfg >/dev/null
 
-# Test for running under make distcheck.
-# If so, sibling src directory will be empty:
-# move it out of the way and symlink the real one while we run doxygen.
-	[ -f ../src/Makefile.in ] || \
-{ set -x; cd ..; mv src src.distcheck; ln -s $(top_srcdir)/src; }
-
-	cd ..; doxygen doxygen.cfg >/dev/null
-
-	[ ! -d ../src.distcheck ] || \
-{ set -x; cd ..; rm src; mv src.distcheck src; }
-
-# We need to use bash for its associative array facility
-# (`bash -p` prevents import of functions from the environment).
-# The command has to be a single line so the functions work
-# and so `make` gives all lines to `bash -c`
-# (hence ";\" at the end of every line but the last).
-	/bin/bash -p -c 'declare -A renamed_page;\
-main(){ set -e; cd man/man3; rm -f _*;\
-  count_real_pages;\
-  rename_real_pages;\
-  make_symlinks;\
-};\
-count_real_pages(){ page_count=0;\
-  for i in $$(ls -S);\
-  do head -n1 $$i | grep -E -q '^\.so' && break;\
-    page_count=$$(($$page_count + 1));\
-  done;\
-  first_link=$$(($$page_count + 1));\
-};\
-rename_real_pages(){ for i in $$(ls -S | head -n$$page_count);\
-  do for j in $$(ls -S | tail -n+$$first_link);\
-    do grep -E -q $$i$$ $$j && break;\
-    done;\
-    mv -f $$i $$j;\
-    renamed_page[$$i]=$$j;\
-  done;\
-};\
-make_symlinks(){ for j in $$(ls -S | tail -n+$$first_link);\
-  do ln -sf $${renamed_page[$$(cat $$j | cut -f2 -d/)]} $$j;\
-  done;\
-};\
-main'
+if BUILD_MAN
+	$(abs_top_srcdir)/doxygen/build_man.sh
+endif
 
 	touch doxyfile.stamp
 
@@ -54,13 +16,22 @@ CLEANFILES = doxyfile.stamp
 
 all-local: doxyfile.stamp
 clean-local:
-	rm -rf $(top_srcdir)/doxygen/man $(top_srcdir)/doxygen/html
+	rm -rf man html
 install-data-local:
+if BUILD_MAN
 	mkdir -p $(DESTDIR)$(mandir)/man3
 	cp --no-dereference --preserve=links,mode,timestamps man/man3/*.3\
 	  $(DESTDIR)$(mandir)/man3/
+endif
+if BUILD_HTML
+	mkdir  -p $(DESTDIR)$(htmldir)
+	cp  --no-dereference --preserve=links,mode,timestamps html/*\
+		$(DESTDIR)$(htmldir)
+endif
 
 # make distcheck needs uninstall-local
 uninstall-local:
-	rm -r $(DESTDIR)$(mandir) man html doxyfile.stamp
+	rm -rf $(DESTDIR)$(mandir) man html doxyfile.stamp $(DESTDIR)$(htmldir)
 endif
+
+EXTRA_DIST = build_man.sh
diff --git a/doxygen/build_man.sh b/doxygen/build_man.sh
new file mode 100755
index 0000000..e0cda71
--- /dev/null
+++ b/doxygen/build_man.sh
@@ -0,0 +1,219 @@
+#!/bin/bash -p
+
+# Script to process man pages output by doxygen.
+# We need to use bash for its associative array facility.
+# (`bash -p` prevents import of functions from the environment).
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
diff --git a/doxygen.cfg.in b/doxygen/doxygen.cfg.in
similarity index 87%
rename from doxygen.cfg.in
rename to doxygen/doxygen.cfg.in
index 266782e..14bd0cf 100644
--- a/doxygen.cfg.in
+++ b/doxygen/doxygen.cfg.in
@@ -1,12 +1,11 @@
 # Difference with default Doxyfile 1.8.20
 PROJECT_NAME           = @PACKAGE@
 PROJECT_NUMBER         = @VERSION@
-OUTPUT_DIRECTORY       = doxygen
 ABBREVIATE_BRIEF       =
 FULL_PATH_NAMES        = NO
 TAB_SIZE               = 8
 OPTIMIZE_OUTPUT_FOR_C  = YES
-INPUT                  = .
+INPUT                  = @abs_top_srcdir@/src
 FILE_PATTERNS          = *.c
 RECURSIVE              = YES
 EXCLUDE_SYMBOLS        = EXPORT_SYMBOL \
@@ -22,7 +21,8 @@ ALPHABETICAL_INDEX     = NO
 SEARCHENGINE           = NO
 GENERATE_LATEX         = NO
 LATEX_CMD_NAME         = latex
-GENERATE_MAN           = YES
+GENERATE_MAN           = @GEN_MAN@
+GENERATE_HTML          = @GEN_HTML@
 MAN_LINKS              = YES
 HAVE_DOT               = @HAVE_DOT@
 DOT_TRANSPARENT        = YES
-- 
2.17.5

