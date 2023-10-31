Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF685C4332F
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Oct 2023 18:55:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbjJaSzx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 31 Oct 2023 14:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbjJaSzw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 31 Oct 2023 14:55:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC52E8
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Oct 2023 11:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698778504;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9D2j3lUh1D80fPlQwHcrmoH2sCZFhcQOfXlvq1fGiQg=;
        b=KqhI8gswCIUPuLb7nn1dcY/K5C2f+gng5Tup4+7xzxplf3GP6y3LbsKUMwZk6CPMPNRjnS
        yg5KLchlyTuVzzJLPip3BSIyxv9Ej8PJ0dLE3F4pfHVt1lcbauAynjJ3blPm1nGNXOmBwj
        DlkarUWyp+4LTXTtvl8B/lVAPgAKtnM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-153-F1kYYWr7NfKT02PAPKsPqw-1; Tue, 31 Oct 2023 14:55:02 -0400
X-MC-Unique: F1kYYWr7NfKT02PAPKsPqw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C18BC857BC9
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Oct 2023 18:55:01 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.54])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0F13C10F51;
        Tue, 31 Oct 2023 18:55:00 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 3/7] tests/shell: check and generate JSON dump files
Date:   Tue, 31 Oct 2023 19:53:29 +0100
Message-ID: <20231031185449.1033380-4-thaller@redhat.com>
In-Reply-To: <20231031185449.1033380-1-thaller@redhat.com>
References: <20231031185449.1033380-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The rules after a successful test are good opportunity to test
`nft -j list ruleset` and `nft -j --check`. This quite possibly touches
code paths that are not hit by other tests yet.

The only downside is the increase of the test runtime (which seems
negligible, given the benefits of increasing test coverage).

Note that with some tests the test wrapper now prints:

  "warning: stmt ops chain have no json callback"

That is a bug that will be fixed next.

Future commits will commit those ".json-nft" dump files.

Test "tests/shell/testcases/transactions/table_onoff" will trigger
a valgrind error during `nft -j list ruleset` which causes the test
to fail in valgrind mode. That needs to be fixed.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/helpers/test-wrapper.sh | 138 +++++++++++++++++++++-------
 tests/shell/run-tests.sh            |  11 ++-
 2 files changed, 110 insertions(+), 39 deletions(-)

diff --git a/tests/shell/helpers/test-wrapper.sh b/tests/shell/helpers/test-wrapper.sh
index 872a0c56ed54..f56537f601e0 100755
--- a/tests/shell/helpers/test-wrapper.sh
+++ b/tests/shell/helpers/test-wrapper.sh
@@ -15,6 +15,16 @@ array_contains() {
 	return 1
 }
 
+show_file() {
+	local filename="$1"
+	shift
+	local msg="$*"
+
+	printf '%s\n>>>>\n' "$msg"
+	cat "$filename"
+	printf "<<<<\n"
+}
+
 TEST="$1"
 TESTBASE="$(basename "$TEST")"
 TESTDIR="$(dirname "$TEST")"
@@ -109,55 +119,103 @@ if [ "$rc_test" -eq 0 ] ; then
 	"${CMD[@]}" &>> "$NFT_TEST_TESTTMPDIR/testout.log" || rc_test=$?
 fi
 
