Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB476C4320A
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Aug 2021 03:43:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8781B6108E
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Aug 2021 03:43:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238049AbhHZDom (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Aug 2021 23:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235803AbhHZDom (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Aug 2021 23:44:42 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0518C061757
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Aug 2021 20:43:55 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id oa17so1294152pjb.1
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Aug 2021 20:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=onfLGWB8XWmbAy3oUNVY/ycjrD2iZZShg1CgFjokcKs=;
        b=ZqDleCSyUM4iT/nF2ZoZ1bMDB8GgAbhVCfbXPN8X9F9NiSgriNIQM6+jZbEaQkCN+N
         JBFcylmeyP+Zn2QURx5cqNuFIL9unrY40NKrM1tuIr6nl82DoX3WTKENQjfSeOJ4vUkO
         zEGDEzjP144ZCmJxJFjPk5pMGdIKXcTS+yQpenLg3Y9VczxLy/+Jk0VPFABSy6hs1wr0
         ndCGcXryRRLKeq7HMgvpIThtIT9te69o9pCY+Ei0t0oUb7GC2RHKZTrC1yHcg7V0T0V5
         DswBprpYAWKV+kmCwzYxmKgRmq6PlyHMZLKUlB6FkqwPrXE4x2fNEUNPbGKlLqBaxhnE
         K3FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=onfLGWB8XWmbAy3oUNVY/ycjrD2iZZShg1CgFjokcKs=;
        b=q1Ts6B0tOtjteTD+mnQF3OflekcoifGxvqnxphtzKHSQ7JwtMjS8cpIyE/lkIHagYW
         sx8tj4cLc7eSzfMZ+u/xSm49Rhcd5HCU0W+s6vzpQIIBb694kHaNIASZM9v9Oz0cun40
         9SYdrSG1+X0yTGQ1wDS07AP1zhlC8rEog1fX8xSQa8vnxsaNBTrTJVtQF3PAOJGrvbvp
         ONMOIocWEiwtN5VKdlqoL1H0rL10jPlyYWqGncSQepNjloaghK/BciupJQFRDZG9VIFg
         fELhU+8YKA4YwoxZX4SnKNIfKYUIBfIFYqUzFztNkP8uusIWzroieWpUTCCu5knm7iom
         XULg==
X-Gm-Message-State: AOAM532EeU/jTT1V+oqY74oEm3rShaD+UUv13Oi7TXX7EOa5mauYTSxg
        UGusq013Ts3iv+9EGEVb5dCsHKnc9stvLA==
X-Google-Smtp-Source: ABdhPJw9CMCBrAqSJ2XySWIeV4QzoReVgd4rNtt6wjhEjx98xCciIUiDQGjZEZY+zhH6fk8gByR9Tg==
X-Received: by 2002:a17:90b:3681:: with SMTP id mj1mr13734219pjb.219.1629949435153;
        Wed, 25 Aug 2021 20:43:55 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id s11sm1109193pfh.18.2021.08.25.20.43.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 20:43:54 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v2 2/5] build: doc: Add a man page post-processor to build_man.sh
Date:   Thu, 26 Aug 2021 13:43:43 +1000
Message-Id: <20210826034346.13224-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210826034346.13224-1-duncan_roe@optusnet.com.au>
References: <20210826034346.13224-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

- If there is a "Modules" section, delete it
- If "Detailed Description" is empty, delete "Detailed Description" line
- Reposition SYNOPSIS (with headers that we inserted) to start of page,
  integrating with defined functions to look like other man pages
- Delete all "Definition at line nnn" lines
- Delete lines that make older versions of man o/p an unwanted blank line
For better readability, shell function definitions are separated by blank
lines, and there is a bit of annotation.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doxygen/build_man.sh | 200 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 195 insertions(+), 5 deletions(-)

diff --git a/doxygen/build_man.sh b/doxygen/build_man.sh
index 304a305..e0cda71 100755
--- a/doxygen/build_man.sh
+++ b/doxygen/build_man.sh
@@ -1,20 +1,37 @@
 #!/bin/bash -p
-# We need to use bash for its associative array facility
+
+# Script to process man pages output by doxygen.
+# We need to use bash for its associative array facility.
 # (`bash -p` prevents import of functions from the environment).
+
 declare -A renamed_page
-main(){ set -e; cd man/man3; rm -f _*
+
+main(){
+  set -e
+  cd man/man3; rm -f _*
   count_real_pages
   rename_real_pages
   make_symlinks
+  post_process
 }
-count_real_pages(){ page_count=0
+
+count_real_pages(){
+  page_count=0
+  #
+  # Count "real" man pages (i.e. not generated by MAN_LINKS)
+  # MAN_LINKS pages are 1-liners starting .so
+  # Method: list files in descending order of size,
+  # looking for the first 1-liner
+  #
   for i in $(ls -S)
   do head -n1 $i | grep -E -q '^\.so' && break
     page_count=$(($page_count + 1))
   done
   first_link=$(($page_count + 1))
 }
-rename_real_pages(){ for i in $(ls -S | head -n$page_count)
+
+rename_real_pages(){
+  for i in $(ls -S | head -n$page_count)
   do for j in $(ls -S | tail -n+$first_link)
     do grep -E -q $i$ $j && break
     done
@@ -22,8 +39,181 @@ rename_real_pages(){ for i in $(ls -S | head -n$page_count)
     renamed_page[$i]=$j
   done
 }
-make_symlinks(){ for j in $(ls -S | tail -n+$first_link)
+
+make_symlinks(){
+  for j in $(ls -S | tail -n+$first_link)
   do ln -sf ${renamed_page[$(cat $j | cut -f2 -d/)]} $j
   done
 }
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
 main
-- 
2.17.5

