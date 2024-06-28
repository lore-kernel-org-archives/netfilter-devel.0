Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5661D6A8
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Jun 2024 04:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719547487; cv=none; b=r5KhOTQ0MeOKXlOuPsNjJRzV3cB/E29gyaq0UFO5iY3P1BoYLv9JoUDmcs6Txg0E2kmj5CHn4RAuTrwf6CnnS3nq26/GXnV31otD1v5V3iCCq/H+EReCzzKDymrABY6SmMUfW+sMs4lR1VZg28QcDxDHH4FkXUpACd0ZFreyA88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719547487; c=relaxed/simple;
	bh=uroH2+qnz3uMmU/cJB4YKthNEv7Pwak6MOfhYkZ6g4s=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rOQYU0GZTjPAvAfLQOF7BWWnrGDu11AvzvYNhu2jtf3u53g8hgAMAvMNtgRZ2zveDV1qg83ow+RXHXzYhzL+fsWnZt+XmN/x4YgOc49SZ+ate8skGR+G92x5fP+D7KAzUajJTet/3CiXIekXXLjXl5wCw8H+4pSw5PObMZREvSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=arUhqPUg; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="arUhqPUg"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-713fa1aea36so53060a12.1
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jun 2024 21:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719547485; x=1720152285; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=uBB4QlzNAZ29hMQ+kJYcYzNwnefgmdKlWl0zn7wUgXg=;
        b=arUhqPUgEf0sv457JdbwySoa+UQrv2lDyVUQ0/TSl6lKjzjOY7Dfv6nAP/6lh9pLa/
         Nr5w2vTpbBFX5lcc/zwP7XMCkovh5DZwXU+4SlMKVBiohUjYONv1R8gDwaVLkEthbNmf
         2UYzC+Pf/8pzb1mfSSeWGvFYtSc6aPZHVufezXdLxUU1ay4HRaVfT5TIncblc6qPa9zq
         yt+ZIxdTM0d7H4Hl3H8yZqSYwhMkc56Od0GzUyxiHoCrpYzVgLKVV7ty0KwxANcHtp9k
         zl0zW7lqUEs0jFmjvba2724ByBSh0Vxh9wYhU8ybjamOUZfCR59GgwPXhBqfXXzdUX8c
         bxDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719547485; x=1720152285;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uBB4QlzNAZ29hMQ+kJYcYzNwnefgmdKlWl0zn7wUgXg=;
        b=XE3g3Woq3GoYZ6ltcl0AYR0c+3CiwhVybOr5dZaifSk9y59XG0/oovuqxyVyhW7LLG
         8nbKWEjVgsJlawwQ3jZIsGY7tOZ/kwmUlnP0bOe7JJHJFKR/DUTsm+9TYTuDQfDCr/cT
         wpoqv28VsiCBQ8vfZgBKc987+g8fyJho5u5Hv5RCpHy/yeGR82mLVPWal+ZzD7lufcQ5
         Ki+A2HDgL6wrheCqawSVmbeArvLc7ox/l10D3huBJQCgstMrpGqwNap8PTQ5nxgKqZqD
         KvAAER+RkIQkdchq4kEJySNngV6+IqdfVEn0HZtFVHe5IFEfwfTxMjyfSdCGWqlHGYOK
         lFpg==
X-Gm-Message-State: AOJu0Yw2VNNZ2BmEEvhvnysWo4MTHbvFid/l2hlrB1yr4todVoANYpdQ
	YyZUltBdoGKtiZORKMLR6xKP6zs1ztxP2WgeI97gCTrVqsiGTnSB1/b3WQ==
X-Google-Smtp-Source: AGHT+IFoTfUEEJyeI9JfWoToNG/wZuG1qUeplaSIsUuK6VAkyybljFjcR7Q/A3+2Kq83yGIME9hiaw==
X-Received: by 2002:a05:6a20:299f:b0:1be:c205:974d with SMTP id adf61e73a8af0-1bec20599a3mr6000233637.45.1719547484760;
        Thu, 27 Jun 2024 21:04:44 -0700 (PDT)
