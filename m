Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84DE0C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Nov 2023 11:12:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjKCLMI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Nov 2023 07:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjKCLMH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2023 07:12:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2696418E
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 04:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699009875;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=HFxECcin8/AnWoSYjhFbsu/2HxIXAFWR72zUV7RCjIo=;
        b=bcLXyo7TFEpPiNVIdd33GmTC0uZPJs/F2cJ4b62S7hfajsVBtZifH6XhUlCAIM7mb8HHY+
        WeHZuXzIQhTAhpwtttazYeyFklj6i7PGR/DMNYYSVhKa4gMEVoXQvsSPgHmw7Fx8fu4r4H
        ySwQFLFNnFknIQNewQo5lG/IexO2cVo=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-486-S9rK44CZODi1E7ASgbBZiQ-1; Fri,
 03 Nov 2023 07:11:13 -0400
X-MC-Unique: S9rK44CZODi1E7ASgbBZiQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 712F03C025B4
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 11:11:13 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.47])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E480C1C060BA;
        Fri,  3 Nov 2023 11:11:12 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 0/6] add infrastructure for unit tests
Date:   Fri,  3 Nov 2023 12:05:42 +0100
Message-ID: <20231103111102.2801624-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There are new new make targets:

  - "build-all"
  - "check" (runs "normal" tests, like unit tests and "tools/check-tree.sh").
  - "check-more" (runs extra tests, like "tests/build")
  - "check-all" (runs "check" + "check-more")
  - "check-local" (a subset of "check")
  - "check-TESTS" (the unit tests)

The unit tests have a test runner "tools/test-runner.sh". See
`tools/test-runner.sh -h` for options, like valgrind, GDB, or make.
It also runs the test in a separate namespace (rootless).

To run unit tests only, `make check-TESTS` or `tools/test-runner.sh
tests/unit/test-libnftables-static -m`.

The unit tests are of course still empty. "tests/unit" is the place
where tests shall be added.

Thomas Haller (6):
  gitignore: ignore build artifacts from top level file
  build: add basic "check-{local,more,all}" and "build-all" make targets
  build: add `make check-tests-build` to add build test
  build: add check for consistency of source tree
  build: cleanup if blocks for conditional compilation
  tests/unit: add unit tests for libnftables

 .gitignore                           |  15 +-
 Makefile.am                          | 128 ++++++++++++---
 src/.gitignore                       |   5 -
 tests/unit/nft-test.h                |  14 ++
 tests/unit/test-libnftables-static.c |  16 ++
 tests/unit/test-libnftables.c        |  21 +++
 tools/test-runner.sh                 | 228 +++++++++++++++++++++++++++
 7 files changed, 399 insertions(+), 28 deletions(-)
 create mode 100644 tests/unit/nft-test.h
 create mode 100644 tests/unit/test-libnftables-static.c
 create mode 100644 tests/unit/test-libnftables.c
 create mode 100755 tools/test-runner.sh

-- 
2.41.0

