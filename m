Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5005FCA0FE2
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Sep 2023 16:26:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351671AbjIEQ0N (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354502AbjIEMCE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Sep 2023 08:02:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28FE7CE0
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Sep 2023 05:00:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693915201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DGFId+I9uEAmv8nKgoPgjK1ub2KpU9SoKEy+FQil0Cw=;
        b=LnyeBubKO8pa+espx1cM9pRqTezAKphsce+P0+VfNKA+XgrJeVQHDjryrcdgeXYvA2pAex
        1ElFO0H9b41qU8j/o3K01GIGD4f3hhDCt5FZ3S6E8DxJbLUHl1rp3PDZAPHpxpmrnyAc3D
        abOkgKG6Xk8CjWGyvx8k4CNJgSXwKDU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-Xec7CuRIOCWLiEDW0drNDA-1; Tue, 05 Sep 2023 08:00:00 -0400
X-MC-Unique: Xec7CuRIOCWLiEDW0drNDA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 45A79928A42
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Sep 2023 12:00:00 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BAE3B1121314;
        Tue,  5 Sep 2023 11:59:59 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v4 17/17] tests/shell: set TMPDIR for tests in "test-wrapper.sh"
Date:   Tue,  5 Sep 2023 13:58:46 +0200
Message-ID: <20230905115936.607599-18-thaller@redhat.com>
In-Reply-To: <20230905115936.607599-1-thaller@redhat.com>
References: <20230905115936.607599-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Various tests create additional temporary files. They really should just
use "$NFT_TEST_TESTTMPDIR" for that. However, they mostly use `mktemp`.

The scripts are supposed to cleanup those files afterwards. However,
often that does not work correctly and /tmp gets full of left over
temporary files.

Export "TMPDIR" so that they use the test-specific temporary directory.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/helpers/test-wrapper.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tests/shell/helpers/test-wrapper.sh b/tests/shell/helpers/test-wrapper.sh
index f8aed3241aea..9782040ed798 100755
--- a/tests/shell/helpers/test-wrapper.sh
+++ b/tests/shell/helpers/test-wrapper.sh
@@ -11,6 +11,8 @@ TESTDIR="$(dirname "$TEST")"
 
 START_TIME="$(cut -d ' ' -f1 /proc/uptime)"
 
+export TMPDIR="$NFT_TEST_TESTTMPDIR"
+
 CLEANUP_UMOUNT_RUN_NETNS=n
 
 cleanup() {
-- 
2.41.0

