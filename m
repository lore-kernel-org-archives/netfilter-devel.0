Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="esIIFuMZ"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA7318C
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Nov 2023 04:48:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700830099;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4g9oepPPJNLgQCzG1mr3iWbSjDbQYQ1hut+sG3uYaAQ=;
	b=esIIFuMZTZBx6oV1bo2iibWsexy1H4v/qnZUJXDP9mx2tnjd4i8ORDt70rAEzLXBG9rRvh
	O8OxypMZwI4JgDkMSMzwg5wvyqeuGcUlxD6YkGHgYHSH8adlcLRfCUwZWEc9EPQvRlc9L5
	iGhdISyWNOX3XVuIIMvM8l/BbdQkTOU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-678-0dxrRbZmM_6O8QXy42fVVA-1; Fri, 24 Nov 2023 07:48:17 -0500
X-MC-Unique: 0dxrRbZmM_6O8QXy42fVVA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 612A1811E7B
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Nov 2023 12:48:17 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.249])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B9C73492BEE;
	Fri, 24 Nov 2023 12:48:16 +0000 (UTC)
From: Thomas Haller <thaller@redhat.com>
To: NetFilter <netfilter-devel@vger.kernel.org>
Cc: Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 1/2] tests/shell: use generated ruleset for `nft --check`
Date: Fri, 24 Nov 2023 13:45:53 +0100
Message-ID: <20231124124759.3269219-2-thaller@redhat.com>
In-Reply-To: <20231124124759.3269219-1-thaller@redhat.com>
References: <20231124124759.3269219-1-thaller@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

The command `nft [-j] list ruleset | nft [-j] --check -f -` should never
fail. "test-wrapper.sh" already checks for that.

However, previously, we would run check against the .nft/.json-nft
files. In most cases, the generated ruleset and the files in git are
identical. However, when they are not, we (also) want to run the check
against the generated one.

This means, we can also run this check every time, regardless whether a
.nft/.json-nft file exists.

If the .nft/.json-nft file is different from the generated one, (because
a test was skipped or because there is a bug), then also check those
files. But this time, any output is ignored as failures are expected
to happen. We still run the check, to get additional coverage for
valgrind or santizers.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/helpers/test-wrapper.sh | 48 ++++++++++++++++-------------
 1 file changed, 26 insertions(+), 22 deletions(-)

diff --git a/tests/shell/helpers/test-wrapper.sh b/tests/shell/helpers/test-wrapper.sh
index 4ffc48184dd7..f0170d763291 100755
--- a/tests/shell/helpers/test-wrapper.sh
+++ b/tests/shell/helpers/test-wrapper.sh
@@ -222,36 +222,40 @@ if [ "$rc" = 1 -o -s "$NFT_TEST_TESTTMPDIR/chkdump" ] ; then
 	show_file "$NFT_TEST_TESTTMPDIR/chkdump" "Command \`$NFT flush ruleset\` failed" >> "$NFT_TEST_TESTTMPDIR/rc-failed-chkdump"
 	rc_chkdump=1
 fi
-# For the dumpfiles, call `nft --check` to possibly cover new code paths.
-if [ -f "$DUMPFILE" ] ; then
-	if [ "$rc_test" -eq 77 ] ; then
-		# The test was skipped. Possibly we don't have the required
-		# features to process this file. Ignore any output and exit
-		# code, but still call the program (for valgrind or sanitizer
-		# issue we hope to find).
-		$NFT --check -f "$DUMPFILE" &>/dev/null || :
+# Check that `nft [-j] list ruleset | nft [-j] --check -f -` works.
+fail=n
+$NFT --check -f "$NFT_TEST_TESTTMPDIR/ruleset-after" &> "$NFT_TEST_TESTTMPDIR/chkdump" || fail=y
+test -s "$NFT_TEST_TESTTMPDIR/chkdump" && fail=y
+if [ "$fail" = y ] ; then
+	show_file "$NFT_TEST_TESTTMPDIR/chkdump" "Command \`$NFT --check -f \"$NFT_TEST_TESTTMPDIR/ruleset-after\"\` failed" >> "$NFT_TEST_TESTTMPDIR/rc-failed-chkdump"
+	rc_chkdump=1
+fi
+if [ -f "$DUMPFILE" ] && ! cmp "$DUMPFILE" "$NFT_TEST_TESTTMPDIR/ruleset-after" &>/dev/null ; then
+	# Also check the $DUMPFILE to hit possibly new code paths. This
+	# is useful to see crashes and with ASAN/valgrind.
+	$NFT --check -f "$DUMPFILE" &>/dev/null || :
+fi
+if [ "$NFT_TEST_HAVE_json" != n ] ; then
+	if [ ! -f "$JDUMPFILE" ] ; then
+		# Optimally, `nft -j list ruleset | nft -j --check -f -` never
+		# fails.  However, there are known issues where this doesn't
+		# work, and we cannot assert hard against that. It's those
+		# tests that don't have a .json-nft file.
+		#
+		# This should be fixed, every test should have a .json-nft
+		# file, and this workaround removed.
+		$NFT -j --check -f "$NFT_TEST_TESTTMPDIR/ruleset-after.json" &>/dev/null || :
 	else
 		fail=n
-		$NFT --check -f "$DUMPFILE" &> "$NFT_TEST_TESTTMPDIR/chkdump" || fail=y
+		$NFT -j --check -f "$NFT_TEST_TESTTMPDIR/ruleset-after.json" &> "$NFT_TEST_TESTTMPDIR/chkdump" || fail=y
 		test -s "$NFT_TEST_TESTTMPDIR/chkdump" && fail=y
 		if [ "$fail" = y ] ; then
-			show_file "$NFT_TEST_TESTTMPDIR/chkdump" "Command \`$NFT --check -f \"$DUMPFILE\"\` failed" >> "$NFT_TEST_TESTTMPDIR/rc-failed-chkdump"
+			show_file "$NFT_TEST_TESTTMPDIR/chkdump" "Command \`$NFT -j --check -f \"$NFT_TEST_TESTTMPDIR/ruleset-after.json\"\` failed" >> "$NFT_TEST_TESTTMPDIR/rc-failed-chkdump"
 			rc_chkdump=1
 		fi
-		rm -f "$NFT_TEST_TESTTMPDIR/chkdump"
 	fi
-fi
-if [ "$NFT_TEST_HAVE_json" != n -a -f "$JDUMPFILE" ] ; then
-	if [ "$rc_test" -eq 77 ] ; then
+	if [ -f "$JDUMPFILE" ] && ! cmp "$JDUMPFILE" "$NFT_TEST_TESTTMPDIR/ruleset-after.json" &>/dev/null ; then
 		$NFT -j --check -f "$JDUMPFILE" &>/dev/null || :
-	else
-		fail=n
-		$NFT -j --check -f "$JDUMPFILE" &> "$NFT_TEST_TESTTMPDIR/chkdump" || fail=y
-		test -s "$NFT_TEST_TESTTMPDIR/chkdump" && fail=y
-		if [ "$fail" = y ] ; then
-			show_file "$NFT_TEST_TESTTMPDIR/chkdump" "Command \`$NFT -j --check -f \"$JDUMPFILE\"\` failed" >> "$NFT_TEST_TESTTMPDIR/rc-failed-chkdump"
-			rc_chkdump=1
-		fi
 	fi
 fi
 rm -f "$NFT_TEST_TESTTMPDIR/chkdump"
-- 
2.42.0

