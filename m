Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6332C83F2C
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Sep 2023 13:52:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236935AbjIDNwi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Sep 2023 09:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232137AbjIDNwi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Sep 2023 09:52:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B3FE3
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Sep 2023 06:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693835507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=C+7ouEPjtbpAoi+wF5jrsnNEWd+pPV9oxk4TyGo2FnM=;
        b=hjUHth57iIT943RZrC+HlrnfeCn9tiJB4agVM02OwIsCcCnhTy5iBSzMXSaVQ+6TyoeYJJ
        jct9pkIuDJnm/0n4cBu5ABKSDiIQQ9i2XRcCKiSlrAgcktFwlYxHcqgyBnBXEQP+uik/TY
        mK5ZvHpJzRZRrtcL0Lp3gz0RD7Hg5Ws=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-65-ZHVpon2HPpqxUUJqia0Glw-1; Mon, 04 Sep 2023 09:51:46 -0400
X-MC-Unique: ZHVpon2HPpqxUUJqia0Glw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 31536803E2E
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Sep 2023 13:51:46 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A5B741121314;
        Mon,  4 Sep 2023 13:51:45 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v3 00/11] tests/shell: allow running tests as
Date:   Mon,  4 Sep 2023 15:48:02 +0200
Message-ID: <20230904135135.1568180-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Changes to v3:

- large rework of all patches.
- we still try to unshare as much as we can, but gracefully fallback to
  only unshare the netns. What we don't do anymore, is accept failure to unshare
  altogether and proceed silently. If you want that, use NFT_TEST_NO_UNSHARE=y or
  NFT_TEST_UNSHARE_CMD=cmd.
- compared to v2, fix `nft flush` to be called inside the target netns.
  It's now done by "test-wrapper.sh"
- add mode to run jobs in parallel.
- move test-specific functionality from "run-tests.sh to "test-wrapper.sh".
- collect test results in a temporary directory for later inspection.

Changes to v2:

- new patch: rework the parsing of command line options
- new patch: add a "--list-tests" option to show the found tests
- call "unshare" for each test individually.
- drop NFT_TEST_ROOTLESS environment variable. You no longer have to
  opt-in to run rootless. However, if any tests fail and we ran
  rootless, then an info is printed at the end.
- the environment variables NFT_TEST_HAVE_REALROOT and
  NFT_TEST_NO_UNSHARE can still be set to configure the script.
  Those are now also configurable via command line options.
  Usually you would not have to set them.

Thomas Haller (11):
  tests/shell: rework command line parsing in "run-tests.sh"
  tests/shell: rework finding tests and add "--list-tests" option
  tests/shell: check test names before start and support directories
  tests/shell: export NFT_TEST_BASEDIR and NFT_TEST_TMPDIR for tests
  tests/shell: run each test in separate namespace and allow rootless
  tests/shell: interpret an exit code of 77 from scripts as "skipped"
  tests/shell: support --keep-logs option (NFT_TEST_KEEP_LOGS=y) to
    preserve test output
  tests/shell: move the dump diff handling inside "test-wrapper.sh"
  tests/shell: rework printing of test results
  tests/shell: move taint check to "test-wrapper.sh"
  tests/shell: support running tests in parallel

 tests/shell/helpers/test-wrapper.sh |  77 +++++
 tests/shell/run-tests.sh            | 467 ++++++++++++++++++++--------
 2 files changed, 422 insertions(+), 122 deletions(-)
 create mode 100755 tests/shell/helpers/test-wrapper.sh

-- 
2.41.0

