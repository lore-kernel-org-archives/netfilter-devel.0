Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51619EED60B
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Sep 2023 15:36:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbjIOPgo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 Sep 2023 11:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236141AbjIOPgR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Sep 2023 11:36:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2294310E
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Sep 2023 08:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694792128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=JfdT5jLqVDjur8CcHtxnycJPX/qFbgT4BsSNJRrbaLw=;
        b=NIA010ulePd+iX0AE1eazkNMkXiwEIuxZZDUKfku/zgtbvR9Uu5L3oDvl9ys4cqK+WYRgV
        nORcV2yOD8+hrBaCEluyRgTpTwek/8O3e+c36mvg7xbmjOK2KFgaCmmpWq62u8h0SX1LYz
        zOamWvADOL558zjFPEZkeMIfJRToFFQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-516-XOYgG0NINzuZguaWwIcI9g-1; Fri, 15 Sep 2023 11:35:26 -0400
X-MC-Unique: XOYgG0NINzuZguaWwIcI9g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7085685828C
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Sep 2023 15:35:26 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E263B2026D4B;
        Fri, 15 Sep 2023 15:35:25 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 0/2] tests/shell: add feature probing via "features/*.nft" files
Date:   Fri, 15 Sep 2023 17:32:34 +0200
Message-ID: <20230915153515.1315886-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is based on

  Subject:	[PATCH nft 1/5] tests: add feature probing
  Date:	Mon,  4 Sep 2023 11:06:30 +0200

Changes compared to Florian's patch:

- The variables are called "NFT_TEST_HAVE_feat" instead of "NFT_HAVE_feat".

- The code is rewritten to fit into the latest changes of "run-tests.sh".

- The user may set NFT_TEST_HAVE_feat=y|n to force a feature for testing
  and override the detection.

- Print the feature detection in a different style.

Thomas Haller (2):
  tests/shell: add feature probing via "features/*.nft" files
  tests/shell: colorize NFT_TEST_SKIP_/NFT_TEST_HAVE_ in test output

 tests/shell/run-tests.sh | 40 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 38 insertions(+), 2 deletions(-)

-- 
2.41.0

