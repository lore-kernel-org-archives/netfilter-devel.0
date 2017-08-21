From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCH nft v2 00/18] introducing libnftables
Date: Mon, 21 Aug 2017 23:42:45 +0200
Message-ID: <1503351765.9868.15.camel@regit.org>
References: <20170819152420.22563-1-eric@regit.org>
         <20170821085511.GA3615@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:55614 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751575AbdHUVmu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Aug 2017 17:42:50 -0400
In-Reply-To: <20170821085511.GA3615@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Mon, 2017-08-21 at 10:55 +0200, Pablo Neira Ayuso wrote:
> Hi Eric,
> 
> First off, I appreciate the time you took to work on this.

Thanks :)
> 
> On Sat, Aug 19, 2017 at 05:24:02PM +0200, Eric Leblond wrote:
> > 
> > Hello,
> > 
> > This patchset is the second version of libnftables introduction
> > patchset.
> > It addresses some remarks by Phil Sutter. Other remarks as said on
> > the ML
> > are in fact TODO points that can be adressed later.
> > 
> > This patchset also fixes issues with error handling and adds
> > documentation
> > in doxygen format. An output is available here if you wanna have a
> > look:
> >  http://home.regit.org/~regit/libnftables/html/group__libnftables.h
> > tml
> 
> This is now a smaller patchset that the one that you posted in
> previous NFWS for nftables-0.5, so I think we're giving the right
> steps towards the library.

Yes, the preparation work that has been done combined with the fact I
had to rewrite everything did help to get something cleaner and
smaller.

> 
> > The first two patches are a bugfix and a helper function that is
> > needed
> > for the library:
> >  * [PATH nft v2 01/18] mnl: fix error handling in mnl_batch_talk
> >  * [PATH nft v2 02/18] erec: add function to free list
> > 
> > As mentioned by Arturo, this is not meant to be added into nftables
> > v0.8 but
> > it is a good candidate for early introduction in the branch as soon
> > as the
> > v0.8 release is done. 
> > 
> > I did not managed to incorporate some suggestions done privately by
> > Pablo. For
> > instance there is an nf_sock in the struct nft_ctx. I did not
> > change any
> > existing internal so it is still possible to do it as incremental
> > patches.
> 
> I'd rather do the other way around... Let's agree on what preparation
> patches need to get in, then submit a final patch to expose the
> library API and documentation.

I see possible issues. Let's take for instance latest work by Florian
on tcpmss. It is add new call to printf so this would be something to
rework. And experience in redoing the work I already done for this
patchset is that it can be really painful. On another side, the change
introduces some complexity and this would be painful to handle that for
nothing if the library is not available.


> Please, we shouldn't assume noone is going to consider this API
> unstable once we push it upstream...

Well, being provocative I would say that if we add a define with
version of the API that would be enough. And if we tag something
experimental, I won't feel guilty to change it later. If we claim it
stable that is another story and we have a responsibility.

> And I really don't know / I can't forecast what resources we will
> have
> here to work / fix things before this go public... so worst case can
> that we take X years to fix remaining issues...

Code needs to be fixed but libnftables is already useful even if
lacking the set handling. It would be sad not to use it relatively
fast.

++
-- 
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/
