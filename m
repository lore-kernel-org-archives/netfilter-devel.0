Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12B6CEED616
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Sep 2023 15:57:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236207AbjIOP5c (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 Sep 2023 11:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236211AbjIOP5Q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Sep 2023 11:57:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A589FE78
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Sep 2023 08:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694793387;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=FYCymlONdZXzT+C/X+fHld+7jPGC0YXqAO+PBIzKzzE=;
        b=IgXpQ9YF3JXDY026CSsuRe3dckuLW+/zjot/TRQVVfQmIGkf2yRePY5fkHbyP+Qd7NCScK
        g+fNBe6f8/UrYfI3DvpVMB1SWHunhECnHIG1QV6/pdzQ0Fm5Dt3IoiDObalZx6seeZVw5c
        UUO2g/im9Yxdt7YuJheoTHW8tlgi9Pg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-550-89QSUxDGODO8GFxNP60VzA-1; Fri, 15 Sep 2023 11:56:26 -0400
X-MC-Unique: 89QSUxDGODO8GFxNP60VzA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E44D8101B04B
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Sep 2023 15:56:25 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6327C40C2070;
        Fri, 15 Sep 2023 15:56:25 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 0/3] shell/tests: cleanups and skip tests on Fedora 38
Date:   Fri, 15 Sep 2023 17:53:59 +0200
Message-ID: <20230915155614.1325657-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

- cleanup dummy interface handling
- adjust 2 tests so that they are skipped on Fedora 38 kernel
  (6.4.14-200.fc38.x86_64). The end goal is to run the test suite
  without failures on Fedora 38.

    - tests/shell/testcases/sets/reset_command_0
    - tests/shell/testcases/sets/0030add_many_elements_interval_0

Thomas Haller (3):
  tests/shell: cleanup creating dummy interfaces in tests
  tests/shell: skip "sets/reset_command_0" on unsupported reset command
  tests/shell: suggest 4Mb /proc/sys/net/core/{wmem_max,rmem_max} for
    rootless

 tests/shell/run-tests.sh                      |  6 ++---
 .../testcases/chains/dumps/netdev_chain_0.nft |  3 ---
 tests/shell/testcases/chains/netdev_chain_0   | 26 +++++++------------
 .../flowtable/0012flowtable_variable_0        |  6 +++++
 .../dumps/0012flowtable_variable_0.nft        |  4 +--
 tests/shell/testcases/json/netdev             | 12 +++++----
 tests/shell/testcases/listing/0020flowtable_0 | 12 +++++----
 tests/shell/testcases/sets/reset_command_0    | 20 ++++++++++----
 8 files changed, 50 insertions(+), 39 deletions(-)

-- 
2.41.0

