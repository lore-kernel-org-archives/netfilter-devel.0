From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH libnftables] Add support for ct set
Date: Fri, 10 Jan 2014 19:20:38 +0000
Message-ID: <20140110192037.GA6297@macbook.localnet>
References: <20140110131406.GA8088@macbook.localnet>
 <CAKfDRXgDZSnQ-cvpDTbea45ZTeFOMu_PThEp1kL-qNeQzVKrQw@mail.gmail.com>
 <20140110132703.GA8224@macbook.localnet>
 <CAKfDRXi5v27Tiazb78rA6v7YrAFqXz+kMEZgeE9jJb1whwnYvQ@mail.gmail.com>
 <20140110134342.GA8720@macbook.localnet>
 <20140110135435.GA18191@localhost>
 <20140110135800.GA8854@macbook.localnet>
 <20140110143252.GA3879@localhost>
 <20140110180625.GA4002@macbook.localnet>
 <20140110191025.GA8905@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kristian Evensen <kristian.evensen@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61606 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbaAJTUn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jan 2014 14:20:43 -0500
Content-Disposition: inline
In-Reply-To: <20140110191025.GA8905@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 10, 2014 at 08:10:25PM +0100, Pablo Neira Ayuso wrote:
> On Fri, Jan 10, 2014 at 06:06:25PM +0000, Patrick McHardy wrote:
> > On Fri, Jan 10, 2014 at 03:32:52PM +0100, Pablo Neira Ayuso wrote:
> > > 
> > > So are you proposing to add a new object for statements in
> > > libnftables? That will require a new infrastructure which would be
> > > very similar to what we have in the current expressions.
> > 
> > Well, the infrastructure should be pretty small. In fact you could
> > probably map everything to expressions internally (although I don't
> > think adding new infrastructure would be much effort), I would just
> > rather not create an API that confuses fundamental types.
> 
> libnftables is the very low level library, as it is very close to the
> kernel details, I would stick to the expression simplification that we
> have in the kernel.

Ok sure. Just wanted to bring it up.

> > > To that extend, that would also require a new infrastructure in the
> > > kernel so we also have statements there. I think one of the good
> > > things of the nf_tables kernel side is that we didn't make any
> > > distinction between matches/targets (or call it
> > > expressions/statements).
> > 
> > In the kernel that was deliberate and is only internal to the kernel
> > (well, and libraries and so on). I considered it, but I think in the
> > kernel its more important to keep the code base and APIs as small 
> > as possible.
> 
> Anyone working with libnftables should be familiar with the kernel
> code, the current approach maps 1 to 1 what we have in the kernel.
> 
> I still think the statement/expression concept should remain in the
> scope of nft. We'll have a high level library at some point, I guess
> that will be based on the (generalized) nft code, so we can provide
> a nft_compile() function similar to what libpcap provides to translate
> nft syntax to rules.
> 
> My proposal is to leave the expressions / statements concepts to the
> scope of nft and the upcoming high level library. As said, libnftables
> is low level stuff, it is just mirroring what we have in the kernel.

Ok that's fine with me for a low level library. Wondering whether the
high layer library should actually be called libnftables though.
