Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14781EE8015
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Sep 2023 15:14:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238645AbjIHPOb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Sep 2023 11:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244378AbjIHPOa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Sep 2023 11:14:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FFEF1BFF
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Sep 2023 08:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694186018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=03RAaNPum9wqQwKX1Qo2cGRN9nzU+fCaA4wLyZAXbPo=;
        b=EnaGOftqmTefosEozm3ZMh6YZW0Mbr4yYsytQds+pQ7rGGyikqoGwINdg3RzzUCKSjGXJP
        5b4eKBF5pN5CAkkxnXxyIEkenp0WVxu4rvZiOIuGwSMWxYqD4RJxV7dwMXxpExDuQBQ1fQ
        e8DfZcCCbT4nfN8rQaRKGATzmKazsFU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-511-qaI0Hc-CM_KvN_67qPEgqA-1; Fri, 08 Sep 2023 11:13:35 -0400
X-MC-Unique: qaI0Hc-CM_KvN_67qPEgqA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C575D856DED;
        Fri,  8 Sep 2023 15:13:34 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1EE18493110;
        Fri,  8 Sep 2023 15:13:33 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 0/2] tests/shell: add mechanism for skipping (for no JSON and slow)
Date:   Fri,  8 Sep 2023 17:07:23 +0200
Message-ID: <20230908151323.1161159-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a mechanism to skip tests. Two cases are implemented:

- skip thest that require JSON support, if nft binary is build without.

- the user can choose to skip long-running tests via the (-Q|--quick) option.
  Most tests are fast, so by skipping 8 of 373 tests, I can run the
  test suite in 7 seconds.

This is inspired and related to Florian's "feature probing" patchset.
And done with the intent, that those patches could integrate in a
common mechanism. Florian's patches are NOT obsoleted by this
(although, they would require rebase/adjustment).

Changes/notes compared to Florian's approach:

- Florian's patchset mostly called the variable NFT_HAVE_xxx (although,
  the commit message also called it NFT_TEST_HAVE_xxx). I choose
  NFT_TEST_HAVE_* name to make it clear that the environment variables are
  related to the tests.

- The evalution of NFT_TEST_HAVE_json=y|n is hard coded in "run-test.sh"
  because it seems special enough. But we certainly can combine that with
  the generic mechanism to load features from the "features/" directory.

- NFT_TEST_HAVE_xxx can also be set by the user. That overrides the
  feature detection. The point is to force the detection for manual
  testing.

- let "test-wrapper.sh" can parse tags like

    # NFT_TEST_REQUIRES(NFT_TEST_HAVE_json)
    # NFT_TEST_SKIP(NFT_TEST_SKIP_slow)

  to simplify marking tests with the skip/requires option.

Thomas Haller (2):
  tests/shell: skip tests if nft does not support JSON mode
  tests/shell: add "--quick" option to skip slow tests (via
    NFT_TEST_SKIP_slow=y)

 tests/shell/helpers/test-wrapper.sh           | 51 ++++++++++++++++-
 tests/shell/run-tests.sh                      | 56 ++++++++++++++++++-
 .../shell/testcases/json/0001set_statements_0 |  2 +
 tests/shell/testcases/json/0002table_map_0    |  2 +
 .../testcases/json/0003json_schema_version_0  |  2 +
 .../testcases/json/0004json_schema_version_1  |  2 +
 .../shell/testcases/json/0005secmark_objref_0 |  2 +
 tests/shell/testcases/json/0006obj_comment_0  |  2 +
 tests/shell/testcases/json/netdev             |  9 ++-
 .../listing/0021ruleset_json_terse_0          | 13 ++++-
 .../maps/0004interval_map_create_once_0       |  8 +++
 .../testcases/maps/0018map_leak_timeout_0     |  2 +
 tests/shell/testcases/maps/vmap_timeout       |  2 +
 .../testcases/sets/0043concatenated_ranges_0  |  2 +
 .../testcases/sets/0044interval_overlap_0     |  2 +
 .../testcases/sets/0044interval_overlap_1     |  2 +
 tests/shell/testcases/sets/automerge_0        |  2 +
 tests/shell/testcases/transactions/0049huge_0 | 14 ++++-
 tests/shell/testcases/transactions/30s-stress |  2 +
 19 files changed, 168 insertions(+), 9 deletions(-)

-- 
2.41.0