-$NFT list ruleset > "$NFT_TEST_TESTTMPDIR/ruleset-after"
+rc_chkdump=0
+rc=0
+$NFT list ruleset > "$NFT_TEST_TESTTMPDIR/ruleset-after" 2> "$NFT_TEST_TESTTMPDIR/chkdump" || rc=$?
+if [ "$rc" -ne 0 -o -s "$NFT_TEST_TESTTMPDIR/chkdump" ] ; then
+	show_file "$NFT_TEST_TESTTMPDIR/chkdump" "Command \`$NFT list ruleset\"$DUMPFILE\"\` failed" >> "$NFT_TEST_TESTTMPDIR/rc-failed-chkdump"
+	rc_chkdump=1
+fi
+if [ "$NFT_TEST_HAVE_json" != n ] ; then
+	rc=0
+	$NFT -j list ruleset > "$NFT_TEST_TESTTMPDIR/ruleset-after.json" 2> "$NFT_TEST_TESTTMPDIR/chkdump" || rc=$?
+	if [ "$rc" -ne 0 -o -s "$NFT_TEST_TESTTMPDIR/chkdump" ] ; then
+		show_file "$NFT_TEST_TESTTMPDIR/chkdump" "Command \`$NFT -j list ruleset\"$DUMPFILE\"\` failed" >> "$NFT_TEST_TESTTMPDIR/rc-failed-chkdump"
+		rc_chkdump=1
+	fi
+	# Normalize the version number from the JSON output. Otherwise, we'd
+	# have to regenerate the .json-nft files upon release.
+	sed '1s/\({"nftables": \[{"metainfo": {"version": "\)[0-9.]\+\(", "release_name": "\)[^"]\+\(", "\)/\1VERSION\2RELEASE_NAME\3/' -i "$NFT_TEST_TESTTMPDIR/ruleset-after.json"
+fi
 
 read tainted_after < /proc/sys/kernel/tainted
 
 DUMPPATH="$TESTDIR/dumps"
 DUMPFILE="$DUMPPATH/$TESTBASE.nft"
+JDUMPFILE="$DUMPPATH/$TESTBASE.json-nft"
 NODUMPFILE="$DUMPPATH/$TESTBASE.nodump"
 
-dump_written=
-
-# The caller can request a re-geneating of the dumps, by setting
-# DUMPGEN=y.
+# The caller can request a re-geneating of the .nft, .nodump, .json-nft dump files
+# by setting DUMPGEN=y. In that case, only the existing files will be regenerated
+# (unless all three files are missing, in which case all of them are generated).
 #
-# This only will happen if the command completed with success.
-#
-# It also will only happen for tests, that have a "$DUMPPATH" directory. There
-# might be tests, that don't want to have dumps created. The existence of the
-# directory controls that. Tests that have a "$NODUMPFILE" file, don't get a dump generated.
-if [ "$rc_test" -eq 0 -a "$DUMPGEN" = y -a -d "$DUMPPATH" -a ! -f "$NODUMPFILE" ] ; then
+# By setting DUMPGEN=force, all 3 files are always regenerated.
+dump_written=n
+if [ "$rc_test" -eq 0 -a '(' "$DUMPGEN" = force -o "$DUMPGEN" = y ')' ] ; then
 	dump_written=y
-	if [ ! -f "$DUMPFILE" ] ; then
-		# No dumpfile exists yet. We generate both a .nft and a .nodump
-		# file. The user can pick which one to commit to git.
+	if [ ! -d "$DUMPPATH" ] ; then
+		mkdir "$DUMPPATH"
+	fi
+	if [ "$DUMPGEN" = force ] ; then
+		gen_nodumpfile=y
+		gen_dumpfile=y
+		gen_jdumpfile=y
+	else
+		# by default, only regenerate the files that we already have on disk.
+		gen_nodumpfile=n
+		gen_dumpfile=n
+		gen_jdumpfile=n
+		test -f "$DUMPFILE"  && gen_dumpfile=y
+		test -f "$JDUMPFILE" && gen_jdumpfile=y
+		test -f "$NODUMPFILE" && gen_nodumpfile=y
+		if [ "$gen_dumpfile" = y -a "$gen_jdumpfile" = y -a "$gen_nodumpfile" = y ] ; then
+			# Except, if no files exist. Them generate all files.
+			gen_dumpfile=y
+			gen_jdumpfile=y
+			gen_nodumpfile=y
+		fi
+	fi
+	if [ "$gen_nodumpfile" = y ] ; then
 		: > "$NODUMPFILE"
 	fi
-	cat "$NFT_TEST_TESTTMPDIR/ruleset-after" > "$DUMPFILE"
+	if [ "$gen_dumpfile" = y ] ; then
+		cat "$NFT_TEST_TESTTMPDIR/ruleset-after" > "$DUMPFILE"
+	fi
+	if [ "$NFT_TEST_HAVE_json" != n -a "$gen_jdumpfile" = y ] ; then
+		cat "$NFT_TEST_TESTTMPDIR/ruleset-after.json" > "$JDUMPFILE"
+	fi
 fi
 
 rc_dump=0
