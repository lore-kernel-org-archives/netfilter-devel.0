Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K+ZzeoHJ"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3900519A
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Dec 2023 01:14:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701940444;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OGlrQG/8OV9D5zSfnwERutepzPe0ulDtXv7EhQ0pMIY=;
	b=K+ZzeoHJI+Z4Bf8BlXK20qtvUU6II33YHgqp3RJHUw68y2PjyRBzhxLmtAgwVWeXqU232m
	r82pMJsamkIaBRMhXdiK1YaAxmhJxe/pIiYReIQiU9JPidZcBAN36DiE4a8LrPcRqVfUpy
	/G1VV8DqiZlUU8fnpiMUTV2h1xo87EU=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-444-R2aMp2dBPF2I3n--0lwwhg-1; Thu,
 07 Dec 2023 04:14:02 -0500
X-MC-Unique: R2aMp2dBPF2I3n--0lwwhg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B3941C0BB41
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Dec 2023 09:14:02 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.194.114])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EFE95492BC6;
	Thu,  7 Dec 2023 09:14:01 +0000 (UTC)
From: Thomas Haller <thaller@redhat.com>
To: NetFilter <netfilter-devel@vger.kernel.org>
Cc: Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 2/2 v2] tests/shell: have .json-nft dumps prettified to wrap lines
Date: Thu,  7 Dec 2023 10:08:50 +0100
Message-ID: <20231207091226.562439-1-thaller@redhat.com>
In-Reply-To: <20231124124759.3269219-3-thaller@redhat.com>
References: <20231124124759.3269219-3-thaller@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

Previously, the .json-nft file in git contains the output of `nft -j
list ruleset`. This is one long line and makes diffs harder to review.

Instead, have the prettified .json-nft file committed to git.

- the diff now operates on the prettified version. That means, it
  compares essentially

     - `nft -j list ruleset | json-sanitize-ruleset.sh | json-pretty.sh`
     - `cat "$TEST.json-nft" | json-pretty.sh`

  The script "json-diff-pretty.sh" is no longer used. It is kept
  however, because it might be a useful for manual comparing files.

  Note that "json-sanitize-ruleset.sh" and "json-pretty.sh" are still
  two separate scripts and called at different times. They also do
  something different. The former mangles the JSON to account for changes
  that are not stable (in the JSON data itself), while the latter only
  pretty prints it.

- when generating a new .json-nft dump file, the file will be updated to
  use the new, prettified format, unless the file is in the old format
  and needs no update. This means, with DUMPGEN=y, old style is preserved
  unless an update becomes necessary.

This requires "json-pretty.sh" having stable output, as those files are
committed to git. This is probably fine.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---

Changes compared to v1:
- fix bug to use "$JDUMPFILE2" in diff command.

Still open question:
- whether to just re-generate/prettify all .json-nft files once. The
  current patch allows the files on disk to be in either form, and a
  DUMPGEN=y will only update the file, when necessary. Alternative
  would be to merge this patch, followed by regenerating all .json-nft
  files. In that case, this patch could be slightly simplified to not
  supporting the "mixed-mode".

 tests/shell/helpers/json-pretty.sh  | 27 ++++++++++++++-----
 tests/shell/helpers/test-wrapper.sh | 41 +++++++++++++++++++++++------
 2 files changed, 53 insertions(+), 15 deletions(-)

diff --git a/tests/shell/helpers/json-pretty.sh b/tests/shell/helpers/json-pretty.sh
index 0d6972b81e2f..5407a8420058 100755
--- a/tests/shell/helpers/json-pretty.sh
+++ b/tests/shell/helpers/json-pretty.sh
@@ -1,17 +1,30 @@
 #!/bin/bash -e
 
