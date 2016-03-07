From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libxt_connlabel: Add translation to nft
Date: Mon, 7 Mar 2016 14:32:14 +0100
Message-ID: <20160307133214.GA27010@salvia>
References: <20160305214746.GA16464@gmail.com>
 <20160306000703.GA31513@breakpoint.cc>
 <20160307130524.GA26624@salvia>
 <CAKHNQQHe7_cRrtd9ChcVyaSmk0GhVUztxQ4Y2wubQsSoFbbmng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49113 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243AbcCGNcU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Mar 2016 08:32:20 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 7625D13C0F3
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2016 14:32:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 666E6DA39C
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2016 14:32:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 43F43DA396
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2016 14:32:15 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAKHNQQHe7_cRrtd9ChcVyaSmk0GhVUztxQ4Y2wubQsSoFbbmng@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 07, 2016 at 06:55:31PM +0530, Shivani Bhardwaj wrote:
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

The current translation seems fine (unless Florian indicates
otherwise). We can incrementally improve this.
