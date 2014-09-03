From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft RFC PATCH] src: add set optimization options
Date: Wed, 3 Sep 2014 12:09:59 +0200
Message-ID: <20140903100959.GA17083@salvia>
References: <20140813081649.25737.82564.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42136 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932142AbaICKJL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Sep 2014 06:09:11 -0400
Content-Disposition: inline
In-Reply-To: <20140813081649.25737.82564.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Cc'ing Patrick.

On Wed, Aug 13, 2014 at 10:17:06AM +0200, Arturo Borrero Gonzalez wrote:
> This patch adds options to choose set optimization mechanisms.
> 
> The syntax is one of:
> 
>  nft add set filter set1 { type ipv4_addr size 1024 ; }
>  nft add set filter set1 { type ipv4_addr policy memory ; }
>  nft add set filter set1 { type ipv4_addr policy performance ; }
>  nft add set filter set1 { type ipv4_addr policy memory size 1024 ; }
>  nft add set filter set1 { type ipv4_addr size 1024 policy memory ; }
>  nft add set filter set1 { type ipv4_addr policy performance size 1024 ; }
>  nft add set filter set1 { type ipv4_addr size 1024 policy performance ; }

@Patrick: Does this syntax look reasonable to you?

> Also valid for maps:
> 
>  nft add map filter map1 { type ipv4_addr : verdict policy performace ; }
>  [...]
> 
> 
> This is the output format, which can be imported later with `nft -f':
> 
> table filter {
> 	set set1 {
> 		type ipv4_addr policy memory size 1024
> 	}
> }
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
> 
> This is my proposal for set internal mechanism selection in nft.
> 
> My idea is: given the kernel uses optional arguments to choose the
> set mechanism, in userspace the configuration should be also optional.
> 
> The patch is not fully tested, there are still some issues; It seems that the
> kernel is lacking some details.
> For example, it doesn't dump back to userspace the policy configuration.
> 
> In my opinion, we should be able to inform userspace of the configuration, in a
> way that userspace can differentiate between default values and fixed ones.
> For example, NFT_SET_POL_PERFORMANCE seems to be the default in kernel, but
> we don't want every set to be printed with "policy performance".
> 
> Please, feel free to comment.

Just one minor comment:

     struct {                                                                 
             uint32_t        flags;                                           
             uint32_t        policy;                                          
             struct {                                                         
                     uint32_t        size;                                    
             } desc;                                                          
     } mechanism;                                                             
};

I prefer if you map 1:1 what we have in the kernel:

        struct set {
                ...
                uint32_t policy;
                struct {
                        uint32_t size;
                        uint32_t flags;
                } desc;
        };

Thanks!
