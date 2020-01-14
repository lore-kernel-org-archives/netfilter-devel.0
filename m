Return-Path: <SRS0=kgPV=3D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE207C33C9E
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jan 2020 17:04:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C66872465A
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jan 2020 17:04:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728558AbgANREM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Jan 2020 12:04:12 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:45684 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726053AbgANREM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Jan 2020 12:04:12 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1irPbv-0001tq-5W; Tue, 14 Jan 2020 18:04:11 +0100
Date:   Tue, 14 Jan 2020 18:04:11 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft 1/3] libnftables: add nft_ctx_set_netns()
Message-ID: <20200114170411.GA19873@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <20200109172115.229723-1-pablo@netfilter.org>
 <20200109172115.229723-2-pablo@netfilter.org>
 <20200110125311.GP20229@orbyte.nwl.cc>
 <20200112102802.7bvwieqaza3zdbza@salvia>
 <20200112104027.ijjcv34glvnkhnvc@salvia>
 <20200114102516.GD20229@orbyte.nwl.cc>
 <20200114103835.toksgmp6krbmh4ei@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114103835.toksgmp6krbmh4ei@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Tue, Jan 14, 2020 at 11:38:35AM +0100, Pablo Neira Ayuso wrote:
> On Tue, Jan 14, 2020 at 11:25:16AM +0100, Phil Sutter wrote:
> > On Sun, Jan 12, 2020 at 11:40:27AM +0100, Pablo Neira Ayuso wrote:
> > > On Sun, Jan 12, 2020 at 11:28:02AM +0100, Pablo Neira Ayuso wrote:
> > > > On Fri, Jan 10, 2020 at 01:53:11PM +0100, Phil Sutter wrote:
> > > > > On Thu, Jan 09, 2020 at 06:21:13PM +0100, Pablo Neira Ayuso wrote:
[...]
> > > > > >  struct nft_ctx *nft_ctx_new(uint32_t flags);
> > > > > >  void nft_ctx_free(struct nft_ctx *ctx);
> > > > > >  
> > > > > > +int nft_ctx_set_netns(struct nft_ctx *ctx, const char *netns);
> > > > > 
> > > > > Is there a way to select init ns again?
> > > > 
> > > > AFAIK, setns() does not let you go back to init ns once set.

FWIW, I found interesting Python code[1] dealing with that. The logic is
to open /proc/$$/ns/net before switching netns and storing the fd for
later. To exit the netns again, it is passed to setns() and then closed.
Note that the code there is much simpler and doesn't deal with mounts or
non-existing entries in /var/run/netns/. Maybe libnftables doesn't need
to either and it is OK to just bail if given netns doesn't exist?

> > I noticed something I find worse, namely that libnftables as a library
> > changes the application's netns. Anything it does after changing the
> > context's netns applies to that netns only, no matter if it's creating a
> > new nft context with NFT_CtX_DEFAULT flag or call iproute via system().
> > 
> > If we can't find a way to exit the netns again, one can safely assume
> > that we are trapping a user's application in a netns with this feature.
> 
> IIRC, you can fork(), then let the child enter the netns while parent
> remain in the original netns.

Yes, that's also the only way to operate in multiple netns in parallel.

> > Maybe we should restrict per-netns operation to nft utility and perform
> > the netns switch there? Maybe we could provide a "switch_netns()"
> > routine in libnftables which is not bound to nft context so users may
> > use it in their application?
> 
> That's another possibility, yes. In that case, there is no need for
> NFT_CTX_NETNS, which is just there to skip the socket initialization.

I just think that a routine which affects things outside of nft scope
shouldn't be tied as closely with nft context.

Cheers, Phil

[1] https://github.com/larsks/python-netns/blob/master/netns.py
