Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3BC7EB8FAF
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Sep 2023 12:02:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbjIFMCI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Sep 2023 08:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbjIFMCI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2023 08:02:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70660199
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Sep 2023 05:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694001684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=6KlYINgib0zUCHmn3GOYvB+UzKJhxtslftwn/9d/xY8=;
        b=ZMU9moGERgyADzVw4CGW3qBt/QYGgRZTtjtXQC1/lXYJmOhl1nLXnaj2Y2cBoeukjN60It
        YzpKMCY1Sb2BVaP+J5s5/FkSvfsxpqUjxzhwDe22Xe7yuoN22vEnrP7u3umQBpXQXOBPFn
        +S/4qm+sL/UivBFHVRYAprr/XXlbyNs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-168-Stgx0tLSPB6898Rdb2XBpg-1; Wed, 06 Sep 2023 08:01:20 -0400
X-MC-Unique: Stgx0tLSPB6898Rdb2XBpg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F2362182BEAE
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Sep 2023 12:01:19 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6CDF7C15BB8;
        Wed,  6 Sep 2023 12:01:19 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v5 00/19] tests/shell: allow running tests as non-root
Date:   Wed,  6 Sep 2023 13:52:03 +0200
Message-ID: <20230906120109.1773860-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Sorry for the branch getting bigger and the fast resend. But this should be the
final version.

Changes to v4:

- improve the usage() output.
- fix valgrind mode (rework to use "tests/shell/helpers/nft-valgrind-wrapper.sh").
- enable parallel run by default. You now have to opt-in with -s/--sequential
  to run one test at a time. It's really not necessary to do anymore.
- drop bogus leftover of "NFT_TEST_NO_UNSHARE" variable (this was already in v4 replaced
  by "NFT_TEST_UNSHARE_CMD").
- autodetect NFT_TEST_HAS_SOCKET_LIMITS=n. You are now advised to just set
  /proc/sys/net/core/{rmem_max,wmem_max} to 2MB. Then you can run rootless
  tests and they all should pass. If you don't, they get skipped.
- fix 0003includepath_0 test to correctly handle different TMPDIR (which
  the patchset also enables).
- fix a few tests that also need to be skipped due to NFT_TEST_HAS_SOCKET_LIMITS.

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


Thomas Haller (19):
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
  tests/shell: move valgrind wrapper script to separate script
  tests/shell: support running tests in parallel
  tests/shell: bind mount private /var/run/netns in test container
  tests/shell: skip test in rootless that hit socket buffer size limit
  tests/shell: record the test duration (wall time) in the result data
  tests/shell: fix "0003includepath_0" for different TMPDIR
  tests/shell: set TMPDIR for tests in "test-wrapper.sh"

 tests/shell/helpers/nft-valgrind-wrapper.sh   |  17 +
 tests/shell/helpers/test-wrapper.sh           | 110 ++++
 tests/shell/run-tests.sh                      | 609 +++++++++++++-----
 .../shell/testcases/include/0003includepath_0 |   4 +-
 tests/shell/testcases/nft-f/0011manydefines_0 |  16 +
 .../testcases/sets/0011add_many_elements_0    |  15 +
 .../sets/0012add_delete_many_elements_0       |  14 +
 .../sets/0013add_delete_many_elements_0       |  14 +
 .../sets/0030add_many_elements_interval_0     |  14 +
 .../sets/0068interval_stack_overflow_0        |  18 +-
 tests/shell/testcases/sets/automerge_0        |  24 +-
 tests/shell/testcases/transactions/0049huge_0 |  16 +
 tests/shell/testcases/transactions/30s-stress |   9 +
 13 files changed, 723 insertions(+), 157 deletions(-)
 create mode 100755 tests/shell/helpers/nft-valgrind-wrapper.sh
 create mode 100755 tests/shell/helpers/test-wrapper.sh

-- 
2.41.0

