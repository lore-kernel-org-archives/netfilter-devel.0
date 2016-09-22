From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nf_meta: support for nexthop and
 nexthop6
Date: Thu, 22 Sep 2016 11:39:42 +0200
Message-ID: <20160922093942.GA11850@salvia>
References: <1473832028.1006.35.camel@cohaesio.com>
 <20160920152816.GA18239@salvia>
 <1474434441.1021.42.camel@cohaesio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: "fw@strlen.de" <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "Anders K. Pedersen | Cohaesio" <akp@cohaesio.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39100 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933227AbcIVJjs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Sep 2016 05:39:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4725891B48
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2016 11:39:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 37B43DA841
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2016 11:39:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9E75BDA84D
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2016 11:39:43 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1474434441.1021.42.camel@cohaesio.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Sep 21, 2016 at 05:07:22AM +0000, Anders K. Pedersen | Cohaesio wrote:
> Hi Pablo,
> 
> On tir, 2016-09-20 at 17:28 +0200, Pablo Neira Ayuso wrote:
> > Hi Anders,
> > 
> > On Wed, Sep 14, 2016 at 05:47:08AM +0000, Anders K. Pedersen |
> > Cohaesio wrote:
> > > Add meta support for IPv4 nexthop and IPv6 nexthop6 (i.e. the
> > > directly
> > > connected IP address that an outgoing packet is sent to), which can
> > > be used
> > > either for matching or accounting, eg.
> 
> > Florian is working on explicitly fib lookup expression, 
> 
> I had noticed his RFC before doing this, but thought that it wouldn't
> be ideal for my use case, since 1) it might not give the route that is
> actually used in case of ECMP, and 2) it would be less efficient to
> perform an additional route lookup in stead of just reusing the one
> that has to be performed anyway for routing the packet - especially on
> a router with a full BGP feed (currently close to 600.000 routes).

Sorry, I didn't mean we should select fib or rt, I think they have
both valid usecases. So I'm fine with what you're doing.

[...]
> > Would you have a look at this? Let me know, thanks!
> 
> I had an initial look at this and found that it would involve
> modifying/creating the following files:
> 
> nf-next:
> include/net/netfilter/nft_rt.h - new file based on nft_meta.h
> include/uapi/linux/netfilter/nf_tables.h
>  - new NFT_RT_* and NFTA_RT_* - based on what exists for nft_meta
> net/netfilter/{Kconfig,Makefile} - new config NFT_RT and NFT_RT_INET
> net/netfilter/nft_rt.c - new file based on nft_meta.c
> net/netfilter/nft_rt_inet.c - new file based on nft_meta_bridge.c
> net/ipv4/netfilter/{Kconfig,Makefile} - new config NFT_RT_IPV4
> net/ipv4/netfilter/nft_rt_ipv4.c - new file based on nft_meta_bridge.c
> net/ipv6/netfilter/{Kconfig,Makefile} - new config NFT_RT_IPV6
> net/ipv6/netfilter/nft_rt_ipv6.c - new file based on nft_meta_bridge.c
> 
> libnftnl:
> include/linux/netfilter/nf_tables.h - same as kernel changes
> include/libnftnl/expr.h - add new NFTNL_EXPR_RT_* and NFT_EXPR_RT_*
> src/expr/rt.c - new file based on meta.c
> src/expr_ops.c - add references to expr_ops_rt
> src/Makefile.am - add expr/rt.c
> 
> nftables:
> doc/nft.xml - document new rt expression
> include/linux/netfilter/nf_tables.h - same as kernel changes
> include/expression.h - add new EXPR_RT
> include/rt.h - new file based on meta.h
> include/statement.h - add new STMT_RT and rt_stmt
> src/evaluate.c - add handling of EXPR_RT and STMT_RT
> src/netlink_linearize.c - add handling of EXPR_RT and STMT_RT
> src/netlink_delinearize.c - add handling of EXPR_RT and STMT_RT
> src/rt.c - new file based on meta.c
> src/Makefile.am - add rt.c to nft_SOURCES
> src/parser_bison.y - define new keywords and syntax
> src/scanner.l - define new keywords
> 
> Does this seem right, or have I missed something?
> 
> It looks like quite a bit more code than my first attempt, but I can
> give it a try. I don't know how much time I'll have for this, so it
> will probably take some weeks to do.

Yes, it's a bit of more code than this, but if there are more usecase
to access the skb_rtable(), then this makes sense to me.

And no problem wrt. time.

Please, let us know if you have any problem. Thanks!
