Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 481D8EE01E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Sep 2023 17:12:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbjIMRMM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Sep 2023 13:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjIMRML (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Sep 2023 13:12:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DA9C31BC8
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Sep 2023 10:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694625080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=AdUVLlNYPNPhy47RhhBe7QnSWgd6dwxJFPdGoWZ5/zc=;
        b=HsKyaSkHzOZtAvZ0rgst5cZuUPExLK0hup8QlIw6lMuMAkth7nUSvp3YKZ36ktqx2MurSk
        MTDE/NNZjkTo0G0kujsyFtdzZfxt5K4ZwuQtuLhjzup2d8JiLepYIcDEBw1UkCVO5U1puK
        s3sTajX8a9gZVinmdMqhCokEkeJ/Qog=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-321-2eK7a_GbPIK8mCcsPA4MgA-1; Wed, 13 Sep 2023 13:11:18 -0400
X-MC-Unique: 2eK7a_GbPIK8mCcsPA4MgA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2CE97801779
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Sep 2023 17:11:18 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E86A2026D4B;
        Wed, 13 Sep 2023 17:11:17 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 1/2] tests/shell: exit 77 from "run-tests.sh" if all tests were skipped
Date:   Wed, 13 Sep 2023 19:11:01 +0200
Message-ID: <20230913171107.439983-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If there are multiple tests and some of them pass and some are skipped,
the overall result should be success (zero). Because likely the user
just selected a bunch of tests (or all of them). So skipping some tests
does not mean that the entire run is not a success.

However, if all tests are skipped, then mark the overall result as
skipped too. The more common case is if you only run one single test,
then we want to know, that the test didn't run.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index bdca0ee1fa0b..188ac89ca1de 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -728,4 +728,10 @@ if [ "$failed" -gt 0 -o "$NFT_TEST_KEEP_LOGS" = y ] ; then
 	NFT_TEST_TMPDIR=
 fi
 
-[ "$failed" -eq 0 ]
+if [ "$failed" -gt 0 ] ; then
+	exit 1
+elif [ "$ok" -eq 0 -a "$skipped" -gt 0 ] ; then
+	exit 77
+else
+	exit 0
+fi
-- 
2.41.0

