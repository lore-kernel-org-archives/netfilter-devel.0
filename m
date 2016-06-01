From: Florian Westphal <fw@strlen.de>
Subject: Re: [nf-next PATCH] netfilter: nf_tables: add support for inverted
 login in nft_lookup
Date: Wed, 1 Jun 2016 10:58:36 +0200
Message-ID: <20160601085836.GB27858@breakpoint.cc>
References: <146469443294.16092.10350972377628813816.stgit@nfdev2.cica.es>
 <20160531144401.GB11135@breakpoint.cc>
 <CAOkSjBgdNOzgbK_v=2_xE2=HUjN508nZNa5knU-BM9zEt-dAzg@mail.gmail.com>
 <CAOkSjBjGVAzVPz8H3NnF_ZBE934nM4ibQ57dk_Eo9gEiG2aX8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:42598 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757536AbcFAI6l (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Jun 2016 04:58:41 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBjGVAzVPz8H3NnF_ZBE934nM4ibQ57dk_Eo9gEiG2aX8A@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com> wrote:
> On 31 May 2016 at 17:50, Arturo Borrero Gonzalez
> <arturo.borrero.glez@gmail.com> wrote:
> > On 31 May 2016 at 16:44, Florian Westphal <fw@strlen.de> wrote:
> >> I think its better to use a
> >>
> >> } else if (priv->invert) {
> >>         return;
> >> }
> >>
> 
> Not that easy, we should consider 4 cases:
>  * lookup false, invert false -> NFT_BREAK
>  * lookup false, invert true -> return w/o NFT_BREAK
>  * lookup true, invert false -> return w/o NFT_BREAK
>  * lookup true, invert true -> NFT_BREAK

Right...

> The XOR approach in my original patch seems to over these cases, ie,
> we enter the return branch only if lookup&invert are different.
> I think the nft_data_copy() should not worry us if we prevent the
> combination from happening in _init()

Agree, thanks Arturo!
