Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCD96C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 May 2022 16:49:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbiENQtl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 14 May 2022 12:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbiENQtl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 14 May 2022 12:49:41 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0B31381A9
        for <netfilter-devel@vger.kernel.org>; Sat, 14 May 2022 09:49:38 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1npuxT-0007kV-UQ; Sat, 14 May 2022 18:49:35 +0200
Date:   Sat, 14 May 2022 18:49:35 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnftnl] src: add dynamic register allocation
 infrastructure
Message-ID: <Yn/dnyORrGtf7t8E@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20220502110744.113720-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220502110744.113720-1-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Mon, May 02, 2022 at 01:07:44PM +0200, Pablo Neira Ayuso wrote:
> Starting Linux kernel 5.18-rc, operations on registers that already
> contain the expected data are turned into noop.
> 
> Track operation on registers to use the same register through
> nftnl_reg_get(). This patch introduces an LRU eviction strategy when all
> the registers are in used.
> 
> nftnl_reg_get_scratch() is used to allocate a register as scratchpad
> area: no tracking is performed in this case, although register eviction
> might occur.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  include/expr_ops.h           |   6 +
>  include/internal.h           |   1 +
>  include/libnftnl/Makefile.am |   1 +
>  include/regs.h               |  32 ++++++
>  src/Makefile.am              |   1 +
>  src/expr/meta.c              |  44 +++++++
>  src/expr/payload.c           |  31 +++++
>  src/libnftnl.map             |   7 ++
>  src/regs.c                   | 216 +++++++++++++++++++++++++++++++++++
>  9 files changed, 339 insertions(+)
>  create mode 100644 include/regs.h
>  create mode 100644 src/regs.c

Did you forget to add include/libnftnl/regs.h to this patch? It is
referenced from src/regs.c and build fails.

Cheers, Phil
