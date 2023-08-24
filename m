Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2839BC6FA8F
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Aug 2023 12:54:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233303AbjHXMyY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Aug 2023 08:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241457AbjHXMyO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2023 08:54:14 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70FD31BEB
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Aug 2023 05:54:06 -0700 (PDT)
Received: from [78.30.34.192] (port=53526 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qZ9qa-0097up-T8; Thu, 24 Aug 2023 14:54:04 +0200
Date:   Thu, 24 Aug 2023 14:54:00 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 0/6] cleanup base includes and add <nftdefault.h>
 header
Message-ID: <ZOdS6DOQLYPkthoX@calendula>
References: <20230824111456.2005125-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230824111456.2005125-1-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Aug 24, 2023 at 01:13:28PM +0200, Thomas Haller wrote:
> - cleanup _GNU_SOURCE/_XOPEN_SOURCE handling
> - ensure <config.h> is included as first (via <nftdefault.h> header)
> - add <nftdefault.h> to provide a base header that is included
>   everywhere.

Could you use include/nft.h instead?

> Thomas Haller (6):
>   meta: define _GNU_SOURCE to get strptime() from <time.h>
>   src: add <nftdefault.h> header and include it as first
>   include: don't define _GNU_SOURCE in public header
>   configure: use AC_USE_SYSTEM_EXTENSIONS to get _GNU_SOURCE
>   include: include <std{bool,int}.h> via nftdefault.h
>   configure: drop AM_PROG_CC_C_O autoconf check
> 
>  configure.ac                   |  4 +++-
>  include/Makefile.am            |  3 ++-
>  include/cli.h                  |  1 -
>  include/datatype.h             |  1 -
>  include/dccpopt.h              |  1 -
>  include/expression.h           |  1 -
>  include/gmputil.h              |  2 --
>  include/nftables.h             |  1 -
>  include/nftables/libnftables.h |  1 -
>  include/nftdefault.h           | 10 ++++++++++
>  include/rule.h                 |  1 -
>  include/utils.h                |  3 ---
>  src/cache.c                    |  2 ++
>  src/cli.c                      |  3 ++-
>  src/cmd.c                      |  2 ++
>  src/ct.c                       |  2 ++
>  src/datatype.c                 |  2 ++
>  src/dccpopt.c                  |  3 ++-
>  src/erec.c                     |  4 ++--
>  src/evaluate.c                 |  3 ++-
>  src/expression.c               |  3 ++-
>  src/exthdr.c                   |  3 ++-
>  src/fib.c                      |  2 ++
>  src/gmputil.c                  |  2 ++
>  src/hash.c                     |  2 ++
>  src/iface.c                    |  2 ++
>  src/intervals.c                |  2 ++
>  src/ipopt.c                    |  3 ++-
>  src/json.c                     |  3 ++-
>  src/libnftables.c              |  3 +++
>  src/main.c                     |  2 ++
>  src/mergesort.c                |  3 ++-
>  src/meta.c                     |  8 +++-----
>  src/mini-gmp.c                 |  2 ++
>  src/misspell.c                 |  2 ++
>  src/mnl.c                      |  2 ++
>  src/monitor.c                  |  2 ++
>  src/netlink.c                  |  2 ++
>  src/netlink_delinearize.c      |  3 ++-
>  src/netlink_linearize.c        |  2 ++
>  src/nfnl_osf.c                 |  2 ++
>  src/nftutils.c                 |  3 +--
>  src/nftutils.h                 |  1 -
>  src/numgen.c                   |  2 ++
>  src/optimize.c                 |  3 ++-
>  src/osf.c                      |  2 ++
>  src/owner.c                    |  2 ++
>  src/parser_json.c              |  4 ++--
>  src/payload.c                  |  3 ++-
>  src/print.c                    |  2 ++
>  src/proto.c                    |  3 ++-
>  src/rt.c                       |  3 ++-
>  src/rule.c                     |  3 ++-
>  src/scanner.l                  |  2 ++
>  src/sctp_chunk.c               |  2 ++
>  src/segtree.c                  |  2 ++
>  src/socket.c                   |  2 ++
>  src/statement.c                |  3 ++-
>  src/tcpopt.c                   |  3 ++-
>  src/utils.c                    |  2 ++
>  src/xfrm.c                     |  2 ++
>  src/xt.c                       |  2 ++
>  62 files changed, 114 insertions(+), 42 deletions(-)
>  create mode 100644 include/nftdefault.h
> 
> -- 
> 2.41.0
> 
