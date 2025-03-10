Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08858846C
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Mar 2025 01:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741571231; cv=none; b=iCpDosOKH4OWunVRGJmhllmlmOROii0gCRKfGKAnrCkUPeYe7Mb8v29NvrG2CLgvFaN0fckfdhcu/lr8FSk0PhMabh/gHak+he6CrrpzkaiKRtP7LpBNZQyXun6WbXKaE3DYn8raWWFqhZe035zrz/j6QFi3qijIInzavSmWACc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741571231; c=relaxed/simple;
	bh=mHWumNsDVJzRmnv1iSHTSryLtg3qompiGQlYUMji3Ss=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=M+vmLSEikCZMn+PnDH0DhRTwwemFznHvrsylrlFHK3BdIE8N1IE52p2kvIr73K5ozVQYrjbJ4q1qCW3WrVdHk1UhmJqOamgMKxaBOSgcKX7XBrKpeJAIyzKcsIOvxkzmK4aeZ8oF047ZNTGyMDgvMtUmA9bGpxG3NC2vxYYXrCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nnyySzEv; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nnyySzEv"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-223a7065ff8so50674305ad.0
        for <netfilter-devel@vger.kernel.org>; Sun, 09 Mar 2025 18:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741571225; x=1742176025; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=BnL96Rbo7Zc2opLI0CPO/OS7gD+RdaDtmwAnyyjoo00=;
        b=nnyySzEvto6espqI/ywAq5ZY5LKFAR3pnpVBXzmCluwId3Xje7uXAmqkL9drv27Ow3
         QaJMeRWIForuaqAvnBSWVX/iht/1lfn2Cu0T2P05FLdbZGI5201lTGXbz2MjSLDOqW0S
         96jTLXal2XfcxRNtwlyahVTM4GblaX10iYASsxyxIW3wdAwSXSKZ+Z1//7ABwVT+wI+a
         w63Aw/kDBSplOuNth0eXy0VJ0djvv+Rc8ZyP18kbXJKpJk+GnJKaQz1lPIpyfHLS91Ez
         q1eXzZyXsWGDYcYIalQNG1wHOncjbd5bls9XNwQEYhmhO1iZQQFnD+TDFjpnmP0RtkW4
         r5vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741571225; x=1742176025;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BnL96Rbo7Zc2opLI0CPO/OS7gD+RdaDtmwAnyyjoo00=;
        b=kmTApm9226B8Js1e2I17yoyt31OH1gWJTbKnbQxnLyLowyHNADzbWVI/wV7tHMJ7yF
         vff8bH4UZEOK8ve8AyXj/mZNonIzcZCP79MVtWQ02z+EPR5wg94Q8p+gdK3dGD0NN0qA
         zfH4wgRkdxVRj20mOCvIK5l/pYZL6ABTJthvAulsbiVk9CMrGB0qK2isErErAIqUvEjH
         528lbYtCSplNSv5ystFEAdThUnsGjq2+m4rtP4FYwihIme4D4u/xIgxCdeFafwzeOYed
         CmwU65euAo62pFK0MqPc4p78S6xQ+I7xiKI4dzv4GhG/Mwb8rhAOLjz7E4T6IoZMpGNJ
         FICA==
X-Gm-Message-State: AOJu0Yw0ggu7BH8IOqhSRi9utt4BlrxMf1uAm9sRx6IZD774jNL4r9Vk
	DXy66G4OWpuV0TwxjtGy18pQOkAvzDeBlAg6mIZOO4o6zT37qIXfp4x1BA==
X-Gm-Gg: ASbGnctcsJKtH/tc17wcPRsq/GDcDSXK1OKp96NJlbG8SukYaRaPpyKSD0ql8V46QwK
	KZ7cUqPyAWpVm/U/U6i1DbHuPaUUdCMBrUsue3H3aOmGi2+1NEChLdJqZXT7gn2bHpBzFaC4XUK
	xJOdfkhDDmvzxtCSxC3SZXmitQz0sChGsB0rlWhxt77kU+yOSo5/tvU9Lt4BFkYfBgj20uEiBur
	eK8TYe279LWIHkG6PLsa+nqoN3GBYodnQbgsraCYgjvU7uJxG+fcEArD/d1KLxIbwcogZc7wTK7
	2MhmEHCMyFI1qGjWrP4Rk51VVOKcVzDqKPggeg6JCxQ+O7iJDcuBj5fVXKA9Gz1PwCNpHu8jUpO
	tCVpvLlexQQGUyyCj/+HJRvNLySLbzw==
