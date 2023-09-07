Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA1EEEC875F
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Sep 2023 22:09:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjIGWJy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Sep 2023 18:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232116AbjIGWJp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Sep 2023 18:09:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C4DE1BC7
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Sep 2023 15:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694124526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iI3VAqFHNCcX6DtHVKxcNqkEC6+kea2I34uN1fS8kcM=;
        b=Zb6qb/msa8pOjsxuhQicvYXPA8Yqb9VvNcRYweSqrPxpc0z3EOJutrpN44sy5hOu772Qiv
        Lj5g1PGaSWDxlNjkl1lsoTxLstsMHaBXbIcMBxBEZM6djJCsvkdVY4O+mPlXHeSXXHgcOv
        aUpl8JKHNm1M5O3l5vf7hrg4OLRlIQg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-zw3UKMaVNiu-6FX-P9Rnrw-1; Thu, 07 Sep 2023 18:08:45 -0400
X-MC-Unique: zw3UKMaVNiu-6FX-P9Rnrw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 38643800888
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Sep 2023 22:08:45 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 838537B62;
        Thu,  7 Sep 2023 22:08:44 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 01/11] tests/shell: cleanup result handling in "test-wrapper.sh"
Date:   Fri,  8 Sep 2023 00:07:13 +0200
Message-ID: <20230907220833.2435010-2-thaller@redhat.com>
In-Reply-To: <20230907220833.2435010-1-thaller@redhat.com>
References: <20230907220833.2435010-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The previous code was mostly correct, but hard to understand.
Rework it.

Also, on failure now always write "rc-failed-exit", which is the exit
code that "test-wrapper.sh" reports to "run-test.sh". Note that this
error code may not be the same as the one returned by the TEST binary.
The latter you can find in one of the files "rc-{ok,skipped,failed}".

In general, you can search the directory with test results for those
"rc-*" files. If you find a "rc-failed" file, it was counted as failure.
There might be other "rc-failed-*" files, depending on whether the diff
failed or kernel got tainted.

Also, reserve all the error codes 118 - 124 for the "test-wrapper.sh".
For example, 124 means a dump difference and 123 means kernel got
tainted. In the future, 122 will mean a valgrind error. Other numbers
are not reserved. If a test command fails with such an reserved code,
"test-wrapper.sh" modifies it to 125, so that "run-test.sh" does not get
the wrong idea about the failure reason.  This is not new in this patch,
except that the reserved range was extended for future additions.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/helpers/test-wrapper.sh | 65 ++++++++++++++++++-----------
 1 file changed, 41 insertions(+), 24 deletions(-)

diff --git a/tests/shell/helpers/test-wrapper.sh b/tests/shell/helpers/test-wrapper.sh
index 43b3aa09ef26..f8b27b1e9291 100755
--- a/tests/shell/helpers/test-wrapper.sh
+++ b/tests/shell/helpers/test-wrapper.sh
@@ -51,7 +51,6 @@ DUMPPATH="$TESTDIR/dumps"
 DUMPFILE="$DUMPPATH/$TESTBASE.nft"
 
 dump_written=
-rc_dump=
 
 # The caller can request a re-geneating of the dumps, by setting
 # DUMPGEN=y.
@@ -66,42 +65,60 @@ if [ "$rc_test" -eq 0 -a "$DUMPGEN" = y -a -d "$DUMPPATH" ] ; then
 	cat "$NFT_TEST_TESTTMPDIR/ruleset-after" > "$DUMPFILE"
 fi
 
+rc_dump=0
 if [ "$rc_test" -ne 77 -a -f "$DUMPFILE" ] ; then
-	rc_dump=0
 	if [ "$dump_written" != y ] ; then
