Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7832C83F12
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Aug 2023 13:00:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232759AbjH2M7j (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Aug 2023 08:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235600AbjH2M7N (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Aug 2023 08:59:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6BB099
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 05:58:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693313901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+rqARaudvWT3oOdAeTMHVtFyhsqJMBiuDvGS+yRiQcY=;
        b=MG1h2rl2e2Y3oHLJC8KHb3TbQ+41b4z5cH98Y1QQExMqrJW2UsJAJA6o78N9kCwu118a+L
        fR36Z1n7gRbsux+7fWa/re1R051qBNRFZ/ixVwEEmDXbSo5DmUcbTyiW6nEQxsqwH918KE
        rFKpy6qN7PJ4xvA5TUGiooGc7CFSJRQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-nSNAlXwlPZ2J6xGBDtcckQ-1; Tue, 29 Aug 2023 08:58:20 -0400
X-MC-Unique: nSNAlXwlPZ2J6xGBDtcckQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 29887185A78F
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 12:58:20 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.45])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9529340C2063;
        Tue, 29 Aug 2023 12:58:19 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v2 0/8] fix compiler warnings with clang
Date:   Tue, 29 Aug 2023 14:53:29 +0200
Message-ID: <20230829125809.232318-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Building with clang caused some compiler warnings. Fix, suppress or work
around them.

Changes to v1:
- replace patches
    "src: use "%zx" format instead of "%Zx""
    "utils: add _NFT_PRAGMA_WARNING_DISABLE()/_NFT_PRAGMA_WARNING_REENABLE helpers"
    "datatype: suppress "-Wformat-nonliteral" warning in integer_type_print()"
  with
    "include: drop "format" attribute from nft_gmp_print()"
  which is the better solution.
- let SNPRINTF_BUFFER_SIZE() not assert against truncation. Instead, the
  callers handle it.
- add bugfix "evaluate: fix check for truncation in stmt_evaluate_log_prefix()"
- add minor patch "evaluate: don't needlessly clear full string buffer in stmt_evaluate_log_prefix()"

Thomas Haller (8):
  netlink: avoid "-Wenum-conversion" warning in dtype_map_from_kernel()
  netlink: avoid "-Wenum-conversion" warning in parser_bison.y
  datatype: avoid cast-align warning with struct sockaddr result from
    getaddrinfo()
  evaluate: fix check for truncation in stmt_evaluate_log_prefix()
  src: rework SNPRINTF_BUFFER_SIZE() and handle truncation
  evaluate: don't needlessly clear full string buffer in
    stmt_evaluate_log_prefix()
  src: suppress "-Wunused-but-set-variable" warning with
    "parser_bison.c"
  include: drop "format" attribute from nft_gmp_print()

 include/nftables.h |  3 +--
 include/utils.h    | 35 ++++++++++++++++++++++++++---------
 src/Makefile.am    |  1 +
 src/datatype.c     | 14 +++++++++++---
 src/evaluate.c     | 15 ++++++++++-----
 src/meta.c         | 11 ++++++-----
 src/netlink.c      |  2 +-
 src/parser_bison.y |  4 ++--
 8 files changed, 58 insertions(+), 27 deletions(-)

-- 
2.41.0

