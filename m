Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FAE8C4167B
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Nov 2023 15:11:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbjKEPLB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Nov 2023 10:11:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjKEPK7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Nov 2023 10:10:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B667BCC
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Nov 2023 07:10:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699197008;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=l4o637IieqGGXjY5WhWShm2SP5CqQEfH1r4xLgHXmAw=;
        b=QujmL92g6B1i6hafqneF1HYKWcUBTGX+qLC9r/No+iOur4Y3o4Kbd34g3Z9bTrBcepBtuo
        Qq5Gxzkgis62/JFVoDZmHG4pY9sWu/Npkgz6xO9yExic1YP6qTpbGbWiek3W+IuSqwApHa
        9AdM1QbWk27wpOlVe+S1e0aIU7qkZcQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-562-Oo0dbqEsNB2XAFnd4POwBA-1; Sun, 05 Nov 2023 10:10:06 -0500
X-MC-Unique: Oo0dbqEsNB2XAFnd4POwBA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B53B3811000
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Nov 2023 15:10:06 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.47])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 30F27492BFA;
        Sun,  5 Nov 2023 15:10:06 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v2 0/5] add infrastructure for unit tests
Date:   Sun,  5 Nov 2023 16:08:36 +0100
Message-ID: <20231105150955.349966-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Changes to v1:

- rename some `make targets`
- add `make check-unit` to alias `make check-TESTS`. These targets
  run the tests hooked up as "TESTS=" (which for now are the tests
  in tests/unit).
- improve commit messages and various minor code changes.

Thomas Haller (5):
  build: add basic "check-{local,more,all}" and "build-all" make targets
  build: add `make check-build` to run `./tests/build/run-tests.sh`
  build: add `make check-tree` to check consistency of source tree
  build: cleanup if-blocks for conditional compilation in "Makefile.am"
  tests/unit: add unit tests for libnftables

 .gitignore                           |  15 +-
 Makefile.am                          | 134 ++++++++++++---
 src/.gitignore                       |   5 -
 tests/unit/nft-test.h                |  14 ++
 tests/unit/test-libnftables-static.c |  16 ++
 tests/unit/test-libnftables.c        |  21 +++
 tools/test-runner.sh                 | 235 +++++++++++++++++++++++++++
 7 files changed, 412 insertions(+), 28 deletions(-)
 create mode 100644 tests/unit/nft-test.h
 create mode 100644 tests/unit/test-libnftables-static.c
 create mode 100644 tests/unit/test-libnftables.c
 create mode 100755 tools/test-runner.sh

-- 
2.41.0