-if [ "$rc_test" -ne 77 -a -f "$DUMPFILE" ] ; then
-	if [ "$dump_written" != y ] ; then
+if [ "$rc_test" -ne 77 -a "$dump_written" != y ] ; then
+	if [ -f "$DUMPFILE" ] ; then
 		if ! $DIFF -u "$DUMPFILE" "$NFT_TEST_TESTTMPDIR/ruleset-after" &> "$NFT_TEST_TESTTMPDIR/ruleset-diff" ; then
+			show_file "$NFT_TEST_TESTTMPDIR/ruleset-diff" "Failed \`$DIFF -u \"$DUMPFILE\" \"$NFT_TEST_TESTTMPDIR/ruleset-after\"\`" >> "$NFT_TEST_TESTTMPDIR/rc-failed-dump"
 			rc_dump=1
 		else
 			rm -f "$NFT_TEST_TESTTMPDIR/ruleset-diff"
 		fi
 	fi
-fi
-if [ "$rc_dump" -ne 0 ] ; then
-	echo "$DUMPFILE" > "$NFT_TEST_TESTTMPDIR/rc-failed-dump"
+	if [ "$NFT_TEST_HAVE_json" != n -a -f "$JDUMPFILE" ] ; then
+		if ! $DIFF -u "$JDUMPFILE" "$NFT_TEST_TESTTMPDIR/ruleset-after.json" &> "$NFT_TEST_TESTTMPDIR/ruleset-diff.json" ; then
+			show_file "$NFT_TEST_TESTTMPDIR/ruleset-diff.json" "Failed \`$DIFF -u \"$JDUMPFILE\" \"$NFT_TEST_TESTTMPDIR/ruleset-after.json\"\`" >> "$NFT_TEST_TESTTMPDIR/rc-failed-dump"
+			rc_dump=1
+		else
+			rm -f "$NFT_TEST_TESTTMPDIR/ruleset-diff.json"
+		fi
+	fi
 fi
 
-rc_chkdump=0
 # check that a flush after the test succeeds. We anyway need a clean ruleset
 # for the `nft --check` next.
-$NFT flush ruleset &> "$NFT_TEST_TESTTMPDIR/rc-failed-chkdump" || rc_chkdump=1
+rc=0
+$NFT flush ruleset &> "$NFT_TEST_TESTTMPDIR/chkdump" || rc=1
+if [ "$rc" = 1 -o -s "$NFT_TEST_TESTTMPDIR/chkdump" ] ; then
+	show_file "$NFT_TEST_TESTTMPDIR/chkdump" "Command \`$NFT flush ruleset\` failed" >> "$NFT_TEST_TESTTMPDIR/rc-failed-chkdump"
+	rc_chkdump=1
+fi
+# For the dumpfiles, call `nft --check` to possibly cover new code paths.
 if [ -f "$DUMPFILE" ] ; then
-	# We have a dumpfile. Call `nft --check` to possibly cover new code
-	# paths.
 	if [ "$rc_test" -eq 77 ] ; then
 		# The test was skipped. Possibly we don't have the required
 		# features to process this file. Ignore any output and exit
@@ -165,20 +223,30 @@ if [ -f "$DUMPFILE" ] ; then
 		# issue we hope to find).
 		$NFT --check -f "$DUMPFILE" &>/dev/null || :
 	else
-		$NFT --check -f "$DUMPFILE" &>> "$NFT_TEST_TESTTMPDIR/rc-failed-chkdump" || rc_chkdump=1
+		fail=n
+		$NFT --check -f "$DUMPFILE" &> "$NFT_TEST_TESTTMPDIR/chkdump" || fail=y
+		test -s "$NFT_TEST_TESTTMPDIR/chkdump" && fail=y
+		if [ "$fail" = y ] ; then
+			show_file "$NFT_TEST_TESTTMPDIR/chkdump" "Command \`$NFT --check -f \"$DUMPFILE\"\` failed" >> "$NFT_TEST_TESTTMPDIR/rc-failed-chkdump"
+			rc_chkdump=1
+		fi
+		rm -f "$NFT_TEST_TESTTMPDIR/chkdump"
 	fi
 fi
