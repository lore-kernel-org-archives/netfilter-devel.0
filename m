Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA6F9C25B47
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Oct 2023 10:01:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233977AbjJXKBa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Oct 2023 06:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232558AbjJXKB2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Oct 2023 06:01:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF3DD79
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2023 03:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698141642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=OCaBIzkOX+ZRvLXUi8HIVXTjHEL0MX2+z+wFJCN8w+U=;
        b=Q7uxvkrbEac+aLq7v7FrD3GhTtWqIrdKMGe2+w+lRlybkjMfyGcXz1xwddslEvYJExUnQQ
        9alUOfcOSfIcXE7BP07R5GNr17q8PG0Oy3w/g6uOC6dh3BIgKAiUE2K51+4Fwpa0wImqKu
        ZnwKCGLG3OMhpcK6mcvttbsSU8UcNEg=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-208-l4xmn4LCNgqvdnd9UBvq5w-1; Tue,
 24 Oct 2023 06:00:41 -0400
X-MC-Unique: l4xmn4LCNgqvdnd9UBvq5w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 27E1A29AA39A
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2023 10:00:41 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.194.225])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 981DA1121318;
        Tue, 24 Oct 2023 10:00:40 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v2 0/4] [RESENT] remove xfree() and add free_const()+nft_gmp_free()
Date:   Tue, 24 Oct 2023 11:57:06 +0200
Message-ID: <20231024095820.1068949-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

RESENT of v1.

Also rebased on top of current `master`, which required minor
adjustments.

Also minor adjustments to the commit messages.

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
 src/libnftables.c       |  24 +++---
 src/meta.c              |   4 +-
 src/misspell.c          |   2 +-
 src/mnl.c               |  16 ++--
 src/netlink_linearize.c |   4 +-
 src/optimize.c          |  12 +--
 src/parser_bison.y      | 158 ++++++++++++++++++++--------------------
 src/rule.c              |  68 ++++++++---------
 src/scanner.l           |   6 +-
 src/segtree.c           |   4 +-
 src/statement.c         |   4 +-
 src/utils.c             |   5 --
 src/xt.c                |  10 +--
 24 files changed, 213 insertions(+), 192 deletions(-)

-- 
2.41.0