Received: from slk15.local.net (n49-190-141-216.meb1.vic.optusnet.com.au. [49.190.141.216])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fac1596680sm5371315ad.247.2024.06.27.21.04.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jun 2024 21:04:44 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] build: Speed up build_man.sh
Date: Fri, 28 Jun 2024 14:04:39 +1000
Message-Id: <20240628040439.8501-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Build_man.sh runs more than 10x as fast as it used to on a system with 16
cpus, and over 3x as fast on a system with 2 cpus. Overall cpu use is
reduced to about half what it was on any system. Much of this comes from
using ed in place of head, tail, cut &c. Using ed eliminates having to have
temp files, so edits can be backgrounded to reduce elapsed time.
Specifics:
 - Split off inserting "See also" from make_man7().
   make_man7 had its own for loop over real man pages to insert
   "See also" lines. Put the code in a function and call it from the for
   loop in post_process() instead. Eliminates `find man/man3 -type f`
   which depended on make_symlinks().
 - Background make_symlinks now it has no dependants.
 - Re-implement rename_real_pages().
   Use ed to extract the name of the first documented function from each
   real man page instead of using grep in a for loop over the man links.
 - del_bogus_synopsis() removes the lines that del_modules() would, so run
   del_bogus_synopsis first and only run del_modules if del_bogus_synopsis
   fails to delete anything (doxygen older than 1.8.20).
 - Run make_man7() in background early on.
 - Modify fix_name_line() to not use the temp files and background it.
   fix_name_line still needs to work on a shortened target file but use
   ../$target.tmp instead of $fileC. (Put the uniquely-named temp file in
   parent directory so as to not disturb `ls -S`).
 - Streamline mygrep to not use any files and only return linnum.
   Only fix_name_line used the found line in $fileG.
---
 doxygen/build_man.sh | 254 +++++++++++++++++++++----------------------
 1 file changed, 124 insertions(+), 130 deletions(-)

diff --git a/doxygen/build_man.sh b/doxygen/build_man.sh
index 7eab8fa..d262f12 100755
--- a/doxygen/build_man.sh
+++ b/doxygen/build_man.sh
@@ -7,14 +7,19 @@
 # Args: none or 2 being man7 page name & relative path of source with \mainpage
 
 declare -A renamed_page