-if [ -s "$NFT_TEST_TESTTMPDIR/rc-failed-chkdump" ] ; then
-	# Non-empty output? That is wrong.
-	rc_chkdump=1
-elif [ "$rc_chkdump" -eq 0 ] ; then
-	rm -rf "$NFT_TEST_TESTTMPDIR/rc-failed-chkdump"
-fi
-if [ "$rc_chkdump" -ne 0 ] ; then
-	# Ensure we don't have empty output files. Always write something, so
-	# that `grep ^ -R` lists the file.
-	echo -e "<<<<<\n\nCalling \`nft --check\` (or \`nft flush ruleset\`) failed for \"$DUMPFILE\"" >> "$NFT_TEST_TESTTMPDIR/rc-failed-chkdump"
+if [ "$NFT_TEST_HAVE_json" != n -a -f "$JDUMPFILE" ] ; then
+	if [ "$rc_test" -eq 77 ] ; then
+		$NFT -j --check -f "$JDUMPFILE" &>/dev/null || :
+	else
+		fail=n
+		$NFT -j --check -f "$JDUMPFILE" &> "$NFT_TEST_TESTTMPDIR/chkdump" || fail=y
+		test -s "$NFT_TEST_TESTTMPDIR/chkdump" && fail=y
+		if [ "$fail" = y ] ; then
+			show_file "$NFT_TEST_TESTTMPDIR/chkdump" "Command \`$NFT -j --check -f \"$JDUMPFILE\"\` failed" >> "$NFT_TEST_TESTTMPDIR/rc-failed-chkdump"
+			rc_chkdump=1
+		fi
+	fi
 fi
+rm -f "$NFT_TEST_TESTTMPDIR/chkdump"
 
 rc_valgrind=0
 [ -f "$NFT_TEST_TESTTMPDIR/rc-failed-valgrind" ] && rc_valgrind=1
diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 27a0ec43042a..846de8429e1f 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -184,9 +184,10 @@ usage() {
 	echo " VERBOSE=*|y   : Enable verbose output."
 	echo " NFT_TEST_VERBOSE_TEST=*|y: if true, enable verbose output for tests. For bash scripts, this means"
 	echo "                 to pass \"-x\" to the interpreter."
-	echo " DUMPGEN=*|y   : Regenerate dump files. Dump files are only recreated if the"
-	echo "                 test completes successfully and the \"dumps\" directory for the"
-	echo "                 test exits."
+	echo " DUMPGEN=*|y|force : Regenerate dump files .nft, .json-nft, .nodump. \"DUMPGEN=y\" only regenerates existing"
+	echo "                 files, unless the test has no files (then all three files are generated, and you need to"
+	echo "                 choose those to keep). With \"DUMPGEN=force\" all 3 files are regenerated, regardless"
+	echo "                 whether they existed."
 	echo " VALGRIND=*|y  : Run \$NFT in valgrind."
 	echo " KMEMLEAK=*|y  : Check for kernel memleaks."
 	echo " NFT_TEST_HAS_REALROOT=*|y : To indicate whether the test has real root permissions."
@@ -279,7 +280,9 @@ _NFT_TEST_JOBS_DEFAULT="$(( _NFT_TEST_JOBS_DEFAULT + (_NFT_TEST_JOBS_DEFAULT + 1
 
 VERBOSE="$(bool_y "$VERBOSE")"
 NFT_TEST_VERBOSE_TEST="$(bool_y "$NFT_TEST_VERBOSE_TEST")"
-DUMPGEN="$(bool_y "$DUMPGEN")"
+if [ "$DUMPGEN" != "force" ] ; then
+	DUMPGEN="$(bool_y "$DUMPGEN")"
+fi
 VALGRIND="$(bool_y "$VALGRIND")"
 KMEMLEAK="$(bool_y "$KMEMLEAK")"
 NFT_TEST_KEEP_LOGS="$(bool_y "$NFT_TEST_KEEP_LOGS")"
-- 
2.41.0

