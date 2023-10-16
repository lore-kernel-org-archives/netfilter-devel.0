Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19A11CDB465
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Oct 2023 13:13:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbjJPNNK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Oct 2023 09:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjJPNNK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Oct 2023 09:13:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3210A2
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Oct 2023 06:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697461944;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=noFKdPUgAvckGV7mweXpb2n7vkYJCaBf0ycnMOO3sq0=;
        b=P+2L+9l2v6iN9Qun8ZzCOvImy8QRoe2ur2I90B47OlNDzQsG6qEDamxHOz8Uq1NDwkrkbw
        VWD5p5QVw1uilyYvbGQH/N0E4wPW47uhpKFgRHR63ObaM4CdNCQhiivRHnaUCDQML916tw
        29dQ0C1kvpkLH6WujWxGHr3ml4Rm/bo=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-633-5vijGf7hM6-baWbILwxGgg-1; Mon, 16 Oct 2023 09:12:22 -0400
X-MC-Unique: 5vijGf7hM6-baWbILwxGgg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9203929ABA34
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Oct 2023 13:12:21 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.156])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EDF4A492BEE;
        Mon, 16 Oct 2023 13:12:20 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 1/3] tests/shell: skip "table_onoff" test if kernel patch is missing
Date:   Mon, 16 Oct 2023 15:12:07 +0200
Message-ID: <20231016131209.1127298-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Passing the test suite must not require latest kernel patches.  If test
"table_onoff" appears to not work due to a missing kernel patch, skip
it.

If you run a special kernel and expect that all test pass, set
NFT_TEST_FAIL_ON_SKIP=y to catch unexpected skips.

Fixes: bcca2d67656f ('tests: add test for dormant on/off/on bug')
Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/testcases/transactions/table_onoff | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tests/shell/testcases/transactions/table_onoff b/tests/shell/testcases/transactions/table_onoff
index 831d4614c1f2..d5ad09ef334c 100755
--- a/tests/shell/testcases/transactions/table_onoff
+++ b/tests/shell/testcases/transactions/table_onoff
@@ -11,7 +11,8 @@ delete table ip t
 EOF
 
 if [ $? -eq 0 ]; then
-	exit 1
+	echo "Command to re-awaken a dormant table did not fail. Assume https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c9bd26513b3a11b3adb3c2ed8a31a01a87173ff1 is missing"
+	exit 77
 fi
 
 set -e
-- 
2.41.0

