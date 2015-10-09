From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft] possible several bugs in maps
Date: Fri, 9 Oct 2015 11:42:19 +0100
Message-ID: <20151009104218.GG26121@macbook.localdomain>
References: <CAOkSjBh6Pt79--f8nOmS_kQgbHhQaWBsXdj88tnV3hUTEuYOGw@mail.gmail.com>
 <20151009104042.GA2331@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48815 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755964AbbJIKmX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Oct 2015 06:42:23 -0400
Content-Disposition: inline
In-Reply-To: <20151009104042.GA2331@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 09.10, Pablo Neira Ayuso wrote:
> On Fri, Oct 09, 2015 at 11:35:32AM +0200, Arturo Borrero Gonzalez wrote:
> > Hi,
> > 
> > i'm playing with nftables maps and found some issues.
> > 
> > First:
> > 
> > I can add this named map in the CLI but I can't load it from a file.
> > This can be reproduced with these commands:
> > 
> > % nft flush ruleset
> > % nft add table t
> > % nft add map t m { type ipv4_addr : ipv4_addr ; }
> > % nft add element t m {1.1.1.1: 2.2.2.2 }
> > % echo "flush ruleset" > test.nft
> > % nft list ruleset >> test.nft
> > % nft -f test.nft
> > test.nft:5:28-46: Error: mapping outside of map context
> >             elements = { 1.1.1.1 : 2.2.2.2}
> >                         ^^^^^^^^^^^^^^^^^^^
> 
> Known issue, our grammar is invoking the evaluating the elements
> before it has actually evaluated the declaration.

It is? Just had a quick look so I might be wrong, but it seems we're simply
not adding the set to the context before we're evaluating the elements.
