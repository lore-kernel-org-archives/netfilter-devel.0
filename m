Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9586FEC875E
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Sep 2023 22:09:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbjIGWJz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Sep 2023 18:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234721AbjIGWJp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Sep 2023 18:09:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECC481BD2
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Sep 2023 15:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694124529;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pDr2XROpy94VkfvsmuTPCE+mjhl1XAhL4pRKgrGnOd8=;
        b=FEnZ+zzl+FoDpNOns4Mc34RzF1erFcQpn1KuPYkgHXPboDa568j96vv9uDINs7CTzlQIaz
        AKe8mS04FjLxBRYAZWSSujVimUqv4eVblFm9FlBcacmlTRLfDKb0Cizp7EeHQfTXKio9B2
        DFvVecx9LNqO7Y1N1o3KYa1tuck9pZo=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-446-hpxP5DG5OZGvB5kQyWpeXQ-1; Thu, 07 Sep 2023 18:08:47 -0400
X-MC-Unique: hpxP5DG5OZGvB5kQyWpeXQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 974D72820543
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Sep 2023 22:08:47 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0FF6F63F78;
        Thu,  7 Sep 2023 22:08:46 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 04/11] tests/shell: fix handling failures with VALGRIND=y
Date:   Fri,  8 Sep 2023 00:07:16 +0200
Message-ID: <20230907220833.2435010-5-thaller@redhat.com>
In-Reply-To: <20230907220833.2435010-1-thaller@redhat.com>
References: <20230907220833.2435010-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

With VALGRIND=y, on memleaks the tests did not fail. Fix that by passing
"--error-exitcode=122" to valgrind.

But just returning 122 from $NFT command may not correctly fail the test.
Instead, ensure to write a "rc-failed-valrind" file, which is picked up
by "test-wrapper.sh" to properly handle the valgrind failure (and fail
with error code 122 itself).

Also, accept NFT_TEST_VALGRIND_OPTS variable to a pass additional
arguments to valgrind. For example a "--suppressions" file.

Also show the special error code [VALGRIND] in "run-test.sh".

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/helpers/nft-valgrind-wrapper.sh | 15 ++++++++++++++-
 tests/shell/helpers/test-wrapper.sh         | 13 +++++++++----
 tests/shell/run-tests.sh                    |  4 +++-
 3 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/tests/shell/helpers/nft-valgrind-wrapper.sh b/tests/shell/helpers/nft-valgrind-wrapper.sh
index 9da50d4d9d1d..ad8cc74bc781 100755
--- a/tests/shell/helpers/nft-valgrind-wrapper.sh
+++ b/tests/shell/helpers/nft-valgrind-wrapper.sh
@@ -1,6 +1,6 @@
 #!/bin/bash -e
 
-SUFFIX="$(date '+%Y%m%d-%H%M%S.%6N')"
+SUFFIX="$(date "+%Y%m%d-%H%M%S.%6N.$$")"
 
 rc=0
 libtool \
@@ -10,8 +10,21 @@ libtool \
 		--trace-children=yes \
 		--leak-check=full \
 		--show-leak-kinds=all \
+		--num-callers=100 \
+		--error-exitcode=122 \
+		$NFT_TEST_VALGRIND_OPTS \
 		"$NFT_REAL" \
 		"$@" \
 	|| rc=$?
 
+if [ "$rc" -eq 122 ] ; then
+	shopt -s nullglob
+	FILES=( "$NFT_TEST_TESTTMPDIR/valgrind.$SUFFIX."*".log" )
+	shopt -u nullglob
+	(
+		printf '%s\n' "args: $*"
+		printf '%s\n' "${FILES[*]}"
+	) >> "$NFT_TEST_TESTTMPDIR/rc-failed-valgrind"
+fi
+
 exit $rc
diff --git a/tests/shell/helpers/test-wrapper.sh b/tests/shell/helpers/test-wrapper.sh
index f8b27b1e9291..405e70c86751 100755
--- a/tests/shell/helpers/test-wrapper.sh
+++ b/tests/shell/helpers/test-wrapper.sh
@@ -78,13 +78,18 @@ if [ "$rc_dump" -ne 0 ] ; then
 	echo "$DUMPFILE" > "$NFT_TEST_TESTTMPDIR/rc-failed-dump"
 fi
 
+rc_valgrind=0
+[ -f "$NFT_TEST_TESTTMPDIR/rc-failed-valgrind" ] && rc_valgrind=122
+
 rc_tainted=0
 if [ "$tainted_before" != "$tainted_after" ] ; then
 	echo "$tainted_after" > "$NFT_TEST_TESTTMPDIR/rc-failed-tainted"
 	rc_tainted=123
 fi
 
-if [ "$rc_tainted" -ne 0 ] ; then
+if [ "$rc_valgrind" -ne 0 ] ; then
+	rc_exit="$rc_valgrind"
+elif [ "$rc_tainted" -ne 0 ] ; then
 	rc_exit="$rc_tainted"
 elif [ "$rc_test" -ge 118 -a "$rc_test" -le 124 ] ; then
 	# Special exit codes are reserved. Coerce them.
@@ -101,9 +106,9 @@ fi
 # We always write the real exit code of the test ($rc_test) to one of the files
 # rc-{ok,skipped,failed}, depending on which it is.
 #
-# Note that there might be other rc-failed-{dump,tainted} files with additional
-# errors. Note that if such files exist, the overall state will always be
-# failed too (and an "rc-failed" file exists).
+# Note that there might be other rc-failed-{dump,tainted,valgrind} files with
+# additional errors. Note that if such files exist, the overall state will
+# always be failed too (and an "rc-failed" file exists).
 #
 # On failure, we also write the combined "$rc_exit" code from "test-wrapper.sh"
 # to "rc-failed-exit" file.
diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index c8688587bbc4..ab91fd4d9053 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -527,7 +527,9 @@ print_test_result() {
 	else
 		((failed++))
 		result_msg_level="W"
-		if [ "$rc_got" -eq 123 ] ; then
+		if [ "$rc_got" -eq 122 ] ; then
+			result_msg_status="VALGRIND"
+		elif [ "$rc_got" -eq 123 ] ; then
 			result_msg_status="TAINTED"
 		elif [ "$rc_got" -eq 124 ] ; then
 			result_msg_status="DUMP FAIL"
-- 
2.41.0

