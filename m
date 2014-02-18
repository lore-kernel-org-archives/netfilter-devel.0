From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft RFC PATCH 6/6] src: add events reporting
Date: Tue, 18 Feb 2014 14:46:14 +0000
Message-ID: <20140218144611.GA29101@macbook.localnet>
References: <20140217231837.19943.77406.stgit@nfdev.cica.es>
 <20140218011007.GA4456@localhost>
 <20140218020354.GG12893@macbook.localnet>
 <20140218092811.GA3880@localhost>
 <20140218093311.GA11507@macbook.localnet>
 <20140218094320.GA4009@localhost>
 <20140218095209.GA12005@macbook.localnet>
 <20140218095829.GA4173@localhost>
 <20140218101259.GC12496@macbook.localnet>
 <CAOkSjBjrvhQ-AUwhXzydN-x4YrCNoDq3--dkG8MwzZYSgWzZZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60604 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580AbaBROqg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:46:36 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBjrvhQ-AUwhXzydN-x4YrCNoDq3--dkG8MwzZYSgWzZZA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 18, 2014 at 03:21:47PM +0100, Arturo Borrero Gonzalez wrote:
> On 18 February 2014 11:12, Patrick McHardy <kaber@trash.net> wrote:
> >
> > I'm actually not sure nft really could fail if the expression returned
> > from the kernel makes any sense at all.
> 
> I did a fast&small test.
> 
> What to do in the event reporting if this situation is reached?
> Non-sense rule added to the kernel:
> 
> ip filter input 0 0
>   [ cmp eq reg 1 0x00000006 ]
>   [ payload load 1b @ network header + 9 => reg 1 ]
>   [ payload load 2b @ transport header + 1 => reg 2 ]
>   [ counter pkts 0 bytes 0 ]
>   [ cmp eq reg 1 0x00001600 ]
> 
> % nft list table filter
> table ip filter {
>  [...]
> }
> netlink: Error: Relational expression has no left hand side
> 
> 
> netlink: Error: Relational expression size mismatch

Well, that's obviously a broken rule. There is no valid interpretation,
hence we don't need to display one. Reporting the error seems perfectly
fine to me, however event reporting shouldn't abort because of this.

Basically I think - netlink header and attribute parsing errors are
fine to exit. However just real parsing errors, not things like f.i.
unknown address families. Any error during interpretation of these
should only cause the error to be displayed, but nothing more.
