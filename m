From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] extensions: libxt_connlabel: Add translation to nft
Date: Mon, 7 Mar 2016 14:30:04 +0100
Message-ID: <20160307133004.GB776@breakpoint.cc>
References: <20160305214746.GA16464@gmail.com>
 <20160306000703.GA31513@breakpoint.cc>
 <20160307130524.GA26624@salvia>
 <CAKHNQQHe7_cRrtd9ChcVyaSmk0GhVUztxQ4Y2wubQsSoFbbmng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34480 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751000AbcCGNaH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Mar 2016 08:30:07 -0500
Content-Disposition: inline
In-Reply-To: <CAKHNQQHe7_cRrtd9ChcVyaSmk0GhVUztxQ4Y2wubQsSoFbbmng@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Shivani Bhardwaj <shivanib134@gmail.com> wrote:
> On Mon, Mar 7, 2016 at 6:35 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Sun, Mar 06, 2016 at 01:07:03AM +0100, Florian Westphal wrote:
> >> Shivani Bhardwaj <shivanib134@gmail.com> wrote:
> >> > Add translation for connlabel to nftables.
> >> > Full translation for this match awaits the support for --set option.
> >>
> >> Hmm, I sent patches for that a while ago, don't know why they were
> >> not applied... Pablo?
> >
> > Please, push the the connlabel support to nft.
> >
> > We can probably introduce something like:
> >
> >         ct connlabel bitset bar
> >
> > instead of:
> >
> >         ct connlabel set ct connlabel | bar
> >
> > in a follow up patch, which looks more compact to me. We can accept
> > both syntax I'd say so we can introduce this without breaking
> > backward.
> 
> Should I be waiting for this or send a v2 with the existing options?
> Please let me know.

I'd suggest you just send a v2, lets handle translation of --set in
a followup change later.

I'm currently not at home but I plan to push set support this week.