-		$DIFF -u "$DUMPFILE" "$NFT_TEST_TESTTMPDIR/ruleset-after" &> "$NFT_TEST_TESTTMPDIR/ruleset-diff" || rc_dump=$?
-		if [ "$rc_dump" -eq 0 ] ; then
+		if ! $DIFF -u "$DUMPFILE" "$NFT_TEST_TESTTMPDIR/ruleset-after" &> "$NFT_TEST_TESTTMPDIR/ruleset-diff" ; then
+			rc_dump=124
 			rm -f "$NFT_TEST_TESTTMPDIR/ruleset-diff"
 		fi
 	fi
 fi
+if [ "$rc_dump" -ne 0 ] ; then
+	echo "$DUMPFILE" > "$NFT_TEST_TESTTMPDIR/rc-failed-dump"
+fi
 
+rc_tainted=0
 if [ "$tainted_before" != "$tainted_after" ] ; then
 	echo "$tainted_after" > "$NFT_TEST_TESTTMPDIR/rc-failed-tainted"
+	rc_tainted=123
 fi
 
-rc_exit="$rc_test"
-if [ -n "$rc_dump" ] && [ "$rc_dump" -ne 0 ] ; then
-	echo "$DUMPFILE" > "$NFT_TEST_TESTTMPDIR/rc-failed-dump"
-	echo "$rc_test" > "$NFT_TEST_TESTTMPDIR/rc-failed"
-	if [ "$rc_exit" -eq 0 ] ; then
-		# Special exit code to indicate dump diff.
-		rc_exit=124
-	fi
-elif [ "$rc_test" -eq 77 ] ; then
-	echo "$rc_test" > "$NFT_TEST_TESTTMPDIR/rc-skipped"
-elif [ "$rc_test" -eq 0 -a "$tainted_before" = "$tainted_after" ] ; then
-	echo "$rc_test" > "$NFT_TEST_TESTTMPDIR/rc-ok"
+if [ "$rc_tainted" -ne 0 ] ; then
+	rc_exit="$rc_tainted"
+elif [ "$rc_test" -ge 118 -a "$rc_test" -le 124 ] ; then
+	# Special exit codes are reserved. Coerce them.
+	rc_exit="125"
+elif [ "$rc_test" -ne 0 ] ; then
+	rc_exit="$rc_test"
+elif [ "$rc_dump" -ne 0 ] ; then
+	rc_exit="$rc_dump"
 else
-	echo "$rc_test" > "$NFT_TEST_TESTTMPDIR/rc-failed"
-	if [ "$rc_test" -eq 0 -a "$tainted_before" != "$tainted_after" ] ; then
-		# Special exit code to indicate tainted.
-		rc_exit=123
-	elif [ "$rc_test" -eq 124 -o "$rc_test" -eq 123 ] ; then
-		# These exit codes are reserved
-		rc_exit=125
-	fi
+	rc_exit="0"
+fi
+
+
+# We always write the real exit code of the test ($rc_test) to one of the files
+# rc-{ok,skipped,failed}, depending on which it is.
+#
+# Note that there might be other rc-failed-{dump,tainted} files with additional
+# errors. Note that if such files exist, the overall state will always be
+# failed too (and an "rc-failed" file exists).
+#
+# On failure, we also write the combined "$rc_exit" code from "test-wrapper.sh"
+# to "rc-failed-exit" file.
+#
+# This means, failed tests will have a "rc-failed" file, and additional
+# "rc-failed-*" files exist for further information.
+if [ "$rc_exit" -eq 0 ] ; then
+	RC_FILENAME="rc-ok"
+elif [ "$rc_exit" -eq 77 ] ; then
+	RC_FILENAME="rc-skipped"
+else
+	RC_FILENAME="rc-failed"
+	echo "$rc_exit" > "$NFT_TEST_TESTTMPDIR/rc-failed-exit"
 fi
+echo "$rc_test" > "$NFT_TEST_TESTTMPDIR/$RC_FILENAME"
 
 END_TIME="$(cut -d ' ' -f1 /proc/uptime)"
 WALL_TIME="$(awk -v start="$START_TIME" -v end="$END_TIME" "BEGIN { print(end - start) }")"
-- 
2.41.0

