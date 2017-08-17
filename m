From: Florian Westphal <fw@strlen.de>
Subject: Re: [nft PATCH 0/16] introduce libnftables
Date: Thu, 17 Aug 2017 12:35:52 +0200
Message-ID: <20170817103552.GA17221@breakpoint.cc>
References: <20170816204310.3371-1-eric@regit.org>
 <CAOkSjBg8L7QQ2WapAoX_erz4pDm3+q9460w8qnrzgPMPouFL1A@mail.gmail.com>
 <1502960318.31564.1.camel@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8bit
Cc: Arturo Borrero Gonzalez <arturo@netfilter.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:54804 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750903AbdHQKiU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Aug 2017 06:38:20 -0400
Content-Disposition: inline
In-Reply-To: <1502960318.31564.1.camel@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond <eric@regit.org> wrote:

Thanks a lot for working on this Eric!

> On Thu, 2017-08-17 at 10:32 +0200, Arturo Borrero Gonzalez wrote:
> > On 16 August 2017 at 22:42, Eric Leblond <eric@regit.org> wrote:
> > > 
> > > Hello,
> > > 
> > > This patchset adds a basi high level libnftables to nftables code.
> > > It is currently supporting running a command from a buffer or from
> > > a file as well as batch support allowing to chain commands and
> > > commit
> > > them at once.
> > > 
> > > The API is mostly using existing structures such as nft_ctx that
> > > are
> > > updated to contain enough information. It also adds a structure
> > > dedicated to batch.
> > > 
> > 
> > Great work Eric, thanks!
> > 
> > Some comments below.
> > 
> > > A simple program running a command is the following:
> > > 
> > >         nft_global_init();
> > >         nft = nft_context_new();
> > >         nft_context_set_print_func(nft, my_print, buf);
> > 
> > ^^^
> > A minor thing: Did you evaluate merging these two? Setting the print
> > function directly when allocating a new context.
> 
> Nope but could make sense.

I'd recommend to keep it like this, else we can run into
problems when we need a new func.

If it stays this way we can simply add
nft_context_set_foo_func() instead of breaking nft_context_new() abi
or adding nft_context_new2() (ugh...).

> > On a side note, I remember in NFWS 2017 we discussed the possibility
> > of libnftables being a separate source project, i.e a standalone
> > repository.
> > Now that I see your patches, what I see is that libnftables is mostly
> > all the code, while nft itself is very little code.
> > Still, with my Debian hat, I think that different repositories is
> > good to have.
> 
> I don't like the cascade idea with nftables -> libnftables -> libnftnl
> -> libmnl that this will induce. Also this means some potential
> breakage in versionning.

I would also like to keep it in same repo, else i fear we will
quickly have copy&paste programming...

We can always split later if we think that nft and libnft have matured
in a way that they are distinct after all.

