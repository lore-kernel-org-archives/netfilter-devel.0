Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B6817BB6
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2025 09:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741771885; cv=none; b=DXqGWqM2k+hY4a1FAlVJuuuKY9zzPIq07BFNGfgeBW8ETebgVL17J+aWOOAankerpwr0y0WKaoIyJrPVSV2XeQRm9JCD2zwK6zhm+yn3hVP3wBYUAaLUxkqtDSFch9W9U5nPutIJtUSPBIZLXw5fKVDAX/1wr4I6ZXu6sxQr5DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741771885; c=relaxed/simple;
	bh=CW40BB0Pi0LHI/yrLgWRMW09drsR+klIhlfBrUr5b/M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Foq8JpaGRNpoxy6G46oF51ZN0ZLuY7BFEn3Ri6hnUfBTBelHLILmdiz/QxZWB8wwkW0AalmyQOremfNPBfZUPUW/ttWhw5kvE117NH1vROT3dBtxS6EkRYDGIib6RddqR/T3nh/oojO2XP17BD9wQBmc29mv89uEktCDPsZrnsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=USVseVwu; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="USVseVwu"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-223959039f4so129475295ad.3
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2025 02:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741771882; x=1742376682; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=Qa6hzhuuEUYRjhGd1mTkxK45D5kbAv5+h4Iy12ejMgQ=;
        b=USVseVwuLToW9raOpSXjCBJeBZs31tflzwKkZORuj6n+Px8hPq+Pv3E336egOtwdp3
         QpXc9OS3i3z9bKn2dFbNvdTBEXuO2OGaOL66CWJEEAyjP80PWt7l0ba/Gx7FKegViera
         M+qlm+kzdYhIFwMMUB/eXoVgQWxAw169c0uaqrXziweaO/DVuj7U/qoDdXGwyaLd4+cS
         QNN1DfeTx7CcibDrFZO6zeKkoPQFkJkliG03GccA8CerJzV22RwvPKAIM0QqCWO7/kBT
         /UHlaq68jii9sIHjMEgFqwD952oooZ83hoxBo6wtQ9HEIzU1Yp9ImcNiAPXXt1/SBrUe
         vecA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741771882; x=1742376682;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qa6hzhuuEUYRjhGd1mTkxK45D5kbAv5+h4Iy12ejMgQ=;
        b=r+DyO7hOoIOr7vCu5K5XE3CIom62WOCE4y74iWe8oxhEN0mZfW1RIb8h5WuY85obj0
         wslFU4COcnqfNoXy9AZW1XFA1PnFV0ngCkFEIn5l9m497TOGUwgEpZJ5utzJfGUOh8uU
         CqVhU+hrXYK0RLChVr3uWoWrsLAgovM5NAyrI7zKSmW5HllF3w3jEf9Eg3AdWUQ3Pl/o
         jB7cH50Jy7k6FrlS1CoVFxhdeRCPAKT5hpX/m5jZdPjdFxRX8whuwBvon0TGGeXyT3BF
         FLmUYbFK7Cl+79bltfjaCTeSiNkiITbUJPOOKC623CuLRIhyNbAcdoG1IKZo5ByOLib5
         dbUA==
X-Gm-Message-State: AOJu0YzZFQejqO9F5wwMdFg0Pj9uen/30f+lerViuDZGO41+76SMQDjy
	igdQNq21udPdQZfMOGCBH0kXq059BWrtabGX3vDQanDBJBO0v8gnU2jOSQ==
X-Gm-Gg: ASbGncs3zuv7QFk3tTaZdFMfkz5jtp57q6sz1xBhdaZamUW4ppA86JAEgcIJt0GQK1C
	mW5JIHpAY2o795A07UUXubk6+lEuywAUA6xFxv8+aEWLCxx9k7v5yEZyo3CMuRro1sO8rrrnv3k
	pvmCxix3JujRldOxAX7a9h8XFsmazvkuF/q2JmHiyhI338VCXRMxrUdSGAR8T+nMa3bj3G+yUJx
	lYz/qKk8IaZWb3pacQT5CiCqArg9jGhPsFShSX+rnvobLfHr2LEOr2vRaTCBONLe9SbSeZpNrLt
	EOePdI0b7crBDFQ32zSxC9WoMMzlXm1Qa8eUcl09RbXazIbEMAHpgiNuuF9nm/Ho8xdKGSItzam
	4a/prCg27tHWMCjqLjVhr6DkfhKVNtg==
