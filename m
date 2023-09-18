Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FC68CD37B0
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Sep 2023 20:00:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbjIRUAk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Sep 2023 16:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjIRUAj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Sep 2023 16:00:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 340F6B6
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Sep 2023 12:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695067188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d2j+VGrr+gdUsJtBnOsMxZjnxTVxeiDpel8tawxOIZQ=;
        b=EP8lhRxzqrdPZobuNAeLECT5pUH3rKsR90tbosbHPWj+IsQ8EhGL6QpFgqgGXfFuhOlggH
        qTBsMA9T818ohkNOif98jIZ24G0otMir7ctADbXxZoxeCsIY2nsktf5Eg+V26TN104Hb1D
        CBtH7TQmLENOxrAIpWjjiZjndbH7FI0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-138-AkiNLu6SNXOlsB41HUoUQg-1; Mon, 18 Sep 2023 15:59:46 -0400
X-MC-Unique: AkiNLu6SNXOlsB41HUoUQg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 340BF802D38
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Sep 2023 19:59:46 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A51DB1055466;
        Mon, 18 Sep 2023 19:59:45 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 2/3] tests/shell: simplify collecting error result in "test-wrapper.sh"
Date:   Mon, 18 Sep 2023 21:59:23 +0200
Message-ID: <20230918195933.318893-2-thaller@redhat.com>
In-Reply-To: <20230918195933.318893-1-thaller@redhat.com>
References: <20230918195933.318893-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The previous pattern was unnecessarily confusing.

The "$rc_{dump,valgrind,tainted}" variable should only remember whether
that particular check failed, not the overall exit code of the test
wrapper.

Otherwise, if you want to know in which case the wrapper exits with code
122, you have to oddly follow the rc_valgrind variable.

This change will make more sense, when we add another such variable, but
which will be assigned the non-zero value at multiple places. Assigning
there the exit code of the wrapper, duplicates the places where the
condition maps to the exit code.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/helpers/test-wrapper.sh | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/tests/shell/helpers/test-wrapper.sh b/tests/shell/helpers/test-wrapper.sh
index ad6a71031506..165a944da2b1 100755
--- a/tests/shell/helpers/test-wrapper.sh
+++ b/tests/shell/helpers/test-wrapper.sh
@@ -124,7 +124,7 @@ rc_dump=0
 if [ "$rc_test" -ne 77 -a -f "$DUMPFILE" ] ; then
 	if [ "$dump_written" != y ] ; then
 		if ! $DIFF -u "$DUMPFILE" "$NFT_TEST_TESTTMPDIR/ruleset-after" &> "$NFT_TEST_TESTTMPDIR/ruleset-diff" ; then
-			rc_dump=124
+			rc_dump=1
 		else
 			rm -f "$NFT_TEST_TESTTMPDIR/ruleset-diff"
 		fi
@@ -135,27 +135,27 @@ if [ "$rc_dump" -ne 0 ] ; then
 fi
 
 rc_valgrind=0
-[ -f "$NFT_TEST_TESTTMPDIR/rc-failed-valgrind" ] && rc_valgrind=122
+[ -f "$NFT_TEST_TESTTMPDIR/rc-failed-valgrind" ] && rc_valgrind=1
 
 rc_tainted=0
 if [ "$tainted_before" != "$tainted_after" ] ; then
 	echo "$tainted_after" > "$NFT_TEST_TESTTMPDIR/rc-failed-tainted"
-	rc_tainted=123
+	rc_tainted=1
 fi
 
 if [ "$rc_valgrind" -ne 0 ] ; then
-	rc_exit="$rc_valgrind"
+	rc_exit=122
 elif [ "$rc_tainted" -ne 0 ] ; then
-	rc_exit="$rc_tainted"
+	rc_exit=123
 elif [ "$rc_test" -ge 118 -a "$rc_test" -le 124 ] ; then
 	# Special exit codes are reserved. Coerce them.
-	rc_exit="125"
+	rc_exit=125
 elif [ "$rc_test" -ne 0 ] ; then
 	rc_exit="$rc_test"
 elif [ "$rc_dump" -ne 0 ] ; then
-	rc_exit="$rc_dump"
+	rc_exit=124
 else
-	rc_exit="0"
+	rc_exit=0
 fi
 
 
-- 
2.41.0

