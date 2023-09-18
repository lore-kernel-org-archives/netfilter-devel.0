Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E256CCD13D9
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Sep 2023 10:31:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239655AbjIRKbW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Sep 2023 06:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240485AbjIRKav (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Sep 2023 06:30:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8939D1
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Sep 2023 03:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695032999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1QATaibgHGgN8poEcqn86SEwlpA5cGw5xDgY3H8w46U=;
        b=ZRkAE2spV65fUaDDfeyoEb/SbppGPD8vZTmmWUVofPZTnzPQG8mEzS5jqeMuwU3CF+SdLK
        n5cp0WlZ1+5/KNWApgcV6TDIzbiV14p2/wSl6CWxgQqTUIjlwnFx9nL8qFVufVl0CUxtlC
        JQtPzBZRY++xAeeq1ynEpXzAuLu26eA=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-640-HWub-tCVMXeAwiFenGR_nQ-1; Mon, 18 Sep 2023 06:29:58 -0400
X-MC-Unique: HWub-tCVMXeAwiFenGR_nQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D998429AA3AD
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Sep 2023 10:29:57 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 531B4C15BB8;
        Mon, 18 Sep 2023 10:29:57 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 00/14] tests/shell: fix tests to skip on lacking feature support
Date:   Mon, 18 Sep 2023 12:28:14 +0200
Message-ID: <20230918102947.2125883-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Most of the patches are from Florian.

With this, a test-run on Fedora 38 and CentOS-Stream-9 should pass (some
tests will be skipped).

Florian Westphal (12):
  tests/shell: add and use chain binding feature probe
  tests/shell: skip netdev_chain_0 if kernel requires netdev device
  tests/shell: skip map query if kernel lacks support
  tests/shell: skip inner matching tests if unsupported
  tests/shell: skip bitshift tests if kernel lacks support
  tests/shell: skip some tests if kernel lacks netdev egress support
  tests/shell: skip inet ingress tests if kernel lacks support
  tests/shell: skip destroy tests if kernel lacks support
  tests/shell: skip catchall tests if kernel lacks support
  tests/shell: skip test cases involving osf match if kernel lacks
    support
  tests/shell: skip test cases if ct expectation and/or timeout lacks
    support
  tests/shell: skip reset tests if kernel lacks support

Thomas Haller (2):
  tests/shell: implement NFT_TEST_HAVE_json feature detection as script
  tests/shell: check diff in "maps/typeof_maps_0" and
    "sets/typeof_sets_0" test

 tests/shell/features/bitshift.nft             |   7 +
 tests/shell/features/catchall_element.nft     |   8 ++
 tests/shell/features/chain_binding.nft        |   7 +
 tests/shell/features/ctexpect.nft             |  10 ++
 tests/shell/features/cttimeout.nft            |   8 ++
 tests/shell/features/destroy.nft              |   3 +
 tests/shell/features/inet_ingress.nft         |   7 +
 tests/shell/features/inner_matching.nft       |   7 +
 tests/shell/features/json.sh                  |   6 +
 tests/shell/features/map_lookup.nft           |  11 ++
 .../features/netdev_chain_without_device.nft  |   7 +
 tests/shell/features/netdev_egress.nft        |   7 +
 tests/shell/features/osf.nft                  |   7 +
 tests/shell/features/reset_rule.sh            |   8 ++
 tests/shell/features/reset_set.sh             |  10 ++
 tests/shell/run-tests.sh                      |  39 +++---
 .../shell/testcases/bitwise/0040mark_binop_0  |   2 +
 .../shell/testcases/bitwise/0040mark_binop_1  |   2 +
 .../shell/testcases/bitwise/0040mark_binop_2  |   2 +
 .../shell/testcases/bitwise/0040mark_binop_3  |   2 +
 .../shell/testcases/bitwise/0040mark_binop_4  |   2 +
 .../shell/testcases/bitwise/0040mark_binop_5  |   2 +
 .../shell/testcases/bitwise/0040mark_binop_6  |   2 +
 .../shell/testcases/bitwise/0040mark_binop_7  |   2 +
 .../shell/testcases/bitwise/0040mark_binop_8  |   2 +
 .../shell/testcases/bitwise/0040mark_binop_9  |   2 +
 .../testcases/cache/0010_implicit_chain_0     |   2 +
 tests/shell/testcases/chains/0021prio_0       |   7 +-
 .../testcases/chains/0041chain_binding_0      |   5 +
 .../testcases/chains/0042chain_variable_0     |   5 +
 .../testcases/chains/0043chain_ingress_0      |   9 +-
 .../testcases/chains/0044chain_destroy_0      |   2 +
 .../chains/dumps/netdev_chain_autoremove.nft  |   0
 tests/shell/testcases/chains/netdev_chain_0   |   2 +
 .../testcases/chains/netdev_chain_autoremove  |   9 ++
 tests/shell/testcases/flowtable/0015destroy_0 |   2 +
 tests/shell/testcases/listing/0013objects_0   |  50 ++-----
 .../testcases/listing/dumps/0013objects_0.nft |   2 -
 tests/shell/testcases/maps/0011vmap_0         |  10 +-
 tests/shell/testcases/maps/0014destroy_0      |   2 +
 .../shell/testcases/maps/0017_map_variable_0  |  13 +-
 .../maps/map_catchall_double_deactivate       |   2 +
 tests/shell/testcases/maps/typeof_maps_0      |  66 ++++++++-
 .../testcases/maps/typeof_maps_add_delete     |  35 +++--
 .../testcases/nft-f/0017ct_timeout_obj_0      |   2 +
 .../testcases/rule_management/0011reset_0     |   2 +
 .../testcases/rule_management/0012destroy_0   |   2 +
 tests/shell/testcases/sets/0063set_catchall_0 |   2 +
 tests/shell/testcases/sets/0064map_catchall_0 |   2 +
 tests/shell/testcases/sets/0072destroy_0      |   2 +
 tests/shell/testcases/sets/inner_0            |   2 +
 tests/shell/testcases/sets/reset_command_0    |   2 +
 tests/shell/testcases/sets/typeof_sets_0      | 130 ++++++++++++++++--
 tests/shell/testcases/transactions/30s-stress |  55 +++++++-
 54 files changed, 502 insertions(+), 94 deletions(-)
 create mode 100644 tests/shell/features/bitshift.nft
 create mode 100644 tests/shell/features/catchall_element.nft
 create mode 100644 tests/shell/features/chain_binding.nft
 create mode 100644 tests/shell/features/ctexpect.nft
 create mode 100644 tests/shell/features/cttimeout.nft
 create mode 100644 tests/shell/features/destroy.nft
 create mode 100644 tests/shell/features/inet_ingress.nft
 create mode 100644 tests/shell/features/inner_matching.nft
 create mode 100755 tests/shell/features/json.sh
 create mode 100644 tests/shell/features/map_lookup.nft
 create mode 100644 tests/shell/features/netdev_chain_without_device.nft
 create mode 100644 tests/shell/features/netdev_egress.nft
 create mode 100644 tests/shell/features/osf.nft
 create mode 100755 tests/shell/features/reset_rule.sh
 create mode 100755 tests/shell/features/reset_set.sh
 create mode 100644 tests/shell/testcases/chains/dumps/netdev_chain_autoremove.nft
 create mode 100755 tests/shell/testcases/chains/netdev_chain_autoremove

-- 
2.41.0

