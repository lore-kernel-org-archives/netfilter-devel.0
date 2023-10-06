Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0191E92FFD
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Oct 2023 09:44:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbjJFJoM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 Oct 2023 05:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231475AbjJFJoK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Oct 2023 05:44:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD326AD
        for <netfilter-devel@vger.kernel.org>; Fri,  6 Oct 2023 02:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696585401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V0t+ETjYOtGPta+fgEV7Z64IPA9YgMP2S1S9KfLNjOI=;
        b=BALumjq3T/WORs2674EZpNXsI1FEuizCnbzC4zqmqU/Zo0eRnlIL2KvjlcmuRO6Ku/EDaU
        X2+ESHJF3eNSO9o2Zgmyq2tihaK6XvJtXRO1X4xJaLnuskDIn0+73LgWfwEyyGj0Xo7tOd
        r/mgsl1VKDHWSic/DtD9BFYxtyXcPv8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556-DLyEpoocMnimzQf1o2RC5w-1; Fri, 06 Oct 2023 05:43:20 -0400
X-MC-Unique: DLyEpoocMnimzQf1o2RC5w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0523085A5A8
        for <netfilter-devel@vger.kernel.org>; Fri,  6 Oct 2023 09:43:20 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.194.252])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E4FD2156711;
        Fri,  6 Oct 2023 09:43:18 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [nft PATCH 2/3] tests/shell: preserve result directory with NFT_TEST_FAIL_ON_SKIP
Date:   Fri,  6 Oct 2023 11:42:19 +0200
Message-ID: <20231006094226.711628-2-thaller@redhat.com>
In-Reply-To: <20231006094226.711628-1-thaller@redhat.com>
References: <20231006094226.711628-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On a successful run, the result directory will be deleted (unless run
with "-k|--keep-logs" option or NFT_TEST_KEEP_LOGS=y).

With NFT_TEST_FAIL_ON_SKIP=y, when there are no failures but skipped
tests, also preserve the result.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 4ff0b55ad7b1..7672b2fe5074 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -850,7 +850,12 @@ echo ""
 kmemleak_found=0
 check_kmemleak_force
 
-if [ "$failed" -gt 0 ] || [ "$NFT_TEST_FAIL_ON_SKIP" = y -a "$skipped" -gt 0 ] ; then
+failed_total="$failed"
+if [ "$NFT_TEST_FAIL_ON_SKIP" = y ] ; then
+	failed_total="$((failed_total + skipped))"
+fi
+
+if [ "$failed_total" -gt 0 ] ; then
 	RR="$RED"
 elif [ "$skipped" -gt 0 ] ; then
 	RR="$YELLOW"
@@ -875,7 +880,7 @@ END_TIME="$(cut -d ' ' -f1 /proc/uptime)"
 WALL_TIME="$(awk -v start="$START_TIME" -v end="$END_TIME" "BEGIN { print(end - start) }")"
 printf "%s\n" "$WALL_TIME" "$START_TIME" "$END_TIME" > "$NFT_TEST_TMPDIR/times"
 
-if [ "$failed" -gt 0 -o "$NFT_TEST_KEEP_LOGS" = y ] ; then
+if [ "$failed_total" -gt 0 -o "$NFT_TEST_KEEP_LOGS" = y ] ; then
 	msg_info "check the temp directory \"$NFT_TEST_TMPDIR\" (\"$NFT_TEST_LATEST\")"
 	msg_info "   ls -lad \"$NFT_TEST_LATEST\"/*/*"
 	msg_info "   grep -R ^ \"$NFT_TEST_LATEST\"/"
-- 
2.41.0

