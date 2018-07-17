From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 nf-next 2/2] netfilter: fix IPV6=m CONNTRACK=y link
 failure
Date: Tue, 17 Jul 2018 17:36:44 +0200
Message-ID: <20180717153644.vabui54at3ob7d6n@salvia>
References: <20180713142754.23349-1-fw@strlen.de>
 <20180713142754.23349-2-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180713142754.23349-2-fw@strlen.de>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Jul 13, 2018 at 04:27:54PM +0200, Florian Westphal wrote:
> IPV6=m
> DEFRAG_IPV6=m
> CONNTRACK=y yields:
> 
> net/netfilter/nf_conntrack_proto.o: In function `nf_ct_netns_do_get':
> net/netfilter/nf_conntrack_proto.c:802: undefined reference to `nf_defrag_ipv6_enable'
> net/netfilter/nf_conntrack_proto.o:(.rodata+0x640): undefined reference to `nf_conntrack_l4proto_icmpv6'
> 
> After previous patch, DEFRAG_IPV6 and IPV6 are no longer retain any
> dependencies, so we can tell Kconfig DEFRAG_IPV6 needs to be built-in as
> well, this resolves missing nf_defrag_ipv6_enable.
> 
> Second error can be fixed via makefile, just make sure conntrack_proto_ipv6
> is part of conntrack module.
> 
> based on earlier patch from Arnd Bergmann.
> 
> Fixes: 66c524acfb5186 ("netfilter: conntrack: remove l3proto abstraction")

Squashed into this original patch.
