Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15323EE01EC
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Sep 2023 17:08:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbjIMRIJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Sep 2023 13:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbjIMRHx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Sep 2023 13:07:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8ACAD19BB
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Sep 2023 10:07:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694624825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=GUUckY19NR7auF96hWueik21cC4dMtM9KDN07m3EqFc=;
        b=bUlm7PGldjmaMjCPRyOMnqJcQGRk+oCblfGBLDfHHgcqmscPDFh363jOHXPTT5OtH/7m5j
        Dq3OQtrXfE7xF0Ipj2pCPFdgtr0OkInRu1cmpBCiNyTUV3iY68esSy0Y9sCS836OWLLChb
        zDDZhTN3NRyvNKCVwc/4wCxIXPVZaJE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-74-qWdN0SobMVOzJlBNsVsUVg-1; Wed, 13 Sep 2023 13:07:00 -0400
X-MC-Unique: qWdN0SobMVOzJlBNsVsUVg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 919CD857A9A
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Sep 2023 17:07:00 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 105F140C6EA8;
        Wed, 13 Sep 2023 17:06:59 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 0/6] adjust nft dump files and add check-tree script
Date:   Wed, 13 Sep 2023 19:05:03 +0200
Message-ID: <20230913170649.439394-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

- add/remove some nft dump scripts, as they are missing or wrong.
- add a "tools/check-tree.sh" script for consistency checks of the
  source tree. Currently, it's only concerned about the tests/shell
  dump files, but (from the name of the script) it shall be used for
  further consistency checks.

Thomas Haller (6):
  tests/shell: remove spurious .nft dump files
  tests/shell: drop unstable dump for "transactions/0051map_0" test
  tests/shell: add missing nft/nodump files for tests
  tests/shell: special handle base path starting with "./"
  tests/shell: in find_tests() use C locale for sorting tests names
  tools: add "tools/check-tree.sh" script to check consistency of nft
    dumps

 tests/shell/run-tests.sh                      |  6 +-
 .../chains/dumps/0043chain_ingress.nft        | 11 ---
 .../testcases/listing/dumps/0013objects_0.nft | 29 ++++++
 .../nft-f/dumps/0026policy_variable_0.nft     |  5 -
 .../sets/dumps/reset_command_0.nodump         |  0
 .../transactions/dumps/0051map_0.nft          |  7 --
 .../transactions/dumps/0051map_0.nodump       |  0
 .../transactions/dumps/bad_expression.nft     |  0
 tools/check-tree.sh                           | 91 +++++++++++++++++++
 9 files changed, 124 insertions(+), 25 deletions(-)
 delete mode 100644 tests/shell/testcases/chains/dumps/0043chain_ingress.nft
 create mode 100644 tests/shell/testcases/listing/dumps/0013objects_0.nft
 delete mode 100644 tests/shell/testcases/nft-f/dumps/0026policy_variable_0.nft
 create mode 100644 tests/shell/testcases/sets/dumps/reset_command_0.nodump
 delete mode 100644 tests/shell/testcases/transactions/dumps/0051map_0.nft
 create mode 100644 tests/shell/testcases/transactions/dumps/0051map_0.nodump
 create mode 100644 tests/shell/testcases/transactions/dumps/bad_expression.nft
 create mode 100755 tools/check-tree.sh

-- 
2.41.0

