Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F131DCD13D2
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Sep 2023 20:00:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjIRUAl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Sep 2023 16:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjIRUAk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Sep 2023 16:00:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD53110A
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Sep 2023 12:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695067188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y2cMe4UJvKzRvI0LDSM9SAYAKWNexALGYQtufFO5TxE=;
        b=H9xV0qOg8PTCTaZeN1kMSEftKGvhjg5wN22tHQdc3TL1o2LtG176IpNy3VwhlkQnp8POUk
        E3aoFx4/mMruAhpaNz/mmcRhfQogOTPEbmvc0hMv1TJPVitkqO814SxUotBUDIUo/iw+Zg
        OY3wUWKkenISVXJaYxq2tBSdDw21CiU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-461-_mYnbirxOx6rEr4nU321Pw-1; Mon, 18 Sep 2023 15:59:47 -0400
X-MC-Unique: _mYnbirxOx6rEr4nU321Pw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F25D3185A79B
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Sep 2023 19:59:46 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6EA431005E28;
        Mon, 18 Sep 2023 19:59:46 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 3/3] tests/shell: run `nft --check` on persisted dump files
Date:   Mon, 18 Sep 2023 21:59:24 +0200
Message-ID: <20230918195933.318893-3-thaller@redhat.com>
In-Reply-To: <20230918195933.318893-1-thaller@redhat.com>
References: <20230918195933.318893-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

"nft --check" will trigger a rollback in kernel. The existing dump files
might hit new code paths. Take the opportunity to call the command on
the existing files.

And alternative would be to write a separate tests, that iterates over
all files. However, then we can only run all the commands sequentially
(unless we do something smart). That might be slower than the
opportunity to run the checks in parallel. More importantly, it would be
nice if the check for the dump file is clearly tied to the file's test.
So run it right after the test, from the test wrapper.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/helpers/test-wrapper.sh | 31 +++++++++++++++++++++++++++++
 tests/shell/run-tests.sh            |  4 +++-
 2 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/tests/shell/helpers/test-wrapper.sh b/tests/shell/helpers/test-wrapper.sh
index 165a944da2b1..e10360c9b266 100755
--- a/tests/shell/helpers/test-wrapper.sh
+++ b/tests/shell/helpers/test-wrapper.sh
@@ -134,6 +134,35 @@ if [ "$rc_dump" -ne 0 ] ; then
 	echo "$DUMPFILE" > "$NFT_TEST_TESTTMPDIR/rc-failed-dump"
 fi
 
+rc_chkdump=0
+# check that a flush after the test succeeds. We anyway need a clean ruleset
+# for the `nft --check` next.
+$NFT flush ruleset &> "$NFT_TEST_TESTTMPDIR/rc-failed-chkdump" || rc_chkdump=1
+if [ -f "$DUMPFILE" ] ; then
+	# We have a dumpfile. Call `nft --check` to possibly cover new code
+	# paths.
+	if [ "$rc_test" -eq 77 ] ; then
+		# The test was skipped. Possibly we don't have the required
+		# features to process this file. Ignore any output and exit
+		# code, but still call the program (for valgrind or sanitizer
+		# issue we hope to find).
+		$NFT --check -f "$DUMPFILE" &>/dev/null || :
+	else
+		$NFT --check -f "$DUMPFILE" &>> "$NFT_TEST_TESTTMPDIR/rc-failed-chkdump" || rc_chkdump=1
+	fi
+fi
+if [ -s "$NFT_TEST_TESTTMPDIR/rc-failed-chkdump" ] ; then
+	# Non-empty output? That is wrong.
+	rc_chkdump=1
+elif [ "$rc_chkdump" -eq 0 ] ; then
+	rm -rf "$NFT_TEST_TESTTMPDIR/rc-failed-chkdump"
+fi
+if [ "$rc_chkdump" -ne 0 ] ; then
+	# Ensure we don't have empty output files. Always write something, so
+	# that `grep ^ -R` lists the file.
+	echo -e "<<<<<\n\nCalling \`nft --check\` (or \`nft flush ruleset\`) failed for \"$DUMPFILE\"" >> "$NFT_TEST_TESTTMPDIR/rc-failed-chkdump"
+fi
+
 rc_valgrind=0
 [ -f "$NFT_TEST_TESTTMPDIR/rc-failed-valgrind" ] && rc_valgrind=1
 
@@ -154,6 +183,8 @@ elif [ "$rc_test" -ne 0 ] ; then
 	rc_exit="$rc_test"
 elif [ "$rc_dump" -ne 0 ] ; then
 	rc_exit=124
+elif [ "$rc_chkdump" -ne 0 ] ; then
+	rc_exit=121
 else
 	rc_exit=0
 fi
diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 528646f57eca..85aa498ca8ee 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -731,7 +731,9 @@ print_test_result() {
 	else
 		((failed++))
 		result_msg_level="W"
-		if [ "$rc_got" -eq 122 ] ; then
+		if [ "$rc_got" -eq 121 ] ; then
+			result_msg_status="CHK DUMP"
+		elif [ "$rc_got" -eq 122 ] ; then
 			result_msg_status="VALGRIND"
 		elif [ "$rc_got" -eq 123 ] ; then
 			result_msg_status="TAINTED"
-- 
2.41.0