X-Google-Smtp-Source: AGHT+IHV5j2bmZHKUMm3kqjrKnTnSp/9GVrLazFEBZhxdXKrmZyS1PfTRkmrlw8sNm7UdT6f34O8Gw==
X-Received: by 2002:a05:6a00:17a7:b0:736:a638:7f9e with SMTP id d2e1a72fcca58-736aa9de258mr21232383b3a.8.1741571224570;
        Sun, 09 Mar 2025 18:47:04 -0700 (PDT)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736cf475dd8sm1754986b3a.101.2025.03.09.18.47.02
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Mar 2025 18:47:03 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_log] build: doc: Avoid autogen.sh contaminating the repository
Date: Mon, 10 Mar 2025 12:46:58 +1100
Message-Id: <20250310014658.9363-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After autogen.sh fetched doxygen/build_man.sh from the
libnetfilter_queue project, git log would show
> Changes not staged for commit:
>         modified:   doxygen/build_man.sh
The fetched file has had fixes, workarounds and speedups
since the local copy was comitted, so get rid of the local copy.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 .gitignore           |   1 +
 doxygen/build_man.sh | 227 -------------------------------------------
 2 files changed, 1 insertion(+), 227 deletions(-)
 delete mode 100755 doxygen/build_man.sh

diff --git a/.gitignore b/.gitignore
index 2dc0dfa..3a74709 100644
--- a/.gitignore
+++ b/.gitignore
@@ -18,6 +18,7 @@ Makefile.in
 
 /doxygen/doxygen.cfg
 /doxygen/doxyfile.stamp
