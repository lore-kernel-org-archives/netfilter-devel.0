Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9DECC83F2C
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Sep 2023 16:27:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243422AbjIEQ0u (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354481AbjIEMAd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Sep 2023 08:00:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE6631AB
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Sep 2023 04:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693915188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=imj11PDo3CoWuEhfPtf42tzWw689geFng2zgIaIC0nc=;
        b=G3EhS/BaAlHUGT685HizNxGRU4Scbxvn5wbkPvGDHaKHCIn1nx7nBR/TIuD7NbGzsrUEYi
        JCwx4DWmFGgzV3WBeTM57v5svDuwbw/JJO/NpRgYFC2qUK1ZH/qwL5ghC3j6PWp/TYFMzc
        HzHi6Av4CeggzQcanKGeUKwnGGSpJQA=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-482-v_0IQiSBNqiyAuXZAIZk4A-1; Tue, 05 Sep 2023 07:59:47 -0400
X-MC-Unique: v_0IQiSBNqiyAuXZAIZk4A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EB4321C041A1
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Sep 2023 11:59:46 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6BC081121314;
        Tue,  5 Sep 2023 11:59:46 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v4 00/17] tests/shell: allow running tests as
Date:   Tue,  5 Sep 2023 13:58:29 +0200
Message-ID: <20230905115936.607599-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Changes to v3:

- add "-j" option to run tests in parallel.
- with real root, don't use `unshare -U`. That breaks tests that require
  real root. Even if the user originally is real-root, after unshare, the
  process can no longer increase the socket buffer beyond wmem_max. For
  rootful, we must not unshare the user namespace. And no longer do that by
  default.
- unshare the mount namespace, this allows to bindmount a different /var/run/netns.
  That's useful with rootful for isolation and necessary with rootless
  to have writable /var/run/netns.
- rework the way how unshare is configurable. Basically, you don't need
  to care, but if you wish, you can override with NFT_TEST_UNSHARE_CMD.
- tests that are known to not work in rootless are now automatically
  skipped. On my system, all tests that pass with rootful also pass 
  or are skipped with rootless (I have some tests that fail also with 
  root). 
- support NFT_TEST_HAS_SOCKET_LIMITS=n environment to get tests that
  would be skipped in rootless to run (and pass, if wmem_max is high
  enough).
- many minor improvements.

Changes to v2:

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

Changes to v1:

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

Thomas Haller (17):
  tests/shell: rework command line parsing in "run-tests.sh"
  tests/shell: rework finding tests and add "--list-tests" option
  tests/shell: check test names before start and support directories
  tests/shell: export NFT_TEST_BASEDIR and NFT_TEST_TMPDIR for tests
  tests/shell: normalize boolean configuration in environment variables
  tests/shell: print test configuration
  tests/shell: run each test in separate namespace and allow rootless
  tests/shell: interpret an exit code of 77 from scripts as "skipped"
  tests/shell: support --keep-logs option (NFT_TEST_KEEP_LOGS=y) to
    preserve test output
  tests/shell: move the dump diff handling inside "test-wrapper.sh"
  tests/shell: rework printing of test results
  tests/shell: move taint check to "test-wrapper.sh"
  tests/shell: support running tests in parallel
  tests/shell: bind mount private /var/run/netns in test container
  tests/shell: skip test in rootless that hit socket buffer size limit
  tests/shell: record the test duration for investigation
  tests/shell: set TMPDIR for tests in "test-wrapper.sh"

 tests/shell/helpers/test-wrapper.sh           | 111 ++++
 tests/shell/run-tests.sh                      | 593 ++++++++++++++----
 tests/shell/testcases/nft-f/0011manydefines_0 |  16 +
 .../testcases/sets/0011add_many_elements_0    |  15 +
 .../sets/0012add_delete_many_elements_0       |  14 +
 .../sets/0013add_delete_many_elements_0       |  14 +
 tests/shell/testcases/sets/automerge_0        |  24 +-
 tests/shell/testcases/transactions/30s-stress |   9 +
 8 files changed, 671 insertions(+), 125 deletions(-)
 create mode 100755 tests/shell/helpers/test-wrapper.sh

-- 
2.41.0

