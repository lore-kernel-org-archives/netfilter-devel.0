Return-Path: <SRS0=Vl9M=3M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85CD8C33CAA
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jan 2020 03:45:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CC7624125
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jan 2020 03:45:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbgAWDps (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Jan 2020 22:45:48 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:42468 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725933AbgAWDpr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Jan 2020 22:45:47 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iuTRB-000406-OE; Thu, 23 Jan 2020 04:45:45 +0100
Date:   Thu, 23 Jan 2020 04:45:45 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf,v2] netfilter: nf_tables: autoload modules from the
 abort path
Message-ID: <20200123034545.GS795@breakpoint.cc>
References: <20200122211706.150042-1-pablo@netfilter.org>
 <20200122222808.GR795@breakpoint.cc>
 <20200122224947.iucrwyxmsrtm7ppe@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200122224947.iucrwyxmsrtm7ppe@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Jan 22, 2020 at 11:28:08PM +0100, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > +	list_for_each_entry(req, &net->nft.module_list, list) {
> > > +		if (!strcmp(req->module, module_name) && req->done)
> > > +			return 0;
> > > +	}
> > 
> > If the module is already on this list, why does it need to be
> > added a second time?
> 
> The first time this finds no module on the list, then the module is
> added to the list and nft_request_module() returns -EAGAIN. This
> triggers abort path with autoload parameter set to true from
> nfnetlink, this sets the module done field to true.

I guess I was confused by the need for the "&& req->done" part.

AFAIU req->done is always true here.

> Now, on the second path, it will find that this already tried to load
> the module, so it does not add it again, nft_request_module() returns 0.

But the "I already tried this" is already implied by the presence of the
module name?  Or did I misunderstand?

> Then, there is a look up to find the object that was missing. If
> module was successfully load, the object will be in place, otherwise
> -ENOENT is reported to userspace.

Good, that will prevent infite retries in case userspace requests
non-existent module.

> I can include this logic in the patch description in a v3.

That would be good, thanks!

> I run the syzbot reproducer for 1 hour and no problems, not sure how
> much I have to run it more. I guess the more time the better.

It triggers instantly for me provided:
1. CONFIG_MODULES=y (with MODULES=n the faulty code part isn't built...)
2. set "sysctl kernel.modprobe=/root/sleep1.sh"
   I found that with normal modprobe the race window is rather small and
   the thread doing the request_module has a decent chance of re-locking
   the mutex before another syzkaller thread has a chance to alter the
   current generation.
