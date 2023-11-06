Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04DA4C4332F
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Nov 2023 13:35:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbjKFNfR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Nov 2023 08:35:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232855AbjKFNfQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Nov 2023 08:35:16 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD967D4C
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Nov 2023 05:35:12 -0800 (PST)
Received: from [78.30.35.151] (port=33816 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qzzky-00FG9r-TW; Mon, 06 Nov 2023 14:35:10 +0100
Date:   Mon, 6 Nov 2023 14:35:07 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v2 0/4] [RESENT] remove xfree() and add
 free_const()+nft_gmp_free()
Message-ID: <ZUjri2C9mi6cTvp1@calendula>
References: <20231024095820.1068949-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231024095820.1068949-1-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 24, 2023 at 11:57:06AM +0200, Thomas Haller wrote:
> RESENT of v1.
> 
> Also rebased on top of current `master`, which required minor
> adjustments.
> 
> Also minor adjustments to the commit messages.

I will put this in the tree this evening, after with the recent fixes
I have posted.

> Thomas Haller (4):
>   datatype: don't return a const string from cgroupv2_get_path()
>   gmputil: add nft_gmp_free() to free strings from mpz_get_str()
>   all: add free_const() and use it instead of xfree()
>   all: remove xfree() and use plain free()
> 
>  include/gmputil.h       |   2 +
>  include/nft.h           |   6 ++
>  include/utils.h         |   1 -
>  src/cache.c             |   6 +-
>  src/ct.c                |   2 +-
>  src/datatype.c          |  18 ++---
>  src/erec.c              |   6 +-
>  src/evaluate.c          |  18 ++---
>  src/expression.c        |   6 +-
>  src/gmputil.c           |  21 +++++-
>  src/json.c              |   2 +-
>  src/libnftables.c       |  24 +++---
>  src/meta.c              |   4 +-
>  src/misspell.c          |   2 +-
>  src/mnl.c               |  16 ++--
>  src/netlink_linearize.c |   4 +-
>  src/optimize.c          |  12 +--
>  src/parser_bison.y      | 158 ++++++++++++++++++++--------------------
>  src/rule.c              |  68 ++++++++---------
>  src/scanner.l           |   6 +-
>  src/segtree.c           |   4 +-
>  src/statement.c         |   4 +-
>  src/utils.c             |   5 --
>  src/xt.c                |  10 +--
>  24 files changed, 213 insertions(+), 192 deletions(-)
> 
> -- 
> 2.41.0
> 