+done_synopsis=false
 
 main(){
   set -e
+  # make_man7 has no dependencies or dependants so kick it off now
+  [ $# -ne 2 ] || make_man7 $@ &
   pushd man/man3 >/dev/null; rm -f _*
   count_real_pages
   rename_real_pages
-  make_symlinks
+  # Nothing depends on make_symlinks so background it
+  make_symlinks &
   post_process $@
+  wait
 }
 
 count_real_pages(){
@@ -34,9 +39,16 @@ count_real_pages(){
 
 rename_real_pages(){
   for i in $(ls -S | head -n$page_count)
-  do for j in $(ls -S | tail -n+$first_link)
-    do grep -E -q $i$ $j && break
-    done
+  do
+    j=$(ed -s $i <<////
+/Functions/+1;.#
+/^\.RI/;.#
+.,.s/^.*\\\\fB//
+.,.s/\\\\.*//
+.,.w /dev/stdout
+Q
+////
+).3
     mv -f $i $j
     renamed_page[$i]=$j
   done
@@ -49,61 +61,56 @@ make_symlinks(){
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
+  #keep_me=nfq_icmp_get_hdr.3
+  #do_diagnostics
   #
   # Work through the "real" man pages
   for target in $(ls -S | head -n$page_count)
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
+  do grep -Eq "^\\.SH \"Function Documentation" $target || continue
+
+    {
+      del_bogus_synopsis
+      $done_synopsis || del_modules
+      fix_name_line
+      move_synopsis
+      del_empty_det_desc
+      del_def_at_lines
+      fix_double_blanks
+      [ $# -ne 2 ] || insert_see_also $@
+
+      # Fix rendering of verbatim "\n" (in code snippets)
+      sed -i 's/\\n/\\\\n/' $target
+    }&
 
   done
 
-  [ $# -ne 2 ] || make_man7 $@
-
-  remove_temp_files
 }
 
 make_man7(){
-  popd >/dev/null
   target=$(grep -Ew INPUT doxygen.cfg | rev | cut -f1 -d' ' | rev)/$2
   mypath=$(dirname $0)
 
   # Build up temporary source in temp.c
   # (doxygen only makes man pages from .c files).
-  mygrep \\\\mainpage $target
-  tail -n+$((linnum-1)) $target | head -n1 >temp.c
-  echo " * \\defgroup $1 $1 overview" >>temp.c
-  tail -n+$((linnum+1)) $target >$fileA
-  linnum=$(grep -En '\*/' $fileA | head -n1 | cut -d: -f1)
-  head -n$((linnum - 1)) $fileA >> temp.c
-
-  echo ' */' >> temp.c
-  cat >> temp.c <<////
-
- /**
-  * @{
-  *
-  * $1 - DELETE_ME
-  */
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
 int $1(void)
 {
 	return 0;
@@ -111,30 +118,29 @@ int $1(void)
 /**
  * @}
  */
+.
+wq temp.c
 ////
 
-  # Create temporary doxygen config in fileC
-  cat /dev/null >$fileC
-  for i in \
-  PROJECT_NAME \
-  PROJECT_NUMBER \
-  ABBREVIATE_BRIEF \
-  FULL_PATH_NAMES \
-  TAB_SIZE \
-  OPTIMIZE_OUTPUT_FOR_C \
-  EXAMPLE_PATTERNS \
-  ALPHABETICAL_INDEX \
-  SEARCHENGINE \
-  GENERATE_LATEX \
-  ; do grep -Ew $i doxygen.cfg >>$fileC; done
-  cat >>$fileC <<////
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
 INPUT = temp.c
 GENERATE_HTML = NO
 GENERATE_MAN = YES
 MAN_EXTENSION = .7
 ////
 
-  doxygen $fileC >/dev/null
+  doxygen doxytmp >/dev/null
 
   # Remove SYNOPSIS line if there is one
   target=man/man7/$1.7
@@ -144,34 +150,35 @@ MAN_EXTENSION = .7
   # doxygen 1.8.9.1 and possibly newer run the first para into NAME
   # (i.e. in this unusual group). There won't be a SYNOPSIS when this happens
   if grep -Eq "overview$1" $target; then
-    head -n2 temp.c >$fileA
-    cat >>$fileA <<////
+    echo "Re-running doxygen $(doxygen --version)"
+    ed -s temp.c << ////
+2a
  * \\manonly
 .PP
 .SH "Detailed Description"
 .PP
 \\endmanonly
+.
+wq
 ////
-    tail -n+3 temp.c >>$fileA
-    cat $fileA >temp.c
-    doxygen $fileC >/dev/null
+    doxygen doxytmp >/dev/null
   fi
 
-  # Insert top-level "See also" of man7 page in all real man3 pages
-  for target in $(find man/man3 -type f)
-  do mygrep "Detailed Description" $target
-    [ $linnum -ne 0 ] || mygrep "Function Documentation" $target
-    [ $linnum -ne 0 ] || { echo "NO HEADER IN $target" >&2; continue; }
-    head -n$((linnum-1)) $target >$fileA
-    cat >>$fileA <<////
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
 .SH "See also"
 \\fB${1}\\fP(7)
+.
+wq
 ////
-    tail -n+$linnum $target >>$fileA
-    cp $fileA $target
-  done
-
-  rm temp.c
 }
 
 fix_double_blanks(){
@@ -228,14 +235,13 @@ move_synopsis(){
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
@@ -243,81 +249,69 @@ fix_name_line(){
 
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
 
 main $@
-- 
2.35.8

