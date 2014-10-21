From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH v3] utils: fix arp family number
Date: Tue, 21 Oct 2014 11:57:41 +0200
Message-ID: <20141021095741.GA5493@salvia>
References: <20141020115049.27980.35459.stgit@nfdev.cica.es>
 <20141021075927.GA3610@salvia>
 <CAOkSjBgmmE0MUPY10u1iOKgBsN4P3y9mLM3FHcMzA7hL3maP8Q@mail.gmail.com>
 <20141021095649.GA5248@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45132 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412AbaJUJ4N (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Oct 2014 05:56:13 -0400
Content-Disposition: inline
In-Reply-To: <20141021095649.GA5248@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 21, 2014 at 11:56:49AM +0200, Pablo Neira Ayuso wrote:
> On Tue, Oct 21, 2014 at 10:53:19AM +0200, Arturo Borrero Gonzalez wrote:
> > On 21 October 2014 09:59, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > >
> > > BTW, it would be good to see a similar refactor in nft_verdict2str().
> > 
> > I don't see a clean way to do it, given some verdicts are negative
> > numbers (enum nft_verdicts in nf_tables.h).
> > We may end accessing a negative index, out of bounds of the array.
> 
> I see, you mean:
> 
> enum nft_verdicts {
>         NFT_CONTINUE    = -1,
>         NFT_BREAK       = -2,
>         NFT_JUMP        = -3,
>         NFT_GOTO        = -4,
>         NFT_RETURN      = -5,
> };
> 
> You can add some function to shift the values:
> 
> #define nft_verdict_index(base)     (base + 5)

BTW, instead of 5, add:

#define NFT_VERDICT_BASE        NFT_RETURN

and use it.

> 
> ... nft_verdict_array[] = {
>         [nft_verdict_index(NFT_RETURN)]     = "return",
>         ...
> };
