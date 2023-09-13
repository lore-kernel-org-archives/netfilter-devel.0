Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F80DCA5507
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Sep 2023 08:23:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232410AbjIMIXQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Sep 2023 04:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbjIMIXQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Sep 2023 04:23:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5BECC10C0
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Sep 2023 01:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694593351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=lCdb1K4EJICdW4+ZMQOwQlaqwA7CR6oRdFSNODI6E/c=;
        b=IlzyZ3OnPhXvoNlNqGJo46ZUoEJ9IVKnGWEuW6Jw/d2anBHK6HyEDEm4osVKR0hAZ5FwB1
        Bs6LhgCmnEPRgOLOacayVwS8MVPCUjY60UamLKq8ZC2nJcr59UGjMoQbtA5JdGw+Qi0xzI
        fe2IybnQewgzID4nhyekW+mtN20KP+g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-448-5C9AtFDRNyiMKd-fH8mKRg-1; Wed, 13 Sep 2023 04:22:29 -0400
X-MC-Unique: 5C9AtFDRNyiMKd-fH8mKRg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6C7BE101B45A
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Sep 2023 08:22:29 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DFBEA63F9D;
        Wed, 13 Sep 2023 08:22:28 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 0/3] add NFT_TEST_RANDOM_SEED and shuffle tests
Date:   Wed, 13 Sep 2023 10:20:22 +0200
Message-ID: <20230913082217.2711665-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

- let "run-tests.sh" export a NFT_TEST_RANDOM_SEED, which tests may use
  for generating stable (reproducible) sequences in randomized tests.
- add NFT_TEST_SHUFFLE_TESTS, to randomize the order in which tests are
  run. The purpose is to find issues where tests interfere with each
  other. It's enabled by default, if no tests are explicitly specified
  on the command line.

Thomas Haller (3):
  tests/shell: export NFT_TEST_RANDOM_SEED variable for tests
  tests/shell: add "random-source.sh" helper for random-source for
    sort/shuf
  tests/shell: add option to shuffle execution order of tests

 tests/shell/helpers/random-source.sh   | 40 ++++++++++++++++
 tests/shell/run-tests.sh               | 64 ++++++++++++++++++++++++++
 tests/shell/testcases/sets/automerge_0 |  2 +-
 3 files changed, 105 insertions(+), 1 deletion(-)
 create mode 100755 tests/shell/helpers/random-source.sh

-- 
2.41.0

