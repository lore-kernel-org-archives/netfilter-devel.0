Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A5A8CA0FE4
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Sep 2023 15:10:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348529AbjIAPKU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Sep 2023 11:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237546AbjIAPKT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Sep 2023 11:10:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86BF310F1
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Sep 2023 08:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693580970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=9GP7SeYwwhpchxpzszhKchv9Uihzp7TrhHrD77y6TYk=;
        b=QBw9drcZjLJ0d7cwkKYjCYCLN0m9xERtpwPguMjYw311x3ZGKOqRZSO+BfyLAqQ8GdzjLN
        n75SfNyAzYTr33wHu5zSSiY3hEFGH49r+SvmUBkdthStFtAf7HjhqNoiZ/aTPHfI6kilWV
        muTgYXyGYAAD6PrzCp/Gnfl01BM6Uhs=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-213-DdO93xO6PeG4HlXT8T9gYA-1; Fri, 01 Sep 2023 11:09:28 -0400
X-MC-Unique: DdO93xO6PeG4HlXT8T9gYA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF57C3C025BD
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Sep 2023 15:09:27 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 402BA4069776;
        Fri,  1 Sep 2023 15:09:27 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v2 0/3] tests/shell: allow running tests as non-root
Date:   Fri,  1 Sep 2023 17:05:56 +0200
Message-ID: <20230901150916.183949-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

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

Thomas Haller (3):
  tests/shell: rework command line parsing in "run-tests.sh"
  tests/shell: rework finding tests and add "--list-tests" option
  tests/shell: run each test in separate namespace and allow rootless

 tests/shell/run-tests.sh | 191 +++++++++++++++++++++++++++------------
 1 file changed, 132 insertions(+), 59 deletions(-)

-- 
2.41.0

