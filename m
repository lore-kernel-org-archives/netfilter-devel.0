Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 585AFEB8FBE
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Sep 2023 12:02:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238846AbjIFMC4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Sep 2023 08:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236265AbjIFMCy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2023 08:02:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9C5B10F9
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Sep 2023 05:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694001689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fo5wYVno3pJ3iEnMTl3mlVPQiE8n+En/6Pya+PI4JYE=;
        b=IcxVgFce4xPJjGrzu6eE14Vzfj2nYke+nAjrj/98spunaLgTVt6yVukOi3K1/qUh2mlxv2
        8QgWdl6K4vVmeXZ9f2xyaVS2ef5NS4v2HMS5B1YNc/TQe9fxTahcaU/deA0xJw3nQw2PUI
        JsVllpGa725NdgUriOg4+EyoIQCwiEc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-437-RptcdlPSMlOXozQ11-feTw-1; Wed, 06 Sep 2023 08:01:26 -0400
X-MC-Unique: RptcdlPSMlOXozQ11-feTw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 533E838149A8
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Sep 2023 12:01:26 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C8241C15BB8;
        Wed,  6 Sep 2023 12:01:25 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v5 08/19] tests/shell: interpret an exit code of 77 from scripts as "skipped"
Date:   Wed,  6 Sep 2023 13:52:11 +0200
Message-ID: <20230906120109.1773860-9-thaller@redhat.com>
In-Reply-To: <20230906120109.1773860-1-thaller@redhat.com>
References: <20230906120109.1773860-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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
index f083773c2310..fec9e7743226 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -323,6 +323,7 @@ fi
 
 echo ""
 ok=0
+skipped=0
 failed=0
 taint=0
 
@@ -423,6 +424,14 @@ for testfile in "${TESTS[@]}" ; do
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
@@ -447,7 +456,7 @@ echo ""
 kmemleak_found=0
 check_kmemleak_force
 
-msg_info "results: [OK] $ok [FAILED] $failed [TOTAL] $((ok+failed))"
+msg_info "results: [OK] $ok [SKIPPED] $skipped [FAILED] $failed [TOTAL] $((ok+skipped+failed))"
 
 kernel_cleanup
 
-- 
2.41.0

