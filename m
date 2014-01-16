From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH v2] ct: fix key and dir requirements
Date: Thu, 16 Jan 2014 22:22:24 +0100
Message-ID: <20140116212224.GA27510@localhost>
References: <20140115181939.25239.19905.stgit@nfdev.cica.es>
 <20140116180538.GA18501@localhost>
 <CAOkSjBhOb=Z_-KDfpmRko7Vi-U4QVhYUJwkJ1FbDpLjEVD3teA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58805 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbaAPVW2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jan 2014 16:22:28 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBhOb=Z_-KDfpmRko7Vi-U4QVhYUJwkJ1FbDpLjEVD3teA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 16, 2014 at 09:46:17PM +0100, Arturo Borrero Gonzalez wrote:
> On 16 January 2014 19:05, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > The kernel will complain if we pass invalid combinations, I don't want
> > to have this early validation code in the library.
> >
> 
> The problem is that as far as I've tested, the kernel  unconditionally
> returns 'dir' [0].

Then I think we have to fix the kernel, it should not dump an
attribute that we don't need. I can see that nft is currently not
using the direction at all, so such change should not break anything.

> If we print in XML/JSON the data obtained from the kernel, <dir> is
> also printed, while it may be totally undesirable (for example, for a
> latter parsing of that XML/JSON meant to be resended to the kernel).
> I think we need this check, in libnftables or nft.
> 
> I don't see the point of allowing such a disruptive combination of attributes.

I agree those combinations don't make sense, but let just the kernel
bail out when we pass invalid combinations. Otherwise, the library
makes internal decisions that we simply cannot change as we'll have
3rd party userspace application relying on it. And we may want to
extend the kernel behaviour in some way that may clash with old
libraries. Really, we have to avoid this, it's just troubles in the
long run.

On the other hand, we should also make sure that the information that
we get from the kernel can be reinjected without troubles. So if you
note similar issues, please report them.

> We already have similar checks in other objects to disallow invalid
> combinations, see [1] [2].
> 
> What do you think?
> 
> >
> > Not related to this patch, but better I prefer if you use:
> > nft_rule_expr_set_u8(...) instead of these two lines above.
> >
> 
> I agree. But I think it would be better if all ops are of the same kind.

Agreed.

> So I will patch all non-shorcuts ops like this all around libnftables,
> unless you say otherwise, before this patch.

That will be a large patch, I guess. I prefer if you hold on with that
cleanup until we have released the first version which is coming soon.
Please, focus on fixes at this stage.
