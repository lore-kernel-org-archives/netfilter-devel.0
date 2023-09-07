Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56E8CEC875D
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Sep 2023 22:09:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239336AbjIGWJw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Sep 2023 18:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234718AbjIGWJp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Sep 2023 18:09:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EB921BC6
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Sep 2023 15:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694124526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=7FdlhPhrBKa5BzlAFz75s20QUUwp+GNglSKD2TSXVu0=;
        b=IvQrXgaJgTTBJxyj4Yk2nsRWBFz11OEi96KXiILwtYaonluEsOZyBRAfmJyqKRQsSoRJe6
        T0HJlBWevGa0hBovpF4tDvAmaurshZflEoWJEP4JMX/GHR1dSAv9IZGmzr43PeJ6W+1UNT
        +Nf0mTvM5D9ZIi5ULO2jJWWtF+K+Rdc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-657-dcW9uEBiOhKwh9q3e-PzzQ-1; Thu, 07 Sep 2023 18:08:44 -0400
X-MC-Unique: dcW9uEBiOhKwh9q3e-PzzQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 46876957844
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Sep 2023 22:08:44 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B498C63F6C;
        Thu,  7 Sep 2023 22:08:43 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 00/11] tests/shell: colorize output, fix VALGRIND mode
Date:   Fri,  8 Sep 2023 00:07:12 +0200
Message-ID: <20230907220833.2435010-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

- colorize the test output.
- fix the valgrind mode (-V, VALGRIND=y).
- various minor improvements(?).

Thomas Haller (11):
  tests/shell: cleanup result handling in "test-wrapper.sh"
  tests/shell: cleanup print_test_result() and show TAINTED error code
  tests/shell: colorize terminal output with test result
  tests/shell: fix handling failures with VALGRIND=y
  tests/shell: print the NFT setting with the VALGRIND=y wrapper
  tests/shell: don't redirect error/warning messages to stderr
  tests/shell: redirect output of test script to file too
  tests/shell: print "kernel is tainted" separate from test result
  tests/shell: no longer enable verbose output when selecting a test
  tests/shell: record wall time of test run in result data
  tests/shell: set NFT_TEST_JOBS based on $(nproc)

 tests/shell/helpers/nft-valgrind-wrapper.sh |  15 ++-
 tests/shell/helpers/test-wrapper.sh         |  70 ++++++----
 tests/shell/run-tests.sh                    | 134 +++++++++++++++-----
 3 files changed, 165 insertions(+), 54 deletions(-)

-- 
2.41.0

