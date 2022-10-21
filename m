Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70919C43217
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Oct 2022 09:28:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiJUJ22 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 Oct 2022 05:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiJUJ21 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Oct 2022 05:28:27 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1C5D724AAEA
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2022 02:28:25 -0700 (PDT)
Date:   Fri, 21 Oct 2022 11:28:20 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Ian Pilcher <arequipeno@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] libnftnl: Fix res_id byte order
Message-ID: <Y1JmNDW8iLZgHo4f@salvia>
References: <20221018164528.250049-1-arequipeno@gmail.com>
 <20221018164528.250049-2-arequipeno@gmail.com>
 <Y0+c2Y3VtyXXFijD@salvia>
 <a93c58a1-4006-0aaf-9f5b-7e3c3bba16c1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a93c58a1-4006-0aaf-9f5b-7e3c3bba16c1@gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 20, 2022 at 10:05:22AM -0500, Ian Pilcher wrote:
> On 10/19/22 01:44, Pablo Neira Ayuso wrote:
> > On Tue, Oct 18, 2022 at 11:45:28AM -0500, Ian Pilcher wrote:
> > > The res_id member of struct nfgenmsg is supposed to be in network
> > > byte order (big endian).  Call htons() in __nftnl_nlmsg_build_hdr()
> > > to ensure that this is true on little endian systems.
> >
> > LGTM, this is zero all the time at this moment. But it might be useful
> > in the future to bump it.
>
> Actually it isn't always zero.  I only noticed this because
> nftnl_batch_begin() and nftnl_batch_end() set res_id to
> NFNL_SUBSYS_NFTABLES (instead of putting it in the high 8 bits of
> nlmsg_type).

Indeed, nfnetlink batch uses this for begin and end message.

> It's entirely possible that this is also a bug, as the fact that the
> value isn't currently being byte-swapped doesn't seem to make any
> difference.

There is code to workaround this issue in the kernel, it was added in 4.3.

commit a9de9777d613500b089a7416f936bf3ae5f070d2
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Fri Aug 28 21:01:43 2015 +0200

    netfilter: nfnetlink: work around wrong endianess in res_id field

oldest stable kernel is 4.9.
