Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA562C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 May 2022 22:29:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbiENW3u (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 14 May 2022 18:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiENW3t (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 14 May 2022 18:29:49 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 40EB064C1
        for <netfilter-devel@vger.kernel.org>; Sat, 14 May 2022 15:29:48 -0700 (PDT)
Date:   Sun, 15 May 2022 00:29:44 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnftnl] src: add dynamic register allocation
 infrastructure
Message-ID: <YoAtWOcCusBi4tR7@salvia>
References: <20220502110744.113720-1-pablo@netfilter.org>
 <Yn/dnyORrGtf7t8E@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yn/dnyORrGtf7t8E@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, May 14, 2022 at 06:49:35PM +0200, Phil Sutter wrote:
> Hi Pablo,
> 
> On Mon, May 02, 2022 at 01:07:44PM +0200, Pablo Neira Ayuso wrote:
> > Starting Linux kernel 5.18-rc, operations on registers that already
> > contain the expected data are turned into noop.
> > 
> > Track operation on registers to use the same register through
> > nftnl_reg_get(). This patch introduces an LRU eviction strategy when all
> > the registers are in used.
> > 
> > nftnl_reg_get_scratch() is used to allocate a register as scratchpad
> > area: no tracking is performed in this case, although register eviction
> > might occur.
> > 
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> >  include/expr_ops.h           |   6 +
> >  include/internal.h           |   1 +
> >  include/libnftnl/Makefile.am |   1 +
> >  include/regs.h               |  32 ++++++
> >  src/Makefile.am              |   1 +
> >  src/expr/meta.c              |  44 +++++++
> >  src/expr/payload.c           |  31 +++++
> >  src/libnftnl.map             |   7 ++
> >  src/regs.c                   | 216 +++++++++++++++++++++++++++++++++++
> >  9 files changed, 339 insertions(+)
> >  create mode 100644 include/regs.h
> >  create mode 100644 src/regs.c
> 
> Did you forget to add include/libnftnl/regs.h to this patch? It is
> referenced from src/regs.c and build fails.

Yes, this is fixed here:

http://git.netfilter.org/libnftnl/commit/?id=e549f5b3239c19f78af2f7c7a582fe5616403ca8
