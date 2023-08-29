Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2B63C71153
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Aug 2023 15:01:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234546AbjH2PBI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Aug 2023 11:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237182AbjH2PAr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Aug 2023 11:00:47 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 186631B6
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 08:00:43 -0700 (PDT)
Received: from [78.30.34.192] (port=53002 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qb0Cp-00F8qX-VM; Tue, 29 Aug 2023 17:00:38 +0200
Date:   Tue, 29 Aug 2023 17:00:35 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v2 0/8] fix compiler warnings with clang
Message-ID: <ZO4IEwJPaP9FZiqF@calendula>
References: <20230829125809.232318-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230829125809.232318-1-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 29, 2023 at 02:53:29PM +0200, Thomas Haller wrote:
> Building with clang caused some compiler warnings. Fix, suppress or work
> around them.

Series LGTM, applied.

The ugly macro can go away later, once meta_parse_key() is removed
when bison/flex use start conditions for this, and probably log prefix
is reviewed not to use it anymore. I still think that macro is not
looking any better after this update but this is not a deal breaker
for this series.

BTW, would you extend tests/build to check for run build tests for
clang in a follow up patch? That would help a lot to improve coverage,
and reduce chances compilation with clang breaks again in the future
before a release.

Thanks.

> Changes to v1:
> - replace patches
>     "src: use "%zx" format instead of "%Zx""
>     "utils: add _NFT_PRAGMA_WARNING_DISABLE()/_NFT_PRAGMA_WARNING_REENABLE helpers"
>     "datatype: suppress "-Wformat-nonliteral" warning in integer_type_print()"
>   with
>     "include: drop "format" attribute from nft_gmp_print()"
>   which is the better solution.
> - let SNPRINTF_BUFFER_SIZE() not assert against truncation. Instead, the
>   callers handle it.
> - add bugfix "evaluate: fix check for truncation in stmt_evaluate_log_prefix()"
> - add minor patch "evaluate: don't needlessly clear full string buffer in stmt_evaluate_log_prefix()"
> 
> Thomas Haller (8):
>   netlink: avoid "-Wenum-conversion" warning in dtype_map_from_kernel()
>   netlink: avoid "-Wenum-conversion" warning in parser_bison.y
>   datatype: avoid cast-align warning with struct sockaddr result from
>     getaddrinfo()
>   evaluate: fix check for truncation in stmt_evaluate_log_prefix()
>   src: rework SNPRINTF_BUFFER_SIZE() and handle truncation
>   evaluate: don't needlessly clear full string buffer in
>     stmt_evaluate_log_prefix()
>   src: suppress "-Wunused-but-set-variable" warning with
>     "parser_bison.c"
>   include: drop "format" attribute from nft_gmp_print()
> 
>  include/nftables.h |  3 +--
>  include/utils.h    | 35 ++++++++++++++++++++++++++---------
>  src/Makefile.am    |  1 +
>  src/datatype.c     | 14 +++++++++++---
>  src/evaluate.c     | 15 ++++++++++-----
>  src/meta.c         | 11 ++++++-----
>  src/netlink.c      |  2 +-
>  src/parser_bison.y |  4 ++--
>  8 files changed, 58 insertions(+), 27 deletions(-)
> 
> -- 
> 2.41.0
> 