+doxygen/build_man.sh
 /doxygen/man/
 /doxygen/html/
 /*.pc
diff --git a/doxygen/build_man.sh b/doxygen/build_man.sh
deleted file mode 100755
index 852c7b8..0000000
--- a/doxygen/build_man.sh
+++ /dev/null
@@ -1,227 +0,0 @@
-#!/bin/bash -p
-
-# Script to process man pages output by doxygen.
-# We need to use bash for its associative array facility.
-# (`bash -p` prevents import of functions from the environment).
-
-declare -A renamed_page
-
-main(){
-  set -e
-  cd man/man3; rm -f _*
-  count_real_pages
-  rename_real_pages
-  make_symlinks
-  post_process
-}
-
-count_real_pages(){
-  page_count=0
-  #
-  # Count "real" man pages (i.e. not generated by MAN_LINKS)
-  # MAN_LINKS pages are 1-liners starting .so
-  # Method: list files in descending order of size,
-  # looking for the first 1-liner
-  #
-  for i in $(ls -S)
-  do head -n1 $i | grep -E -q '^\.so' && break
-    page_count=$(($page_count + 1))
-  done
-  first_link=$(($page_count + 1))
-}
-
-rename_real_pages(){
-  for i in $(ls -S | head -n$page_count)
-  do for j in $(ls -S | tail -n+$first_link)
-    do grep -E -q $i$ $j && break
-    done
-    mv -f $i $j
-    renamed_page[$i]=$j
-  done
-}
-
-make_symlinks(){
-  for j in $(ls -S | tail -n+$first_link)
-  do ln -sf ${renamed_page[$(cat $j | cut -f2 -d/)]} $j
-  done
-}
-
-post_process(){
-  make_temp_files
-  #
-  # DIAGNOSTIC / DEVELOPMENT CODE
-  # set -x and restrict processing to keep_me: un-comment to activate
-  # Change keep_me as required
-  #
-  #keep_me=nfq_icmp_get_hdr.3;\
-  #do_diagnostics;\
-  #
-  # Work through the "real" man pages
-  for target in $(ls -S | head -n$page_count)
-  do mygrep "^\\.SH \"Function Documentation" $target
-    # Next file if this isn't a function page
-    [ $linnum -ne 0 ] || continue
-
-    del_modules
-    del_bogus_synopsis
-    fix_name_line
-    move_synopsis
-    del_empty_det_desc
-    del_def_at_lines
-    fix_double_blanks
-
-    # Fix rendering of verbatim "\n" (in code snippets)
-    sed -i 's/\\n/\\\\n/' $target
-
-  done
-
-  remove_temp_files
-}
-
-fix_double_blanks(){
-  linnum=1
-  #
-  # Older versions of man display a blank line on encountering "\fB\fP";
-  # newer versions of man do not.
-  # doxygen emits "\fB\fP" on seeing "\par" on a line by itself.
-  # "\par" gives us double-spacing in the web doc, which we want, but double-
-  # spacing looks odd in a man page so remove "\fB\fP".
-  #
-  while [ $linnum -ne 0 ]
-  do mygrep \\\\fB\\\\fP $target
-    [ $linnum -eq 0 ] || delete_lines $linnum $linnum
-  done
-}
-
-del_def_at_lines(){
-  linnum=1
-  while [ $linnum -ne 0 ]
-  do mygrep "^Definition at line [[:digit:]]* of file" $target
-    [ $linnum -eq 0 ] || delete_lines $(($linnum - 1)) $linnum
-  done
-}
-
-# Only invoked if you un-comment the 2 diagnostic / development lines above
-do_diagnostics(){
-  mv $keep_me xxx
-  rm *.3
-  mv xxx $keep_me
-  page_count=1
-  set -x
-}
-
-del_empty_det_desc(){
-  mygrep "^\\.SH \"Function Documentation" $target
-  i=$linnum
-  mygrep "^\\.SH \"Detailed Description" $target
-  [ $linnum -ne 0  ] || return 0
-  [ $(($i - $linnum)) -eq 3 ] || return 0
-  # A 1-line Detailed Description is also 3 lines long,
-  # but the 3rd line is not empty
-  i=$(($i -1))
-  [ $(tail -n+$i $target | head -n1 | wc -c) -le 2 ] || return 0
-  delete_lines $linnum $i
-}
-
-move_synopsis(){
-  mygrep "SH SYNOPSIS" $target
-  [ $linnum -ne 0  ] || return 0
-  i=$linnum
-  # If this is a doxygen-created synopsis, leave it.
-  # (We haven't inserted our own one in the source yet)
-  mygrep "^\\.SS \"Functions" $target
-  [ $i -gt $linnum ] || return 0
-
-  mygrep "^\\.SH \"Function Documentation" $target
-  j=$(($linnum - 1))
-  head -n$(($j - 1)) $target | tail -n$(($linnum - $i - 1)) >$fileC
-  delete_lines $i $j
-  mygrep "^\\.SS \"Functions" $target
-  head -n$(($linnum - 1)) $target >$fileA
-  tail -n+$(($linnum + 1)) $target >$fileB
-  cat $fileA $fileC $fileB >$target
-}
-
-fix_name_line(){
-  all_funcs=""
-
-  # Search a shortened version of the page in case there are .RI lines later
-  mygrep "^\\.SH \"Function Documentation" $target
-  head -n$linnum $target >$fileC
-
-  while :
-  do mygrep ^\\.RI $fileC
-    [ $linnum -ne 0 ] || break
-    # Discard this entry
-    tail -n+$(($linnum + 1)) $fileC >$fileB
-    cp $fileB $fileC
-
-    func=$(cat $fileG | cut -f2 -d\\ | cut -c3-)
-    [ -z "$all_funcs" ] && all_funcs=$func ||\
-      all_funcs="$all_funcs, $func"
-  done
-  # For now, assume name is at line 5
-  head -n4 $target >$fileA
-  desc=$(head -n5 $target | tail -n1 | cut -f3- -d" ")
-  tail -n+6 $target >$fileB
-  cat $fileA >$target
-  echo "$all_funcs \\- $desc" >>$target
-  cat $fileB >>$target
-}
-
-del_modules(){
-  mygrep "^\.SS \"Modules" $target
-  [ $linnum -ne 0  ] || return 0
-  i=$linnum
-  mygrep "^\\.SS \"Functions" $target
-  delete_lines $i $(($linnum - 1))
-}
-
-del_bogus_synopsis(){
-  mygrep "SH SYNOPSIS" $target
-  #
-  # doxygen 1.8.20 inserts its own SYNOPSIS line but there is no mention
-  # in the documentation or git log what to do with it.
-  # So get rid of it
-  #
-  [ $linnum -ne 0  ] || return 0
-  i=$linnum
-  # Look for the next one
-  tail -n+$(($i + 1)) $target >$fileC;\
-  mygrep "SH SYNOPSIS" $fileC
-  [ $linnum -ne 0  ] || return 0
-
-  mygrep "^\\.SS \"Functions" $target
-  delete_lines $i $(($linnum - 1))
-}
-
-# Delete lines $1 through $2 from $target
-delete_lines(){
-  head -n$(($1 - 1)) $target >$fileA
-  tail -n+$(($2 +1)) $target >$fileB
-  cat $fileA $fileB >$target
-}
-
-mygrep(){
-  set +e
-  grep -En "$1" $2 2>/dev/null >$fileH
-  [ $? -ne 0 ] && linnum=0 ||\
-    { head -n1 $fileH >$fileG; linnum=$(cat $fileG | cut -f1 -d:); }
-  set -e
-}
-
-make_temp_files(){
-  temps="A B C G H"
-  for i in $temps
-  do declare -g file$i=$(mktemp)
-  done
-}
-
-remove_temp_files(){
-  for i in $temps
-  do j=file$i
-    rm ${!j}
-  done
-}
-
-main
-- 
2.46.3