X-Google-Smtp-Source: AGHT+IG53RQbqWa1qQMoJOvPLGi0fkW4WvHT3GWrcQd2RAUOslQAcwu85eR40Wt55sIHhMardU23Cg==
X-Received: by 2002:a17:903:283:b0:216:2bd7:1c2f with SMTP id d9443c01a7336-2242888d06amr271809585ad.18.1741771881687;
        Wed, 12 Mar 2025 02:31:21 -0700 (PDT)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22410aa8ae4sm111953745ad.243.2025.03.12.02.31.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Mar 2025 02:31:21 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: netfilter-devel@vger.kernel.org
Cc: fw@netfilter.org,
	pablo@netfilter.org
Subject: [PATCH libnetfilter_log] build: doc: Install latest build_man.sh from libnetfilter_queue
Date: Wed, 12 Mar 2025 20:31:16 +1100
Message-Id: <20250312093116.11655-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

autogen.sh no longer fetches doxygen/build_man.sh from the
libnetfilter_queue project using curl.
Instead, just check in that file here.

Summary of updates (from git log in libnetfilter_queue tree):
512cd12 build: doc: Fix silly error in test
60aa427 build: doc: Fix `fprintf` in man pages from using single quotes
f54dc69 build: doc: Only fix rendering of verbatim '\n"' when needed
809240b build: add missing backslash to build_man.sh
6d17e6d build: Speed up build_man.sh
b35f537 make the HTML main page available as `man 7 libnetfilter_queue`
7cff95b build: doc: Update build_man.sh to find bash in PATH
088c883 build: doc: Update build_man.sh for doxygen 1.9.2

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doxygen/build_man.sh | 276 ++++++++++++++++++++++++++++++-------------
 1 file changed, 193 insertions(+), 83 deletions(-)

diff --git a/doxygen/build_man.sh b/doxygen/build_man.sh
index 852c7b8..50ab884 100755
--- a/doxygen/build_man.sh
+++ b/doxygen/build_man.sh
@@ -1,18 +1,25 @@
-#!/bin/bash -p
+#!/bin/sh
+[ -n "$BASH" ] || exec bash -p $0 $@
 
 # Script to process man pages output by doxygen.
 # We need to use bash for its associative array facility.
 # (`bash -p` prevents import of functions from the environment).
+# Args: none or 2 being man7 page name & relative path of source with \mainpage
 
 declare -A renamed_page
