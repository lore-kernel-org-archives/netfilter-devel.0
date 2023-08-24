Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A855C83003
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Aug 2023 11:17:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238172AbjHXLQc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Aug 2023 07:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241013AbjHXLQR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2023 07:16:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 986D019B3
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Aug 2023 04:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692875710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=SqFbJkhLA4H4MalkVjYXYBTRauei2/jjZu/Hnt7HtUc=;
        b=H+v0TX6IhPDTFAWYFfNEGu5ORg17WOZsOJ4rhr2Sz0E9pvRMuZECMr5OQf/C/r+wPVdn+g
        7DoQerCmhoLVGyrlAxZLvF4yuNAIeLzigcQlCPae1PoNt+FsGFRpcXuU1xan2ZwDh4Cp0U
        47wZvr6Z7k+ewOYlGHndia03Tic45EI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-580-wWRltOAwM-iAKav95EXAaw-1; Thu, 24 Aug 2023 07:15:08 -0400
X-MC-Unique: wWRltOAwM-iAKav95EXAaw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A24C585CCE3
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Aug 2023 11:15:08 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.207])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 213F5C1602B;
        Thu, 24 Aug 2023 11:15:08 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 0/6] cleanup base includes and add <nftdefault.h> header
Date:   Thu, 24 Aug 2023 13:13:28 +0200
Message-ID: <20230824111456.2005125-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

- cleanup _GNU_SOURCE/_XOPEN_SOURCE handling
- ensure <config.h> is included as first (via <nftdefault.h> header)
- add <nftdefault.h> to provide a base header that is included
  everywhere.

Thomas Haller (6):
  meta: define _GNU_SOURCE to get strptime() from <time.h>
  src: add <nftdefault.h> header and include it as first
  include: don't define _GNU_SOURCE in public header
  configure: use AC_USE_SYSTEM_EXTENSIONS to get _GNU_SOURCE
  include: include <std{bool,int}.h> via nftdefault.h
  configure: drop AM_PROG_CC_C_O autoconf check

 configure.ac                   |  4 +++-
 include/Makefile.am            |  3 ++-
 include/cli.h                  |  1 -
 include/datatype.h             |  1 -
 include/dccpopt.h              |  1 -
 include/expression.h           |  1 -
 include/gmputil.h              |  2 --
 include/nftables.h             |  1 -
 include/nftables/libnftables.h |  1 -
 include/nftdefault.h           | 10 ++++++++++
 include/rule.h                 |  1 -
 include/utils.h                |  3 ---
 src/cache.c                    |  2 ++
 src/cli.c                      |  3 ++-
 src/cmd.c                      |  2 ++
 src/ct.c                       |  2 ++
 src/datatype.c                 |  2 ++
 src/dccpopt.c                  |  3 ++-
 src/erec.c                     |  4 ++--
 src/evaluate.c                 |  3 ++-
 src/expression.c               |  3 ++-
 src/exthdr.c                   |  3 ++-
 src/fib.c                      |  2 ++
 src/gmputil.c                  |  2 ++
 src/hash.c                     |  2 ++
 src/iface.c                    |  2 ++
 src/intervals.c                |  2 ++
 src/ipopt.c                    |  3 ++-
 src/json.c                     |  3 ++-
 src/libnftables.c              |  3 +++
 src/main.c                     |  2 ++
 src/mergesort.c                |  3 ++-
 src/meta.c                     |  8 +++-----
 src/mini-gmp.c                 |  2 ++
 src/misspell.c                 |  2 ++
 src/mnl.c                      |  2 ++
 src/monitor.c                  |  2 ++
 src/netlink.c                  |  2 ++
 src/netlink_delinearize.c      |  3 ++-
 src/netlink_linearize.c        |  2 ++
 src/nfnl_osf.c                 |  2 ++
 src/nftutils.c                 |  3 +--
 src/nftutils.h                 |  1 -
 src/numgen.c                   |  2 ++
 src/optimize.c                 |  3 ++-
 src/osf.c                      |  2 ++
 src/owner.c                    |  2 ++
 src/parser_json.c              |  4 ++--
 src/payload.c                  |  3 ++-
 src/print.c                    |  2 ++
 src/proto.c                    |  3 ++-
 src/rt.c                       |  3 ++-
 src/rule.c                     |  3 ++-
 src/scanner.l                  |  2 ++
 src/sctp_chunk.c               |  2 ++
 src/segtree.c                  |  2 ++
 src/socket.c                   |  2 ++
 src/statement.c                |  3 ++-
 src/tcpopt.c                   |  3 ++-
 src/utils.c                    |  2 ++
 src/xfrm.c                     |  2 ++
 src/xt.c                       |  2 ++
 62 files changed, 114 insertions(+), 42 deletions(-)
 create mode 100644 include/nftdefault.h

-- 
2.41.0