-# WARNING: the output is not guaranteed to be stable.
+exec_pretty() {
+	# The output of this command must be stable (and `jq` and python
+	# fallback must generate the same output.
 
-if command -v jq &>/dev/null ; then
-	# If we have, use `jq`
-	exec jq
-fi
+	if command -v jq &>/dev/null ; then
+		# If we have, use `jq`
+		exec jq
+	fi
 
-# Fallback to python.
-exec python -c '
+	# Fallback to python.
+	exec python -c '
 import json
 import sys
 
 parsed = json.load(sys.stdin)
 print(json.dumps(parsed, indent=2))
 '
+}
+
+[ "$#" -le 1 ] || { echo "At most one argument supported" ; exit 1 ; }
+
+if [ "$#" -eq 1 ] ; then
+	# One argument passed. This must be a JSON file.
+	[ -f "$1" ] || { echo "File \"$1\" does not exist" ; exit 1 ; }
+	exec_pretty < "$1"
+fi
+
+exec_pretty
diff --git a/tests/shell/helpers/test-wrapper.sh b/tests/shell/helpers/test-wrapper.sh
index f0170d763291..f1f33991b454 100755
--- a/tests/shell/helpers/test-wrapper.sh
+++ b/tests/shell/helpers/test-wrapper.sh
@@ -25,6 +25,10 @@ show_file() {
 	printf "<<<<\n"
 }
 
+json_pretty() {
+	"$NFT_TEST_BASEDIR/helpers/json-pretty.sh" "$@" 2>&1 || :
+}
+
 TEST="$1"
 TESTBASE="$(basename "$TEST")"
 TESTDIR="$(dirname "$TEST")"
@@ -140,6 +144,7 @@ if [ "$NFT_TEST_HAVE_json" != n ] ; then
 	fi
 	# JSON output needs normalization/sanitization, otherwise it's not stable.
 	"$NFT_TEST_BASEDIR/helpers/json-sanitize-ruleset.sh" "$NFT_TEST_TESTTMPDIR/ruleset-after.json"
+	json_pretty "$NFT_TEST_TESTTMPDIR/ruleset-after.json" > "$NFT_TEST_TESTTMPDIR/ruleset-after.json-pretty"
 fi
 
 read tainted_after < /proc/sys/kernel/tainted
@@ -186,7 +191,12 @@ if [ "$rc_test" -eq 0 -a '(' "$DUMPGEN" = all -o "$DUMPGEN" = y ')' ] ; then
 		cat "$NFT_TEST_TESTTMPDIR/ruleset-after" > "$DUMPFILE"
 	fi
 	if [ "$NFT_TEST_HAVE_json" != n -a "$gen_jdumpfile" = y ] ; then
-		cat "$NFT_TEST_TESTTMPDIR/ruleset-after.json" > "$JDUMPFILE"
+		if cmp "$NFT_TEST_TESTTMPDIR/ruleset-after.json" "$JDUMPFILE" &>/dev/null ; then
+			# The .json-nft file is still the non-pretty variant. Keep it.
+			:
+		else
+			cat "$NFT_TEST_TESTTMPDIR/ruleset-after.json-pretty" > "$JDUMPFILE"
+		fi
 	fi
 fi
 
@@ -201,12 +211,16 @@ if [ "$rc_test" -ne 77 -a "$dump_written" != y ] ; then
 		fi
 	fi
 	if [ "$NFT_TEST_HAVE_json" != n -a -f "$JDUMPFILE" ] ; then