+done_synopsis=false
 
 main(){
   set -e
-  cd man/man3; rm -f _*
+  # make_man7 has no dependencies or dependants so kick it off now
+  [ $# -ne 2 ] || make_man7 $@ &
+  pushd man/man3 >/dev/null; rm -f _*
   count_real_pages
   rename_real_pages
-  make_symlinks
-  post_process
+  # Nothing depends on make_symlinks so background it
+  make_symlinks &
+  post_process $@
+  wait
 }
 
 count_real_pages(){
@@ -32,9 +39,16 @@ count_real_pages(){
 
 rename_real_pages(){
   for i in $(ls -S | head -n$page_count)
-  do for j in $(ls -S | tail -n+$first_link)
-    do grep -E -q $i$ $j && break
-    done
+  do
+    j=$(ed -s $i <<////
+/Functions/+1;.#
+/^\\.RI/;.#
+.,.s/^.*\\\\fB//
+.,.s/\\\\.*//
+.,.w /dev/stdout
+Q
+////
+).3
     mv -f $i $j
     renamed_page[$i]=$j
   done
@@ -47,35 +61,144 @@ make_symlinks(){
 }
 
 post_process(){
-  make_temp_files
   #
   # DIAGNOSTIC / DEVELOPMENT CODE
   # set -x and restrict processing to keep_me: un-comment to activate
   # Change keep_me as required
   #
-  #keep_me=nfq_icmp_get_hdr.3;\
-  #do_diagnostics;\
-  #
+  #keep_me=nfq_icmp_get_hdr.3
+  #do_diagnostics
+
+  # Record doxygen version
+  i=$(doxygen --version)
+  doxymajor=$(echo $i|cut -f1 -d.)
+  doxyminor=$(echo $i|cut -f2 -d.)
+
+  # Decide if we need to fix rendering of verbatim "\n"
+  [ $doxymajor -eq 1 -a $doxyminor -lt 9 ] &&
+    fix_newlines=true || fix_newlines=false
+
+  # Decide if we need to fix double-to-single-quote conversion
+  [ $doxymajor -eq 1 -a $doxyminor -ge 9 -a $doxyminor -lt 13 ] &&
+    fix_quotes = true || fix_quotes=false
+
   # Work through the "real" man pages
   for target in $(ls -S | head -n$page_count)
-  do mygrep "^\\.SH \"Function Documentation" $target
-    # Next file if this isn't a function page
-    [ $linnum -ne 0 ] || continue
+  do grep -Eq "^\\.SH \"Function Documentation" $target || continue
 
-    del_modules
-    del_bogus_synopsis
-    fix_name_line
-    move_synopsis
-    del_empty_det_desc
-    del_def_at_lines
-    fix_double_blanks
+    {
+      del_bogus_synopsis
+      $done_synopsis || del_modules
+      fix_name_line
+      move_synopsis
+      del_empty_det_desc
+      del_def_at_lines
+      fix_double_blanks
+      [ $# -ne 2 ] || insert_see_also $@
 
-    # Fix rendering of verbatim "\n" (in code snippets)
-    sed -i 's/\\n/\\\\n/' $target
+      # Work around doxygen bugs (doxygen version-specific)
+
+      # Best effort: \" becomes \'
+      #              Only do lines with some kind of printf,
+      #              since other single quotes might be OK as-is.
+      $fix_quotes && sed -i '/printf/s/'\''/"/g' $target
+
+      # Fix rendering of verbatim "\n" (in code snippets)
+      $fix_newlines && sed -i 's/\\n/\\\\n/' $target
+    }&
 
   done
 
-  remove_temp_files
+}
+
+make_man7(){
+  target=$(grep -Ew INPUT doxygen.cfg | rev | cut -f1 -d' ' | rev)/$2
+  mypath=$(dirname $0)
+
+  # Build up temporary source in temp.c
+  # (doxygen only makes man pages from .c files).
+  ed -s $target << ////
+1,/\\\\mainpage/d
+0i
+/**
+ * \\defgroup $1 $1 overview
+.
+/\\*\\//+1,\$d
+a
+
+/**
+ * @{
+ *
+ * $1 - DELETE_ME
+ */
+int $1(void)
+{
+	return 0;
+}
+/**
+ * @}
+ */
+.
+wq temp.c
+////
+
+  # Create temporary doxygen config in doxytmp
+  grep -Ew PROJECT_NUMBER doxygen.cfg >doxytmp
+  cat >>doxytmp <<////
+PROJECT_NAME = $1
+ABBREVIATE_BRIEF =
+FULL_PATH_NAMES = NO
+TAB_SIZE = 8
+OPTIMIZE_OUTPUT_FOR_C = YES
+EXAMPLE_PATTERNS =
+ALPHABETICAL_INDEX = NO
+SEARCHENGINE = NO
+GENERATE_LATEX = NO
+INPUT = temp.c
+GENERATE_HTML = NO
+GENERATE_MAN = YES
+MAN_EXTENSION = .7
+////
+
+  doxygen doxytmp >/dev/null
+
+  # Remove SYNOPSIS line if there is one
+  target=man/man7/$1.7
+  mygrep "SH SYNOPSIS" $target
+  [ $linnum -eq 0 ] || delete_lines $linnum $((linnum+1))
+
+  # doxygen 1.8.9.1 and possibly newer run the first para into NAME
+  # (i.e. in this unusual group). There won't be a SYNOPSIS when this happens
+  if grep -Eq "overview$1" $target; then
+    echo "Re-running doxygen $(doxygen --version)"
+    ed -s temp.c << ////
+2a
+ * \\manonly
+.PP
+.SH "Detailed Description"
+.PP
+\\endmanonly
+.
+wq
+////
+    doxygen doxytmp >/dev/null
+  fi
+
+  rm temp.c doxytmp
+}
+
+# Insert top-level "See also" of man7 page in man3 page
+insert_see_also(){
+  mygrep "Detailed Description" $target
+  [ $linnum -ne 0 ] || mygrep "Function Documentation" $target
+  [ $linnum -ne 0 ] || { echo "NO HEADER IN $target" >&2; return; }
+  ed -s $target <<////
+${linnum}i
+.SH "See also"
+\\fB${1}\\fP(7)
+.
+wq
+////
 }
 
 fix_double_blanks(){
@@ -96,7 +219,7 @@ fix_double_blanks(){
 del_def_at_lines(){
   linnum=1
   while [ $linnum -ne 0 ]
-  do mygrep "^Definition at line [[:digit:]]* of file" $target
+  do mygrep '^Definition at line (\\fB)?[[:digit:]]*(\\fP)? of file' $target
     [ $linnum -eq 0 ] || delete_lines $(($linnum - 1)) $linnum
   done
 }
@@ -132,14 +255,13 @@ move_synopsis(){
   mygrep "^\\.SS \"Functions" $target
   [ $i -gt $linnum ] || return 0
 
-  mygrep "^\\.SH \"Function Documentation" $target
-  j=$(($linnum - 1))
-  head -n$(($j - 1)) $target | tail -n$(($linnum - $i - 1)) >$fileC
-  delete_lines $i $j
-  mygrep "^\\.SS \"Functions" $target
-  head -n$(($linnum - 1)) $target >$fileA
-  tail -n+$(($linnum + 1)) $target >$fileB
-  cat $fileA $fileC $fileB >$target
+  ed -s $target <<////
+/^\\.SS \"Functions\"/;.d
+.ka
+/^\\.SH SYNOPSIS/;/^[[:space:]]*\$/-1m'a-1
+/\"Function Documentation\"/-1;.d
+wq
+////
 }
 
 fix_name_line(){
@@ -147,81 +269,69 @@ fix_name_line(){
 
   # Search a shortened version of the page in case there are .RI lines later
   mygrep "^\\.SH \"Function Documentation" $target
-  head -n$linnum $target >$fileC
+  head -n$linnum $target >../$target.tmp
 
   while :
-  do mygrep ^\\.RI $fileC
-    [ $linnum -ne 0 ] || break
-    # Discard this entry
-    tail -n+$(($linnum + 1)) $fileC >$fileB
-    cp $fileB $fileC
+  do foundline=$(grep -En "^\\.RI" ../$target.tmp 2>/dev/null | head -n1)
+    [ "$foundline" ] || break
+    linnum=$(echo $foundline | cut -f1 -d:)
+    # Discard this entry (and all previous lines)
+    ed -s ../$target.tmp <<////
+1,${linnum}d
+wq
+////
 
-    func=$(cat $fileG | cut -f2 -d\\ | cut -c3-)
+    func=$(echo $foundline | cut -f2 -d\\ | cut -c3-)
     [ -z "$all_funcs" ] && all_funcs=$func ||\
       all_funcs="$all_funcs, $func"
   done
   # For now, assume name is at line 5
-  head -n4 $target >$fileA
   desc=$(head -n5 $target | tail -n1 | cut -f3- -d" ")
-  tail -n+6 $target >$fileB
-  cat $fileA >$target
-  echo "$all_funcs \\- $desc" >>$target
-  cat $fileB >>$target
+  ed -s $target <<////
+5c
+$all_funcs \\- $desc
+.
+wq
+////
+  rm ../$target.tmp
 }
 
+# Prior to doxygen 1.8.20 there was a "Modules" entry which became part of the
+# "bogus" synopsis. Doxygen 1.11.0 replaces "Modules" with "Topics" still as
+# part of the "bogus" synopsis and so cleaned up by del_bogus_synopsis().
 del_modules(){
-  mygrep "^\.SS \"Modules" $target
-  [ $linnum -ne 0  ] || return 0
-  i=$linnum
-  mygrep "^\\.SS \"Functions" $target
-  delete_lines $i $(($linnum - 1))
+  grep -Eq "^\\.SS \"Modules" $target || return 0
+  ed -s $target <<////
+/^\\.SS \"Modules/,/^\\.SS \"Functions/-1d
+wq
+////
 }
 
 del_bogus_synopsis(){
-  mygrep "SH SYNOPSIS" $target
+  [ $(grep -E 'SH SYNOPSIS' $target | wc -l) -eq 2 ] || return 0
   #
   # doxygen 1.8.20 inserts its own SYNOPSIS line but there is no mention
   # in the documentation or git log what to do with it.
   # So get rid of it
   #
-  [ $linnum -ne 0  ] || return 0
-  i=$linnum
-  # Look for the next one
-  tail -n+$(($i + 1)) $target >$fileC;\
-  mygrep "SH SYNOPSIS" $fileC
-  [ $linnum -ne 0  ] || return 0
-
-  mygrep "^\\.SS \"Functions" $target
-  delete_lines $i $(($linnum - 1))
+  ed -s $target <<////
+/SH SYNOPSIS/,/^\\.SS \"Functions/-1d
+wq
+////
+  done_synopsis=true
 }
 
 # Delete lines $1 through $2 from $target
 delete_lines(){
-  head -n$(($1 - 1)) $target >$fileA
-  tail -n+$(($2 +1)) $target >$fileB
-  cat $fileA $fileB >$target
+  ed -s $target <<////
+$1,$2d
+wq
+////
 }
 
 mygrep(){
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
+  linnum=$(grep -En "$1" $2 2>/dev/null | head -n1 | cut -f1 -d:)
+  [ $linnum ] || linnum=0
 }
 
-main
+main $@
-- 
2.46.3

