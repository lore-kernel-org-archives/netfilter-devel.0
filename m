Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D54ACE79D1
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 13:16:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234531AbjITNRB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 09:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234465AbjITNRA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 09:17:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 765B6A9
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 06:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695215767;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=7DzeTqmEy1kZE5Z/dkI0k/USZiqxPlUX4WaDS3/Ov0c=;
        b=UWQt2px0WGPm6WcWq/Kbh2JQerKr5dB+UD8kUQ2sQLtAZooJHcqqFxCDIGSHhcZQvMLw2o
        +DPYSRqpeKV5lkLCbPERK7KQlsBl634Lt2jaMW7sxKxaD+j6jWlfcsy8rnBMRyfZBe5NAd
        GlP0pvW+OGN7vd/BMU0iTIyRERpijNw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-128-cfgCJ2FHPfqHRqReYzehjw-1; Wed, 20 Sep 2023 09:16:05 -0400
X-MC-Unique: cfgCJ2FHPfqHRqReYzehjw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 54D081C0CCAC
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 13:16:05 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C73A8C15BB8;
        Wed, 20 Sep 2023 13:16:04 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 0/4] remove xfree() and add free_const()+nft_gmp_free()
Date:   Wed, 20 Sep 2023 15:13:37 +0200
Message-ID: <20230920131554.204899-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

- add and use a nft_gmp_free() for freeing memory allocated by gmp.
- add a free_const() for the many places where we intentionally want
  to free a const pointer. It still just wraps free(), as the name
  indicates. Unlike xfree(), which sounds as if xmalloc()/xfree()
  were a distinct set of allocators.
- drop xfree() and use plain free() (or free_const()) everywhere.

Thomas Haller (4):
  datatype: don't return a const string from cgroupv2_get_path()
  gmputil: add nft_gmp_free() to free strings from mpz_get_str()
  all: add free_const() and use it instead of xfree()
  all: remove xfree() and use plain free()

 include/gmputil.h       |   2 +
 include/nft.h           |   6 ++
 include/utils.h         |   1 -
 src/cache.c             |   6 +-
 src/ct.c                |   2 +-
 src/datatype.c          |  18 ++---
 src/erec.c              |   6 +-
 src/evaluate.c          |  18 ++---
 src/expression.c        |   6 +-
 src/gmputil.c           |  21 +++++-
 src/json.c              |   2 +-
 src/libnftables.c       |  24 +++----
 src/meta.c              |   4 +-
 src/misspell.c          |   2 +-
 src/mnl.c               |  16 ++---
 src/netlink_linearize.c |   4 +-
 src/optimize.c          |  12 ++--
 src/parser_bison.y      | 156 ++++++++++++++++++++--------------------
 src/rule.c              |  68 +++++++++---------
 src/scanner.l           |   6 +-
 src/segtree.c           |   4 +-
 src/statement.c         |   4 +-
 src/utils.c             |   5 --
 src/xt.c                |  10 +--
 24 files changed, 212 insertions(+), 191 deletions(-)

-- 
2.41.0

