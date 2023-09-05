Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 434D8CA0FE2
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Sep 2023 16:26:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352337AbjIEQ0m (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:26:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354488AbjIEMBT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Sep 2023 08:01:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE56CC2
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Sep 2023 04:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693915195;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R8EqVD18hYzRA7XCZdg+SUutEQsbU/5PBG5AVp/YcU8=;
        b=UMDk6+wKG7UcjQ2SpJOASG7i4t0rTKLwtlcrp6mKs9xmp5RNCqSe0RTxcuGBjJjWqi6PGA
        rW8Sz1x2IebkUquAlwcbCErqX98Snljbq/yyzQy2gs3eSbbUSg5Owco31lpmUwJQLGODAT
        yn5GGLTqd1KTmP9qh4fx5ABzcHuIRVs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-126-hhGjPVaxNbenhNLoUo2ucA-1; Tue, 05 Sep 2023 07:59:53 -0400
X-MC-Unique: hhGjPVaxNbenhNLoUo2ucA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3A30C18DA720
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Sep 2023 11:59:53 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AF69D1121314;
        Tue,  5 Sep 2023 11:59:52 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v4 08/17] tests/shell: interpret an exit code of 77 from scripts as "skipped"
Date:   Tue,  5 Sep 2023 13:58:37 +0200
Message-ID: <20230905115936.607599-9-thaller@redhat.com>
In-Reply-To: <20230905115936.607599-1-thaller@redhat.com>
References: <20230905115936.607599-1-thaller@redhat.com>
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
index f811b44aab0d..0cf37f408003 100755
--- a/tests/shell/helpers/test-wrapper.sh
+++ b/tests/shell/helpers/test-wrapper.sh
@@ -14,6 +14,8 @@ rc_test=0
 
 if [ "$rc_test" -eq 0 ] ; then
 	echo "$rc_test" > "$NFT_TEST_TESTTMPDIR/rc_test-ok"
+elif [ "$rc_test" -eq 77 ] ; then
+	echo "$rc_test" > "$NFT_TEST_TESTTMPDIR/rc_test-skipped"
 else
 	echo "$rc_test" > "$NFT_TEST_TESTTMPDIR/rc_test-failed"
 fi
diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 66da48ab893e..394073024f5f 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -330,6 +330,7 @@ fi
 
 echo ""
 ok=0
+skipped=0
 failed=0
 taint=0
 
@@ -430,6 +431,14 @@ for testfile in "${TESTS[@]}" ; do
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
@@ -454,7 +463,7 @@ echo ""
 kmemleak_found=0
 check_kmemleak_force
 
-msg_info "results: [OK] $ok [FAILED] $failed [TOTAL] $((ok+failed))"
+msg_info "results: [OK] $ok [SKIPPED] $skipped [FAILED] $failed [TOTAL] $((ok+skipped+failed))"
 
 kernel_cleanup
 
-- 
2.41.0

