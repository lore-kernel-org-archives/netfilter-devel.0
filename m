From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft RFC PATCH] src: add set optimization options
Date: Wed, 3 Sep 2014 11:22:35 +0100
Message-ID: <20140903102233.GC4069@acer.localdomain>
References: <20140813081649.25737.82564.stgit@nfdev.cica.es>
 <20140903100959.GA17083@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39603 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755994AbaICKWk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Sep 2014 06:22:40 -0400
Content-Disposition: inline
In-Reply-To: <20140903100959.GA17083@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Sep 03, 2014 at 12:09:59PM +0200, Pablo Neira Ayuso wrote:
> Cc'ing Patrick.
> 
> On Wed, Aug 13, 2014 at 10:17:06AM +0200, Arturo Borrero Gonzalez wrote:
> > This patch adds options to choose set optimization mechanisms.
> > 
> > The syntax is one of:
> > 
> >  nft add set filter set1 { type ipv4_addr size 1024 ; }
> >  nft add set filter set1 { type ipv4_addr policy memory ; }
> >  nft add set filter set1 { type ipv4_addr policy performance ; }
> >  nft add set filter set1 { type ipv4_addr policy memory size 1024 ; }
> >  nft add set filter set1 { type ipv4_addr size 1024 policy memory ; }
> >  nft add set filter set1 { type ipv4_addr policy performance size 1024 ; }
> >  nft add set filter set1 { type ipv4_addr size 1024 policy performance ; }
> 
> @Patrick: Does this syntax look reasonable to you?

I think I would prefer having statements instead of everything combined.

> > Also valid for maps:
> > 
> >  nft add map filter map1 { type ipv4_addr : verdict policy performace ; }
> >  [...]
> > 
> > 
> > This is the output format, which can be imported later with `nft -f':
> > 
> > table filter {
> > 	set set1 {
> > 		type ipv4_addr policy memory size 1024
> > 	}
> > }
> > 
> > Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> > ---
> > 
> > This is my proposal for set internal mechanism selection in nft.
> > 
> > My idea is: given the kernel uses optional arguments to choose the
> > set mechanism, in userspace the configuration should be also optional.

Agreed.

> > The patch is not fully tested, there are still some issues; It seems that the
> > kernel is lacking some details.
> > For example, it doesn't dump back to userspace the policy configuration.
> > 
> > In my opinion, we should be able to inform userspace of the configuration, in a
> > way that userspace can differentiate between default values and fixed ones.
> > For example, NFT_SET_POL_PERFORMANCE seems to be the default in kernel, but
> > we don't want every set to be printed with "policy performance".
> > 
> > Please, feel free to comment.
> 
> Just one minor comment:
> 
>      struct {                                                                 
>              uint32_t        flags;                                           
>              uint32_t        policy;                                          
>              struct {                                                         
>                      uint32_t        size;                                    
>              } desc;                                                          
>      } mechanism;                                                             
> };
> 
> I prefer if you map 1:1 what we have in the kernel:
> 
>         struct set {
>                 ...
>                 uint32_t policy;
>                 struct {
>                         uint32_t size;
>                         uint32_t flags;
>                 } desc;
>         };

This is what I have in my patchset:

+struct set_desc {
+       unsigned int            size;
+       struct expr             *range;
+};

Range is another way to express the maximum size and at the same time a
common prefix.

I can dust off my patch and send it later so we combine what we have.
