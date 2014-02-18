From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft RFC PATCH 3/6] netlink: add netlink_delinearize_set() func
Date: Tue, 18 Feb 2014 09:21:03 +0000
Message-ID: <20140218092103.GC10327@macbook.localnet>
References: <20140217231654.19943.18736.stgit@nfdev.cica.es>
 <20140217231822.19943.3523.stgit@nfdev.cica.es>
 <20140218015641.GF12893@macbook.localnet>
 <CAOkSjBgWGqsG9FdSfp=R6joP_us3FSRRcFdU0cjobDLexvY4vw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57990 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362AbaBRJVH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Feb 2014 04:21:07 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBgWGqsG9FdSfp=R6joP_us3FSRRcFdU0cjobDLexvY4vw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 18, 2014 at 10:11:52AM +0100, Arturo Borrero Gonzalez wrote:
> On 18 February 2014 02:56, Patrick McHardy <kaber@trash.net> wrote:
> >> +extern struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
> >> +                                        struct nft_set *nls);
> >
> > Actually delinarization so far refers to the act of converting a linear
> > instruction stream into an abstract syntax tree. This is not really a
> > good term for sets, which are still pretty much linear.
> >
> > I don't have a good suggestion right now though.
> 
> At first, I used something like 'nls2set', but this delinearize thing
> sounded more 'serious' :)
> 
> In think in all cases, we are converting netlink objects to the
> internal nft object. We need a name for that, no?

You *could* call it deserialization since we're converting the attribute
stream into an object and we should (not done so far) convert bitmask
values with more than one bit set into a tree of inclusive OR expressions.

Not sure. I guess you can keep that name until we come up with something
better, but I wouldn't move it to netlink_delinearize.c. This is meant to
mirror netlink_linearize.c, they both only take care of rules.