-		if ! $DIFF -u "$JDUMPFILE" "$NFT_TEST_TESTTMPDIR/ruleset-after.json" &> "$NFT_TEST_TESTTMPDIR/ruleset-diff.json" ; then
-			"$NFT_TEST_BASEDIR/helpers/json-diff-pretty.sh" \
-				"$JDUMPFILE" \
-				"$NFT_TEST_TESTTMPDIR/ruleset-after.json" \
-				2>&1 > "$NFT_TEST_TESTTMPDIR/ruleset-diff.json.pretty"
-			show_file "$NFT_TEST_TESTTMPDIR/ruleset-diff.json" "Failed \`$DIFF -u \"$JDUMPFILE\" \"$NFT_TEST_TESTTMPDIR/ruleset-after.json\"\`" >> "$NFT_TEST_TESTTMPDIR/rc-failed-dump"
+		JDUMPFILE2="$NFT_TEST_TESTTMPDIR/json-nft-pretty"
+		json_pretty "$JDUMPFILE" > "$JDUMPFILE2"
+		if cmp "$JDUMPFILE" "$JDUMPFILE2" &>/dev/null ; then
+			# The .json-nft file is already prettified. We can use
+			# it directly.
+			rm -rf "$JDUMPFILE2"
+			JDUMPFILE2="$JDUMPFILE"
+		fi
+		if ! $DIFF -u "$JDUMPFILE2" "$NFT_TEST_TESTTMPDIR/ruleset-after.json-pretty" &> "$NFT_TEST_TESTTMPDIR/ruleset-diff.json" ; then
+			show_file "$NFT_TEST_TESTTMPDIR/ruleset-diff.json" "Failed \`$DIFF -u \"$JDUMPFILE2\" \"$NFT_TEST_TESTTMPDIR/ruleset-after.json-pretty\"\`" >> "$NFT_TEST_TESTTMPDIR/rc-failed-dump"
 			rc_dump=1
 		else
 			rm -f "$NFT_TEST_TESTTMPDIR/ruleset-diff.json"
@@ -245,6 +259,7 @@ if [ "$NFT_TEST_HAVE_json" != n ] ; then
 		# This should be fixed, every test should have a .json-nft
 		# file, and this workaround removed.
 		$NFT -j --check -f "$NFT_TEST_TESTTMPDIR/ruleset-after.json" &>/dev/null || :
+		$NFT -j --check -f "$NFT_TEST_TESTTMPDIR/ruleset-after.json-pretty" &>/dev/null || :
 	else
 		fail=n
 		$NFT -j --check -f "$NFT_TEST_TESTTMPDIR/ruleset-after.json" &> "$NFT_TEST_TESTTMPDIR/chkdump" || fail=y
@@ -253,8 +268,18 @@ if [ "$NFT_TEST_HAVE_json" != n ] ; then
 			show_file "$NFT_TEST_TESTTMPDIR/chkdump" "Command \`$NFT -j --check -f \"$NFT_TEST_TESTTMPDIR/ruleset-after.json\"\` failed" >> "$NFT_TEST_TESTTMPDIR/rc-failed-chkdump"
 			rc_chkdump=1
 		fi
+		fail=n
+		$NFT -j --check -f "$NFT_TEST_TESTTMPDIR/ruleset-after.json-pretty" &> "$NFT_TEST_TESTTMPDIR/chkdump" || fail=y
+		test -s "$NFT_TEST_TESTTMPDIR/chkdump" && fail=y
+		if [ "$fail" = y ] ; then
+			show_file "$NFT_TEST_TESTTMPDIR/chkdump" "Command \`$NFT -j --check -f \"$NFT_TEST_TESTTMPDIR/ruleset-after.json-pretty\"\` failed" >> "$NFT_TEST_TESTTMPDIR/rc-failed-chkdump"
+			rc_chkdump=1
+		fi
 	fi
-	if [ -f "$JDUMPFILE" ] && ! cmp "$JDUMPFILE" "$NFT_TEST_TESTTMPDIR/ruleset-after.json" &>/dev/null ; then
+	if [ -f "$JDUMPFILE" ] \
+	     && ! cmp "$JDUMPFILE" "$NFT_TEST_TESTTMPDIR/ruleset-after.json" &>/dev/null \
+	     && ! cmp "$JDUMPFILE" "$NFT_TEST_TESTTMPDIR/ruleset-after.json-pretty" &>/dev/null ; \
+	then
 		$NFT -j --check -f "$JDUMPFILE" &>/dev/null || :
 	fi
 fi
-- 
2.43.0

