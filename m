Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73398C83F2C
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Sep 2023 13:53:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238262AbjIDNxR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Sep 2023 09:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbjIDNxR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Sep 2023 09:53:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C1BCE2
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Sep 2023 06:51:53 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-266-e1V1GpuTMRmtUKJfWjPTFQ-1; Mon, 04 Sep 2023 09:51:51 -0400
X-MC-Unique: e1V1GpuTMRmtUKJfWjPTFQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E718980602D
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Sep 2023 13:51:50 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 66E8F1121314;
        Mon,  4 Sep 2023 13:51:50 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v3 06/11] tests/shell: interpret an exit code of 77 from scripts as "skipped"
Date:   Mon,  4 Sep 2023 15:48:08 +0200
Message-ID: <20230904135135.1568180-7-thaller@redhat.com>
In-Reply-To: <20230904135135.1568180-1-thaller@redhat.com>
References: <20230904135135.1568180-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Allow scripts to indicate that a test could not run by exiting 77.

"77" is chosen as exit code from automake's testsuites ([1]). Compare to
git-bisect which chooses 125 to indicate skipped.

[1] https://www.gnu.org/software/automake/manual/html_node/Scripts_002dbased-Testsuites.html

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/helpers/test-wrapper.sh |  2 ++
 tests/shell/run-tests.sh            | 11 ++++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/tests/shell/helpers/test-wrapper.sh b/tests/shell/helpers/test-wrapper.sh
index 99546f060e26..8f0dc685e1fe 100755
--- a/tests/shell/helpers/test-wrapper.sh
+++ b/tests/shell/helpers/test-wrapper.sh
@@ -12,6 +12,8 @@ rc_test=0
 
 if [ "$rc_test" -eq 0 ] ; then
 	echo "$rc_test" > "$NFT_TEST_TESTTMPDIR/rc_test-ok"
+elif [ "$rc_test" -eq 77 ] ; then
+	echo "$rc_test" > "$NFT_TEST_TESTTMPDIR/rc_test-skipped"
 else
 	echo "$rc_test" > "$NFT_TEST_TESTTMPDIR/rc_test-failed"
 fi
diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 3d0ef6fa8499..f3b58e1e200b 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -271,6 +271,7 @@ fi
 
 echo ""
 ok=0
+skipped=0
 failed=0
 taint=0
 
@@ -366,6 +367,14 @@ for testfile in "${TESTS[@]}" ; do
 				msg_warn "[DUMP FAIL]	$testfile"
 			fi
 		fi
+	elif [ "$rc_got" -eq 77 ] ; then
+		((skipped++))
+		if [ "$VERBOSE" == "y" ] ; then
+			msg_warn "[SKIPPED]	$testfile"
+			[ ! -z "$test_output" ] && echo "$test_output"
+		else
+			msg_warn "[SKIPPED]	$testfile"
+		fi
 	else
 		((failed++))
 		if [ "$VERBOSE" == "y" ] ; then
@@ -390,7 +399,7 @@ echo ""
 kmemleak_found=0
 check_kmemleak_force
 
-msg_info "results: [OK] $ok [FAILED] $failed [TOTAL] $((ok+failed))"
+msg_info "results: [OK] $ok [SKIPPED] $skipped [FAILED] $failed [TOTAL] $((ok+skipped+failed))"
 
 kernel_cleanup
 
-- 
2.41.0

