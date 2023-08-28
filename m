Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 177B7C83F16
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Aug 2023 14:48:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231868AbjH1Or7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Aug 2023 10:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231922AbjH1Orb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Aug 2023 10:47:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F9312F
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Aug 2023 07:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693233983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=XttZKPZ0DrGUFopg6lszfnXv62jbvt/fcjwF/QylWAE=;
        b=AIXFGpiRMqkrqLPLrIVhvxak4X5r9iSt/yODCRyn/PIeP10DVVvADiE2/Bbha9BP6eDPnf
        Xd8kpfUQUtQa+e1/TV2gXYb9o6m6NDv/3ZkPpBfeqEcub6/lB+Ei65kQjHCDS/YFGr1fT2
        JuqgFfwYsVc3yQpppeFpe9ghbLFYqN8=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-316-973PixLdOmWPpJU7ivgjIw-1; Mon, 28 Aug 2023 10:46:21 -0400
X-MC-Unique: 973PixLdOmWPpJU7ivgjIw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9DE112A5956F
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Aug 2023 14:46:21 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.45])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1886840D2839;
        Mon, 28 Aug 2023 14:46:20 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 0/8] fix compiler warnings with clang
Date:   Mon, 28 Aug 2023 16:43:50 +0200
Message-ID: <20230828144441.3303222-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Building with clang caused some compiler warnings. Fix, suppress or work
around them.

Thomas Haller (8):
  netlink: avoid "-Wenum-conversion" warning in dtype_map_from_kernel()
  netlink: avoid "-Wenum-conversion" warning in parser_bison.y
  src: use "%zx" format instead of "%Zx"
  datatype: avoid cast-align warning with struct sockaddr result from
    getaddrinfo()
  src: rework SNPRINTF_BUFFER_SIZE() and avoid
    "-Wunused-but-set-variable"
  src: suppress "-Wunused-but-set-variable" warning with
    "parser_bison.c"
  utils: add _NFT_PRAGMA_WARNING_DISABLE()/_NFT_PRAGMA_WARNING_REENABLE
    helpers
  datatype: suppress "-Wformat-nonliteral" warning in
    integer_type_print()

 include/utils.h    | 73 ++++++++++++++++++++++++++++++++++++++++------
 src/Makefile.am    |  1 +
 src/datatype.c     | 22 ++++++++++----
 src/evaluate.c     | 11 ++++---
 src/intervals.c    | 10 +++----
 src/meta.c         | 10 +++----
 src/netlink.c      |  2 +-
 src/parser_bison.y |  4 +--
 8 files changed, 99 insertions(+), 34 deletions(-)

-- 
2.41.0

